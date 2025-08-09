-- Verificar estrutura de todas as tabelas relevantes
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions', 'profiles', 'organization_members')
ORDER BY table_name, ordinal_position;

-- Verificar tabelas mensais de transações
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name, ordinal_position;

-- Verificar se as tabelas existem
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions', 'profiles', 'organization_members')
ORDER BY table_name;
