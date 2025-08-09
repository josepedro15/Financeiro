-- =====================================================
-- SISTEMA DE ASSINATURAS COMPLETO
-- =====================================================

-- 1. CRIAR TABELA DE ASSINATURAS
CREATE TABLE IF NOT EXISTS public.subscriptions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('starter', 'business', 'unlimited')),
    status VARCHAR(20) NOT NULL DEFAULT 'trial' CHECK (status IN ('trial', 'active', 'inactive', 'cancelled', 'expired')),
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    trial_ends_at TIMESTAMP WITH TIME ZONE,
    monthly_transaction_limit INTEGER,
    user_limit INTEGER,
    client_limit INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 2. CRIAR TABELA DE CONTROLE DE USO
CREATE TABLE IF NOT EXISTS public.usage_tracking (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    month_year VARCHAR(7) NOT NULL, -- formato: YYYY-MM
    transactions_count INTEGER DEFAULT 0,
    users_count INTEGER DEFAULT 0,
    clients_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, month_year)
);

-- 3. CRIAR FUNÇÃO PARA VERIFICAR LIMITES
CREATE OR REPLACE FUNCTION public.check_plan_limits(
    target_user_id UUID,
    check_type VARCHAR(20) DEFAULT 'transaction'
)
RETURNS TABLE(
    allowed BOOLEAN,
    current_count INTEGER,
    limit_count INTEGER,
    plan_type VARCHAR(20)
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_subscription RECORD;
    current_usage RECORD;
    current_month VARCHAR(7);
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- Usuário master tem acesso ilimitado
    IF target_user_id = master_user_id THEN
        RETURN QUERY SELECT 
            TRUE as allowed,
            0 as current_count,
            999999 as limit_count,
            'unlimited' as plan_type;
        RETURN;
    END IF;

    -- Obter mês atual
    current_month := TO_CHAR(NOW(), 'YYYY-MM');

    -- Buscar assinatura do usuário
    SELECT * INTO user_subscription 
    FROM public.subscriptions 
    WHERE user_id = target_user_id;

    -- Se não tem assinatura, criar trial automaticamente
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
            'trial',
            NOW() + INTERVAL '14 days',
            100,
            1,
            10
        );
        
        -- Buscar a assinatura recém-criada
        SELECT * INTO user_subscription 
        FROM public.subscriptions 
        WHERE user_id = target_user_id;
    END IF;

    -- Buscar uso atual
    SELECT * INTO current_usage 
    FROM public.usage_tracking 
    WHERE user_id = target_user_id AND month_year = current_month;

    -- Se não tem registro de uso, criar
    IF current_usage IS NULL THEN
        INSERT INTO public.usage_tracking (
            user_id, 
            month_year, 
            transactions_count, 
            users_count, 
            clients_count
        ) VALUES (
            target_user_id,
            current_month,
            0,
            0,
            0
        );
        
        -- Buscar o uso recém-criado
        SELECT * INTO current_usage 
        FROM public.usage_tracking 
        WHERE user_id = target_user_id AND month_year = current_month;
    END IF;

    -- Verificar se está no trial e se ainda é válido
    IF user_subscription.status = 'trial' AND user_subscription.trial_ends_at > NOW() THEN
        -- No trial, verificar limites baseados no tipo
        CASE check_type
            WHEN 'transaction' THEN
                RETURN QUERY SELECT 
                    current_usage.transactions_count < user_subscription.monthly_transaction_limit as allowed,
                    current_usage.transactions_count as current_count,
                    user_subscription.monthly_transaction_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            WHEN 'user' THEN
                RETURN QUERY SELECT 
                    current_usage.users_count < user_subscription.user_limit as allowed,
                    current_usage.users_count as current_count,
                    user_subscription.user_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            WHEN 'client' THEN
                RETURN QUERY SELECT 
                    current_usage.clients_count < user_subscription.client_limit as allowed,
                    current_usage.clients_count as current_count,
                    user_subscription.client_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            ELSE
                RETURN QUERY SELECT FALSE, 0, 0, user_subscription.plan_type;
        END CASE;
    ELSIF user_subscription.status = 'active' THEN
        -- Assinatura ativa, verificar limites
        CASE check_type
            WHEN 'transaction' THEN
                RETURN QUERY SELECT 
                    current_usage.transactions_count < user_subscription.monthly_transaction_limit as allowed,
                    current_usage.transactions_count as current_count,
                    user_subscription.monthly_transaction_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            WHEN 'user' THEN
                RETURN QUERY SELECT 
                    current_usage.users_count < user_subscription.user_limit as allowed,
                    current_usage.users_count as current_count,
                    user_subscription.user_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            WHEN 'client' THEN
                RETURN QUERY SELECT 
                    current_usage.clients_count < user_subscription.client_limit as allowed,
                    current_usage.clients_count as current_count,
                    user_subscription.client_limit as limit_count,
                    user_subscription.plan_type as plan_type;
            ELSE
                RETURN QUERY SELECT FALSE, 0, 0, user_subscription.plan_type;
        END CASE;
    ELSE
        -- Assinatura inativa ou expirada
        RETURN QUERY SELECT FALSE, 0, 0, user_subscription.plan_type;
    END IF;
