-- =====================================================
-- VERIFICAÇÃO ESPECÍFICA DOS DADOS CLIENTS
-- =====================================================

-- 1. Verificar quantos clientes existem no total
SELECT '=== TOTAL DE CLIENTES ===' as info;
SELECT 
    COUNT(*) as total_clientes,
    COUNT(CASE WHEN is_active = true THEN 1 END) as clientes_ativos,
    COUNT(CASE WHEN is_active = false THEN 1 END) as clientes_inativos
FROM clients;

-- 2. Verificar clientes por usuário
SELECT '=== CLIENTES POR USUÁRIO ===' as info;
SELECT 
    user_id,
    COUNT(*) as total,
    COUNT(CASE WHEN is_active = true THEN 1 END) as ativos,
    COUNT(CASE WHEN is_active = false THEN 1 END) as inativos
FROM clients 
GROUP BY user_id
ORDER BY total DESC;

-- 3. Verificar clientes sem user_id
SELECT '=== CLIENTES SEM USER_ID ===' as info;
SELECT 
    id,
    name,
    email,
    stage,
    is_active,
    created_at
FROM clients 
WHERE user_id IS NULL
ORDER BY created_at DESC;

-- 4. Verificar clientes com user_id específico (usuário atual)
SELECT '=== CLIENTES DO USUÁRIO ATUAL ===' as info;
-- Substitua pelo seu user_id
SELECT 
    id,
    name,
    email,
    stage,
    is_active,
    created_at,
    updated_at
FROM clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'  -- Seu user_id
ORDER BY created_at DESC;

-- 5. Testar operação de delete em um cliente específico
SELECT '=== TESTE DE DELETE ===' as info;
-- Pegar um cliente ativo para teste
WITH cliente_teste AS (
    SELECT id, name, is_active 
    FROM clients 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
    AND is_active = true 
    LIMIT 1
)
UPDATE clients 
SET is_active = false, updated_at = NOW()
WHERE id = (SELECT id FROM cliente_teste)
RETURNING id, name, is_active, updated_at;

-- 6. Verificar se o delete funcionou
SELECT '=== VERIFICAÇÃO PÓS-DELETE ===' as info;
SELECT 
    id,
    name,
    is_active,
    updated_at
FROM clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY updated_at DESC
LIMIT 5;

-- 7. Reativar o cliente de teste
SELECT '=== REATIVANDO CLIENTE ===' as info;
UPDATE clients 
SET is_active = true, updated_at = NOW()
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
AND is_active = false
RETURNING id, name, is_active, updated_at;

SELECT '=== VERIFICAÇÃO FINAL ===' as info;
