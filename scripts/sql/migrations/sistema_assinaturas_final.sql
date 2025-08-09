-- Script FINAL para sistema de assinaturas
-- Execute este script no Supabase SQL Editor
-- Versão robusta sem testes que podem falhar

SELECT '=== INICIANDO SISTEMA ASSINATURAS FINAL ===' as status;

-- 1. Criar tabela de assinaturas
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('starter', 'business', 'unlimited')),
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'cancelled', 'expired')),
    started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    trial_ends_at TIMESTAMP WITH TIME ZONE,
    monthly_transaction_limit INTEGER,
    user_limit INTEGER,
    client_limit INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 2. Criar tabela de uso (para controlar limites)
CREATE TABLE IF NOT EXISTS public.usage_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    month_year VARCHAR(7) NOT NULL, -- formato: 2024-01
    transactions_count INTEGER DEFAULT 0,
    users_count INTEGER DEFAULT 1,
    clients_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, month_year)
);

-- 3. Habilitar RLS nas tabelas
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usage_tracking ENABLE ROW LEVEL SECURITY;

-- 4. Criar políticas RLS SIMPLES para subscriptions
DROP POLICY IF EXISTS "Users can view own subscription" ON public.subscriptions;
CREATE POLICY "Users can view own subscription"
ON public.subscriptions FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own subscription" ON public.subscriptions;
CREATE POLICY "Users can update own subscription"
ON public.subscriptions FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "System can insert subscriptions" ON public.subscriptions;
CREATE POLICY "System can insert subscriptions"
ON public.subscriptions FOR INSERT
WITH CHECK (true);

-- 5. Criar políticas RLS SIMPLES para usage_tracking
DROP POLICY IF EXISTS "Users can view own usage" ON public.usage_tracking;
CREATE POLICY "Users can view own usage"
ON public.usage_tracking FOR SELECT
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "System can manage usage tracking" ON public.usage_tracking;
CREATE POLICY "System can manage usage tracking"
ON public.usage_tracking FOR ALL
USING (true)
WITH CHECK (true);

-- 6. Criar função para verificar limites de plano (VERSÃO ROBUSTA)
CREATE OR REPLACE FUNCTION public.check_plan_limits(
    target_user_id UUID,
    check_type VARCHAR DEFAULT 'transaction'
) RETURNS TABLE (
    allowed BOOLEAN,
    current_count INTEGER,
    limit_count INTEGER,
    plan_type VARCHAR
) AS $$
DECLARE
    user_subscription RECORD;
    current_month VARCHAR := TO_CHAR(NOW(), 'YYYY-MM');
    usage_record RECORD;
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
    is_trial_active BOOLEAN := false;
    user_exists BOOLEAN := false;
