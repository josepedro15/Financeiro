-- CORREÇÃO RLS SIMPLES E DIRETA
-- Execute este script no Supabase SQL Editor

-- 1. Corrigir RLS para transactions_2025_08 (agosto)
SELECT '=== CORRIGINDO RLS PARA AGOSTO 2025 ===' as info;

-- Desabilitar RLS temporariamente
ALTER TABLE transactions_2025_08 DISABLE ROW LEVEL SECURITY;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can insert own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Full access to transactions" ON transactions_2025_08;

-- Reabilitar RLS
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;

-- Criar políticas corretas
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 2. Testar inserção
SELECT '=== TESTANDO INSERÇÃO ===' as info;
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
    'TESTE RLS SIMPLES - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_simples', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 3. Verificar se funcionou
SELECT '=== VERIFICANDO RESULTADO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE description = 'TESTE RLS SIMPLES - 12/08/2025'
ORDER BY created_at DESC;

-- 4. Limpar teste
SELECT '=== LIMPANDO TESTE ===' as info;
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE RLS SIMPLES - 12/08/2025';

-- 5. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd
FROM pg_policies 
WHERE tablename = 'transactions_2025_08'
ORDER BY policyname;

SELECT '=== RLS CORRIGIDO COM SUCESSO! ===' as info;
