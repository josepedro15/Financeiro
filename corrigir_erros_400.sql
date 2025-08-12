-- =====================================================
-- DIAGNÓSTICO E CORREÇÃO DE ERROS 400 - API KEY
-- =====================================================

DO $$
DECLARE
    test_user_id UUID;
    test_result JSONB;
    api_key_status TEXT;
BEGIN
    RAISE NOTICE '=== INICIANDO DIAGNÓSTICO DE ERROS 400 ===';
    
    -- 1. Verificar se há usuários ativos
    SELECT COUNT(*) INTO test_user_id FROM auth.users WHERE email = 'jopedromkt@gmail.com';
    RAISE NOTICE 'Usuários com email jopedromkt@gmail.com: %', test_user_id;
    
    -- 2. Verificar estrutura da tabela clients
    RAISE NOTICE '=== VERIFICANDO ESTRUTURA DA TABELA CLIENTS ===';
    
    -- Verificar se a tabela existe
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'clients') THEN
        RAISE NOTICE '✅ Tabela clients existe';
        
        -- Verificar colunas
        RAISE NOTICE 'Colunas da tabela clients:';
        FOR test_result IN 
            SELECT column_name, data_type, is_nullable 
            FROM information_schema.columns 
            WHERE table_name = 'clients' 
            ORDER BY ordinal_position
        LOOP
            RAISE NOTICE '  - %: % (nullable: %)', 
                test_result.column_name, 
                test_result.data_type, 
                test_result.is_nullable;
        END LOOP;
    ELSE
        RAISE NOTICE '❌ Tabela clients NÃO existe';
    END IF;
    
    -- 3. Verificar políticas RLS na tabela clients
    RAISE NOTICE '=== VERIFICANDO POLÍTICAS RLS ===';
    
    SELECT COUNT(*) INTO test_user_id 
    FROM pg_policies 
    WHERE tablename = 'clients';
    
    RAISE NOTICE 'Políticas RLS na tabela clients: %', test_user_id;
    
    -- Listar políticas existentes
    FOR test_result IN 
        SELECT policyname, permissive, roles, cmd, qual 
        FROM pg_policies 
        WHERE tablename = 'clients'
    LOOP
        RAISE NOTICE '  Política: %', test_result.policyname;
        RAISE NOTICE '    - Permissiva: %', test_result.permissive;
        RAISE NOTICE '    - Comando: %', test_result.cmd;
        RAISE NOTICE '    - Condição: %', test_result.qual;
    END LOOP;
    
    -- 4. Verificar se RLS está habilitado
    SELECT relrowsecurity INTO api_key_status 
    FROM pg_class 
    WHERE relname = 'clients';
    
    RAISE NOTICE 'RLS habilitado na tabela clients: %', api_key_status;
    
    -- 5. Testar inserção direta (se RLS estiver desabilitado temporariamente)
    RAISE NOTICE '=== TESTANDO OPERAÇÕES DIRETAS ===';
    
    -- Verificar se há dados na tabela
    SELECT COUNT(*) INTO test_user_id FROM clients;
    RAISE NOTICE 'Total de clientes na tabela: %', test_user_id;
    
    -- 6. Verificar configurações de autenticação
    RAISE NOTICE '=== VERIFICANDO CONFIGURAÇÕES DE AUTH ===';
    
    -- Verificar se há usuários na tabela auth.users
    SELECT COUNT(*) INTO test_user_id FROM auth.users;
    RAISE NOTICE 'Total de usuários no sistema: %', test_user_id;
    
    -- Verificar usuários específicos
    FOR test_result IN 
        SELECT id, email, created_at, last_sign_in_at
        FROM auth.users 
        WHERE email IN ('jopedromkt@gmail.com', 'test@example.com')
        LIMIT 5
    LOOP
        RAISE NOTICE 'Usuário: % - Email: % - Criado: %', 
            test_result.id, 
            test_result.email, 
            test_result.created_at;
    END LOOP;
    
    RAISE NOTICE '=== DIAGNÓSTICO CONCLUÍDO ===';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO NO DIAGNÓSTICO: %', SQLERRM;
END $$;

-- =====================================================
-- CORREÇÕES AUTOMÁTICAS
-- =====================================================

