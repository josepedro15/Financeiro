-- Script para criar sistema de assinaturas
-- Execute este script no Supabase SQL Editor

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

-- 4. Criar políticas RLS para subscriptions
CREATE POLICY "Users can view own subscription"
ON public.subscriptions FOR SELECT
USING (
    auth.uid() = user_id 
    OR 
    EXISTS (
        SELECT 1 FROM public.organization_members om 
        WHERE om.member_id = auth.uid() 
        AND om.organization_id = user_id 
        AND om.status = 'active'
    )
);

CREATE POLICY "Users can update own subscription"
ON public.subscriptions FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "System can insert subscriptions"
ON public.subscriptions FOR INSERT
WITH CHECK (true);

-- 5. Criar políticas RLS para usage_tracking
CREATE POLICY "Users can view own usage"
ON public.usage_tracking FOR SELECT
USING (
    auth.uid() = user_id 
    OR 
    EXISTS (
        SELECT 1 FROM public.organization_members om 
        WHERE om.member_id = auth.uid() 
        AND om.organization_id = user_id 
        AND om.status = 'active'
    )
);

CREATE POLICY "System can manage usage tracking"
ON public.usage_tracking FOR ALL
USING (true)
WITH CHECK (true);

-- 6. Criar função para verificar limites de plano
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

    -- Buscar assinatura do usuário
    SELECT * INTO user_subscription 
    FROM public.subscriptions 
    WHERE user_id = target_user_id AND status = 'active';

    -- Se não tem assinatura, criar trial automático
    IF user_subscription IS NULL THEN
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
    END IF;

    -- Buscar uso atual do mês
    SELECT * INTO usage_record 
    FROM public.usage_tracking 
    WHERE user_id = target_user_id AND month_year = current_month;

    -- Se não existe registro de uso, criar
    IF usage_record IS NULL THEN
        INSERT INTO public.usage_tracking (user_id, month_year)
        VALUES (target_user_id, current_month);
        
        SELECT * INTO usage_record 
        FROM public.usage_tracking 
        WHERE user_id = target_user_id AND month_year = current_month;
    END IF;

    -- Verificar limite baseado no tipo
    IF check_type = 'transaction' THEN
        RETURN QUERY SELECT 
            (usage_record.transactions_count < user_subscription.monthly_transaction_limit OR user_subscription.monthly_transaction_limit IS NULL) as allowed,
            usage_record.transactions_count as current_count,
            user_subscription.monthly_transaction_limit as limit_count,
            user_subscription.plan_type as plan_type;
    ELSIF check_type = 'user' THEN
        RETURN QUERY SELECT 
            (usage_record.users_count < user_subscription.user_limit OR user_subscription.user_limit IS NULL) as allowed,
            usage_record.users_count as current_count,
            user_subscription.user_limit as limit_count,
            user_subscription.plan_type as plan_type;
    ELSIF check_type = 'client' THEN
        RETURN QUERY SELECT 
            (usage_record.clients_count < user_subscription.client_limit OR user_subscription.client_limit IS NULL) as allowed,
            usage_record.clients_count as current_count,
            user_subscription.client_limit as limit_count,
            user_subscription.plan_type as plan_type;
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

    -- Inserir ou atualizar uso
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
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. Criar assinatura UNLIMITED para o usuário master
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

-- 9. Criar trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_subscriptions_updated_at 
    BEFORE UPDATE ON public.subscriptions 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_usage_tracking_updated_at 
    BEFORE UPDATE ON public.usage_tracking 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 10. Verificação final
SELECT '=== SISTEMA DE ASSINATURAS CRIADO COM SUCESSO ===' as status;

SELECT 
    'Usuário Master Configurado:' as info,
    user_id,
    plan_type,
    status,
    monthly_transaction_limit,
    user_limit,
    client_limit
FROM public.subscriptions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
