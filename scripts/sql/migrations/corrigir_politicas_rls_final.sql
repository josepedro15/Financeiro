-- Script final para corrigir as políticas RLS com base na estrutura real
-- accounts: sem user_id (ignorar)
-- clients, expenses, transactions, transactions_YYYY_MM: com user_id

-- 1. ATIVAR USUÁRIO PENDENTE
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
    ELSE
        RAISE NOTICE 'Usuário % não encontrado', pending_email;
    END IF;
END $$;

-- 2. REABILITAR RLS E CRIAR POLÍTICAS CORRETAS

-- CLIENTS (tem user_id)
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

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

-- EXPENSES (tem user_id)
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

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

-- TRANSACTIONS (tem user_id)
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

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

-- ACCOUNTS (sem user_id - desabilitar RLS ou permitir acesso total)
-- Opção 1: Desabilitar RLS (todos podem ver todas as contas)
ALTER TABLE public.accounts DISABLE ROW LEVEL SECURITY;

-- Opção 2: Se quiser manter RLS mas permitir acesso total:
-- ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
-- DROP POLICY IF EXISTS "All users can access accounts" ON public.accounts;
-- CREATE POLICY "All users can access accounts" ON public.accounts FOR ALL USING (true);

-- 3. TABELAS MENSAIS (todas têm user_id)
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
            
            -- Criar políticas
            EXECUTE format('DROP POLICY IF EXISTS "Users can view own transactions or shared transactions" ON public.%I', monthly_table);
            EXECUTE format('CREATE POLICY "Users can view own transactions or shared transactions" ON public.%I FOR SELECT USING (auth.uid() = user_id OR public.is_organization_member(user_id))', monthly_table);
            
            EXECUTE format('DROP POLICY IF EXISTS "Users can insert own transactions" ON public.%I', monthly_table);
            EXECUTE format('CREATE POLICY "Users can insert own transactions" ON public.%I FOR INSERT WITH CHECK (auth.uid() = user_id)', monthly_table);
            
            EXECUTE format('DROP POLICY IF EXISTS "Users can update own transactions" ON public.%I', monthly_table);
            EXECUTE format('CREATE POLICY "Users can update own transactions" ON public.%I FOR UPDATE USING (auth.uid() = user_id)', monthly_table);
            
            EXECUTE format('DROP POLICY IF EXISTS "Users can delete own transactions" ON public.%I', monthly_table);
            EXECUTE format('CREATE POLICY "Users can delete own transactions" ON public.%I FOR DELETE USING (auth.uid() = user_id)', monthly_table);
            
            RAISE NOTICE 'Políticas criadas para %', monthly_table;
        END IF;
    END LOOP;
END $$;

-- 4. VERIFICAR STATUS FINAL
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM public.organization_members
WHERE email = 'josepedro123nato88@gmail.com'
ORDER BY created_at DESC;

-- 5. TESTAR CONTAGEM DE DADOS
SELECT 'clients' as tabela, COUNT(*) as total FROM public.clients WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID
UNION ALL
SELECT 'expenses' as tabela, COUNT(*) as total FROM public.expenses WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID
UNION ALL
SELECT 'transactions' as tabela, COUNT(*) as total FROM public.transactions WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID
UNION ALL
SELECT 'transactions_2025_04' as tabela, COUNT(*) as total FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID
UNION ALL
SELECT 'accounts' as tabela, COUNT(*) as total FROM public.accounts;

RAISE NOTICE 'Configuração concluída! Políticas RLS criadas corretamente.';
RAISE NOTICE 'ACCOUNTS: RLS desabilitado (sem user_id)';
RAISE NOTICE 'CLIENTS, EXPENSES, TRANSACTIONS: RLS habilitado com compartilhamento';
