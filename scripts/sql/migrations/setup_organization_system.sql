-- ====================================
-- CONFIGURAÇÃO COMPLETA DO SISTEMA DE ORGANIZAÇÕES
-- ====================================
-- Este script cria todas as tabelas e políticas necessárias
-- para permitir compartilhamento de dados entre usuários

-- 1. CRIAR TABELAS
-- ====================================

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

-- 2. CRIAR ÍNDICES
-- ====================================

CREATE INDEX IF NOT EXISTS idx_organization_members_owner_id ON public.organization_members(owner_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_member_id ON public.organization_members(member_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_email ON public.organization_members(email);
CREATE INDEX IF NOT EXISTS idx_organization_members_status ON public.organization_members(status);

-- 3. CRIAR FUNÇÕES E TRIGGERS
-- ====================================

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at na tabela organization_members
DROP TRIGGER IF EXISTS trigger_organization_members_updated_at ON public.organization_members;
CREATE TRIGGER trigger_organization_members_updated_at
    BEFORE UPDATE ON public.organization_members
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Trigger para atualizar updated_at na tabela profiles
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

-- 4. FUNÇÃO PARA VERIFICAR MEMBROS DE ORGANIZAÇÃO
-- ====================================

CREATE OR REPLACE FUNCTION public.is_organization_member(owner_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    -- Verificar se o usuário atual é o owner
    IF auth.uid() = owner_user_id THEN
        RETURN TRUE;
    END IF;
    
    -- Verificar se o usuário atual é membro ativo da organização do owner
    RETURN EXISTS (
        SELECT 1 
        FROM public.organization_members 
        WHERE owner_id = owner_user_id 
        AND member_id = auth.uid() 
        AND status = 'active'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. HABILITAR RLS
-- ====================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;

-- 6. POLÍTICAS PARA PROFILES
-- ====================================

DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile"
ON public.profiles FOR SELECT
USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

-- 7. POLÍTICAS PARA ORGANIZATION_MEMBERS
-- ====================================

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

-- 8. POLÍTICAS DE COMPARTILHAMENTO PARA ACCOUNTS
-- ====================================

DROP POLICY IF EXISTS "Users can view own accounts or shared accounts" ON public.accounts;
CREATE POLICY "Users can view own accounts or shared accounts"
ON public.accounts FOR SELECT
USING (
    auth.uid() = user_id OR 
    public.is_organization_member(user_id)
);

DROP POLICY IF EXISTS "Users can insert own accounts" ON public.accounts;
CREATE POLICY "Users can insert own accounts"
ON public.accounts FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own accounts" ON public.accounts;
CREATE POLICY "Users can update own accounts"
ON public.accounts FOR UPDATE
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own accounts" ON public.accounts;
CREATE POLICY "Users can delete own accounts"
ON public.accounts FOR DELETE
USING (auth.uid() = user_id);

-- 9. POLÍTICAS DE COMPARTILHAMENTO PARA CLIENTS
-- ====================================

DROP POLICY IF EXISTS "Users can view own clients or shared clients" ON public.clients;
CREATE POLICY "Users can view own clients or shared clients"
ON public.clients FOR SELECT
USING (
    auth.uid() = user_id OR 
    public.is_organization_member(user_id)
);

DROP POLICY IF EXISTS "Users can insert own clients" ON public.clients;
CREATE POLICY "Users can insert own clients"
ON public.clients FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own clients" ON public.clients;
CREATE POLICY "Users can update own clients"
ON public.clients FOR UPDATE
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own clients" ON public.clients;
CREATE POLICY "Users can delete own clients"
ON public.clients FOR DELETE
USING (auth.uid() = user_id);

-- 10. POLÍTICAS DE COMPARTILHAMENTO PARA EXPENSES
-- ====================================

DROP POLICY IF EXISTS "Users can view own expenses or shared expenses" ON public.expenses;
CREATE POLICY "Users can view own expenses or shared expenses"
ON public.expenses FOR SELECT
USING (
    auth.uid() = user_id OR 
    public.is_organization_member(user_id)
);

DROP POLICY IF EXISTS "Users can insert own expenses" ON public.expenses;
CREATE POLICY "Users can insert own expenses"
ON public.expenses FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own expenses" ON public.expenses;
CREATE POLICY "Users can update own expenses"
ON public.expenses FOR UPDATE
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own expenses" ON public.expenses;
CREATE POLICY "Users can delete own expenses"
ON public.expenses FOR DELETE
USING (auth.uid() = user_id);

-- 11. POLÍTICAS PARA TABELAS MENSAIS DE TRANSAÇÕES
-- ====================================

DO $$
DECLARE
    table_name TEXT;
    tables TEXT[] := ARRAY[
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
    ];
BEGIN
    FOREACH table_name IN ARRAY tables
    LOOP
        -- Verificar se a tabela existe antes de criar as políticas
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = table_name) THEN
            -- Drop existing policies
            EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.%I', table_name);
            EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON public.%I', table_name);
            EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON public.%I', table_name);
            EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON public.%I', table_name);
            
            -- Create new policies
            EXECUTE format('CREATE POLICY "Users can view own transactions or shared transactions" ON public.%I FOR SELECT USING (auth.uid() = user_id OR public.is_organization_member(user_id))', table_name);
            EXECUTE format('CREATE POLICY "Users can insert own transactions" ON public.%I FOR INSERT WITH CHECK (auth.uid() = user_id)', table_name);
            EXECUTE format('CREATE POLICY "Users can update own transactions" ON public.%I FOR UPDATE USING (auth.uid() = user_id)', table_name);
            EXECUTE format('CREATE POLICY "Users can delete own transactions" ON public.%I FOR DELETE USING (auth.uid() = user_id)', table_name);
        END IF;
    END LOOP;
END $$;

-- 12. POLÍTICA PARA TABELA TRANSACTIONS ORIGINAL
-- ====================================

DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.transactions;
CREATE POLICY "Users can view own transactions or shared transactions"
ON public.transactions FOR SELECT
USING (
    auth.uid() = user_id OR 
    public.is_organization_member(user_id)
);

DROP POLICY IF EXISTS "Users can insert own transactions" ON public.transactions;
CREATE POLICY "Users can insert own transactions"
ON public.transactions FOR INSERT
WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own transactions" ON public.transactions;
CREATE POLICY "Users can update own transactions"
ON public.transactions FOR UPDATE
USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own transactions" ON public.transactions;
CREATE POLICY "Users can delete own transactions"
ON public.transactions FOR DELETE
USING (auth.uid() = user_id);

-- 13. CONCEDER PERMISSÕES
-- ====================================

GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.organization_members TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated;

-- ====================================
-- CONFIGURAÇÃO COMPLETA!
-- ====================================
-- O sistema de organizações está configurado e pronto para uso.
-- 
-- FUNCIONALIDADES:
-- • Adicionar usuários por email à organização
-- • Usuários adicionados podem ver todos os dados do owner
-- • Status automático (pendente → ativo quando usuário se registra)
-- • Políticas RLS seguras para todas as tabelas
-- • Triggers automáticos para sincronização
