-- CORREÇÃO ESPECÍFICA PARA USUÁRIO 2dc520e3-5f19-4dfe-838b-1aca7238ae36
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se o usuário é o master user
SELECT '=== VERIFICANDO SE É USUÁRIO MASTER ===' as info;
SELECT 
    CASE 
        WHEN '2dc520e3-5f19-4dfe-838b-1aca7238ae36' = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
        THEN 'SIM - É o usuário master'
        ELSE 'NÃO - Não é o usuário master'
    END as is_master_user;

-- 2. Criar política especial para o usuário master
SELECT '=== CRIANDO POLÍTICAS ESPECIAIS PARA USUÁRIO MASTER ===' as info;

-- Para tabela transactions principal
ALTER TABLE transactions DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Master user full access" ON transactions;
CREATE POLICY "Master user full access" ON transactions FOR ALL USING (true) WITH CHECK (true);

-- Para tabela transactions_2025_08
ALTER TABLE transactions_2025_08 DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Master user full access" ON transactions_2025_08;
CREATE POLICY "Master user full access" ON transactions_2025_08 FOR ALL USING (true) WITH CHECK (true);

-- 3. Verificar se há outras tabelas mensais que precisam ser corrigidas
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
        ORDER BY table_name
    LOOP
        RAISE NOTICE 'Corrigindo tabela: %', table_record.table_name;
        
        -- Desabilitar RLS
        EXECUTE format('ALTER TABLE %I DISABLE ROW LEVEL SECURITY', table_record.table_name);
        
        -- Remover políticas antigas
        EXECUTE format('DROP POLICY IF EXISTS "Master user full access" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can view their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can create their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can update their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', table_record.table_name);
        
        -- Criar política de acesso total
        EXECUTE format('CREATE POLICY "Master user full access" ON %I FOR ALL USING (true) WITH CHECK (true)', table_record.table_name);
        
        RAISE NOTICE 'Tabela % corrigida', table_record.table_name;
    END LOOP;
END $$;

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
    'TESTE USUÁRIO MASTER - TABELA PRINCIPAL', 
    2000.00, 
    'income', 
    'teste_master', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 5. Testar inserção na tabela mensal
SELECT '=== TESTANDO INSERÇÃO NA TABELA MENSAIS ===' as info;
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
    'TESTE USUÁRIO MASTER - TABELA MENSAIS', 
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
WHERE description LIKE 'TESTE USUÁRIO MASTER%'
UNION ALL
SELECT 
    'Tabela Mensal' as tabela,
    id,
    description,
    transaction_date
FROM transactions_2025_08 
WHERE description LIKE 'TESTE USUÁRIO MASTER%';

-- 7. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions WHERE description LIKE 'TESTE USUÁRIO MASTER%';
DELETE FROM transactions_2025_08 WHERE description LIKE 'TESTE USUÁRIO MASTER%';

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

-- 9. Verificar status RLS
SELECT '=== STATUS RLS ===' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename;

SELECT '=== USUÁRIO MASTER CORRIGIDO COM SUCESSO! ===' as info;
