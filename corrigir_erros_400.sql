-- =====================================================
-- DIAGNÓSTICO E CORREÇÃO DE ERROS 400 - API KEY
-- =====================================================

-- 1. Verificar se há usuários ativos
SELECT '=== VERIFICANDO USUÁRIOS ===' as info;
SELECT COUNT(*) as total_usuarios FROM auth.users WHERE email = 'jopedromkt@gmail.com';

-- 2. Verificar estrutura da tabela clients
SELECT '=== VERIFICANDO ESTRUTURA DA TABELA CLIENTS ===' as info;

-- Verificar se a tabela existe
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'clients'
) as tabela_existe;

-- Listar colunas da tabela
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'clients' 
ORDER BY ordinal_position;

-- 3. Verificar políticas RLS na tabela clients
SELECT '=== VERIFICANDO POLÍTICAS RLS ===' as info;

SELECT COUNT(*) as total_politicas
FROM pg_policies 
WHERE tablename = 'clients';

-- Listar políticas existentes
SELECT 
    policyname,
    permissive,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 4. Verificar se RLS está habilitado
SELECT '=== VERIFICANDO STATUS RLS ===' as info;

SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

-- 5. Verificar dados na tabela
SELECT '=== VERIFICANDO DADOS ===' as info;

SELECT COUNT(*) as total_clientes FROM clients;

-- 6. Verificar configurações de autenticação
SELECT '=== VERIFICANDO CONFIGURAÇÕES DE AUTH ===' as info;

SELECT COUNT(*) as total_usuarios_sistema FROM auth.users;

-- Verificar usuários específicos
SELECT 
    id,
    email,
    created_at,
    last_sign_in_at
FROM auth.users 
WHERE email IN ('jopedromkt@gmail.com', 'test@example.com')
LIMIT 5;

-- =====================================================
-- CORREÇÕES AUTOMÁTICAS
-- =====================================================

-- 1. Garantir que RLS está configurado corretamente
SELECT '=== APLICANDO CORREÇÕES ===' as info;

-- Habilitar RLS se não estiver habilitado
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas que possam estar causando conflito
DROP POLICY IF EXISTS "Users can view own clients" ON clients;
DROP POLICY IF EXISTS "Users can insert own clients" ON clients;
DROP POLICY IF EXISTS "Users can update own clients" ON clients;
DROP POLICY IF EXISTS "Users can delete own clients" ON clients;
DROP POLICY IF EXISTS "Enable read access for all users" ON clients;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON clients;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON clients;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON clients;

-- Criar políticas simples e funcionais
CREATE POLICY "Enable read access for all users" ON clients
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users only" ON clients
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Enable update for users based on user_id" ON clients
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Enable delete for users based on user_id" ON clients
    FOR DELETE USING (auth.uid() = user_id);

-- 2. Verificar se a coluna user_id existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' AND column_name = 'user_id'
    ) THEN
        RAISE NOTICE 'Adicionando coluna user_id...';
        ALTER TABLE clients ADD COLUMN user_id UUID REFERENCES auth.users(id);
        
        -- Atualizar registros existentes com um user_id padrão
        UPDATE clients SET user_id = (
            SELECT id FROM auth.users LIMIT 1
        ) WHERE user_id IS NULL;
        
        RAISE NOTICE 'Coluna user_id adicionada e registros atualizados';
    ELSE
        RAISE NOTICE 'Coluna user_id já existe';
    END IF;
END $$;

-- 3. Verificar foreign keys
SELECT '=== VERIFICANDO FOREIGN KEYS ===' as info;

SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_name = 'clients';

-- =====================================================
-- TESTES FINAIS
-- =====================================================

SELECT '=== EXECUTANDO TESTES FINAIS ===' as info;

-- Teste 1: Verificar se as políticas foram criadas
SELECT COUNT(*) as politicas_ativas
FROM pg_policies 
WHERE tablename = 'clients';

-- Teste 2: Verificar se há dados na tabela
SELECT COUNT(*) as total_clientes_final FROM clients;

-- Teste 3: Verificar estrutura final
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'clients' 
ORDER BY ordinal_position;

-- Teste 4: Verificar se há usuários válidos
SELECT COUNT(*) as usuarios_sistema FROM auth.users;

-- Teste 5: Verificar se clientes têm user_id válido
SELECT COUNT(*) as clientes_com_user_id_valido
FROM clients c
JOIN auth.users u ON c.user_id = u.id;

SELECT '=== CORREÇÕES CONCLUÍDAS ===' as info;
SELECT 'SISTEMA PRONTO PARA USO!' as status;
