-- Desabilitar RLS temporariamente na tabela organization_members para teste

-- 1. Verificar status atual
SELECT 'Status RLS atual:' as info;
SELECT 
    t.table_name,
    CASE 
        WHEN c.relrowsecurity THEN 'Habilitado'
        ELSE 'Desabilitado'
    END as rls_status
FROM information_schema.tables t
LEFT JOIN pg_class c ON c.relname = t.table_name
WHERE t.table_schema = 'public' 
AND t.table_name = 'organization_members';

-- 2. Desabilitar RLS temporariamente
ALTER TABLE organization_members DISABLE ROW LEVEL SECURITY;

-- 3. Verificar novo status
SELECT 'Status RLS após desabilitar:' as info;
SELECT 
    t.table_name,
    CASE 
        WHEN c.relrowsecurity THEN 'Habilitado'
        ELSE 'Desabilitado'
    END as rls_status
FROM information_schema.tables t
LEFT JOIN pg_class c ON c.relname = t.table_name
WHERE t.table_schema = 'public' 
AND t.table_name = 'organization_members';

-- 4. Testar consulta simples
SELECT 'Teste após desabilitar RLS:' as info;
SELECT * FROM organization_members;
