-- =====================================================
-- CORRIGIR CONVITES PENDENTES E NOTIFICAÇÕES
-- =====================================================

-- 1. VERIFICAR USUÁRIOS QUE JÁ SE REGISTRARAM
-- =====================================================

SELECT '=== USUÁRIOS REGISTRADOS ===' as info;

-- Verificar quais emails de convites pendentes já têm usuários registrados
SELECT 
    om.email,
    om.status as convite_status,
    CASE 
        WHEN au.id IS NOT NULL THEN '✅ USUÁRIO REGISTRADO'
        ELSE '❌ USUÁRIO NÃO REGISTRADO'
    END as status_registro,
    au.id as auth_user_id,
    au.created_at as data_registro
FROM public.organization_members om
LEFT JOIN auth.users au ON au.email = om.email
WHERE om.status = 'pending'
ORDER BY om.created_at DESC;

-- 2. ATUALIZAR CONVITES PARA USUÁRIOS JÁ REGISTRADOS
-- =====================================================

SELECT '=== ATUALIZANDO CONVITES ===' as info;

-- Atualizar member_id para usuários que já se registraram
UPDATE public.organization_members om
SET 
    member_id = au.id,
    status = 'active',
    updated_at = NOW()
FROM auth.users au
WHERE om.email = au.email 
AND om.status = 'pending'
AND om.member_id IS NULL;

-- 3. CRIAR NOTIFICAÇÕES PARA CONVITES ATIVOS
-- =====================================================

SELECT '=== CRIANDO NOTIFICAÇÕES ===' as info;

-- Criar notificações para convites que agora têm member_id
INSERT INTO public.notifications (
    user_id,
    type,
    title,
    message,
    data,
    status
)
SELECT 
    om.member_id as user_id,
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
WHERE om.status = 'active'
AND om.member_id IS NOT NULL
AND n.id IS NULL;

-- 4. CRIAR PROFILES PARA USUÁRIOS QUE NÃO TÊM
-- =====================================================

SELECT '=== CRIANDO PROFILES ===' as info;

-- Criar profiles para usuários que se registraram mas não têm profile
INSERT INTO public.profiles (id, email)
SELECT 
    au.id,
    au.email
FROM auth.users au
WHERE au.email IN (
    SELECT om.email 
    FROM public.organization_members om 
    WHERE om.status = 'active' 
    AND om.member_id IS NOT NULL
)
AND NOT EXISTS (
    SELECT 1 FROM public.profiles p WHERE p.id = au.id
);

-- 5. VERIFICAÇÃO FINAL
-- =====================================================

SELECT '=== VERIFICAÇÃO FINAL ===' as info;

-- Verificar convites atualizados
SELECT 
    'Convites atualizados:' as info,
    COUNT(*) as total,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pendentes,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as ativos,
    COUNT(CASE WHEN member_id IS NOT NULL THEN 1 END) as com_usuario
FROM public.organization_members;

-- Verificar notificações criadas
SELECT 
    'Notificações criadas:' as info,
    COUNT(*) as total,
    COUNT(CASE WHEN type = 'organization_invite' THEN 1 END) as convites,
    COUNT(CASE WHEN type = 'organization_invite' AND status = 'pending' THEN 1 END) as convites_pendentes
FROM public.notifications;

-- 6. LISTAR CONVITES QUE AINDA ESTÃO PENDENTES
-- =====================================================

SELECT '=== CONVITES AINDA PENDENTES ===' as info;

-- Mostrar convites que ainda estão pendentes (usuários que não se registraram)
SELECT 
    om.id,
    om.email,
    om.created_at as data_convite,
    CASE 
        WHEN au.id IS NOT NULL THEN '✅ USUÁRIO REGISTRADO - ATUALIZAR MANUALMENTE'
        ELSE '❌ USUÁRIO NÃO REGISTRADO - AGUARDANDO REGISTRO'
    END as status
FROM public.organization_members om
LEFT JOIN auth.users au ON au.email = om.email
WHERE om.status = 'pending'
ORDER BY om.created_at DESC;

-- 7. INSTRUÇÕES PARA O USUÁRIO
-- =====================================================

SELECT 
    '=== INSTRUÇÕES ===' as info,
    '1. Execute este script no Supabase SQL Editor' as instrucao1,
    '2. Verifique se os convites foram atualizados' as instrucao2,
    '3. Verifique se as notificações foram criadas' as instrucao3,
    '4. Para convites ainda pendentes, aguarde o usuário se registrar' as instrucao4,
    '5. Configure a URL correta no Supabase Dashboard' as instrucao5,
    '6. Teste criando um novo convite' as instrucao6;
