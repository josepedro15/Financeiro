-- Script para corrigir sistema de trial
-- Execute este script no Supabase SQL Editor

-- 1. Recriar função com lógica de trial corrigida
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
        INSERT INTO public.usage_tracking (user_id, month_year)
        VALUES (target_user_id, current_month);
        
        SELECT * INTO usage_record 
        FROM public.usage_tracking 
        WHERE user_id = target_user_id AND month_year = current_month;
    END IF;

    -- LÓGICA PRINCIPAL: Se está em trial, permitir acesso total
    IF is_trial_active THEN
        -- Durante o trial, permitir tudo mas mostrar uso atual
        IF check_type = 'transaction' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                usage_record.transactions_count as current_count,
                user_subscription.monthly_transaction_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'user' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                usage_record.users_count as current_count,
                user_subscription.user_limit as limit_count,
                user_subscription.plan_type as plan_type;
        ELSIF check_type = 'client' THEN
            RETURN QUERY SELECT 
                true as allowed, -- SEMPRE PERMITIDO NO TRIAL
                usage_record.clients_count as current_count,
                user_subscription.client_limit as limit_count,
                user_subscription.plan_type as plan_type;
        END IF;
    ELSE
        -- Após o trial, aplicar limites normais
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
    END IF;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Criar função para verificar especificamente se usuário está em trial
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

-- 3. Garantir que usuário master tenha configuração correta
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

-- 4. Testar as correções
SELECT '=== TESTE AFTER CORREÇÃO ===' as info;

-- Teste para usuário não-master (simular novo usuário)
SELECT 
    'TESTE NOVO USUÁRIO:' as teste,
    allowed,
    current_count,
    limit_count,
    plan_type
FROM public.check_plan_limits('00000000-0000-0000-0000-000000000001', 'transaction');

-- Teste para usuário master
SELECT 
    'TESTE USUÁRIO MASTER:' as teste,
    allowed,
    current_count,
    limit_count,
    plan_type
FROM public.check_plan_limits('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'transaction');

SELECT '=== CORREÇÕES APLICADAS COM SUCESSO ===' as status;
