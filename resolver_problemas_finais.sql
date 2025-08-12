-- Script completo para resolver problemas de exclusão e carregamento

-- 1. Verificar todas as tabelas mensais existentes
SELECT 'Tabelas mensais existentes:' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

-- 2. Verificar políticas RLS em todas as tabelas mensais
SELECT 'Políticas RLS existentes:' as info;
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename LIKE 'transactions_2025_%'
ORDER BY tablename, policyname;

-- 3. Remover todas as políticas antigas das tabelas mensais
DO $$
DECLARE
    table_record RECORD;
BEGIN
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name LIKE 'transactions_2025_%'
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS "Users can view their own transactions" ON ' || table_record.table_name;
        EXECUTE 'DROP POLICY IF EXISTS "Users can create their own transactions" ON ' || table_record.table_name;
        EXECUTE 'DROP POLICY IF EXISTS "Users can update their own transactions" ON ' || table_record.table_name;
        EXECUTE 'DROP POLICY IF EXISTS "Users can delete their own transactions" ON ' || table_record.table_name;
        
        RAISE NOTICE 'Políticas removidas da tabela: %', table_record.table_name;
    END LOOP;
END $$;

-- 4. Criar políticas corretas para todas as tabelas mensais
DO $$
DECLARE
    table_record RECORD;
BEGIN
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name LIKE 'transactions_2025_%'
    LOOP
        -- Habilitar RLS
        EXECUTE 'ALTER TABLE ' || table_record.table_name || ' ENABLE ROW LEVEL SECURITY';
        
        -- Criar políticas
        EXECUTE 'CREATE POLICY "Users can view their own transactions" ON ' || table_record.table_name || 
                ' FOR SELECT USING (auth.uid() = user_id)';
        
        EXECUTE 'CREATE POLICY "Users can create their own transactions" ON ' || table_record.table_name || 
                ' FOR INSERT WITH CHECK (auth.uid() = user_id)';
        
        EXECUTE 'CREATE POLICY "Users can update their own transactions" ON ' || table_record.table_name || 
                ' FOR UPDATE USING (auth.uid() = user_id)';
        
        EXECUTE 'CREATE POLICY "Users can delete their own transactions" ON ' || table_record.table_name || 
                ' FOR DELETE USING (auth.uid() = user_id)';
        
        RAISE NOTICE 'Políticas criadas para a tabela: %', table_record.table_name;
    END LOOP;
END $$;

-- 5. Verificar transações do usuário em todas as tabelas
SELECT 'Transações do usuário por tabela:' as info;
DO $$
DECLARE
    table_record RECORD;
    transacao_count INTEGER;
BEGIN
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name LIKE 'transactions_2025_%'
    LOOP
        EXECUTE 'SELECT COUNT(*) FROM ' || table_record.table_name || 
                ' WHERE user_id = ''2dc520e3-5f19-4dfe-838b-1aca7238ae36''' INTO transacao_count;
        
        RAISE NOTICE 'Tabela %: % transações', table_record.table_name, transacao_count;
    END LOOP;
END $$;

-- 6. Verificar algumas transações específicas em agosto
SELECT 'Transações em transactions_2025_08:' as info;
SELECT id, description, amount, transaction_type, account_name, transaction_date, created_at 
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 10;

-- 7. Testar uma exclusão (substitua o ID por um real)
-- SELECT 'Testando exclusão:' as info;
-- DELETE FROM transactions_2025_08 
-- WHERE id = 'SUBSTITUA_PELO_ID_REAL' 
-- AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 8. Verificar se há transações duplicadas
SELECT 'Verificando duplicatas:' as info;
SELECT description, amount, transaction_type, account_name, transaction_date, COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY description, amount, transaction_type, account_name, transaction_date
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;
