-- SOLUÇÃO ESPECÍFICA PARA USUÁRIO MASTER
-- O usuário 2dc520e3-5f19-4dfe-838b-1aca7238ae36 é o MASTER USER
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se é realmente o master user
SELECT '=== CONFIRMANDO USUÁRIO MASTER ===' as info;
SELECT 
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36' as master_user_id,
    'Este é o usuário master com acesso total ao sistema' as descricao;

-- 2. Criar função para verificar se é master user
CREATE OR REPLACE FUNCTION is_master_user(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN user_uuid = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
END;
$$;

-- 3. Corrigir políticas RLS para permitir acesso total ao master user
SELECT '=== CORRIGINDO POLÍTICAS RLS PARA MASTER USER ===' as info;

-- Para tabela transactions principal
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Master user full access" ON transactions;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;

-- Criar políticas que permitem acesso total ao master user
CREATE POLICY "Master user full access" ON transactions FOR ALL 
USING (is_master_user(auth.uid()) OR auth.uid() = user_id) 
WITH CHECK (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- Para tabela transactions_2025_08
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Master user full access" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;

-- Criar políticas que permitem acesso total ao master user
CREATE POLICY "Master user full access" ON transactions_2025_08 FOR ALL 
USING (is_master_user(auth.uid()) OR auth.uid() = user_id) 
WITH CHECK (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- 4. Corrigir todas as outras tabelas mensais
SELECT '=== CORRIGINDO TODAS AS TABELAS MENSAIS ===' as info;
DO $$
DECLARE
    table_record RECORD;
BEGIN
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_name LIKE 'transactions_2025_%'
          AND table_name != 'transactions_2025_08'
        ORDER BY table_name
    LOOP
        RAISE NOTICE 'Corrigindo tabela: %', table_record.table_name;
        
        -- Habilitar RLS
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', table_record.table_name);
        
        -- Remover políticas antigas
        EXECUTE format('DROP POLICY IF EXISTS "Master user full access" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can view their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can create their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can update their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', table_record.table_name);
        
        -- Criar política de acesso total para master user
        EXECUTE format('CREATE POLICY "Master user full access" ON %I FOR ALL USING (is_master_user(auth.uid()) OR auth.uid() = user_id) WITH CHECK (is_master_user(auth.uid()) OR auth.uid() = user_id)', table_record.table_name);
        
        RAISE NOTICE 'Tabela % corrigida', table_record.table_name;
    END LOOP;
END $$;

-- 5. Testar inserção como master user
SELECT '=== TESTANDO INSERÇÃO COMO MASTER USER ===' as info;

-- Simular contexto do master user
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claim.sub" TO '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Testar inserção na tabela principal
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
    'TESTE MASTER USER - TABELA PRINCIPAL', 
    2000.00, 
    'income', 
    'teste_master', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- Testar inserção na tabela mensal
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
    'TESTE MASTER USER - TABELA MENSAIS', 
    2000.00, 
    'income', 
    'teste_master', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 6. Verificar inserções
SELECT '=== VERIFICANDO INSERÇÕES ===' as info;
SELECT 
    'Tabela Principal' as tabela,
    id,
    description,
    transaction_date
FROM transactions 
WHERE description LIKE 'TESTE MASTER USER%'
UNION ALL
SELECT 
    'Tabela Mensal' as tabela,
    id,
    description,
    transaction_date
FROM transactions_2025_08 
WHERE description LIKE 'TESTE MASTER USER%';

-- 7. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions WHERE description LIKE 'TESTE MASTER USER%';
DELETE FROM transactions_2025_08 WHERE description LIKE 'TESTE MASTER USER%';

-- 8. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, policyname;

-- 9. Testar função is_master_user
SELECT '=== TESTANDO FUNÇÃO IS_MASTER_USER ===' as info;
SELECT 
    is_master_user('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID) as master_user_result,
    is_master_user('00000000-0000-0000-0000-000000000000'::UUID) as other_user_result;

SELECT '=== MASTER USER CORRIGIDO COM SUCESSO! ===' as info;
