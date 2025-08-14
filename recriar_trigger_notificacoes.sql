-- =====================================================
-- RECRIAR TRIGGER DE NOTIFICAÇÕES DE CONVITES
-- =====================================================

-- 1. REMOVER TRIGGER EXISTENTE
-- =====================================================

DROP TRIGGER IF EXISTS organization_invite_notification_trigger ON public.organization_members;

-- 2. RECRIAR FUNÇÃO DE NOTIFICAÇÃO
-- =====================================================

CREATE OR REPLACE FUNCTION public.create_organization_invite_notification()
RETURNS TRIGGER AS $$
DECLARE
    inviter_email TEXT;
    target_user_id UUID;
BEGIN
    -- Buscar email do usuário que convidou
    SELECT email INTO inviter_email 
    FROM public.profiles 
    WHERE id = NEW.owner_id;
    
    -- Determinar o user_id da notificação
    IF NEW.member_id IS NOT NULL THEN
        target_user_id := NEW.member_id;
    ELSE
        -- Se não tem member_id, buscar pelo email
        SELECT id INTO target_user_id
        FROM auth.users 
        WHERE email = NEW.email;
    END IF;
    
    -- Criar notificação apenas se o status for 'pending' e tiver um user_id válido
    IF NEW.status = 'pending' AND target_user_id IS NOT NULL THEN
        -- Verificar se já existe uma notificação para este convite
        IF NOT EXISTS (
            SELECT 1 FROM public.notifications 
            WHERE type = 'organization_invite' 
            AND data->>'organization_member_id' = NEW.id::text
        ) THEN
            INSERT INTO public.notifications (
                user_id,
                type,
                title,
                message,
                data,
                status
            ) VALUES (
                target_user_id,
                'organization_invite',
                'Convite para Organização',
                'Você foi convidado por ' || COALESCE(inviter_email, 'um usuário') || ' para participar de sua organização financeira.',
                jsonb_build_object(
                    'organization_member_id', NEW.id,
                    'owner_id', NEW.owner_id,
                    'owner_email', inviter_email
                ),
                'pending'
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. RECRIAR TRIGGER
-- =====================================================

CREATE TRIGGER organization_invite_notification_trigger
    AFTER INSERT ON public.organization_members
    FOR EACH ROW EXECUTE FUNCTION public.create_organization_invite_notification();

-- 4. VERIFICAR SE FOI CRIADO CORRETAMENTE
-- =====================================================

SELECT 
    'Trigger criado com sucesso!' as status,
    trigger_name,
    event_object_table,
    event_manipulation,
    action_timing
FROM information_schema.triggers 
WHERE trigger_name = 'organization_invite_notification_trigger';

-- 5. TESTE MANUAL - CRIAR UM CONVITE DE TESTE
-- =====================================================

-- NOTA: Descomente as linhas abaixo para testar o trigger
-- Substitua os UUIDs pelos IDs reais dos usuários

/*
-- Teste: Criar um convite de teste
INSERT INTO public.organization_members (
    owner_id,
    member_id,
    email,
    status
) VALUES (
    'UUID_DO_OWNER',  -- Substitua pelo UUID do usuário que está convidando
    'UUID_DO_MEMBER', -- Substitua pelo UUID do usuário convidado
    'email@teste.com',
    'pending'
);

-- Verificar se a notificação foi criada
SELECT 
    'Notificação criada:' as info,
    id,
    user_id,
    type,
    title,
    status,
    created_at
FROM public.notifications 
WHERE type = 'organization_invite'
ORDER BY created_at DESC
LIMIT 1;
*/

-- 6. VERIFICAR NOTIFICAÇÕES EXISTENTES
-- =====================================================

SELECT 
    'Notificações de convite existentes:' as info,
    COUNT(*) as total_convites,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) as pendentes,
    COUNT(CASE WHEN status = 'accepted' THEN 1 END) as aceitas,
    COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejeitadas
FROM public.notifications 
WHERE type = 'organization_invite';

-- 7. VERIFICAR CONVITES PENDENTES
-- =====================================================

SELECT 
    'Convites pendentes:' as info,
    COUNT(*) as total_pendentes,
    COUNT(CASE WHEN member_id IS NOT NULL THEN 1 END) as com_usuario,
    COUNT(CASE WHEN member_id IS NULL THEN 1 END) as sem_usuario
FROM public.organization_members 
WHERE status = 'pending';

-- 8. INSTRUÇÕES
-- =====================================================

SELECT 
    '=== INSTRUÇÕES ===' as info,
    '1. O trigger foi recriado com sucesso' as instrucao1,
    '2. Novos convites devem gerar notificações automaticamente' as instrucao2,
    '3. Para testar, adicione um novo usuário na página Settings' as instrucao3,
    '4. Verifique se a notificação aparece no NotificationCenter' as instrucao4,
    '5. Se ainda não funcionar, verifique os logs do console' as instrucao5;
