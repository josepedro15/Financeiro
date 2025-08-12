-- =====================================================
-- DESABILITAR RLS TEMPORARIAMENTE PARA TESTES
-- =====================================================

-- ATENÇÃO: Este script desabilita RLS temporariamente
-- Execute apenas para testes e reabilite depois

SELECT '=== DESABILITANDO RLS TEMPORARIAMENTE ===' as info;

-- 1. Desabilitar RLS na tabela clients
ALTER TABLE clients DISABLE ROW LEVEL SECURITY;

-- 2. Verificar se foi desabilitado
SELECT '=== VERIFICANDO STATUS RLS ===' as info;
SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

-- 3. Remover todas as políticas
SELECT '=== REMOVENDO POLÍTICAS ===' as info;
DROP POLICY IF EXISTS "Users can view own clients" ON clients;
DROP POLICY IF EXISTS "Users can insert own clients" ON clients;
DROP POLICY IF EXISTS "Users can update own clients" ON clients;
DROP POLICY IF EXISTS "Users can delete own clients" ON clients;
DROP POLICY IF EXISTS "Enable read access for all users" ON clients;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON clients;
DROP POLICY IF EXISTS "Enable update for users based on user_id" ON clients;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON clients;
DROP POLICY IF EXISTS "Enable read access for all users" ON clients;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON clients;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON clients;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON clients;

-- 4. Verificar se não há mais políticas
SELECT '=== VERIFICANDO POLÍTICAS REMOVIDAS ===' as info;
SELECT COUNT(*) as total_politicas
FROM pg_policies 
WHERE tablename = 'clients';

-- 5. Testar operações básicas
SELECT '=== TESTANDO OPERAÇÕES ===' as info;

-- Testar SELECT
SELECT COUNT(*) as total_clientes FROM clients;

-- Testar UPDATE
UPDATE clients 
SET updated_at = NOW() 
WHERE id = (SELECT id FROM clients LIMIT 1)
RETURNING id, name, updated_at;

-- Testar DELETE (soft)
UPDATE clients 
SET is_active = false 
WHERE id = (SELECT id FROM clients WHERE is_active = true LIMIT 1)
RETURNING id, name, is_active;

-- Reativar o cliente
UPDATE clients 
SET is_active = true 
WHERE is_active = false
RETURNING id, name, is_active;

SELECT '=== RLS DESABILITADO TEMPORARIAMENTE ===' as info;
SELECT 'AGORA TESTE OS BOTÕES DE EDITAR E DELETAR!' as status;
SELECT 'LEMBRE-SE DE REABILITAR RLS DEPOIS DOS TESTES!' as aviso;
