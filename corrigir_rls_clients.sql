-- =====================================================
-- CORREÇÃO DAS POLÍTICAS RLS DA TABELA CLIENTS
-- =====================================================

-- 1. Verificar políticas atuais
SELECT '=== POLÍTICAS ATUAIS ===' as info;
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 2. Remover todas as políticas existentes
SELECT '=== REMOVENDO POLÍTICAS ANTIGAS ===' as info;

DROP POLICY IF EXISTS "Enable delete for authenticated users" ON clients;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON clients;
DROP POLICY IF EXISTS "Enable read access for all users" ON clients;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON clients;
DROP POLICY IF EXISTS "Full access to clients" ON clients;
DROP POLICY IF EXISTS "Global access to clients" ON clients;

-- 3. Verificar se todas foram removidas
SELECT '=== POLÍTICAS APÓS REMOÇÃO ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 4. Criar políticas simples e claras
SELECT '=== CRIANDO NOVAS POLÍTICAS ===' as info;

-- Política para SELECT (leitura)
CREATE POLICY "clients_select_policy" ON clients
    FOR SELECT
    USING (true);  -- Todos podem ler

-- Política para INSERT (inserção)
CREATE POLICY "clients_insert_policy" ON clients
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);  -- Apenas o próprio usuário

-- Política para UPDATE (atualização)
CREATE POLICY "clients_update_policy" ON clients
    FOR UPDATE
    USING (auth.uid() = user_id)  -- Apenas o próprio usuário
    WITH CHECK (auth.uid() = user_id);

-- Política para DELETE (exclusão)
CREATE POLICY "clients_delete_policy" ON clients
    FOR DELETE
    USING (auth.uid() = user_id);  -- Apenas o próprio usuário

-- 5. Verificar novas políticas
SELECT '=== NOVAS POLÍTICAS CRIADAS ===' as info;
SELECT 
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 6. Testar operações básicas
SELECT '=== TESTANDO OPERAÇÕES ===' as info;

-- Testar SELECT
SELECT COUNT(*) as total_clientes FROM clients;

-- Testar UPDATE (vai falhar se não estiver autenticado, mas não deve dar erro de RLS)
-- UPDATE clients SET updated_at = NOW() WHERE id = (SELECT id FROM clients LIMIT 1);

SELECT '=== CORREÇÃO CONCLUÍDA ===' as info;
