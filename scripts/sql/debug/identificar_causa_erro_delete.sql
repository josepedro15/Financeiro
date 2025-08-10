-- Identificar causa específica do erro de delete de clientes
-- Baseado nos dados: lead (6), client (1), negocia (1)

-- 1. Verificar se há algum trigger que está modificando dados durante UPDATE
SELECT '=== TRIGGERS QUE PODEM CAUSAR PROBLEMAS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'clients'
AND event_object_schema = 'public'
AND event_manipulation = 'UPDATE';

-- 2. Verificar se há alguma função que está sendo chamada
SELECT '=== FUNÇÕES RELACIONADAS ===' as info;
SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE '%client%'
OR routine_name LIKE '%stage%'
OR routine_name LIKE '%update%';

-- 3. Verificar se há algum problema com a coluna updated_at
SELECT '=== VERIFICAÇÃO DA COLUNA UPDATED_AT ===' as info;
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'updated_at';

-- 4. Verificar se há algum problema com RLS durante UPDATE
SELECT '=== POLÍTICAS RLS PARA UPDATE ===' as info;
SELECT 
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE tablename = 'clients'
AND schemaname = 'public'
AND cmd = 'UPDATE';

-- 5. Testar um UPDATE simples para ver se o problema é específico
SELECT '=== TESTE DE UPDATE SIMPLES ===' as info;
-- Vamos tentar fazer um update simples sem modificar a coluna stage
UPDATE public.clients 
SET updated_at = NOW()
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE stage = 'lead'
    LIMIT 1
);

SELECT 'Update simples executado com sucesso' as resultado;

-- 6. Verificar se há algum problema com a coluna stage especificamente
SELECT '=== TESTE DE UPDATE DA COLUNA STAGE ===' as info;
-- Vamos tentar fazer um update apenas da coluna stage
UPDATE public.clients 
SET stage = 'lead'
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE stage = 'lead'
    LIMIT 1
);

SELECT 'Update da coluna stage executado com sucesso' as resultado;

-- 7. Verificar se há algum problema com valores específicos
SELECT '=== TESTE COM VALOR ESPECÍFICO ===' as info;
-- Vamos tentar fazer um update com o valor 'negocia' que tem 7 caracteres
UPDATE public.clients 
SET stage = 'negocia'
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE stage = 'client'
    LIMIT 1
);

SELECT 'Update com valor específico executado com sucesso' as resultado;

-- 8. Verificar se há algum problema com o trigger de updated_at
SELECT '=== VERIFICAÇÃO DO TRIGGER UPDATED_AT ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'clients'
AND event_object_schema = 'public'
AND trigger_name LIKE '%updated_at%';

-- 9. Verificar se há algum problema com a função do trigger
SELECT '=== VERIFICAÇÃO DA FUNÇÃO DO TRIGGER ===' as info;
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE '%updated_at%';

-- 10. Verificar se há algum problema com a constraint da coluna stage
SELECT '=== VERIFICAÇÃO DA CONSTRAINT STAGE ===' as info;
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc 
    ON tc.constraint_name = cc.constraint_name
WHERE tc.table_name = 'clients'
AND tc.table_schema = 'public'
AND tc.constraint_name LIKE '%stage%';
