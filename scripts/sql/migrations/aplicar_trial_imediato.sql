-- Script para aplicar trial imediatamente
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se as tabelas existem
SELECT '=== VERIFICANDO TABELAS ===' as status;

SELECT 
    table_name,
    CASE WHEN table_name IN ('subscriptions', 'usage_tracking') THEN 'EXISTE' ELSE 'NÃO EXISTE' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_name IN ('subscriptions', 'usage_tracking');

-- 2. Verificar usuários atuais
SELECT '=== USUÁRIOS ATUAIS ===' as status;

SELECT 
    au.id,
    au.email,
    CASE 
        WHEN s.user_id IS NOT NULL THEN 'TEM ASSINATURA'
        ELSE 'SEM ASSINATURA'
    END as subscription_status,
    s.plan_type,
    s.status,
    s.trial_ends_at
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
ORDER BY au.created_at DESC;

-- 3. Criar trial para usuários sem assinatura
SELECT '=== CRIANDO TRIALS ===' as status;

DO $$
DECLARE
    user_record RECORD;
    trial_count INTEGER := 0;
BEGIN
    -- Para cada usuário que não tem assinatura, criar trial
    FOR user_record IN 
        SELECT au.id, au.email 
        FROM auth.users au
        LEFT JOIN public.subscriptions s ON au.id = s.user_id
        WHERE s.user_id IS NULL 
        AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'  -- Excluir master
    LOOP
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
                user_record.id,
                'starter',
                'trial',
                NOW() + INTERVAL '14 days',
                100,
                1,
                10
            );
            
            trial_count := trial_count + 1;
            RAISE NOTICE 'Trial criado para usuário: % (%)', user_record.email, user_record.id;
            
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Erro ao criar trial para %: %', user_record.email, SQLERRM;
        END;
    END LOOP;
    
    RAISE NOTICE 'Total de trials criados: %', trial_count;
END $$;

-- 4. Verificar resultado
SELECT '=== RESULTADO FINAL ===' as status;

SELECT 
    au.email,
    s.plan_type,
    s.status,
    s.trial_ends_at,
    CASE 
        WHEN s.status = 'trial' AND s.trial_ends_at > NOW() THEN 'TRIAL ATIVO'
        WHEN s.status = 'active' THEN 'ASSINATURA ATIVA'
        WHEN s.plan_type = 'unlimited' THEN 'MASTER USER'
        ELSE 'SEM ACESSO'
    END as access_status
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
ORDER BY au.created_at DESC;

-- 5. Contagem final
SELECT 
    'RESUMO:' as info,
    COUNT(*) as total_users,
    COUNT(CASE WHEN s.status = 'trial' AND s.trial_ends_at > NOW() THEN 1 END) as active_trials,
    COUNT(CASE WHEN s.status = 'active' THEN 1 END) as active_subscriptions,
    COUNT(CASE WHEN s.plan_type = 'unlimited' THEN 1 END) as master_users
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id;

SELECT '=== TRIAL APLICADO COM SUCESSO ===' as final_status;
