-- CRIAR NOTIFICAÇÃO DE TESTE APÓS SISTEMA ESTAR ATIVO

-- 1. VERIFICAR USUÁRIOS
SELECT 'USUÁRIOS DISPONÍVEIS:' as info;
SELECT 
    u.id as user_id,
    u.email
FROM auth.users u
WHERE u.email IN ('jopedromkt@gmail.com', 'josepedro123nato88@gmail.com', 'logotiq@gmail.com');

-- 2. CRIAR NOTIFICAÇÃO MANUAL PARA LOGOTIQ@GMAIL.COM
DO $$
DECLARE
    user_logotiq UUID;
    user_jopedro UUID;
BEGIN
    -- Buscar IDs dos usuários
    SELECT id INTO user_jopedro 
    FROM auth.users 
    WHERE email = 'jopedromkt@gmail.com';
    
    SELECT id INTO user_logotiq 
    FROM auth.users 
    WHERE email = 'logotiq@gmail.com';
    
    -- Criar notificação
    IF user_logotiq IS NOT NULL AND user_jopedro IS NOT NULL THEN
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
                'owner_id', user_jopedro,
                'owner_email', 'jopedromkt@gmail.com'
            ),
            'pending'
        );
        
        RAISE NOTICE '✅ Notificação criada para logotiq@gmail.com!';
    ELSE
        RAISE NOTICE '❌ Usuários não encontrados';
    END IF;
END $$;

-- 3. VERIFICAR NOTIFICAÇÃO CRIADA
SELECT 'NOTIFICAÇÕES CRIADAS:' as info;
SELECT 
    n.id,
    u.email as destinatario,
    n.type,
    n.title,
    n.message,
    n.status,
    n.created_at
FROM public.notifications n
JOIN auth.users u ON n.user_id = u.id
ORDER BY n.created_at DESC;
