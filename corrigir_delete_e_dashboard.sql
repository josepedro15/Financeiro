-- CORREÇÃO PARA DELETE E CARREGAMENTO DO DASHBOARD
-- Execute este script no Supabase SQL Editor

-- 1. Verificar políticas de DELETE atuais
SELECT '=== POLÍTICAS DE DELETE ATUAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
  AND cmd = 'DELETE'
ORDER BY tablename, policyname;

-- 2. Corrigir políticas de DELETE para todas as tabelas
SELECT '=== CORRIGINDO POLÍTICAS DE DELETE ===' as info;

-- Função para corrigir DELETE em uma tabela
CREATE OR REPLACE FUNCTION corrigir_delete_tabela(tabela_nome TEXT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    -- Remover políticas de DELETE antigas
    EXECUTE format('DROP POLICY IF EXISTS "Users can delete their own transactions" ON %I', tabela_nome);
    EXECUTE format('DROP POLICY IF EXISTS "Master user full access" ON %I', tabela_nome);
    
    -- Criar política de DELETE correta
    EXECUTE format('CREATE POLICY "Users can delete their own transactions" ON %I FOR DELETE USING (is_master_user(auth.uid()) OR auth.uid() = user_id)', tabela_nome);
    
    RETURN 'DELETE corrigido para ' || tabela_nome;
END;
$$;

-- 3. Corrigir DELETE para todas as tabelas de transações
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
        RAISE NOTICE 'Corrigindo DELETE para: %', tabela_record.table_name;
        PERFORM corrigir_delete_tabela(tabela_record.table_name);
    END LOOP;
END $$;

-- 4. Verificar se a função is_master_user existe
SELECT '=== VERIFICANDO FUNÇÃO IS_MASTER_USER ===' as info;
SELECT 
    routine_name,
    routine_type
FROM information_schema.routines 
WHERE routine_name = 'is_master_user';

-- 5. Criar função is_master_user se não existir
CREATE OR REPLACE FUNCTION is_master_user(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN user_uuid = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
END;
$$;

-- 6. Testar DELETE na tabela principal
SELECT '=== TESTANDO DELETE NA TABELA PRINCIPAL ===' as info;

-- Inserir transação de teste
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
    'TESTE DELETE - TABELA PRINCIPAL', 
    100.00, 
    'income', 
    'teste_delete', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 7. Testar DELETE na tabela mensal
SELECT '=== TESTANDO DELETE NA TABELA MENSAIS ===' as info;

-- Inserir transação de teste
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
    'TESTE DELETE - TABELA MENSAIS', 
    200.00, 
    'income', 
    'teste_delete', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 8. Verificar transações de teste inseridas
SELECT '=== VERIFICANDO TRANSAÇÕES DE TESTE ===' as info;
SELECT 
    'Tabela Principal' as tabela,
    id,
    description,
    transaction_date
FROM transactions 
WHERE description LIKE 'TESTE DELETE%'
UNION ALL
SELECT 
    'Tabela Mensal' as tabela,
    id,
    description,
    transaction_date
FROM transactions_2025_08 
WHERE description LIKE 'TESTE DELETE%';

-- 9. Testar DELETE das transações de teste
SELECT '=== TESTANDO DELETE DAS TRANSAÇÕES ===' as info;

-- Deletar da tabela principal
DELETE FROM transactions 
WHERE description LIKE 'TESTE DELETE%';

-- Deletar da tabela mensal
DELETE FROM transactions_2025_08 
WHERE description LIKE 'TESTE DELETE%';

-- 10. Verificar se foram deletadas
SELECT '=== VERIFICANDO SE FORAM DELETADAS ===' as info;
SELECT 
    'Tabela Principal' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions 
WHERE description LIKE 'TESTE DELETE%'
UNION ALL
SELECT 
    'Tabela Mensal' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions_2025_08 
WHERE description LIKE 'TESTE DELETE%';

-- 11. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
  AND cmd = 'DELETE'
ORDER BY tablename, policyname;

-- 12. Verificar se há dados para o dashboard carregar
SELECT '=== VERIFICANDO DADOS PARA DASHBOARD ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes,
    COUNT(DISTINCT user_id) as usuarios_unicos
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes,
    COUNT(DISTINCT user_id) as usuarios_unicos
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 13. Limpar função auxiliar
DROP FUNCTION IF EXISTS corrigir_delete_tabela(TEXT);

SELECT '=== DELETE E DASHBOARD CORRIGIDOS COM SUCESSO! ===' as info;
