-- Forçar criação de notificação para teste

-- 1. Verificar usuários existentes
SELECT 'USUÁRIOS DISPONÍVEIS:' as info;
SELECT 
    u.id as user_id,
    u.email,
    p.id as profile_id
FROM auth.users u
LEFT JOIN profiles p ON u.id = p.id
WHERE u.email IN ('jopedromkt@gmail.com', 'josepedro123nato88@gmail.com', 'logotiq@gmail.com');

-- 2. Verificar organização atual
SELECT 'ORGANIZAÇÃO ATUAL:' as info;
SELECT * FROM organization_members ORDER BY created_at DESC;

-- 3. FORÇAR criação de notificação manualmente para logotiq@gmail.com
DO $$
DECLARE
    user_logotiq UUID;
    user_jopedro UUID;
    org_member_id UUID;
BEGIN
    -- Buscar IDs dos usuários
    SELECT id INTO user_jopedro 
    FROM auth.users 
    WHERE email = 'jopedromkt@gmail.com';
    
    SELECT id INTO user_logotiq 
    FROM auth.users 
    WHERE email = 'logotiq@gmail.com';
    
    -- Buscar ID do member na organização
    SELECT id INTO org_member_id
    FROM organization_members
    WHERE member_id = user_logotiq 
      AND owner_id = user_jopedro;
    
    -- Criar notificação manualmente
    IF user_logotiq IS NOT NULL AND user_jopedro IS NOT NULL THEN
        INSERT INTO notifications (
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
                'organization_member_id', org_member_id,
                'owner_id', user_jopedro,
                'owner_email', 'jopedromkt@gmail.com'
            ),
            'pending'
        );
        
        RAISE NOTICE 'Notificação criada para logotiq@gmail.com!';
    ELSE
        RAISE NOTICE 'Usuários não encontrados: jopedro=%, logotiq=%', user_jopedro, user_logotiq;
    END IF;
END $$;

-- 4. Verificar notificação criada
SELECT 'NOTIFICAÇÃO CRIADA:' as info;
SELECT 
    n.id,
    u.email as destinatario,
    n.type,
    n.title,
    n.message,
    n.data,
    n.status,
    n.created_at
FROM notifications n
JOIN auth.users u ON n.user_id = u.id
ORDER BY n.created_at DESC;
