-- =====================================================
-- DIAGNÓSTICO E CORREÇÃO - CONVITES DE COMPARTILHAMENTO
-- =====================================================

-- 1. VERIFICAR ESTRUTURA DAS TABELAS
-- =====================================================

SELECT '=== VERIFICANDO ESTRUTURA DAS TABELAS ===' as info;

-- Verificar se a tabela organization_members existe
SELECT 
    'organization_members' as tabela,
    EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' AND table_name = 'organization_members'
    ) as existe;

-- Verificar se a tabela notifications existe
SELECT 
    'notifications' as tabela,
    EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' AND table_name = 'notifications'
    ) as existe;

-- Verificar se a tabela profiles existe
SELECT 
    'profiles' as tabela,
    EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' AND table_name = 'profiles'
    ) as existe;

-- 2. VERIFICAR DADOS NAS TABELAS
-- =====================================================

SELECT '=== VERIFICANDO DADOS NAS TABELAS ===' as info;

-- Verificar organization_members
SELECT 
    'organization_members' as tabela,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pendentes,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos
FROM public.organization_members;

-- Verificar notifications
SELECT 
    'notifications' as tabela,
    COUNT(*) as total_registros,
    COUNT(CASE WHEN type = 'organization_invite' THEN 1 END) as convites,
    COUNT(CASE WHEN type = 'organization_invite' AND status = 'pending' THEN 1 END) as convites_pendentes
FROM public.notifications;

-- Verificar profiles
SELECT 
    'profiles' as tabela,
    COUNT(*) as total_registros
FROM public.profiles;

-- 3. VERIFICAR TRIGGERS
-- =====================================================

SELECT '=== VERIFICANDO TRIGGERS ===' as info;

SELECT 
    trigger_name,
    event_object_table,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table IN ('organization_members', 'notifications')
ORDER BY event_object_table, trigger_name;

-- 4. VERIFICAR FUNÇÕES
-- =====================================================

SELECT '=== VERIFICANDO FUNÇÕES ===' as info;

SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name IN (
    'create_organization_invite_notification',
    'is_organization_member',
    'update_organization_member_status'
)
ORDER BY routine_name;

-- 5. VERIFICAR POLÍTICAS RLS
-- =====================================================

SELECT '=== VERIFICANDO POLÍTICAS RLS ===' as info;

SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('organization_members', 'notifications', 'profiles')
ORDER BY tablename, policyname;

-- 6. DIAGNÓSTICO ESPECÍFICO - CONVITES PENDENTES
-- =====================================================

SELECT '=== DIAGNÓSTICO DE CONVITES PENDENTES ===' as info;

-- Verificar convites pendentes sem notificação
SELECT 
    om.id as organization_member_id,
    om.owner_id,
    om.member_id,
    om.email,
    om.status,
    om.created_at,
    CASE 
        WHEN n.id IS NULL THEN '❌ SEM NOTIFICAÇÃO'
        ELSE '✅ COM NOTIFICAÇÃO'
    END as status_notificacao,
    n.id as notification_id,
    n.status as notification_status
FROM public.organization_members om
LEFT JOIN public.notifications n ON 
    n.type = 'organization_invite' 
    AND n.data->>'organization_member_id' = om.id::text
WHERE om.status = 'pending'
ORDER BY om.created_at DESC;

-- 7. VERIFICAR SE O USUÁRIO CONVIDADO EXISTE
-- =====================================================

SELECT '=== VERIFICANDO USUÁRIOS CONVIDADOS ===' as info;

SELECT 
    om.email,
    om.status,
    CASE 
        WHEN p.id IS NOT NULL THEN '✅ USUÁRIO EXISTE'
        ELSE '❌ USUÁRIO NÃO EXISTE'
    END as status_usuario,
    p.id as profile_id,
    au.id as auth_user_id
FROM public.organization_members om
LEFT JOIN public.profiles p ON p.email = om.email
LEFT JOIN auth.users au ON au.email = om.email
WHERE om.status = 'pending'
ORDER BY om.created_at DESC;

-- 8. CORREÇÕES AUTOMÁTICAS
-- =====================================================

SELECT '=== APLICANDO CORREÇÕES ===' as info;

-- 8.1. Criar notificações para convites pendentes sem notificação
INSERT INTO public.notifications (
    user_id,
    type,
    title,
    message,
    data,
    status
)
SELECT 
    COALESCE(om.member_id, 
        (SELECT id FROM auth.users WHERE email = om.email LIMIT 1)
    ) as user_id,
    'organization_invite',
    'Convite para Organização',
    'Você foi convidado para participar de uma organização financeira.',
    jsonb_build_object(
        'organization_member_id', om.id,
        'owner_id', om.owner_id,
        'owner_email', (SELECT email FROM public.profiles WHERE id = om.owner_id)
    ),
    'pending'
FROM public.organization_members om
LEFT JOIN public.notifications n ON 
    n.type = 'organization_invite' 
    AND n.data->>'organization_member_id' = om.id::text
WHERE om.status = 'pending'
AND n.id IS NULL
AND om.member_id IS NOT NULL;

-- 8.2. Atualizar member_id para usuários que já existem
UPDATE public.organization_members om
SET 
    member_id = p.id,
    status = 'active',
    updated_at = NOW()
FROM public.profiles p
WHERE om.email = p.email 
AND om.status = 'pending'
AND om.member_id IS NULL;

-- 8.3. Criar profiles para usuários que não existem
INSERT INTO public.profiles (id, email)
SELECT 
    au.id,
    au.email
FROM auth.users au
WHERE au.email IN (
    SELECT om.email 
    FROM public.organization_members om 
    WHERE om.status = 'pending' 
    AND om.member_id IS NULL
)
AND NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = au.id
);

-- 9. VERIFICAÇÃO FINAL
-- =====================================================

SELECT '=== VERIFICAÇÃO FINAL ===' as info;

-- Verificar se as correções funcionaram
SELECT 
    'organization_members' as tabela,
    COUNT(*) as total,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pendentes,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos
FROM public.organization_members;

SELECT 
    'notifications' as tabela,
    COUNT(*) as total,
    COUNT(CASE WHEN type = 'organization_invite' THEN 1 END) as convites,
    COUNT(CASE WHEN type = 'organization_invite' AND status = 'pending' THEN 1 END) as convites_pendentes
FROM public.notifications;

-- 10. TESTE MANUAL DE NOTIFICAÇÃO
-- =====================================================

SELECT '=== TESTE MANUAL DE NOTIFICAÇÃO ===' as info;

-- Testar a função de criação de notificação
SELECT 
    'Testando função create_organization_invite_notification' as teste,
    public.create_organization_invite_notification() as resultado;

-- 11. INSTRUÇÕES PARA O USUÁRIO
-- =====================================================

SELECT 
    '=== INSTRUÇÕES ===' as info,
    '1. Execute este script completo no Supabase SQL Editor' as instrucao1,
    '2. Verifique se as tabelas e triggers foram criados corretamente' as instrucao2,
    '3. Se ainda houver problemas, verifique os logs do console do navegador' as instrucao3,
    '4. Certifique-se de que o usuário convidado está logado no sistema' as instrucao4,
    '5. Verifique se o NotificationCenter está sendo carregado na página' as instrucao5;
