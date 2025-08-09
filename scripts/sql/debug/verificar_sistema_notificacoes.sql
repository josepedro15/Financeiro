-- Debug: Verificar sistema de notificações completo

-- 1. Verificar se tabela de notificações existe
SELECT 'VERIFICANDO TABELA NOTIFICATIONS' as info;
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'notifications' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar RLS e políticas
SELECT 'VERIFICANDO RLS NOTIFICATIONS' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'notifications';

SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'notifications';

-- 3. Verificar triggers existentes
SELECT 'VERIFICANDO TRIGGERS' as info;
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table IN ('notifications', 'organization_members')
ORDER BY event_object_table, trigger_name;

-- 4. Verificar dados atuais
SELECT 'DADOS ORGANIZATION_MEMBERS' as info;
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM organization_members
ORDER BY created_at DESC;

-- 5. Verificar notificações existentes
SELECT 'DADOS NOTIFICATIONS' as info;
SELECT 
    id,
    user_id,
    type,
    title,
    message,
    data,
    read,
    status,
    created_at
FROM notifications
ORDER BY created_at DESC;

-- 6. Verificar usuários no sistema
SELECT 'USUÁRIOS NO SISTEMA' as info;
SELECT 
    u.id as auth_id,
    u.email as auth_email,
    p.id as profile_id,
    p.email as profile_email
FROM auth.users u
LEFT JOIN profiles p ON u.id = p.id
WHERE u.email IN ('jopedromkt@gmail.com', 'josepedro123nato88@gmail.com', 'logotiq@gmail.com')
ORDER BY u.email;
