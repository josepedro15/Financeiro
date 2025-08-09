-- Função para verificar se um usuário é membro de uma organização
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

-- Atualizar políticas para accounts
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

-- Atualizar políticas para clients
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

-- Atualizar políticas para expenses
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

-- Políticas para as tabelas mensais de transações (2025)
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

-- Política para a tabela transactions original (se ainda existir)
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
