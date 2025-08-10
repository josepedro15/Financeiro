-- Investigar erro global de delete de clientes
-- O erro "value too long for type character varying(20)" está acontecendo para todos os usuários

-- 1. Verificar estrutura completa da tabela clients
SELECT '=== ESTRUTURA COMPLETA DA TABELA CLIENTS ===' as info;
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable, 
    column_default,
    ordinal_position
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar se há triggers que podem estar causando o problema
SELECT '=== TRIGGERS NA TABELA CLIENTS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'clients'
AND event_object_schema = 'public';

-- 3. Verificar todas as constraints da tabela
SELECT '=== CONSTRAINTS DA TABELA CLIENTS ===' as info;
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.check_constraints cc 
    ON tc.constraint_name = cc.constraint_name
WHERE tc.table_name = 'clients'
AND tc.table_schema = 'public';

-- 4. Verificar se há RLS (Row Level Security) ativo
SELECT '=== ROW LEVEL SECURITY ===' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables
WHERE tablename = 'clients'
AND schemaname = 'public';

-- 5. Verificar políticas RLS
SELECT '=== POLÍTICAS RLS ===' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'clients'
AND schemaname = 'public';

-- 6. Verificar dados de exemplo para todos os usuários
SELECT '=== DADOS DE EXEMPLO POR USUÁRIO ===' as info;
SELECT 
    user_id,
    COUNT(*) as total_clientes,
    COUNT(CASE WHEN is_active = true THEN 1 END) as ativos,
    COUNT(CASE WHEN is_active = false THEN 1 END) as inativos,
    MIN(created_at) as primeiro_cliente,
    MAX(created_at) as ultimo_cliente
FROM public.clients
GROUP BY user_id
ORDER BY total_clientes DESC;

-- 7. Verificar valores únicos da coluna stage
SELECT '=== VALORES ÚNICOS DA COLUNA STAGE ===' as info;
SELECT 
    stage, 
    COUNT(*) as quantidade, 
    LENGTH(stage) as tamanho,
    MIN(created_at) as primeiro_uso,
    MAX(created_at) as ultimo_uso
FROM public.clients
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY quantidade DESC;

-- 8. Verificar se há valores problemáticos
SELECT '=== VALORES PROBLEMÁTICOS ===' as info;
SELECT 
    id,
    user_id,
    name,
    stage,
    LENGTH(stage) as tamanho_stage,
    is_active,
    created_at
FROM public.clients
WHERE stage IS NOT NULL
AND (LENGTH(stage) > 20 OR stage = '' OR stage IS NULL)
ORDER BY LENGTH(stage) DESC;

-- 9. Testar um update simples para ver se o problema é específico do delete
SELECT '=== TESTE DE UPDATE SIMPLES ===' as info;
-- Vamos tentar fazer um update simples em um cliente ativo
UPDATE public.clients 
SET updated_at = NOW()
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE is_active = true 
    LIMIT 1
);

SELECT 'Update de teste executado com sucesso' as resultado;

-- 10. Verificar se há algum problema com a coluna updated_at
SELECT '=== VERIFICAÇÃO DA COLUNA UPDATED_AT ===' as info;
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'updated_at';
