-- =====================================================
-- TESTE SIMPLES - VERIFICAR SE OPERAÇÕES FUNCIONAM
-- =====================================================

-- 1. Verificar se conseguimos fazer SELECT
SELECT '=== TESTE SELECT ===' as info;
SELECT COUNT(*) as total_clientes FROM clients;

-- 2. Verificar se conseguimos fazer UPDATE
SELECT '=== TESTE UPDATE ===' as info;
UPDATE clients 
SET updated_at = NOW() 
WHERE id = (SELECT id FROM clients LIMIT 1)
RETURNING id, name, updated_at;

-- 3. Verificar se conseguimos fazer DELETE (soft delete)
SELECT '=== TESTE DELETE (SOFT) ===' as info;
UPDATE clients 
SET is_active = false 
WHERE id = (SELECT id FROM clients WHERE is_active = true LIMIT 1)
RETURNING id, name, is_active;

-- 4. Reativar o cliente que foi desativado
SELECT '=== REATIVANDO CLIENTE ===' as info;
UPDATE clients 
SET is_active = true 
WHERE is_active = false
RETURNING id, name, is_active;

-- 5. Verificar políticas atuais
SELECT '=== POLÍTICAS ATUAIS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 6. Verificar se RLS está habilitado
SELECT '=== STATUS RLS ===' as info;
SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

-- 7. Teste final - verificar se tudo está funcionando
SELECT '=== TESTE FINAL ===' as info;
SELECT 
    COUNT(*) as total_clientes,
    COUNT(CASE WHEN is_active = true THEN 1 END) as ativos,
    COUNT(CASE WHEN is_active = false THEN 1 END) as inativos
FROM clients;

SELECT '=== TESTE CONCLUÍDO ===' as info;
SELECT 'Se chegou até aqui, as operações básicas funcionam!' as status;
