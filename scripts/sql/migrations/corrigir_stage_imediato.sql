-- Correção imediata da coluna stage
-- Este script resolve o erro "value too long for type character varying(20)"

-- 1. Verificar o tamanho atual da coluna stage
SELECT '=== TAMANHO ATUAL DA COLUNA STAGE ===' as info;
SELECT 
    column_name, 
    data_type, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 2. Alterar a coluna stage para VARCHAR(100) se necessário
DO $$
BEGIN
    -- Verificar se a coluna stage tem limite de 20 caracteres ou menos
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND column_name = 'stage'
        AND character_maximum_length <= 20
    ) THEN
        -- Alterar para VARCHAR(100)
        ALTER TABLE public.clients ALTER COLUMN stage TYPE VARCHAR(100);
        RAISE NOTICE 'Coluna stage alterada de VARCHAR(20) para VARCHAR(100)';
    ELSE
        RAISE NOTICE 'Coluna stage já tem tamanho adequado (mais de 20 caracteres)';
    END IF;
END $$;

-- 3. Verificar se a alteração foi aplicada
SELECT '=== TAMANHO APÓS ALTERAÇÃO ===' as info;
SELECT 
    column_name, 
    data_type, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 4. Testar um update simples
SELECT '=== TESTE DE UPDATE ===' as info;
UPDATE public.clients 
SET updated_at = NOW()
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE stage = 'lead'
    LIMIT 1
);

SELECT 'Update de teste executado com sucesso!' as resultado;

-- 5. Verificar se há constraints problemáticas
SELECT '=== CONSTRAINTS DA COLUNA STAGE ===' as info;
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

-- 6. Se houver constraint problemática, removê-la
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND constraint_name = 'clients_stage_check'
        AND constraint_type = 'CHECK'
    ) THEN
        ALTER TABLE public.clients DROP CONSTRAINT clients_stage_check;
        RAISE NOTICE 'Constraint clients_stage_check removida';
    ELSE
        RAISE NOTICE 'Nenhuma constraint problemática encontrada';
    END IF;
END $$;

-- 7. Criar nova constraint mais flexível
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND constraint_name = 'clients_stage_check'
    ) THEN
        ALTER TABLE public.clients ADD CONSTRAINT clients_stage_check 
        CHECK (stage IS NOT NULL AND length(stage) > 0 AND length(stage) <= 100);
        RAISE NOTICE 'Nova constraint clients_stage_check criada';
    ELSE
        RAISE NOTICE 'Constraint clients_stage_check já existe';
    END IF;
END $$;

SELECT 'Correção concluída com sucesso!' as resultado;
