-- ====================================
-- CONFIGURAÇÃO CORRIGIDA DO SISTEMA DE ORGANIZAÇÕES
-- ====================================

-- 1. CRIAR TABELAS BÁSICAS
-- ====================================

CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE,
  email TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.organization_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  member_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(owner_id, email)
);

-- 2. CRIAR ÍNDICES
-- ====================================

CREATE INDEX IF NOT EXISTS idx_organization_members_owner_id ON public.organization_members(owner_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_member_id ON public.organization_members(member_id);
CREATE INDEX IF NOT EXISTS idx_organization_members_email ON public.organization_members(email);
CREATE INDEX IF NOT EXISTS idx_organization_members_status ON public.organization_members(status);

-- 3. CRIAR FUNÇÕES
-- ====================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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

CREATE OR REPLACE FUNCTION public.update_organization_member_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.organization_members
    SET 
        member_id = NEW.id,
        status = 'active',
        updated_at = NOW()
    WHERE email = NEW.email AND status = 'pending';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_organization_member(owner_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    IF auth.uid() = owner_user_id THEN
        RETURN TRUE;
    END IF;
    
    RETURN EXISTS (
        SELECT 1 
        FROM public.organization_members 
        WHERE owner_id = owner_user_id 
        AND member_id = auth.uid() 
        AND status = 'active'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. CRIAR TRIGGERS
-- ====================================

DROP TRIGGER IF EXISTS trigger_organization_members_updated_at ON public.organization_members;
CREATE TRIGGER trigger_organization_members_updated_at
    BEFORE UPDATE ON public.organization_members
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trigger_profiles_updated_at ON public.profiles;
CREATE TRIGGER trigger_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

DROP TRIGGER IF EXISTS on_user_registered ON public.profiles;
CREATE TRIGGER on_user_registered
    AFTER INSERT ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_organization_member_status();

-- 5. HABILITAR RLS
-- ====================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organization_members ENABLE ROW LEVEL SECURITY;

-- 6. POLÍTICAS BÁSICAS
-- ====================================

DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile"
ON public.profiles FOR SELECT
USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
USING (auth.uid() = id);

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

-- 7. POLÍTICAS PARA TABELAS EXISTENTES
-- ====================================

DO $$
DECLARE
    tbl_name TEXT;
    user_col TEXT;
BEGIN
    -- Verificar e configurar tabela accounts
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'accounts') THEN
        user_col := NULL;
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'accounts' AND column_name = 'user_id') THEN
            user_col := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'accounts' AND column_name = 'owner_id') THEN
            user_col := 'owner_id';
        END IF;
        
        IF user_col IS NOT NULL THEN
            ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
            DROP POLICY IF EXISTS "Users can view own accounts or shared accounts" ON public.accounts;
            EXECUTE format('CREATE POLICY "Users can view own accounts or shared accounts" ON public.accounts FOR SELECT USING (auth.uid() = %I OR public.is_organization_member(%I))', user_col, user_col);
            DROP POLICY IF EXISTS "Users can insert own accounts" ON public.accounts;
            EXECUTE format('CREATE POLICY "Users can insert own accounts" ON public.accounts FOR INSERT WITH CHECK (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can update own accounts" ON public.accounts;
            EXECUTE format('CREATE POLICY "Users can update own accounts" ON public.accounts FOR UPDATE USING (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can delete own accounts" ON public.accounts;
            EXECUTE format('CREATE POLICY "Users can delete own accounts" ON public.accounts FOR DELETE USING (auth.uid() = %I)', user_col);
            RAISE NOTICE 'Configurado accounts com coluna %', user_col;
        END IF;
    END IF;
    
    -- Verificar e configurar tabela clients
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'clients') THEN
        user_col := NULL;
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'user_id') THEN
            user_col := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'clients' AND column_name = 'owner_id') THEN
            user_col := 'owner_id';
        END IF;
        
        IF user_col IS NOT NULL THEN
            ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
            DROP POLICY IF EXISTS "Users can view own clients or shared clients" ON public.clients;
            EXECUTE format('CREATE POLICY "Users can view own clients or shared clients" ON public.clients FOR SELECT USING (auth.uid() = %I OR public.is_organization_member(%I))', user_col, user_col);
            DROP POLICY IF EXISTS "Users can insert own clients" ON public.clients;
            EXECUTE format('CREATE POLICY "Users can insert own clients" ON public.clients FOR INSERT WITH CHECK (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can update own clients" ON public.clients;
            EXECUTE format('CREATE POLICY "Users can update own clients" ON public.clients FOR UPDATE USING (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can delete own clients" ON public.clients;
            EXECUTE format('CREATE POLICY "Users can delete own clients" ON public.clients FOR DELETE USING (auth.uid() = %I)', user_col);
            RAISE NOTICE 'Configurado clients com coluna %', user_col;
        END IF;
    END IF;
    
    -- Verificar e configurar tabela expenses
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'expenses') THEN
        user_col := NULL;
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'expenses' AND column_name = 'user_id') THEN
            user_col := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'expenses' AND column_name = 'owner_id') THEN
            user_col := 'owner_id';
        END IF;
        
        IF user_col IS NOT NULL THEN
            ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
            DROP POLICY IF EXISTS "Users can view own expenses or shared expenses" ON public.expenses;
            EXECUTE format('CREATE POLICY "Users can view own expenses or shared expenses" ON public.expenses FOR SELECT USING (auth.uid() = %I OR public.is_organization_member(%I))', user_col, user_col);
            DROP POLICY IF EXISTS "Users can insert own expenses" ON public.expenses;
            EXECUTE format('CREATE POLICY "Users can insert own expenses" ON public.expenses FOR INSERT WITH CHECK (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can update own expenses" ON public.expenses;
            EXECUTE format('CREATE POLICY "Users can update own expenses" ON public.expenses FOR UPDATE USING (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can delete own expenses" ON public.expenses;
            EXECUTE format('CREATE POLICY "Users can delete own expenses" ON public.expenses FOR DELETE USING (auth.uid() = %I)', user_col);
            RAISE NOTICE 'Configurado expenses com coluna %', user_col;
        END IF;
    END IF;
    
    -- Verificar e configurar tabela transactions
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'transactions') THEN
        user_col := NULL;
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'transactions' AND column_name = 'user_id') THEN
            user_col := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'transactions' AND column_name = 'owner_id') THEN
            user_col := 'owner_id';
        END IF;
        
        IF user_col IS NOT NULL THEN
            ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
            DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.transactions;
            EXECUTE format('CREATE POLICY "Users can view own transactions or shared transactions" ON public.transactions FOR SELECT USING (auth.uid() = %I OR public.is_organization_member(%I))', user_col, user_col);
            DROP POLICY IF EXISTS "Users can insert own transactions" ON public.transactions;
            EXECUTE format('CREATE POLICY "Users can insert own transactions" ON public.transactions FOR INSERT WITH CHECK (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can update own transactions" ON public.transactions;
            EXECUTE format('CREATE POLICY "Users can update own transactions" ON public.transactions FOR UPDATE USING (auth.uid() = %I)', user_col);
            DROP POLICY IF EXISTS "Users can delete own transactions" ON public.transactions;
            EXECUTE format('CREATE POLICY "Users can delete own transactions" ON public.transactions FOR DELETE USING (auth.uid() = %I)', user_col);
            RAISE NOTICE 'Configurado transactions com coluna %', user_col;
        END IF;
    END IF;
END $$;

-- 8. POLÍTICAS PARA TABELAS MENSAIS
-- ====================================

DO $$
DECLARE
    monthly_table TEXT;
    user_col TEXT;
    monthly_tables TEXT[] := ARRAY[
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
    ];
BEGIN
    FOREACH monthly_table IN ARRAY monthly_tables LOOP
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = monthly_table) THEN
            user_col := NULL;
            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = monthly_table AND column_name = 'user_id') THEN
                user_col := 'user_id';
            ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = monthly_table AND column_name = 'owner_id') THEN
                user_col := 'owner_id';
            END IF;
            
            IF user_col IS NOT NULL THEN
                EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', monthly_table);
                EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.%I', monthly_table);
                EXECUTE format('CREATE POLICY "Users can view own transactions or shared transactions" ON public.%I FOR SELECT USING (auth.uid() = %I OR public.is_organization_member(%I))', monthly_table, user_col, user_col);
                EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON public.%I', monthly_table);
                EXECUTE format('CREATE POLICY "Users can insert own transactions" ON public.%I FOR INSERT WITH CHECK (auth.uid() = %I)', monthly_table, user_col);
                EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON public.%I', monthly_table);
                EXECUTE format('CREATE POLICY "Users can update own transactions" ON public.%I FOR UPDATE USING (auth.uid() = %I)', monthly_table, user_col);
                EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON public.%I', monthly_table);
                EXECUTE format('CREATE POLICY "Users can delete own transactions" ON public.%I FOR DELETE USING (auth.uid() = %I)', monthly_table, user_col);
                RAISE NOTICE 'Configurado % com coluna %', monthly_table, user_col;
            END IF;
        END IF;
    END LOOP;
END $$;

-- 9. CONCEDER PERMISSÕES
-- ====================================

GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.organization_members TO authenticated;
GRANT USAGE ON SCHEMA public TO authenticated;

-- ====================================
-- CONFIGURAÇÃO COMPLETA!
-- ====================================
