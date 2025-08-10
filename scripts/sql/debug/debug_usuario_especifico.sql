-- scripts/sql/debug/debug_usuario_especifico.sql
-- =====================================================
-- DEBUG USUÁRIO ESPECÍFICO - LIMITES DE TRANSAÇÕES
-- =====================================================

DO $$
DECLARE
    target_user_id UUID := '5b86818d-3fbe-4e30-ac35-68211c100b90';
    current_month VARCHAR(7) := TO_CHAR(NOW(), 'YYYY-MM');
    user_subscription RECORD;
    current_usage RECORD;
    test_result RECORD;
    test_increment RECORD;
BEGIN
    RAISE NOTICE '=== DEBUG USUÁRIO: % ===', target_user_id;
    RAISE NOTICE '=== MÊS ATUAL: % ===', current_month;
    
    -- 1. VERIFICAR SE O USUÁRIO EXISTE
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = target_user_id) THEN
        RAISE NOTICE 'ERRO: Usuário não existe em auth.users';
        RETURN;
    END IF;
    
    -- 2. VERIFICAR ASSINATURA
    SELECT * INTO user_subscription 
    FROM public.subscriptions 
    WHERE user_id = target_user_id;
    
    IF user_subscription IS NULL THEN
        RAISE NOTICE 'AVISO: Usuário não tem assinatura - será criada automaticamente';
    ELSE
        RAISE NOTICE 'ASSINATURA: plan_type=%, status=%, trial_ends_at=%, monthly_limit=%', 
            user_subscription.plan_type, 
            user_subscription.status, 
            user_subscription.trial_ends_at, 
            user_subscription.monthly_transaction_limit;
    END IF;
    
    -- 3. VERIFICAR USO ATUAL
    SELECT * INTO current_usage 
    FROM public.usage_tracking 
    WHERE user_id = target_user_id AND month_year = current_month;
    
    IF current_usage IS NULL THEN
        RAISE NOTICE 'AVISO: Usuário não tem registro de uso para % - será criado automaticamente', current_month;
    ELSE
        RAISE NOTICE 'USO ATUAL: transactions=%, users=%, clients=%', 
            current_usage.transactions_count, 
            current_usage.users_count, 
            current_usage.clients_count;
    END IF;
    
    -- 4. TESTAR FUNÇÃO check_plan_limits
    SELECT * INTO test_result 
    FROM public.check_plan_limits(target_user_id, 'transaction');
    
    RAISE NOTICE 'RESULTADO check_plan_limits: allowed=%, current=%, limit=%, plan=%', 
        test_result.allowed, 
        test_result.current_count, 
        test_result.limit_count, 
        test_result.plan_type;
    
    -- 5. VERIFICAR SE ESTÁ NO TRIAL
    IF user_subscription IS NOT NULL AND user_subscription.trial_ends_at IS NOT NULL THEN
        IF user_subscription.trial_ends_at > NOW() THEN
            RAISE NOTICE 'STATUS TRIAL: Usuário está no trial válido até %', user_subscription.trial_ends_at;
        ELSE
            RAISE NOTICE 'STATUS TRIAL: Trial expirado em %', user_subscription.trial_ends_at;
        END IF;
    END IF;
    
    -- 6. TESTAR FUNÇÃO increment_usage
    RAISE NOTICE 'TESTANDO increment_usage...';
    BEGIN
        SELECT * INTO test_increment 
        FROM public.increment_usage(target_user_id, 'transaction', 1);
        RAISE NOTICE 'increment_usage executado com sucesso';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'ERRO em increment_usage: %', SQLERRM;
    END;
    
    -- 7. VERIFICAR USO APÓS INCREMENTO
    SELECT * INTO current_usage 
    FROM public.usage_tracking 
    WHERE user_id = target_user_id AND month_year = current_month;
    
    IF current_usage IS NOT NULL THEN
        RAISE NOTICE 'USO APÓS INCREMENTO: transactions=%, users=%, clients=%', 
            current_usage.transactions_count, 
            current_usage.users_count, 
            current_usage.clients_count;
    END IF;
    
    -- 8. CALCULAR MANUALMENTE SE PODE CRIAR TRANSAÇÃO
    IF user_subscription IS NOT NULL AND current_usage IS NOT NULL THEN
        IF user_subscription.monthly_transaction_limit IS NOT NULL THEN
            IF current_usage.transactions_count < user_subscription.monthly_transaction_limit THEN
                RAISE NOTICE 'CÁLCULO MANUAL: PODE criar transação (% < %)', 
                    current_usage.transactions_count, user_subscription.monthly_transaction_limit;
            ELSE
                RAISE NOTICE 'CÁLCULO MANUAL: NÃO PODE criar transação (% >= %)', 
                    current_usage.transactions_count, user_subscription.monthly_transaction_limit;
            END IF;
        ELSE
            RAISE NOTICE 'CÁLCULO MANUAL: monthly_transaction_limit é NULL';
        END IF;
    END IF;
    
END $$;

-- 9. MOSTRAR TODOS OS DADOS RELEVANTES
SELECT 
    '=== RESUMO COMPLETO ===' as info,
    s.user_id,
    s.plan_type,
    s.status,
    s.monthly_transaction_limit,
    s.trial_ends_at,
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
    END as can_create_transaction,
    CASE 
        WHEN s.trial_ends_at > NOW() THEN 'Trial válido'
        ELSE 'Trial expirado ou não aplicável'
    END as trial_status
FROM public.subscriptions s
LEFT JOIN public.usage_tracking ut ON s.user_id = ut.user_id 
    AND ut.month_year = TO_CHAR(NOW(), 'YYYY-MM')
WHERE s.user_id = '5b86818d-3fbe-4e30-ac35-68211c100b90';

-- 10. VERIFICAR FUNÇÕES DISPONÍVEIS
SELECT 
    '=== FUNÇÕES DISPONÍVEIS ===' as info,
    routine_name,
    routine_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
    AND routine_name IN ('check_plan_limits', 'increment_usage', 'is_user_in_trial')
ORDER BY routine_name;
