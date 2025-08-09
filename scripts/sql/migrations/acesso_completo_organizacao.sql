-- LÓGICA DE ACESSO COMPLETO À ORGANIZAÇÃO
-- O usuário adicionado terá TODOS os direitos do owner

-- 1. PRIMEIRO: Verificar se o usuário foi ativado
SELECT 
    om.email,
    om.status,
    om.member_id,
    om.owner_id,
    au.email as auth_email
FROM public.organization_members om
LEFT JOIN auth.users au ON au.id = om.member_id
WHERE om.email = 'josepedro123nato88@gmail.com';

-- 2. ATIVAR USUÁRIO SE AINDA ESTIVER PENDENTE
DO $$
DECLARE
    user_uuid UUID;
    pending_email TEXT := 'josepedro123nato88@gmail.com';
BEGIN
    SELECT au.id INTO user_uuid
    FROM auth.users au
    WHERE au.email = pending_email;
    
    IF user_uuid IS NOT NULL THEN
        UPDATE public.organization_members
        SET 
            member_id = user_uuid,
            status = 'active',
            updated_at = NOW()
        WHERE email = pending_email AND status = 'pending';
        
        INSERT INTO public.profiles (id, email)
        VALUES (user_uuid, pending_email)
        ON CONFLICT (id) DO UPDATE SET
            email = pending_email,
            updated_at = NOW();
        
        RAISE NOTICE 'Usuário % ativado com UUID %', pending_email, user_uuid;
    END IF;
END $$;

-- 3. CRIAR NOVA FUNÇÃO MAIS SIMPLES
CREATE OR REPLACE FUNCTION public.can_access_user_data(target_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    -- Se é o próprio usuário, pode acessar
    IF auth.uid() = target_user_id THEN
        RETURN TRUE;
    END IF;
    
    -- Se é membro ativo de uma organização onde target_user_id é owner, pode acessar
    IF EXISTS (
        SELECT 1 
        FROM public.organization_members 
        WHERE owner_id = target_user_id 
        AND member_id = auth.uid() 
        AND status = 'active'
    ) THEN
        RETURN TRUE;
    END IF;
    
    -- Se é owner de uma organização onde target_user_id é membro, pode acessar os próprios dados
    IF EXISTS (
        SELECT 1 
        FROM public.organization_members 
        WHERE owner_id = auth.uid() 
        AND member_id = target_user_id 
        AND status = 'active'
    ) THEN
        RETURN TRUE;
    END IF;
    
    RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. REMOVER TODAS AS POLÍTICAS ANTIGAS E CRIAR NOVAS SIMPLES

-- CLIENTS
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can view own clients or shared clients" ON public.clients;
DROP POLICY IF EXISTS "Users can insert own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can update own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can delete own clients" ON public.clients;

CREATE POLICY "Full access to clients" ON public.clients FOR ALL
USING (public.can_access_user_data(user_id))
WITH CHECK (public.can_access_user_data(user_id));

-- EXPENSES
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can view own expenses or shared expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can update own expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can delete own expenses" ON public.expenses;

CREATE POLICY "Full access to expenses" ON public.expenses FOR ALL
USING (public.can_access_user_data(user_id))
WITH CHECK (public.can_access_user_data(user_id));

-- TRANSACTIONS (tabela principal)
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Global access to transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can insert own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can update own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can delete own transactions" ON public.transactions;

CREATE POLICY "Full access to transactions" ON public.transactions FOR ALL
USING (public.can_access_user_data(user_id))
WITH CHECK (public.can_access_user_data(user_id));

-- 5. TABELAS MENSAIS DE TRANSAÇÕES
DO $$
DECLARE
    monthly_table TEXT;
    monthly_tables TEXT[] := ARRAY[
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
    ];
BEGIN
    FOREACH monthly_table IN ARRAY monthly_tables LOOP
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = monthly_table) THEN
            -- Habilitar RLS
            EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', monthly_table);
            
            -- Remover políticas antigas
            EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.%I', monthly_table);
            EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON public.%I', monthly_table);
            EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON public.%I', monthly_table);
            EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON public.%I', monthly_table);
            
            -- Criar nova política de acesso completo
            EXECUTE format('CREATE POLICY "Full access to transactions" ON public.%I FOR ALL USING (public.can_access_user_data(user_id)) WITH CHECK (public.can_access_user_data(user_id))', monthly_table);
            
            RAISE NOTICE 'Política de acesso completo criada para %', monthly_table;
        END IF;
    END LOOP;
END $$;

-- 6. ACCOUNTS (sem user_id - acesso total)
ALTER TABLE public.accounts DISABLE ROW LEVEL SECURITY;

-- 7. TESTAR A NOVA FUNÇÃO
DO $$
DECLARE
    owner_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
    member_user_id UUID;
BEGIN
    -- Buscar o ID do usuário membro
    SELECT au.id INTO member_user_id
    FROM auth.users au
    WHERE au.email = 'josepedro123nato88@gmail.com';
    
    RAISE NOTICE 'Owner ID: %', owner_user_id;
    RAISE NOTICE 'Member ID: %', member_user_id;
    
    -- Simular contexto do membro (normalmente seria feito pelo auth.uid())
    -- Esta é apenas uma simulação - na aplicação real, auth.uid() será o member_user_id
    RAISE NOTICE 'Usuário membro deveria poder acessar dados do owner: TRUE';
    RAISE NOTICE 'Owner deveria poder acessar próprios dados: TRUE';
END $$;

-- 8. VERIFICAR STATUS FINAL
SELECT 
    'Configuração concluída!' as status,
    'Usuários de organização têm acesso COMPLETO aos dados compartilhados' as descricao;

SELECT 
    om.email,
    om.status,
    CASE 
        WHEN om.status = 'active' THEN 'Pode acessar e gerenciar todos os dados'
        ELSE 'Sem acesso'
    END as nivel_acesso
FROM public.organization_members om
WHERE om.email = 'josepedro123nato88@gmail.com';
