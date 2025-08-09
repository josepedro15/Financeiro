-- SCRIPT TEMPORÁRIO: Desabilitar RLS para testar
-- ATENÇÃO: Este script remove a segurança temporariamente para debug

-- 1. PRIMEIRO: Ativar o usuário pendente
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

-- 2. DESABILITAR RLS TEMPORARIAMENTE (APENAS PARA TESTE)
ALTER TABLE public.accounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;

-- Desabilitar RLS nas tabelas mensais
DO $$
DECLARE
    table_name TEXT;
    monthly_tables TEXT[] := ARRAY[
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
    ];
BEGIN
    FOREACH table_name IN ARRAY monthly_tables LOOP
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = table_name) THEN
            EXECUTE format('ALTER TABLE public.%I DISABLE ROW LEVEL SECURITY', table_name);
            RAISE NOTICE 'RLS desabilitado em %', table_name;
        END IF;
    END LOOP;
END $$;

-- 3. VERIFICAR STATUS DO USUÁRIO
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

-- 4. TESTAR SE CONSEGUE VER DADOS AGORA (SEM RLS)
SELECT 'organization_members' as tabela, COUNT(*) as total FROM public.organization_members
UNION ALL
SELECT 'profiles' as tabela, COUNT(*) as total FROM public.profiles
UNION ALL
SELECT 'accounts' as tabela, COUNT(*) as total FROM public.accounts
UNION ALL
SELECT 'clients' as tabela, COUNT(*) as total FROM public.clients
UNION ALL
SELECT 'expenses' as tabela, COUNT(*) as total FROM public.expenses
UNION ALL
SELECT 'transactions' as tabela, COUNT(*) as total FROM public.transactions
UNION ALL
SELECT 'transactions_2025_04' as tabela, COUNT(*) as total FROM public.transactions_2025_04;

-- IMPORTANTE: Depois de testar, execute este comando para reabilitar RLS
-- ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
-- (E para todas as tabelas mensais também)
