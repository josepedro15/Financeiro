-- Verificar a estrutura real de todas as tabelas
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions')
ORDER BY table_name, ordinal_position;

-- Verificar especificamente colunas que podem identificar usuários
SELECT 
    table_name,
    column_name
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND column_name LIKE '%user%' OR column_name LIKE '%owner%' OR column_name LIKE '%id%'
ORDER BY table_name, column_name;

-- Verificar estrutura das tabelas mensais
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name LIKE 'transactions_2025_%'
AND column_name LIKE '%user%' OR column_name LIKE '%owner%' OR column_name = 'id'
ORDER BY table_name, ordinal_position;

-- Listar todas as tabelas existentes
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE'
ORDER BY table_name;