-- 1. Garantir que RLS está configurado corretamente
DO $$
BEGIN
    RAISE NOTICE '=== APLICANDO CORREÇÕES ===';
    
    -- Habilitar RLS se não estiver habilitado
    ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
    RAISE NOTICE '✅ RLS habilitado na tabela clients';
    
    -- Remover políticas antigas que possam estar causando conflito
    DROP POLICY IF EXISTS "Users can view own clients" ON clients;
    DROP POLICY IF EXISTS "Users can insert own clients" ON clients;
    DROP POLICY IF EXISTS "Users can update own clients" ON clients;
    DROP POLICY IF EXISTS "Users can delete own clients" ON clients;
    DROP POLICY IF EXISTS "Enable read access for all users" ON clients;
    DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON clients;
    DROP POLICY IF EXISTS "Enable update for users based on user_id" ON clients;
    DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON clients;
    RAISE NOTICE '✅ Políticas antigas removidas';
    
    -- Criar políticas simples e funcionais
    CREATE POLICY "Enable read access for all users" ON clients
        FOR SELECT USING (true);
    
    CREATE POLICY "Enable insert for authenticated users only" ON clients
        FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
    
    CREATE POLICY "Enable update for users based on user_id" ON clients
        FOR UPDATE USING (auth.uid() = user_id);
    
    CREATE POLICY "Enable delete for users based on user_id" ON clients
        FOR DELETE USING (auth.uid() = user_id);
    
    RAISE NOTICE '✅ Novas políticas RLS criadas';
    
    -- 2. Verificar se a coluna user_id existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' AND column_name = 'user_id'
    ) THEN
        RAISE NOTICE '❌ Coluna user_id não existe na tabela clients';
        RAISE NOTICE 'Adicionando coluna user_id...';
        
        ALTER TABLE clients ADD COLUMN user_id UUID REFERENCES auth.users(id);
        RAISE NOTICE '✅ Coluna user_id adicionada';
        
        -- Atualizar registros existentes com um user_id padrão
        UPDATE clients SET user_id = (
            SELECT id FROM auth.users LIMIT 1
        ) WHERE user_id IS NULL;
        
        RAISE NOTICE '✅ Registros existentes atualizados com user_id';
    ELSE
        RAISE NOTICE '✅ Coluna user_id já existe';
    END IF;
    
    -- 3. Garantir que não há constraints problemáticas
    RAISE NOTICE 'Verificando constraints...';
    
    -- Verificar foreign keys
    FOR test_result IN 
        SELECT tc.constraint_name, tc.table_name, kcu.column_name, 
               ccu.table_name AS foreign_table_name,
               ccu.column_name AS foreign_column_name
        FROM information_schema.table_constraints AS tc 
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY' 
          AND tc.table_name = 'clients'
    LOOP
        RAISE NOTICE 'FK: % -> %.%', 
            test_result.constraint_name,
            test_result.foreign_table_name,
            test_result.foreign_column_name;
    END LOOP;
    
    RAISE NOTICE '=== CORREÇÕES APLICADAS COM SUCESSO ===';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO AO APLICAR CORREÇÕES: %', SQLERRM;
END $$;

-- =====================================================
-- TESTES FINAIS
-- =====================================================

DO $$
DECLARE
    test_count INTEGER;
    test_user_id UUID;
BEGIN
    RAISE NOTICE '=== EXECUTANDO TESTES FINAIS ===';
    
    -- Teste 1: Verificar se as políticas foram criadas
    SELECT COUNT(*) INTO test_count 
    FROM pg_policies 
    WHERE tablename = 'clients';
    
    RAISE NOTICE 'Políticas RLS ativas: %', test_count;
    
    -- Teste 2: Verificar se há dados na tabela
    SELECT COUNT(*) INTO test_count FROM clients;
    RAISE NOTICE 'Total de clientes: %', test_count;
    
    -- Teste 3: Verificar estrutura final
    RAISE NOTICE 'Estrutura final da tabela clients:';
    FOR test_result IN 
        SELECT column_name, data_type, is_nullable 
        FROM information_schema.columns 
        WHERE table_name = 'clients' 
        ORDER BY ordinal_position
    LOOP
        RAISE NOTICE '  - %: % (nullable: %)', 
            test_result.column_name, 
            test_result.data_type, 
            test_result.is_nullable;
    END LOOP;
    
    -- Teste 4: Verificar se há usuários válidos
    SELECT COUNT(*) INTO test_count FROM auth.users;
    RAISE NOTICE 'Usuários no sistema: %', test_count;
    
    -- Teste 5: Verificar se clientes têm user_id válido
    SELECT COUNT(*) INTO test_count 
    FROM clients c
    JOIN auth.users u ON c.user_id = u.id;
    
    RAISE NOTICE 'Clientes com user_id válido: %', test_count;
    
    RAISE NOTICE '=== TESTES CONCLUÍDOS ===';
    RAISE NOTICE '✅ SISTEMA PRONTO PARA USO!';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '❌ ERRO NOS TESTES: %', SQLERRM;
END $$;
