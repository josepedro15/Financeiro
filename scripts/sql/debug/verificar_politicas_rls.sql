-- Verificar se as políticas RLS foram criadas corretamente
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- Verificar se RLS está habilitado nas tabelas
SELECT 
    t.table_name,
    CASE 
        WHEN c.relrowsecurity THEN 'Habilitado'
        ELSE 'Desabilitado'
    END as rls_status
FROM information_schema.tables t
LEFT JOIN pg_class c ON c.relname = t.table_name
WHERE t.table_schema = 'public' 
AND t.table_name IN ('accounts', 'clients', 'expenses', 'transactions', 'organization_members', 'profiles')
AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name;

-- Verificar se as funções foram criadas
SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name IN ('is_organization_member', 'handle_new_user', 'update_organization_member_status', 'handle_updated_at')
ORDER BY routine_name;

-- Verificar dados na tabela organization_members
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM public.organization_members
ORDER BY created_at DESC;

-- Verificar qual coluna de usuário existe nas tabelas principais
SELECT 
    table_name,
    column_name
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name IN ('accounts', 'clients', 'expenses', 'transactions')
AND column_name IN ('user_id', 'owner_id')
ORDER BY table_name, column_name;
