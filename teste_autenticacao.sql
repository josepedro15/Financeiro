-- =====================================================
-- TESTE SIMPLES DE AUTENTICAÇÃO E PERMISSÕES
-- =====================================================

-- 1. Verificar se a tabela clients existe
SELECT '=== TESTE 1: VERIFICAR TABELA ===' as info;
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'clients'
) as tabela_existe;

-- 2. Verificar se há dados na tabela
SELECT '=== TESTE 2: VERIFICAR DADOS ===' as info;
SELECT COUNT(*) as total_clientes FROM clients;

-- 3. Verificar estrutura da tabela
SELECT '=== TESTE 3: ESTRUTURA ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'clients' 
ORDER BY ordinal_position;

-- 4. Verificar políticas RLS
SELECT '=== TESTE 4: POLÍTICAS RLS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

-- 5. Verificar se RLS está habilitado
SELECT '=== TESTE 5: STATUS RLS ===' as info;
SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

-- 6. Testar SELECT básico
SELECT '=== TESTE 6: SELECT BÁSICO ===' as info;
SELECT 
    id,
    name,
    stage,
    is_active
FROM clients 
LIMIT 5;

-- 7. Verificar usuários
SELECT '=== TESTE 7: USUÁRIOS ===' as info;
SELECT COUNT(*) as total_usuarios FROM auth.users;

-- 8. Verificar se clientes têm user_id
SELECT '=== TESTE 8: USER_ID ===' as info;
SELECT 
    COUNT(*) as total_clientes,
    COUNT(user_id) as com_user_id,
    COUNT(*) - COUNT(user_id) as sem_user_id
FROM clients;

SELECT '=== TESTE CONCLUÍDO ===' as info;
