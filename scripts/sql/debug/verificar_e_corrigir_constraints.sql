-- =====================================================
-- VERIFICAR E CORRIGIR CONSTRAINTS DA TABELA SUBSCRIPTIONS
-- =====================================================

-- 1. VERIFICAR ESTRUTURA ATUAL DA TABELA
SELECT 
    '=== ESTRUTURA ATUAL ===' as info,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'subscriptions' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. VERIFICAR CONSTRAINTS ATUAIS
SELECT 
    '=== CONSTRAINTS ATUAIS ===' as info,
    constraint_name,
    constraint_type,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_name LIKE '%subscriptions%';

-- 3. VERIFICAR DADOS ATUAIS
SELECT 
    '=== DADOS ATUAIS ===' as info,
    user_id,
    plan_type,
    status,
    trial_ends_at,
    created_at
FROM public.subscriptions
ORDER BY created_at DESC;

-- 4. REMOVER CONSTRAINT PROBLEMÁTICA (se existir)
DO $$
BEGIN
    -- Tentar remover constraint se existir
    BEGIN
        ALTER TABLE public.subscriptions DROP CONSTRAINT IF EXISTS subscriptions_status_check;
        RAISE NOTICE 'Constraint removida com sucesso';
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao remover constraint: %', SQLERRM;
    END;
END $$;

-- 5. ADICIONAR CONSTRAINT CORRETA
ALTER TABLE public.subscriptions 
ADD CONSTRAINT subscriptions_status_check 
CHECK (status IN ('trial', 'active', 'inactive', 'cancelled', 'expired'));

-- 6. VERIFICAR SE A CONSTRAINT FOI ADICIONADA
SELECT 
    '=== CONSTRAINT VERIFICADA ===' as info,
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_name = 'subscriptions_status_check';

-- 7. TESTAR INSERÇÃO
DO $$
DECLARE
    test_user_id UUID := gen_random_uuid();
BEGIN
    -- Tentar inserir um registro de teste
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
            test_user_id,
            'starter',
            'trial',
            NOW() + INTERVAL '14 days',
            100,
            1,
            10
        );
        
        RAISE NOTICE 'Teste de inserção bem-sucedido para usuário: %', test_user_id;
        
        -- Remover o registro de teste
        DELETE FROM public.subscriptions WHERE user_id = test_user_id;
        RAISE NOTICE 'Registro de teste removido';
        
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Erro no teste de inserção: %', SQLERRM;
    END;
END $$;
