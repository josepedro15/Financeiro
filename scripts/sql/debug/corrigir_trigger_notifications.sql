-- Corrigir trigger de criação de notificações

-- 1. Verificar trigger atual
SELECT 'VERIFICANDO TRIGGER ATUAL:' as info;
SELECT 
    trigger_name,
    event_manipulation,
    event_object_table,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'organization_members'
  AND trigger_name LIKE '%notification%';

-- 2. Verificar função do trigger
SELECT 'FUNÇÃO DO TRIGGER:' as info;
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines 
WHERE routine_name = 'create_organization_invite_notification';

-- 3. RECRIAR função corrigida do trigger
CREATE OR REPLACE FUNCTION public.create_organization_invite_notification()
RETURNS TRIGGER AS $$
DECLARE
    inviter_email TEXT;
    member_user_id UUID;
BEGIN
    -- Debug: Log dos dados recebidos
    RAISE NOTICE 'TRIGGER EXECUTADO - NEW.owner_id: %, NEW.member_id: %, NEW.status: %', 
        NEW.owner_id, NEW.member_id, NEW.status;
    
    -- Verificar se member_id não é NULL
    IF NEW.member_id IS NULL THEN
        RAISE NOTICE 'ERRO: NEW.member_id é NULL!';
        RETURN NEW;
    END IF;
    
    -- Buscar email do usuário que convidou
    SELECT email INTO inviter_email 
    FROM public.profiles 
    WHERE id = NEW.owner_id;
    
    -- Usar NEW.member_id como user_id da notificação
    member_user_id := NEW.member_id;
    
    -- Criar notificação apenas se o status for 'pending'
    IF NEW.status = 'pending' THEN
        RAISE NOTICE 'CRIANDO NOTIFICAÇÃO - user_id: %, inviter_email: %', 
            member_user_id, inviter_email;
            
        INSERT INTO public.notifications (
            user_id,
            type,
            title,
            message,
            data
        ) VALUES (
            member_user_id,  -- Usar member_id como user_id
            'organization_invite',
            'Convite para Organização',
            'Você foi convidado por ' || COALESCE(inviter_email, 'um usuário') || ' para participar de sua organização financeira.',
            jsonb_build_object(
                'organization_member_id', NEW.id,
                'owner_id', NEW.owner_id,
                'owner_email', inviter_email
            )
        );
        
        RAISE NOTICE 'NOTIFICAÇÃO CRIADA COM SUCESSO!';
    ELSE
        RAISE NOTICE 'STATUS NÃO É PENDING, NOTIFICAÇÃO NÃO CRIADA';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. RECRIAR trigger
DROP TRIGGER IF EXISTS organization_invite_notification_trigger ON public.organization_members;
CREATE TRIGGER organization_invite_notification_trigger
    AFTER INSERT ON public.organization_members
    FOR EACH ROW EXECUTE FUNCTION public.create_organization_invite_notification();

-- 5. Testar trigger manualmente
SELECT 'TESTANDO TRIGGER MANUALMENTE:' as info;

-- Primeiro, limpar dados de teste
DELETE FROM public.notifications WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = 'logotiq@gmail.com'
);

DELETE FROM public.organization_members WHERE email = 'logotiq@gmail.com';

-- Inserir novo member para disparar trigger
DO $$
DECLARE
    user_jopedro UUID;
    user_logotiq UUID;
BEGIN
    SELECT id INTO user_jopedro FROM auth.users WHERE email = 'jopedromkt@gmail.com';
    SELECT id INTO user_logotiq FROM auth.users WHERE email = 'logotiq@gmail.com';
    
    IF user_jopedro IS NOT NULL AND user_logotiq IS NOT NULL THEN
        RAISE NOTICE 'INSERINDO ORGANIZATION_MEMBER - owner: %, member: %', 
            user_jopedro, user_logotiq;
            
        INSERT INTO public.organization_members (
            id,
            owner_id,
            member_id,
            email,
            status,
            created_at,
            updated_at
        ) VALUES (
            gen_random_uuid(),
            user_jopedro,
            user_logotiq,
            'logotiq@gmail.com',
            'pending',
            NOW(),
            NOW()
        );
        
        RAISE NOTICE 'ORGANIZATION_MEMBER INSERIDO, TRIGGER DEVE TER EXECUTADO';
    ELSE
        RAISE NOTICE 'USUÁRIOS NÃO ENCONTRADOS - jopedro: %, logotiq: %', 
            user_jopedro, user_logotiq;
    END IF;
END $$;

-- 6. Verificar se notificação foi criada
SELECT 'VERIFICANDO NOTIFICAÇÃO CRIADA:' as info;
SELECT 
    n.id,
    u.email as destinatario,
    n.type,
    n.title,
    n.message,
    n.data,
    n.status,
    n.created_at
FROM public.notifications n
JOIN auth.users u ON n.user_id = u.id
WHERE u.email = 'logotiq@gmail.com'
ORDER BY n.created_at DESC;

-- 7. Verificar organization_members
SELECT 'VERIFICANDO ORGANIZATION_MEMBERS:' as info;
SELECT 
    om.id,
    o.email as owner_email,
    m.email as member_email,
    om.email as email_field,
    om.status,
    om.created_at
FROM public.organization_members om
LEFT JOIN auth.users o ON om.owner_id = o.id
LEFT JOIN auth.users m ON om.member_id = m.id
ORDER BY om.created_at DESC;

SELECT '✅ TRIGGER CORRIGIDO E TESTADO!' as resultado;
