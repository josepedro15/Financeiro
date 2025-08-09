-- Verificar dados das notificações existentes

-- 1. Verificar todas as notificações
SELECT 'TODAS AS NOTIFICAÇÕES:' as info;
SELECT 
    id,
    user_id,
    type,
    title,
    message,
    data,
    status,
    created_at
FROM public.notifications
ORDER BY created_at DESC;

-- 2. Verificar structure dos dados JSONB
SELECT 'ESTRUTURA DOS DADOS JSONB:' as info;
SELECT 
    id,
    data,
    jsonb_pretty(data) as dados_formatados,
    data->'organization_member_id' as org_member_id,
    data->'owner_id' as owner_id,
    data->'owner_email' as owner_email
FROM public.notifications
WHERE type = 'organization_invite';

-- 3. Verificar organization_members existentes
SELECT 'ORGANIZATION_MEMBERS EXISTENTES:' as info;
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM public.organization_members
ORDER BY created_at DESC;

-- 4. RECRIAR notificação com dados corretos
DO $$
DECLARE
    user_logotiq UUID;
    user_jopedro UUID;
    org_member_record RECORD;
BEGIN
    -- Buscar IDs dos usuários
    SELECT id INTO user_jopedro 
    FROM auth.users 
    WHERE email = 'jopedromkt@gmail.com';
    
    SELECT id INTO user_logotiq 
    FROM auth.users 
    WHERE email = 'logotiq@gmail.com';
    
    -- Buscar registro da organização
    SELECT * INTO org_member_record
    FROM public.organization_members
    WHERE member_id = user_logotiq 
      AND owner_id = user_jopedro;
    
    -- Deletar notificações antigas do logotiq
    DELETE FROM public.notifications 
    WHERE user_id = user_logotiq;
    
    -- Criar nova notificação com dados corretos
    IF user_logotiq IS NOT NULL AND user_jopedro IS NOT NULL AND org_member_record.id IS NOT NULL THEN
        INSERT INTO public.notifications (
            user_id,
            type,
            title,
            message,
            data,
            status
        ) VALUES (
            user_logotiq,
            'organization_invite',
            'Convite para Organização',
            'Você foi convidado por jopedromkt@gmail.com para participar de sua organização financeira.',
            jsonb_build_object(
                'organization_member_id', org_member_record.id,
                'owner_id', user_jopedro,
                'owner_email', 'jopedromkt@gmail.com'
            ),
            'pending'
        );
        
        RAISE NOTICE '✅ Nova notificação criada com organization_member_id: %', org_member_record.id;
    ELSE
        RAISE NOTICE '❌ Dados não encontrados: jopedro=%, logotiq=%, org_member=%', 
            user_jopedro, user_logotiq, org_member_record.id;
    END IF;
END $$;

-- 5. Verificar notificação recriada
SELECT 'NOTIFICAÇÃO RECRIADA:' as info;
SELECT 
    n.id,
    u.email as destinatario,
    n.type,
    n.title,
    n.data,
    n.data->'organization_member_id' as org_member_id_extraido,
    n.status,
    n.created_at
FROM public.notifications n
JOIN auth.users u ON n.user_id = u.id
WHERE u.email = 'logotiq@gmail.com'
ORDER BY n.created_at DESC;
