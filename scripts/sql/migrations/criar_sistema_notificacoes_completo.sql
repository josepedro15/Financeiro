-- CRIAR SISTEMA DE NOTIFICAÇÕES COMPLETO
-- Execute este script PRIMEIRO no Supabase SQL Editor

-- 1. CRIAR TABELA DE NOTIFICAÇÕES
CREATE TABLE IF NOT EXISTS public.notifications (
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

-- 2. HABILITAR RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- 3. POLÍTICA PARA USUÁRIOS VEREM APENAS SUAS NOTIFICAÇÕES
DROP POLICY IF EXISTS "notifications_user_policy" ON public.notifications;
CREATE POLICY "notifications_user_policy" ON public.notifications
    FOR ALL USING (user_id = auth.uid());

-- 4. FUNÇÃO PARA ATUALIZAR updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 5. TRIGGER PARA updated_at
DROP TRIGGER IF EXISTS update_notifications_updated_at ON public.notifications;
CREATE TRIGGER update_notifications_updated_at 
    BEFORE UPDATE ON public.notifications 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 6. FUNÇÃO PARA CRIAR NOTIFICAÇÃO AUTOMÁTICA
CREATE OR REPLACE FUNCTION public.create_organization_invite_notification()
RETURNS TRIGGER AS $$
DECLARE
    inviter_email TEXT;
BEGIN
    -- Buscar email do usuário que convidou
    SELECT email INTO inviter_email 
    FROM public.profiles 
    WHERE id = NEW.owner_id;
    
    -- Criar notificação apenas se o status for 'pending'
    IF NEW.status = 'pending' THEN
        INSERT INTO public.notifications (
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

-- 7. TRIGGER PARA CRIAR NOTIFICAÇÃO QUANDO CONVITE FOR FEITO
DROP TRIGGER IF EXISTS organization_invite_notification_trigger ON public.organization_members;
CREATE TRIGGER organization_invite_notification_trigger
    AFTER INSERT ON public.organization_members
    FOR EACH ROW EXECUTE FUNCTION public.create_organization_invite_notification();

-- 8. VERIFICAR SE TUDO FOI CRIADO
SELECT 'VERIFICANDO CRIAÇÃO DA TABELA...' as info;
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_name = 'notifications' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

SELECT 'VERIFICANDO TRIGGERS...' as info;
SELECT 
    trigger_name,
    event_object_table
FROM information_schema.triggers 
WHERE event_object_table IN ('notifications', 'organization_members')
ORDER BY event_object_table;

SELECT '✅ SISTEMA DE NOTIFICAÇÕES CRIADO COM SUCESSO!' as status;
