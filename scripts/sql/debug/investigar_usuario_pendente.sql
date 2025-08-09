-- Investigar por que logotiq@gmail.com está pendente se já fez login

-- 1. Verificar se existe na tabela auth.users
SELECT 'Usuário no auth.users:' as info;
SELECT id, email, created_at, email_confirmed_at
FROM auth.users 
WHERE email = 'logotiq@gmail.com';

-- 2. Verificar se existe na tabela profiles
SELECT 'Usuário na tabela profiles:' as info;
SELECT id, email, created_at
FROM profiles 
WHERE email = 'logotiq@gmail.com';

-- 3. Verificar status na organization_members
SELECT 'Status na organization_members:' as info;
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM organization_members 
WHERE email = 'logotiq@gmail.com';

-- 4. Verificar se member_id está correto
SELECT 'Verificar member_id correto:' as info;
SELECT 
    om.email,
    om.member_id as member_id_atual,
    au.id as auth_user_id,
    p.id as profile_id,
    om.status
FROM organization_members om
LEFT JOIN auth.users au ON au.email = om.email
LEFT JOIN profiles p ON p.email = om.email
WHERE om.email = 'logotiq@gmail.com';
