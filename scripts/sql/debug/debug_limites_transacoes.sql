-- =====================================================
-- DEBUG LIMITES DE TRANSAÇÕES
-- =====================================================

-- 1. VERIFICAR DADOS DO USUÁRIO ESPECÍFICO
SELECT 
    '=== DADOS DO USUÁRIO ===' as info,
    s.user_id,
    s.plan_type,
    s.status,
    s.monthly_transaction_limit,
    s.trial_ends_at,
    s.created_at
FROM public.subscriptions s
WHERE s.user_id = '5b86818d-3fbe-4e30-ac35-68211c100b90';

-- 2. VERIFICAR USO ATUAL
SELECT 
    '=== USO ATUAL ===' as info,
    ut.user_id,
    ut.month_year,
    ut.transactions_count,
    ut.users_count,
    ut.clients_count,
    ut.created_at,
    ut.updated_at
FROM public.usage_tracking ut
WHERE ut.user_id = '5b86818d-3fbe-4e30-ac35-68211c100b90';

-- 3. TESTAR FUNÇÃO check_plan_limits MANUALMENTE
SELECT 
    '=== TESTE MANUAL check_plan_limits ===' as info,
    *
FROM public.check_plan_limits(
    '5b86818d-3fbe-4e30-ac35-68211c100b90',
    'transaction'
);

-- 4. VERIFICAR SE O USUÁRIO ESTÁ NO TRIAL
SELECT 
    '=== VERIFICAÇÃO DE TRIAL ===' as info,
    s.user_id,
    s.status,
    s.trial_ends_at,
    CASE 
        WHEN s.trial_ends_at > NOW() THEN 'Dentro do trial'
        ELSE 'Trial expirado'
    END as trial_status,
    CASE 
        WHEN s.trial_ends_at > NOW() THEN 
            EXTRACT(DAY FROM (s.trial_ends_at - NOW()))
        ELSE 0
    END as dias_restantes
FROM public.subscriptions s
WHERE s.user_id = '5b86818d-3fbe-4e30-ac35-68211c100b90';

-- 5. VERIFICAR TODOS OS USUÁRIOS E SEUS LIMITES
SELECT 
    '=== TODOS OS USUÁRIOS ===' as info,
    s.user_id,
    s.plan_type,
    s.status,
    s.monthly_transaction_limit,
    COALESCE(ut.transactions_count, 0) as transactions_used,
    CASE 
        WHEN s.monthly_transaction_limit IS NOT NULL THEN 
            s.monthly_transaction_limit - COALESCE(ut.transactions_count, 0)
        ELSE 0
    END as transactions_remaining,
    CASE 
        WHEN s.monthly_transaction_limit IS NOT NULL AND ut.transactions_count IS NOT NULL THEN
            COALESCE(ut.transactions_count, 0) < s.monthly_transaction_limit
        ELSE true
    END as can_create_transaction
FROM public.subscriptions s
LEFT JOIN public.usage_tracking ut ON s.user_id = ut.user_id 
    AND ut.month_year = TO_CHAR(NOW(), 'YYYY-MM')
ORDER BY s.created_at DESC;
