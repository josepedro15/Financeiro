-- CORRIGIR RLS DE TODAS AS TABELAS MENSAIS
-- Execute este script no Supabase SQL Editor

-- 1. Verificar tabelas mensais existentes
SELECT '=== TABELAS MENSAIS EXISTENTES ===' as info;
SELECT 
    table_name
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

-- 2. Função para corrigir RLS de uma tabela
CREATE OR REPLACE FUNCTION corrigir_rls_tabela_mensal(tabela_nome TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    -- Habilitar RLS
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', tabela_nome);
    
    -- Remover políticas antigas
    EXECUTE format('DROP POLICY IF EXISTS "Users can view their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can insert their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can update their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Master user full access" ON %I', tabela_nome);
    
    -- Criar políticas corretas
    EXECUTE format('CREATE POLICY "Users can view their own transactions" ON %I FOR SELECT USING (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can insert their own transactions" ON %I FOR INSERT WITH CHECK (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can update their own transactions" ON %I FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id)', tabela_nome);
    EXECUTE format('CREATE POLICY "Users can delete their own transactions" ON %I FOR DELETE USING (auth.uid() = user_id)', tabela_nome);
    
    RETURN 'RLS corrigido para ' || tabela_nome;
END;
$$;

-- 3. Corrigir RLS para todas as tabelas mensais
SELECT '=== CORRIGINDO RLS DAS TABELAS MENSAIS ===' as info;

DO $$
DECLARE
    tabela_record RECORD;
BEGIN
    FOR tabela_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_name LIKE 'transactions_2025_%'
        ORDER BY table_name
    LOOP
        RAISE NOTICE 'Corrigindo RLS para: %', tabela_record.table_name;
        PERFORM corrigir_rls_tabela_mensal(tabela_record.table_name);
    END LOOP;
END $$;

-- 4. Corrigir RLS da tabela principal também
SELECT '=== CORRIGINDO RLS DA TABELA PRINCIPAL ===' as info;

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;
DROP POLICY IF EXISTS "Master user full access" ON transactions;

CREATE POLICY "Users can view their own transactions" ON transactions 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions 
FOR DELETE USING (auth.uid() = user_id);

-- 5. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03', 
                   'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06', 'transactions_2025_07',
                   'transactions_2025_08', 'transactions_2025_09', 'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12')
ORDER BY tablename, cmd, policyname;

-- 6. Testar inserção em uma tabela mensal
SELECT '=== TESTANDO INSERÇÃO ===' as info;

INSERT INTO transactions_2025_08 (
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
    'TESTE RLS CORRIGIDO', 
    500.00, 
    'income', 
    'teste_rls', 
    '2025-08-12', 
    'Conta PJ',
    'Maria Regina',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, account_name;

-- 7. Verificar se foi inserida
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_date,
    account_name,
    client_name
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE RLS CORRIGIDO';

-- 8. Limpar função auxiliar
DROP FUNCTION IF EXISTS corrigir_rls_tabela_mensal(TEXT);

SELECT '=== RLS DE TODAS AS TABELAS CORRIGIDO! ===' as info;
