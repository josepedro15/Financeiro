-- Verificar se as tabelas estão expostas na API do Supabase

-- 1. Verificar se as tabelas existem
SELECT 'VERIFICANDO EXISTÊNCIA DAS TABELAS' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE tablename IN ('notifications', 'organization_members', 'profiles')
  AND schemaname = 'public'
ORDER BY tablename;

-- 2. Verificar se as tabelas estão na API (schema graphql_public)
SELECT 'VERIFICANDO EXPOSIÇÃO NA API' as info;
SELECT 
    table_name
FROM information_schema.tables 
WHERE table_schema = 'graphql_public'
  AND table_name IN ('notifications', 'organization_members', 'profiles')
ORDER BY table_name;

-- 3. Verificar políticas RLS
SELECT 'VERIFICANDO POLÍTICAS RLS' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd,
    permissive,
    roles
FROM pg_policies 
WHERE tablename IN ('notifications', 'organization_members')
ORDER BY tablename, policyname;

-- 4. EXPOR TABELAS NA API (se não estiverem expostas)
SELECT 'EXPONDO TABELAS NA API...' as info;

-- Expor notifications na API
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO anon, authenticated;

-- Expor organization_members na API  
GRANT SELECT, INSERT, UPDATE, DELETE ON public.organization_members TO anon, authenticated;

-- Verificar grants
SELECT 'VERIFICANDO PERMISSÕES' as info;
SELECT 
    table_schema,
    table_name,
    grantee,
    privilege_type
FROM information_schema.table_privileges 
WHERE table_name IN ('notifications', 'organization_members')
  AND table_schema = 'public'
ORDER BY table_name, grantee;
