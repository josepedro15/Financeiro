-- CORREÇÃO RLS COMPLETA - TODAS AS TABELAS DE TRANSAÇÕES
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as tabelas de transações
SELECT '=== TABELAS DE TRANSAÇÕES EXISTENTES ===' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND (table_name = 'transactions' OR table_name LIKE 'transactions_2025_%')
ORDER BY table_name;

-- 2. Função para corrigir RLS de qualquer tabela
CREATE OR REPLACE FUNCTION corrigir_rls_tabela(tabela_nome TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    -- Desabilitar RLS temporariamente
    EXECUTE format('ALTER TABLE %I DISABLE ROW LEVEL SECURITY', tabela_nome);
    
    -- Remover políticas antigas
    EXECUTE format('DROP POLICY IF EXISTS "Users can view their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can create their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can update their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Full access to transactions" ON %I', tabela_nome);
    
    -- Reabilitar RLS
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tabela_nome);
    
    -- Criar políticas corretas
    EXECUTE format('CREATE POLICY "Users can view their own transactions" ON %I FOR SELECT USING (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can create their own transactions" ON %I FOR INSERT WITH CHECK (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can update their own transactions" ON %I FOR UPDATE USING (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can delete their own transactions" ON %I FOR DELETE USING (auth.uid() = user_id)', tabela_nome);
    
    RETURN 'RLS corrigido para ' || tabela_nome;
END;
$$;

-- 3. Corrigir RLS para todas as tabelas
SELECT '=== CORRIGINDO RLS PARA TODAS AS TABELAS ===' as info;
DO $$
DECLARE
    tabela_record RECORD;
BEGIN
    FOR tabela_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND (table_name = 'transactions' OR table_name LIKE 'transactions_2025_%')
        ORDER BY table_name
    LOOP
        RAISE NOTICE 'Corrigindo RLS para: %', tabela_record.table_name;
        PERFORM corrigir_rls_tabela(tabela_record.table_name);
    END LOOP;
END $$;

-- 4. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'transactions' OR tablename LIKE 'transactions_2025_%'
ORDER BY tablename, policyname;

-- 5. Testar inserção na tabela principal
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

-- 6. Testar inserção na tabela mensal
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
    'TESTE TABELA MENSAIS - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_mensal', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 7. Verificar inserções
SELECT '=== VERIFICANDO INSERÇÕES ===' as info;
SELECT 'Tabela Principal:' as tabela, id, description, transaction_date FROM transactions WHERE description LIKE 'TESTE TABELA PRINCIPAL%'
UNION ALL
SELECT 'Tabela Mensal:' as tabela, id, description, transaction_date FROM transactions_2025_08 WHERE description LIKE 'TESTE TABELA MENSAIS%';

-- 8. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions WHERE description LIKE 'TESTE TABELA PRINCIPAL%';
DELETE FROM transactions_2025_08 WHERE description LIKE 'TESTE TABELA MENSAIS%';

-- 9. Limpar função auxiliar
DROP FUNCTION IF EXISTS corrigir_rls_tabela(TEXT);

-- 10. Status final
SELECT '=== STATUS FINAL ===' as info;
SELECT 
    table_name,
    'RLS Corrigido' as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND (table_name = 'transactions' OR table_name LIKE 'transactions_2025_%')
ORDER BY table_name;

SELECT '=== RLS CORRIGIDO PARA TODAS AS TABELAS DE TRANSAÇÕES ===' as info;
