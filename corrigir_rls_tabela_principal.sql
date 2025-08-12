-- CORREÇÃO RLS PARA TABELA TRANSACTIONS PRINCIPAL
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se a tabela transactions existe
SELECT '=== VERIFICANDO TABELA PRINCIPAL ===' as info;
SELECT 
    table_name,
    table_type,
    is_insertable_into
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'transactions';

-- 2. Verificar políticas atuais da tabela principal
SELECT '=== POLÍTICAS ATUAIS DA TABELA PRINCIPAL ===' as info;
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
WHERE tablename = 'transactions'
ORDER BY policyname;

-- 3. Corrigir RLS para tabela transactions principal
SELECT '=== CORRIGINDO RLS PARA TABELA PRINCIPAL ===' as info;

-- Desabilitar RLS temporariamente
ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON transactions;
DROP POLICY IF EXISTS "Users can insert own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can delete own transactions" ON transactions;
DROP POLICY IF EXISTS "Full access to transactions" ON transactions;

-- Reabilitar RLS
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Criar políticas corretas
CREATE POLICY "Users can view their own transactions" ON transactions 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own transactions" ON transactions 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions 
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions 
FOR DELETE USING (auth.uid() = user_id);

-- 4. Testar inserção na tabela principal
SELECT '=== TESTANDO INSERÇÃO NA TABELA PRINCIPAL ===' as info;
INSERT INTO transactions (
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
    'TESTE TABELA PRINCIPAL - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_principal', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 5. Verificar inserção
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions 
WHERE description = 'TESTE TABELA PRINCIPAL - 12/08/2025'
ORDER BY created_at DESC;

-- 6. Limpar teste
SELECT '=== LIMPANDO TESTE ===' as info;
DELETE FROM transactions 
WHERE description = 'TESTE TABELA PRINCIPAL - 12/08/2025';

-- 7. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'transactions'
ORDER BY policyname;

SELECT '=== RLS CORRIGIDO PARA TABELA PRINCIPAL ===' as info;
