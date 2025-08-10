-- Corrigir problema de delete de clientes
-- O erro "value too long for type character varying(20)" indica problema na coluna stage

-- 1. Verificar se a coluna stage existe e seu tipo atual
SELECT '=== VERIFICAÇÃO INICIAL ===' as info;
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 2. Alterar a coluna stage para permitir mais caracteres (se necessário)
DO $$
BEGIN
    -- Verificar se a coluna stage tem limite de 20 caracteres
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND column_name = 'stage'
        AND character_maximum_length = 20
    ) THEN
        -- Alterar para VARCHAR(100)
        ALTER TABLE public.clients ALTER COLUMN stage TYPE VARCHAR(100);
        RAISE NOTICE 'Coluna stage alterada de VARCHAR(20) para VARCHAR(100)';
    ELSE
        RAISE NOTICE 'Coluna stage já tem tamanho adequado ou não existe';
    END IF;
END $$;

-- 3. Verificar se há triggers na tabela clients
SELECT '=== TRIGGERS NA TABELA CLIENTS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers
WHERE event_object_table = 'clients'
AND event_object_schema = 'public';

-- 4. Verificar constraints na tabela clients
SELECT '=== CONSTRAINTS NA TABELA CLIENTS ===' as info;
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

-- 5. Verificar se há valores problemáticos na coluna stage
SELECT '=== VALORES NA COLUNA STAGE ===' as info;
SELECT DISTINCT stage, COUNT(*) as quantidade, LENGTH(stage) as tamanho
FROM public.clients
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY quantidade DESC;

-- 6. Verificar se há valores com mais de 20 caracteres
SELECT '=== VALORES PROBLEMÁTICOS ===' as info;
SELECT id, name, stage, LENGTH(stage) as tamanho
FROM public.clients
WHERE stage IS NOT NULL
AND LENGTH(stage) > 20
ORDER BY LENGTH(stage) DESC;

-- 7. Testar um update simples para verificar se o problema persiste
SELECT '=== TESTE DE UPDATE ===' as info;
-- Vamos tentar fazer um update simples para ver se o erro persiste
UPDATE public.clients 
SET updated_at = NOW()
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE is_active = true 
    LIMIT 1
);

SELECT 'Update de teste executado com sucesso' as resultado;
