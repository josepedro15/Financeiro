-- CORREÇÃO RLS PARA TABELA transactions_2025_08 (AGOSTO 2025)
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se a tabela existe
SELECT '=== VERIFICANDO TABELA ===' as info;
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'transactions_2025_08'
) as tabela_existe;

-- 2. Verificar políticas atuais
SELECT '=== POLÍTICAS ATUAIS ===' as info;
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
WHERE tablename = 'transactions_2025_08';

-- 3. Remover políticas antigas se existirem
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

-- 4. Habilitar RLS
SELECT '=== HABILITANDO RLS ===' as info;
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;

-- 5. Criar políticas corretas
SELECT '=== CRIANDO POLÍTICAS CORRETAS ===' as info;

-- Política para SELECT (visualizar)
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

-- Política para INSERT (criar)
CREATE POLICY "Users can create their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Política para UPDATE (atualizar)
CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id);

-- Política para DELETE (excluir)
CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 6. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
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
WHERE tablename = 'transactions_2025_08'
ORDER BY policyname;

-- 7. Testar permissões
SELECT '=== TESTANDO PERMISSÕES ===' as info;
SELECT COUNT(*) as transacoes_visiveis 
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 8. Testar inserção
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
    'TESTE RLS CORRIGIDO - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_rls', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 9. Verificar se foi inserida
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE description = 'TESTE RLS CORRIGIDO - 12/08/2025'
ORDER BY created_at DESC;

-- 10. Limpar teste
SELECT '=== LIMPANDO TESTE ===' as info;
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE RLS CORRIGIDO - 12/08/2025';

SELECT '=== RLS CORRIGIDO COM SUCESSO ===' as info;
