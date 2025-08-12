-- SOLUÇÃO SIMPLES PARA PROBLEMA DE DELETE
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estado atual
SELECT '=== ESTADO ATUAL ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, cmd, policyname;

-- 2. Remover todas as políticas existentes
SELECT '=== REMOVENDO POLÍTICAS ANTIGAS ===' as info;

-- Para transactions
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions;
DROP POLICY IF EXISTS "Master user full access" ON transactions;

-- Para transactions_2025_08
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Master user full access" ON transactions_2025_08;

-- 3. Criar políticas simples e diretas
SELECT '=== CRIANDO POLÍTICAS SIMPLES ===' as info;

-- Para transactions
CREATE POLICY "Users can view their own transactions" ON transactions 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions 
FOR DELETE USING (auth.uid() = user_id);

-- Para transactions_2025_08
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 4. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, cmd, policyname;

-- 5. Testar DELETE
SELECT '=== TESTANDO DELETE ===' as info;

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
    'TESTE DELETE SIMPLES', 
    555.00, 
    'income', 
    'teste_simples', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 6. Verificar se foi inserida
SELECT 
    'Transações com descrição de teste:' as status,
    COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE description = 'TESTE DELETE SIMPLES';

-- 7. Deletar a transação de teste
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE DELETE SIMPLES';

-- 8. Verificar se foi deletada
SELECT 
    'Transações restantes após delete:' as status,
    COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE description = 'TESTE DELETE SIMPLES';

-- 9. Verificar dados disponíveis
SELECT '=== DADOS DISPONÍVEIS ===' as info;
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

SELECT '=== DELETE CORRIGIDO COM SUCESSO! ===' as info;
