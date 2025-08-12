-- DIAGNÓSTICO COMPLETO DO ERRO RLS
-- Execute este script no Supabase SQL Editor para identificar o problema

-- 1. Verificar usuário atual
SELECT '=== USUÁRIO ATUAL ===' as info;
SELECT 
    auth.uid() as user_id_atual,
    auth.role() as role_atual;

-- 2. Verificar se a tabela transactions_2025_08 existe
SELECT '=== VERIFICANDO TABELA ===' as info;
SELECT 
    table_name,
    table_type,
    is_insertable_into
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08';

-- 3. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08'
ORDER BY ordinal_position;

-- 4. Verificar se RLS está habilitado
SELECT '=== STATUS RLS ===' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions_2025_08';

-- 5. Verificar políticas atuais
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
WHERE tablename = 'transactions_2025_08'
ORDER BY policyname;

-- 6. Testar acesso direto sem RLS
SELECT '=== TESTE SEM RLS ===' as info;
-- Desabilitar RLS temporariamente
ALTER TABLE transactions_2025_08 DISABLE ROW LEVEL SECURITY;

-- Tentar inserção
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
    'TESTE SEM RLS - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_sem_rls', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- Verificar se foi inserida
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE description = 'TESTE SEM RLS - 12/08/2025'
ORDER BY created_at DESC;

-- 7. Reabilitar RLS e criar políticas corretas
SELECT '=== REABILITANDO RLS ===' as info;
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;

-- Criar políticas corretas
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 8. Verificar políticas criadas
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

-- 9. Testar inserção com RLS ativo
SELECT '=== TESTE COM RLS ATIVO ===' as info;
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
    'TESTE COM RLS - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_com_rls', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 10. Verificar inserção
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE description = 'TESTE COM RLS - 12/08/2025'
ORDER BY created_at DESC;

-- 11. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions_2025_08 
WHERE description IN ('TESTE SEM RLS - 12/08/2025', 'TESTE COM RLS - 12/08/2025');

-- 12. Verificar permissões do usuário
SELECT '=== PERMISSÕES DO USUÁRIO ===' as info;
SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.table_privileges 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08'
  AND grantee = 'authenticated';

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as info;
