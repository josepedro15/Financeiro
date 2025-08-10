-- Verificar e corrigir problema de delete de clientes
-- O erro "value too long for type character varying(20)" indica problema na coluna stage

-- 1. Verificar estrutura atual da tabela clients
SELECT '=== ESTRUTURA DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, character_maximum_length, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar se a coluna stage existe e seu tipo
SELECT '=== VERIFICAÇÃO DA COLUNA STAGE ===' as info;
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 3. Verificar se há constraint na coluna stage
SELECT '=== CONSTRAINTS DA COLUNA STAGE ===' as info;
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
AND tc.table_schema = 'public'
AND kcu.column_name = 'stage';

-- 4. Verificar dados atuais na tabela clients
SELECT '=== DADOS ATUAIS ===' as info;
SELECT id, name, stage, is_active, created_at
FROM public.clients
ORDER BY created_at DESC
LIMIT 10;

-- 5. Verificar valores únicos da coluna stage
SELECT '=== VALORES ÚNICOS DA COLUNA STAGE ===' as info;
SELECT DISTINCT stage, COUNT(*) as quantidade, LENGTH(stage) as tamanho
FROM public.clients
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY quantidade DESC;

-- 6. Verificar se há valores com mais de 20 caracteres
SELECT '=== VALORES COM MAIS DE 20 CARACTERES ===' as info;
SELECT id, name, stage, LENGTH(stage) as tamanho
FROM public.clients
WHERE stage IS NOT NULL
AND LENGTH(stage) > 20
ORDER BY LENGTH(stage) DESC;
