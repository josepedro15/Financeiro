-- =====================================================
-- TESTE DA TABELA CLIENTS
-- =====================================================

-- 1. Verificar estrutura da tabela clients
SELECT '=== ESTRUTURA DA TABELA CLIENTS ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'clients' 
ORDER BY ordinal_position;

-- 2. Verificar dados atuais
SELECT '=== DADOS ATUAIS ===' as info;
SELECT 
    id,
    name,
    email,
    stage,
    is_active,
    user_id,
    created_at,
    updated_at
FROM clients 
ORDER BY created_at DESC
LIMIT 10;

-- 3. Verificar se há clientes com user_id nulo
SELECT '=== CLIENTES SEM USER_ID ===' as info;
SELECT COUNT(*) as clientes_sem_user_id
FROM clients 
WHERE user_id IS NULL;

-- 4. Verificar usuários disponíveis
SELECT '=== USUÁRIOS DISPONÍVEIS ===' as info;
SELECT 
    id,
    email,
    created_at
FROM auth.users 
ORDER BY created_at DESC
LIMIT 5;

-- 5. Verificar se clientes têm user_id válido
SELECT '=== CLIENTES COM USER_ID VÁLIDO ===' as info;
SELECT 
    c.id,
    c.name,
    c.user_id,
    u.email as user_email
FROM clients c
LEFT JOIN auth.users u ON c.user_id = u.id
ORDER BY c.created_at DESC
LIMIT 10;

-- 6. Testar operações básicas
SELECT '=== TESTANDO OPERAÇÕES ===' as info;

-- Testar UPDATE
UPDATE clients 
SET updated_at = NOW() 
WHERE id = (SELECT id FROM clients LIMIT 1)
RETURNING id, name, updated_at;

-- Testar soft delete
UPDATE clients 
SET is_active = false 
WHERE id = (SELECT id FROM clients WHERE is_active = true LIMIT 1)
RETURNING id, name, is_active;

-- Reativar o cliente
UPDATE clients 
SET is_active = true 
WHERE is_active = false
RETURNING id, name, is_active;

-- 7. Verificar políticas RLS
SELECT '=== POLÍTICAS RLS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 8. Verificar status RLS
SELECT '=== STATUS RLS ===' as info;
SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

SELECT '=== TESTE CONCLUÍDO ===' as info;
