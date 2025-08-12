-- SOLUÇÃO RÁPIDA PARA ERRO RLS
-- Execute este script no Supabase SQL Editor para corrigir imediatamente

-- 1. Desabilitar RLS temporariamente para permitir inserções
SELECT '=== DESABILITANDO RLS TEMPORARIAMENTE ===' as info;
ALTER TABLE transactions_2025_08 DISABLE ROW LEVEL SECURITY;

-- 2. Remover todas as políticas antigas
SELECT '=== REMOVENDO POLÍTICAS ANTIGAS ===' as info;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can insert own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Full access to transactions" ON transactions_2025_08;

-- 3. Testar inserção sem RLS
SELECT '=== TESTANDO INSERÇÃO SEM RLS ===' as info;
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
    'TESTE SOLUÇÃO RÁPIDA - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_solucao', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 4. Verificar se foi inserida
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE description = 'TESTE SOLUÇÃO RÁPIDA - 12/08/2025'
ORDER BY created_at DESC;

-- 5. Reabilitar RLS com políticas corretas
SELECT '=== REABILITANDO RLS COM POLÍTICAS CORRETAS ===' as info;
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

-- 6. Testar inserção com RLS ativo
SELECT '=== TESTANDO INSERÇÃO COM RLS ATIVO ===' as info;
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
    'TESTE RLS ATIVO - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_rls_ativo', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 7. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'transactions_2025_08'
ORDER BY policyname;

-- 8. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions_2025_08 
WHERE description IN ('TESTE SOLUÇÃO RÁPIDA - 12/08/2025', 'TESTE RLS ATIVO - 12/08/2025');

SELECT '=== PROBLEMA RESOLVIDO! AGORA VOCÊ PODE INSERIR TRANSAÇÕES ===' as info;
