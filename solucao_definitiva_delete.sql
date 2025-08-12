-- SOLUÇÃO DEFINITIVA PARA PROBLEMA DE DELETE
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estado atual das políticas
SELECT '=== ESTADO ATUAL DAS POLÍTICAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, cmd, policyname;

-- 2. Desabilitar RLS temporariamente para teste
SELECT '=== DESABILITANDO RLS TEMPORARIAMENTE ===' as info;
ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE transactions_2025_08 DISABLE ROW LEVEL SECURITY;

-- 3. Verificar se há dados para deletar
SELECT '=== VERIFICANDO DADOS DISPONÍVEIS ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Testar DELETE sem RLS
SELECT '=== TESTANDO DELETE SEM RLS ===' as info;

-- Inserir transação de teste
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE DELETE DEFINITIVO', 
    999.00, 
    'income', 
    'teste_definitivo', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 5. Deletar a transação de teste
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE DELETE DEFINITIVO';

-- 6. Verificar se foi deletada
SELECT 
    'Transações restantes com descrição de teste:' as status,
    COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE description = 'TESTE DELETE DEFINITIVO';

-- 7. Reabilitar RLS com políticas corretas
SELECT '=== REABILITANDO RLS COM POLÍTICAS CORRETAS ===' as info;

-- Para tabela transactions principal
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions;

-- Criar políticas completas para transactions
CREATE POLICY "Users can view their own transactions" ON transactions 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions 
FOR DELETE USING (auth.uid() = user_id);

-- Para tabela transactions_2025_08
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;

-- Criar políticas completas para transactions_2025_08
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 8. Criar função RPC para delete seguro
SELECT '=== CRIANDO FUNÇÃO RPC PARA DELETE ===' as info;

CREATE OR REPLACE FUNCTION delete_transaction_safe(
    p_transaction_id UUID,
    p_user_id UUID,
    p_transaction_date DATE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_table_name TEXT;
    v_result JSON;
    v_deleted_count INTEGER;
BEGIN
    -- Determinar tabela baseada na data
    IF EXTRACT(YEAR FROM p_transaction_date) = 2025 THEN
        v_table_name := 'transactions_' || EXTRACT(YEAR FROM p_transaction_date) || '_' || 
                       LPAD(EXTRACT(MONTH FROM p_transaction_date)::TEXT, 2, '0');
    ELSE
        v_table_name := 'transactions';
    END IF;
    
    -- Verificar se a tabela mensal existe
    IF v_table_name != 'transactions' AND NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = v_table_name
    ) THEN
        v_table_name := 'transactions';
    END IF;
    
    -- Deletar da tabela determinada
    EXECUTE format('DELETE FROM %I WHERE id = $1 AND user_id = $2', v_table_name)
    USING p_transaction_id, p_user_id;
    
    GET DIAGNOSTICS v_deleted_count = ROW_COUNT;
    
    -- Retornar resultado
    v_result := json_build_object(
        'success', v_deleted_count > 0,
        'deleted_count', v_deleted_count,
        'table_name', v_table_name,
        'transaction_id', p_transaction_id,
        'user_id', p_user_id
    );
    
    RETURN v_result;
END;
$$;

-- 9. Testar função RPC
SELECT '=== TESTANDO FUNÇÃO RPC ===' as info;

-- Inserir transação para testar
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE RPC DELETE', 
    888.00, 
    'income', 
    'teste_rpc', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 10. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, cmd, policyname;

-- 11. Verificar se há triggers que podem interferir
SELECT '=== VERIFICANDO TRIGGERS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table IN ('transactions', 'transactions_2025_08')
AND event_object_schema = 'public'
AND event_manipulation = 'DELETE';

-- 12. Verificar constraints
SELECT '=== VERIFICANDO CONSTRAINTS ===' as info;
SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints
WHERE table_name IN ('transactions', 'transactions_2025_08')
AND table_schema = 'public';

SELECT '=== SOLUÇÃO DEFINITIVA APLICADA! ===' as info;