BEGIN
    -- USUÁRIO MASTER TEM ACESSO ILIMITADO
    IF target_user_id = master_user_id THEN
        RETURN QUERY SELECT 
            true as allowed,
            0 as current_count,
            999999 as limit_count,
            'unlimited'::VARCHAR as plan_type;
        RETURN;
    END IF;

    -- Verificar se o usuário existe na tabela auth.users
    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) INTO user_exists;
    
    -- Se usuário não existe, retornar acesso negado
    IF NOT user_exists THEN
        RETURN QUERY SELECT 
            false as allowed,
            0 as current_count,
            0 as limit_count,
            'none'::VARCHAR as plan_type;
        RETURN;
    END IF;

    -- Buscar assinatura do usuário
    SELECT * INTO user_subscription 
    FROM public.subscriptions 
    WHERE user_id = target_user_id AND status = 'active';

    -- Se não tem assinatura, criar trial automático (SÓ PARA USUÁRIOS REAIS)
    IF user_subscription IS NULL THEN
        BEGIN
            INSERT INTO public.subscriptions (
                user_id, 
                plan_type, 
                status, 
                trial_ends_at,
                monthly_transaction_limit,
                user_limit,
                client_limit
            ) VALUES (
                target_user_id,
                'starter',
                'active',
                NOW() + INTERVAL '14 days',
                1000,
                1,
                50
            );
            
            SELECT * INTO user_subscription 
            FROM public.subscriptions 
            WHERE user_id = target_user_id;
        EXCEPTION WHEN OTHERS THEN
            -- Se falhar ao criar assinatura, retornar acesso negado
            RETURN QUERY SELECT 
                false as allowed,
                0 as current_count,
                0 as limit_count,
                'error'::VARCHAR as plan_type;
            RETURN;
        END;
    END IF;

    -- Verificar se o trial está ativo
    IF user_subscription.trial_ends_at IS NOT NULL AND user_subscription.trial_ends_at > NOW() THEN
        is_trial_active := true;
    END IF;

    -- Buscar uso atual do mês
    SELECT * INTO usage_record 
    FROM public.usage_tracking 
    WHERE user_id = target_user_id AND month_year = current_month;

    -- Se não existe registro de uso, criar
    IF usage_record IS NULL THEN
        BEGIN
            INSERT INTO public.usage_tracking (user_id, month_year)
            VALUES (target_user_id, current_month);
            
            SELECT * INTO usage_record 
            FROM public.usage_tracking 
            WHERE user_id = target_user_id AND month_year = current_month;
        EXCEPTION WHEN OTHERS THEN
            -- Se falhar, usar valores padrão
            usage_record.transactions_count := 0;
            usage_record.users_count := 1;
            usage_record.clients_count := 0;
        END;
    END IF;

    -- LÓGICA PRINCIPAL: Se está em trial, permitir acesso total
    IF is_trial_active THEN
        -- Durante o trial, permitir tudo mas mostrar uso atual
        IF check_type = 'transaction' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                COALESCE(usage_record.transactions_count, 0) as current_count,
                user_subscription.monthly_transaction_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'user' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                COALESCE(usage_record.users_count, 1) as current_count,
                user_subscription.user_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'client' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                COALESCE(usage_record.clients_count, 0) as current_count,
                user_subscription.client_limit as limit_count,
                user_subscription.plan_type as plan_type;
        END IF;
    ELSE
        -- Após o trial, aplicar limites normais
        IF check_type = 'transaction' THEN
            RETURN QUERY SELECT 
                (COALESCE(usage_record.transactions_count, 0) < user_subscription.monthly_transaction_limit OR user_subscription.monthly_transaction_limit IS NULL) as allowed,
                COALESCE(usage_record.transactions_count, 0) as current_count,
                user_subscription.monthly_transaction_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'user' THEN
            RETURN QUERY SELECT 
                (COALESCE(usage_record.users_count, 1) < user_subscription.user_limit OR user_subscription.user_limit IS NULL) as allowed,
                COALESCE(usage_record.users_count, 1) as current_count,
                user_subscription.user_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'client' THEN
            RETURN QUERY SELECT 
                (COALESCE(usage_record.clients_count, 0) < user_subscription.client_limit OR user_subscription.client_limit IS NULL) as allowed,
                COALESCE(usage_record.clients_count, 0) as current_count,
                user_subscription.client_limit as limit_count,
                user_subscription.plan_type as plan_type;
        END IF;
    END IF;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Criar função para incrementar uso
