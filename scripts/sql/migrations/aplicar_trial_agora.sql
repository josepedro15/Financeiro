-- Script para aplicar trial IMEDIATAMENTE
-- Execute este script no Supabase SQL Editor

SELECT '=== APLICANDO TRIAL IMEDIATAMENTE ===' as status;

-- 1. Verificar usuário atual
SELECT 
    'USUÁRIO ATUAL:' as info,
    au.id,
    au.email,
    au.created_at
FROM auth.users au
WHERE au.email = 'josepedro15net@gmail.com';

-- 2. Verificar se já tem assinatura
SELECT 
    'ASSINATURA ATUAL:' as info,
    s.id,
    s.plan_type,
    s.status,
    s.trial_ends_at,
    s.monthly_transaction_limit,
    s.user_limit,
    s.client_limit
FROM public.subscriptions s
WHERE s.user_id = (
    SELECT id FROM auth.users 
    WHERE email = 'josepedro15net@gmail.com'
);

-- 3. Criar ou atualizar trial
DO $$
DECLARE
    user_id UUID;
    subscription_id UUID;
BEGIN
    -- Buscar ID do usuário
    SELECT id INTO user_id 
    FROM auth.users 
    WHERE email = 'josepedro15net@gmail.com';
    
    IF user_id IS NULL THEN
        RAISE EXCEPTION 'Usuário não encontrado';
    END IF;
    
    -- Verificar se já tem assinatura
    SELECT id INTO subscription_id 
    FROM public.subscriptions 
    WHERE user_id = user_id;
    
    IF subscription_id IS NULL THEN
        -- Criar nova assinatura com trial
        INSERT INTO public.subscriptions (
            user_id,
            plan_type,
            status,
            trial_ends_at,
            monthly_transaction_limit,
            user_limit,
            client_limit,
            started_at
        ) VALUES (
            user_id,
            'starter',
            'trial',
            NOW() + INTERVAL '14 days',
            100,
            1,
            10
        );
        RAISE NOTICE 'Nova assinatura com trial criada para: %', user_id;
    ELSE
        -- Atualizar assinatura existente para trial
        UPDATE public.subscriptions 
        SET 
            plan_type = 'starter',
            status = 'trial',
            trial_ends_at = NOW() + INTERVAL '14 days',
            monthly_transaction_limit = 100,
            user_limit = 1,
            client_limit = 10,
            updated_at = NOW()
        WHERE id = subscription_id;
        RAISE NOTICE 'Assinatura atualizada para trial: %', subscription_id;
    END IF;
    
    -- Criar ou atualizar registro de uso
    INSERT INTO public.usage_tracking (
        user_id,
        month_year,
        transactions_count,
        users_count,
        clients_count
    ) VALUES (
        user_id,
        TO_CHAR(NOW(), 'YYYY-MM'),
        0,
        1,
        0
    ) ON CONFLICT (user_id, month_year) 
    DO UPDATE SET
        transactions_count = 0,
        users_count = 1,
        clients_count = 0,
        updated_at = NOW();
    
    RAISE NOTICE 'Registro de uso criado/atualizado';
END $$;

-- 4. Verificar resultado
SELECT 
    'RESULTADO FINAL:' as info,
    au.email,
    s.plan_type,
    s.status,
    s.trial_ends_at,
    CASE 
        WHEN s.status = 'trial' AND s.trial_ends_at > NOW() THEN 'TRIAL ATIVO'
        WHEN s.status = 'active' THEN 'ASSINATURA ATIVA'
        WHEN s.plan_type = 'unlimited' THEN 'MASTER USER'
        ELSE 'SEM ACESSO'
    END as access_status,
    s.monthly_transaction_limit,
    s.user_limit,
    s.client_limit
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
WHERE au.email = 'josepedro15net@gmail.com';

-- 5. Verificar uso atual
SELECT 
    'USO ATUAL:' as info,
    ut.month_year,
    ut.transactions_count,
    ut.users_count,
    ut.clients_count
FROM auth.users au
LEFT JOIN public.usage_tracking ut ON au.id = ut.user_id 
    AND ut.month_year = TO_CHAR(NOW(), 'YYYY-MM')
WHERE au.email = 'josepedro15net@gmail.com';

SELECT '=== TRIAL APLICADO COM SUCESSO ===' as final_status;
