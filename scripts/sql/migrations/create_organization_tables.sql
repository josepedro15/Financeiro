-- Criar tabela de perfis de usuários (se não existir)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE,
  email TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

-- Criar tabela para membros de organização
CREATE TABLE IF NOT EXISTS public.organization_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  member_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Garantir que não haja duplicatas de email por owner
  UNIQUE(owner_id, email)
);

-- Criar índices para melhor performance
CREATE INDEX IF NOT EXISTS idx_organization_members_owner_id ON public.organization_members(owner_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_member_id ON public.organization_members(member_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_email ON public.organization_members(email);
CREATE INDEX IF NOT EXISTS idx_organization_members_status ON public.organization_members(status);

-- Criar função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para atualizar updated_at na tabela organization_members
DROP TRIGGER IF EXISTS trigger_organization_members_updated_at ON public.organization_members;
CREATE TRIGGER trigger_organization_members_updated_at
    BEFORE UPDATE ON public.organization_members
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Criar trigger para atualizar updated_at na tabela profiles
DROP TRIGGER IF EXISTS trigger_profiles_updated_at ON public.profiles;
CREATE TRIGGER trigger_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Função para sincronizar perfis com auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email)
    VALUES (NEW.id, NEW.email)
    ON CONFLICT (id) DO UPDATE SET
        email = NEW.email,
        updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para criar perfil automaticamente quando um usuário se registra
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Função para atualizar status do membro quando ele se registra
CREATE OR REPLACE FUNCTION public.update_organization_member_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualizar membros pendentes para ativos quando o usuário se registrar
    UPDATE public.organization_members
    SET 
        member_id = NEW.id,
        status = 'active',
        updated_at = NOW()
    WHERE email = NEW.email AND status = 'pending';
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para atualizar status automaticamente
DROP TRIGGER IF EXISTS on_user_registered ON public.profiles;
CREATE TRIGGER on_user_registered
    AFTER INSERT ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_organization_member_status();

-- Habilitar RLS nas tabelas
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;

-- Policies para profiles
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile"
ON public.profiles FOR SELECT
USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

-- Policies para organization_members
DROP POLICY IF EXISTS "Users can view own organization members" ON public.organization_members;
CREATE POLICY "Users can view own organization members"
ON public.organization_members FOR SELECT
USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can insert organization members" ON public.organization_members;
CREATE POLICY "Users can insert organization members"
ON public.organization_members FOR INSERT
WITH CHECK (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can update own organization members" ON public.organization_members;
CREATE POLICY "Users can update own organization members"
ON public.organization_members FOR UPDATE
USING (auth.uid() = owner_id);

DROP POLICY IF EXISTS "Users can delete own organization members" ON public.organization_members;
CREATE POLICY "Users can delete own organization members"
ON public.organization_members FOR DELETE
USING (auth.uid() = owner_id);

-- Grant permissions
GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.organization_members TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated;
