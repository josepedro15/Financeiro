-- Verificar colunas específicas de cada tabela
SELECT 
    table_name,
    STRING_AGG(column_name, ', ' ORDER BY ordinal_position) as todas_colunas
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions')
GROUP BY table_name
ORDER BY table_name;

-- Verificar colunas das tabelas mensais (exemplo com uma tabela)
SELECT 
    table_name,
    STRING_AGG(column_name, ', ' ORDER BY ordinal_position) as todas_colunas
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'transactions_2025_04'
GROUP BY table_name;

-- Procurar especificamente por colunas de usuário
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions', 'transactions_2025_04')
AND (column_name ILIKE '%user%' OR column_name ILIKE '%owner%' OR column_name ILIKE '%created%' OR column_name = 'id')
ORDER BY table_name, column_name;
