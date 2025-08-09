-- Script para verificar sistema de trial
-- Execute este script para diagnosticar problemas

SELECT '=== DIAGNÓSTICO DO SISTEMA DE TRIAL ===' as status;

-- 1. Verificar estrutura das tabelas
SELECT '=== ESTRUTURA DAS TABELAS ===' as info;

SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name IN ('subscriptions', 'usage_tracking')
ORDER BY table_name, ordinal_position;

-- 2. Verificar funções
SELECT '=== FUNÇÕES DO SISTEMA ===' as info;

SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
    AND routine_name IN ('check_plan_limits', 'increment_usage', 'is_user_in_trial')
ORDER BY routine_name;

-- 3. Verificar políticas RLS
SELECT '=== POLÍTICAS RLS ===' as info;

SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE schemaname = 'public' 
    AND tablename IN ('subscriptions', 'usage_tracking')
ORDER BY tablename, policyname;

-- 4. Verificar dados atuais
SELECT '=== DADOS ATUAIS ===' as info;

-- Assinaturas
SELECT 
    'SUBSCRIPTIONS:' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN status = 'trial' THEN 1 END) as trial_count,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_count,
    COUNT(CASE WHEN plan_type = 'unlimited' THEN 1 END) as unlimited_count
FROM public.subscriptions;

-- Usage tracking
SELECT 
    'USAGE_TRACKING:' as table_name,
    COUNT(*) as total_records,
    COUNT(DISTINCT user_id) as unique_users
FROM public.usage_tracking;

-- 5. Verificar usuários específicos
SELECT '=== USUÁRIOS ESPECÍFICOS ===' as info;

SELECT 
    au.id,
    au.email,
    au.created_at as user_created,
    s.id as subscription_id,
    s.plan_type,
    s.status,
    s.trial_ends_at,
    s.monthly_transaction_limit,
    s.user_limit,
    s.client_limit,
    s.created_at as subscription_created,
    ut.transactions_count,
    ut.users_count,
    ut.clients_count
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
LEFT JOIN public.usage_tracking ut ON au.id = ut.user_id AND ut.month_year = TO_CHAR(NOW(), 'YYYY-MM')
ORDER BY au.created_at DESC;

-- 6. Testar função check_plan_limits
SELECT '=== TESTE DA FUNÇÃO CHECK_PLAN_LIMITS ===' as info;

-- Testar com usuário master
SELECT 
    'MASTER USER TEST:' as test_type,
    check_plan_limits('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'transaction') as result;

-- Testar com usuário trial (se existir)
DO $$
DECLARE
    trial_user_id UUID;
    test_result RECORD;
BEGIN
    -- Buscar um usuário em trial
    SELECT user_id INTO trial_user_id
    FROM public.subscriptions
    WHERE status = 'trial' AND trial_ends_at > NOW()
    LIMIT 1;
    
    IF trial_user_id IS NOT NULL THEN
        SELECT * INTO test_result FROM check_plan_limits(trial_user_id, 'transaction');
        RAISE NOTICE 'TRIAL USER TEST: allowed=%, current_count=%, limit_count=%, plan_type=%', 
            test_result.allowed, test_result.current_count, test_result.limit_count, test_result.plan_type;
    ELSE
        RAISE NOTICE 'Nenhum usuário em trial encontrado para teste';
    END IF;
END $$;

-- 7. Verificar problemas comuns
SELECT '=== VERIFICAÇÃO DE PROBLEMAS ===' as info;

-- Usuários sem assinatura
SELECT 
    'USUÁRIOS SEM ASSINATURA:' as problem,
    COUNT(*) as count
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
WHERE s.user_id IS NULL 
AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Trials expirados
SELECT 
    'TRIALS EXPIRADOS:' as problem,
    COUNT(*) as count
FROM public.subscriptions
WHERE status = 'trial' AND trial_ends_at <= NOW();

-- Assinaturas sem limites definidos
SELECT 
    'ASSINATURAS SEM LIMITES:' as problem,
    COUNT(*) as count
FROM public.subscriptions
WHERE monthly_transaction_limit IS NULL 
AND plan_type != 'unlimited';

-- 8. Recomendações
SELECT '=== RECOMENDAÇÕES ===' as info;

SELECT 
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM auth.users au
            LEFT JOIN public.subscriptions s ON au.id = s.user_id
            WHERE s.user_id IS NULL 
            AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
        ) THEN 'EXECUTAR: aplicar_trial_imediato.sql'
        ELSE 'OK: Todos os usuários têm assinatura'
    END as recommendation;

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as final_status;