END;
$$;

-- 4. CRIAR FUNÇÃO PARA INCREMENTAR USO
CREATE OR REPLACE FUNCTION public.increment_usage(
    target_user_id UUID,
    usage_type VARCHAR(20),
    increment_by INTEGER DEFAULT 1
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_month VARCHAR(7);
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- Usuário master não precisa incrementar uso
    IF target_user_id = master_user_id THEN
        RETURN TRUE;
    END IF;

    -- Obter mês atual
    current_month := TO_CHAR(NOW(), 'YYYY-MM');

    -- Incrementar uso baseado no tipo
    CASE usage_type
        WHEN 'transaction' THEN
            INSERT INTO public.usage_tracking (user_id, month_year, transactions_count)
            VALUES (target_user_id, current_month, increment_by)
            ON CONFLICT (user_id, month_year)
            DO UPDATE SET 
                transactions_count = public.usage_tracking.transactions_count + increment_by,
                updated_at = NOW();
        WHEN 'user' THEN
            INSERT INTO public.usage_tracking (user_id, month_year, users_count)
            VALUES (target_user_id, current_month, increment_by)
            ON CONFLICT (user_id, month_year)
            DO UPDATE SET 
                users_count = public.usage_tracking.users_count + increment_by,
                updated_at = NOW();
        WHEN 'client' THEN
            INSERT INTO public.usage_tracking (user_id, month_year, clients_count)
            VALUES (target_user_id, current_month, increment_by)
            ON CONFLICT (user_id, month_year)
            DO UPDATE SET 
                clients_count = public.usage_tracking.clients_count + increment_by,
                updated_at = NOW();
        ELSE
            RETURN FALSE;
    END CASE;

    RETURN TRUE;
END;
$$;

-- 5. CRIAR FUNÇÃO PARA CRIAR TRIAL AUTOMÁTICO
CREATE OR REPLACE FUNCTION public.create_trial_for_user(target_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Verificar se já existe assinatura
    IF EXISTS (SELECT 1 FROM public.subscriptions WHERE user_id = target_user_id) THEN
        RETURN FALSE;
    END IF;

    -- Criar trial
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
        'trial',
        NOW() + INTERVAL '14 days',
        100,
        1,
        10
    );

    RETURN TRUE;
END;
$$;

-- 6. CRIAR RLS POLICIES
ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usage_tracking ENABLE ROW LEVEL SECURITY;

-- Políticas para subscriptions
CREATE POLICY "Users can view own subscription" ON public.subscriptions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own subscription" ON public.subscriptions
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own subscription" ON public.subscriptions
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para usage_tracking
CREATE POLICY "Users can view own usage" ON public.usage_tracking
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own usage" ON public.usage_tracking
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own usage" ON public.usage_tracking
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 7. CRIAR TRIGGER PARA ATUALIZAR updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_subscriptions_updated_at 
    BEFORE UPDATE ON public.subscriptions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usage_tracking_updated_at 
    BEFORE UPDATE ON public.usage_tracking 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 8. CRIAR ASSINATURA PARA USUÁRIO MASTER
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
    999999,
    999999,
    999999
) ON CONFLICT (user_id) DO NOTHING;

-- 9. CRIAR TRIALS PARA USUÁRIOS EXISTENTES SEM ASSINATURA
DO $$
DECLARE
    user_record RECORD;
BEGIN
    FOR user_record IN 
        SELECT id FROM auth.users 
        WHERE id NOT IN (SELECT user_id FROM public.subscriptions)
        AND id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    LOOP
        PERFORM public.create_trial_for_user(user_record.id);
    END LOOP;
END $$;

-- 10. VERIFICAÇÃO FINAL
SELECT 
    'Sistema de assinaturas criado com sucesso!' as status,
    COUNT(*) as total_subscriptions,
    COUNT(CASE WHEN status = 'trial' THEN 1 END) as trial_users,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_users
FROM public.subscriptions;
