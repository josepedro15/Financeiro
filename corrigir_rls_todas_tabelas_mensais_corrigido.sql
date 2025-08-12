-- CORREÇÃO RLS PARA TODAS AS TABELAS MENSAIS DE 2025 (VERSÃO CORRIGIDA)
-- Execute este script no Supabase SQL Editor

-- 1. Verificar tabelas mensais existentes
SELECT '=== TABELAS MENSAIS EXISTENTES ===' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

-- 2. Corrigir RLS para cada tabela mensal
SELECT '=== CORRIGINDO RLS PARA CADA TABELA ===' as info;
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
        RAISE NOTICE 'Corrigindo RLS para: %', table_record.table_name;
        
        -- Remover políticas antigas
        EXECUTE format('DROP POLICY IF EXISTS "Users can view their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can create their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can update their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON %I', table_record.table_name);
        EXECUTE format('DROP POLICY IF EXISTS "Full access to transactions" ON %I', table_record.table_name);
        
        -- Habilitar RLS
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', table_record.table_name);
        
        -- Criar políticas corretas
        EXECUTE format('CREATE POLICY "Users can view their own transactions" ON %I FOR SELECT USING (auth.uid() = user_id)', table_record.table_name);
        EXECUTE format('CREATE POLICY "Users can create their own transactions" ON %I FOR INSERT WITH CHECK (auth.uid() = user_id)', table_record.table_name);
        EXECUTE format('CREATE POLICY "Users can update their own transactions" ON %I FOR UPDATE USING (auth.uid() = user_id)', table_record.table_name);
        EXECUTE format('CREATE POLICY "Users can delete their own transactions" ON %I FOR DELETE USING (auth.uid() = user_id)', table_record.table_name);
        
        RAISE NOTICE 'RLS corrigido para: %', table_record.table_name;
    END LOOP;
END $$;

-- 3. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename LIKE 'transactions_2025_%'
ORDER BY tablename, policyname;

-- 4. Testar inserção em uma tabela específica (transactions_2025_08)
SELECT '=== TESTANDO INSERÇÃO EM transactions_2025_08 ===' as info;
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
    'teste_rls_corrigido', 
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
FROM transactions_2025_08 
WHERE description = 'TESTE RLS CORRIGIDO - 12/08/2025'
ORDER BY created_at DESC;

-- 6. Limpar teste
SELECT '=== LIMPANDO TESTE ===' as info;
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE RLS CORRIGIDO - 12/08/2025';

-- 7. Verificar status final
SELECT '=== STATUS FINAL ===' as info;
SELECT 
    table_name,
    'RLS Corrigido' as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

SELECT '=== RLS CORRIGIDO PARA TODAS AS TABELAS MENSAIS ===' as info;