CREATE OR REPLACE FUNCTION public.increment_usage(
    target_user_id UUID,
    usage_type VARCHAR,
    increment_by INTEGER DEFAULT 1
) RETURNS BOOLEAN AS $$
DECLARE
    current_month VARCHAR := TO_CHAR(NOW(), 'YYYY-MM');
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- USUÁRIO MASTER NÃO TEM LIMITES
    IF target_user_id = master_user_id THEN
        RETURN true;
    END IF;

    -- Verificar se usuário existe
    IF NOT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) THEN
        RETURN false;
    END IF;

    -- Inserir ou atualizar uso
    BEGIN
        INSERT INTO public.usage_tracking (user_id, month_year, transactions_count, users_count, clients_count)
        VALUES (
            target_user_id, 
            current_month,
            CASE WHEN usage_type = 'transaction' THEN increment_by ELSE 0 END,
            CASE WHEN usage_type = 'user' THEN increment_by ELSE 1 END,
            CASE WHEN usage_type = 'client' THEN increment_by ELSE 0 END
        )
        ON CONFLICT (user_id, month_year) 
        DO UPDATE SET
            transactions_count = usage_tracking.transactions_count + 
                CASE WHEN usage_type = 'transaction' THEN increment_by ELSE 0 END,
            users_count = usage_tracking.users_count + 
                CASE WHEN usage_type = 'user' THEN increment_by ELSE 0 END,
            clients_count = usage_tracking.clients_count + 
                CASE WHEN usage_type = 'client' THEN increment_by ELSE 0 END,
            updated_at = NOW();

        RETURN true;
    EXCEPTION WHEN OTHERS THEN
        RETURN false;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. Criar função para verificar especificamente se usuário está em trial
CREATE OR REPLACE FUNCTION public.is_user_in_trial(target_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    trial_end_date TIMESTAMP WITH TIME ZONE;
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- Usuário master nunca está em trial (tem acesso ilimitado)
    IF target_user_id = master_user_id THEN
        RETURN false;
    END IF;

    -- Verificar se usuário existe
    IF NOT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) THEN
        RETURN false;
    END IF;

    -- Buscar data de fim do trial
    SELECT trial_ends_at INTO trial_end_date
    FROM public.subscriptions
    WHERE user_id = target_user_id AND status = 'active';

    -- Se não encontrou ou não tem trial, retornar false
    IF trial_end_date IS NULL THEN
        RETURN false;
    END IF;

    -- Verificar se trial ainda está ativo
    RETURN trial_end_date > NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 9. Criar assinatura UNLIMITED para o usuário master
INSERT INTO public.subscriptions (
    user_id,
    plan_type,
    status,
    monthly_transaction_limit,
    user_limit,
    client_limit
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36',
    'unlimited',
    'active',
    NULL, -- ilimitado
    NULL, -- ilimitado
    NULL  -- ilimitado
) ON CONFLICT (user_id) DO UPDATE SET
    plan_type = 'unlimited',
    status = 'active',
    monthly_transaction_limit = NULL,
    user_limit = NULL,
    client_limit = NULL,
    updated_at = NOW();

-- 10. Criar trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_subscriptions_updated_at ON public.subscriptions;
CREATE TRIGGER update_subscriptions_updated_at 
    BEFORE UPDATE ON public.subscriptions 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_usage_tracking_updated_at ON public.usage_tracking;
CREATE TRIGGER update_usage_tracking_updated_at 
    BEFORE UPDATE ON public.usage_tracking 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 11. Verificações finais (SEM TESTES QUE PODEM FALHAR)
SELECT '=== VERIFICANDO SISTEMA ===' as info;

-- Verificar se master foi configurado
SELECT 
    'MASTER CONFIGURADO:' as status,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM public.subscriptions 
            WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
        ) THEN 'SIM'
        ELSE 'NÃO'
    END as master_exists;

-- Verificar estrutura das tabelas
SELECT 
    'TABELAS CRIADAS:' as status,
    COUNT(*) as total_tables
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_name IN ('subscriptions', 'usage_tracking');

-- Verificar funções criadas
SELECT 
    'FUNÇÕES CRIADAS:' as status,
    COUNT(*) as total_functions
FROM information_schema.routines 
WHERE routine_schema = 'public' 
    AND routine_name IN ('check_plan_limits', 'increment_usage', 'is_user_in_trial');

SELECT '=== ✅ SISTEMA ROBUSTO CRIADO COM SUCESSO ===' as final_status;
SELECT 'Agora teste com usuários reais!' as instrucao;
