-- Criar sistema de notificações para convites de organização

-- 1. Criar tabela de notificações
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('organization_invite', 'general')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    data JSONB DEFAULT '{}',
    read BOOLEAN DEFAULT FALSE,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Habilitar RLS
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- 3. Política para usuários verem apenas suas notificações
CREATE POLICY "notifications_user_policy" ON notifications
    FOR ALL USING (user_id = auth.uid());

-- 4. Criar trigger para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_notifications_updated_at 
    BEFORE UPDATE ON notifications 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 5. Função para criar notificação de convite automática
CREATE OR REPLACE FUNCTION create_organization_invite_notification()
RETURNS TRIGGER AS $$
DECLARE
    inviter_email TEXT;
BEGIN
    -- Buscar email do usuário que convidou
    SELECT email INTO inviter_email 
    FROM profiles 
    WHERE id = NEW.owner_id;
    
    -- Criar notificação apenas se o status for 'pending'
    IF NEW.status = 'pending' THEN
        INSERT INTO notifications (
            user_id,
            type,
            title,
            message,
            data
        ) VALUES (
            NEW.member_id,
            'organization_invite',
            'Convite para Organização',
            'Você foi convidado por ' || COALESCE(inviter_email, 'um usuário') || ' para participar de sua organização financeira.',
            jsonb_build_object(
                'organization_member_id', NEW.id,
                'owner_id', NEW.owner_id,
                'owner_email', inviter_email
            )
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. Trigger para criar notificação quando convite for feito
DROP TRIGGER IF EXISTS organization_invite_notification_trigger ON organization_members;
CREATE TRIGGER organization_invite_notification_trigger
    AFTER INSERT ON organization_members
    FOR EACH ROW EXECUTE FUNCTION create_organization_invite_notification();

-- 7. Testar o sistema
SELECT 'Sistema de notificações criado com sucesso!' as status;
