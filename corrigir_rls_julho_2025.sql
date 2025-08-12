-- CORREÇÃO RLS ESPECÍFICA PARA JULHO 2025
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se a tabela existe
SELECT '=== VERIFICANDO TABELA JULHO 2025 ===' as info;
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_07';

-- 2. Verificar RLS atual
SELECT '=== RLS ATUAL ===' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions_2025_07';

-- 3. Verificar políticas atuais
SELECT '=== POLÍTICAS ATUAIS ===' as info;
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'transactions_2025_07';

-- 4. Corrigir RLS para transactions_2025_07
SELECT '=== CORRIGINDO RLS JULHO 2025 ===' as info;

-- Habilitar RLS
ALTER TABLE transactions_2025_07 ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Master user full access" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can insert own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can update own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Users can delete own transactions" ON transactions_2025_07;
DROP POLICY IF EXISTS "Full access to transactions" ON transactions_2025_07;

-- Criar políticas corretas
CREATE POLICY "Users can view their own transactions" ON transactions_2025_07 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions_2025_07 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_07 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_07 
FOR DELETE USING (auth.uid() = user_id);

-- 5. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'transactions_2025_07'
ORDER BY cmd, policyname;

-- 6. Testar inserção
SELECT '=== TESTANDO INSERÇÃO ===' as info;

INSERT INTO transactions_2025_07 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    client_name,
    created_at,
    updated_at
) VALUES (
    '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6', 
    'TESTE RLS JULHO 2025', 
    100.00, 
    'income', 
    'teste_rls', 
    '2025-07-15', 
    'Conta PJ',
    'Teste Cliente',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, account_name;

-- 7. Verificar inserção
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_date,
    account_name,
    client_name
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE RLS JULHO 2025';

-- 8. Limpar teste
DELETE FROM transactions_2025_07 
WHERE description = 'TESTE RLS JULHO 2025';

SELECT '=== RLS JULHO 2025 CORRIGIDO! ===' as info;
