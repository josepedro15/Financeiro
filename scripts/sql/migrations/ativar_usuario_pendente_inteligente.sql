-- Script inteligente para ativar usuário pendente
-- Este script detecta automaticamente a estrutura das tabelas

-- 1. ATIVAR USUÁRIO PENDENTE
DO $$
DECLARE
    user_uuid UUID;
    pending_email TEXT := 'josepedro123nato88@gmail.com'; -- Email do usuário pendente
BEGIN
    -- Buscar o UUID do usuário pelo email
    SELECT au.id INTO user_uuid
    FROM auth.users au
    WHERE au.email = pending_email;
    
    IF user_uuid IS NOT NULL THEN
        -- Atualizar o status para ativo
        UPDATE public.organization_members
        SET 
            member_id = user_uuid,
            status = 'active',
            updated_at = NOW()
        WHERE email = pending_email AND status = 'pending';
        
        -- Criar perfil se não existir
        INSERT INTO public.profiles (id, email)
        VALUES (user_uuid, pending_email)
        ON CONFLICT (id) DO UPDATE SET
            email = pending_email,
            updated_at = NOW();
        
        RAISE NOTICE 'Usuário % ativado com UUID %', pending_email, user_uuid;
    ELSE
        RAISE NOTICE 'Usuário % não encontrado na tabela auth.users', pending_email;
    END IF;
END $$;

-- 2. VERIFICAR STATUS DO USUÁRIO
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

-- 3. TESTAR A FUNÇÃO DE COMPARTILHAMENTO
SELECT 
    public.is_organization_member('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID) as pode_ver_dados_owner;

-- 4. SCRIPT INTELIGENTE PARA CONTAR DADOS
-- Este script detecta automaticamente qual coluna usar
DO $$
DECLARE
    table_record RECORD;
    user_column TEXT;
    query_text TEXT;
    result_count INTEGER;
    target_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
BEGIN
    RAISE NOTICE '=== VERIFICANDO DADOS POR TABELA ===';
    
    -- Loop através das tabelas principais
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name IN ('accounts', 'clients', 'expenses', 'transactions')
        AND table_type = 'BASE TABLE'
    LOOP
        user_column := NULL;
        
        -- Verificar qual coluna de usuário existe
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'user_id') THEN
            user_column := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'owner_id') THEN
            user_column := 'owner_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'created_by') THEN
            user_column := 'created_by';
        END IF;
        
        IF user_column IS NOT NULL THEN
            -- Construir e executar query dinamicamente
            query_text := format('SELECT COUNT(*) FROM public.%I WHERE %I = $1', table_record.table_name, user_column);
            EXECUTE query_text INTO result_count USING target_user_id;
            RAISE NOTICE 'Tabela %: % registros (coluna: %)', table_record.table_name, result_count, user_column;
        ELSE
            RAISE NOTICE 'Tabela %: nenhuma coluna de usuário encontrada', table_record.table_name;
        END IF;
    END LOOP;
    
    RAISE NOTICE '=== VERIFICANDO TABELAS MENSAIS ===';
    
    -- Loop através das tabelas mensais
    FOR table_record IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name LIKE 'transactions_2025_%'
        AND table_type = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        user_column := NULL;
        
        -- Verificar qual coluna de usuário existe
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'user_id') THEN
            user_column := 'user_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'owner_id') THEN
            user_column := 'owner_id';
        ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = table_record.table_name AND column_name = 'created_by') THEN
            user_column := 'created_by';
        END IF;
        
        IF user_column IS NOT NULL THEN
            -- Construir e executar query dinamicamente
            query_text := format('SELECT COUNT(*) FROM public.%I WHERE %I = $1', table_record.table_name, user_column);
            EXECUTE query_text INTO result_count USING target_user_id;
            RAISE NOTICE 'Tabela %: % registros (coluna: %)', table_record.table_name, result_count, user_column;
        ELSE
            RAISE NOTICE 'Tabela %: nenhuma coluna de usuário encontrada', table_record.table_name;
        END IF;
    END LOOP;
END $$;

-- 5. VERIFICAR SE AS POLÍTICAS RLS ESTÃO FUNCIONANDO
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename IN (
    SELECT table_name 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND (table_name IN ('accounts', 'clients', 'expenses', 'transactions', 'organization_members', 'profiles')
         OR table_name LIKE 'transactions_2025_%')
)
ORDER BY tablename, policyname;
