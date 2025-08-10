-- Corrigir erro global de delete de clientes
-- O erro "value too long for type character varying(20)" está acontecendo para todos os usuários

-- 1. Verificar e corrigir a estrutura da tabela clients
DO $$
BEGIN
    -- Verificar se a coluna stage existe e tem o tamanho correto
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND column_name = 'stage'
        AND character_maximum_length <= 20
    ) THEN
        -- Alterar para VARCHAR(100)
        ALTER TABLE public.clients ALTER COLUMN stage TYPE VARCHAR(100);
        RAISE NOTICE 'Coluna stage alterada para VARCHAR(100)';
    ELSE
        RAISE NOTICE 'Coluna stage já tem tamanho adequado';
    END IF;
    
    -- Verificar se a coluna notes existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND column_name = 'notes'
    ) THEN
        -- Adicionar coluna notes se não existir
        ALTER TABLE public.clients ADD COLUMN notes TEXT;
        RAISE NOTICE 'Coluna notes adicionada';
    ELSE
        RAISE NOTICE 'Coluna notes já existe';
    END IF;
END $$;

-- 2. Verificar e corrigir constraints problemáticas
DO $$
BEGIN
    -- Remover constraint problemática se existir
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_name = 'clients'
        AND table_schema = 'public'
        AND constraint_name = 'clients_stage_check'
    ) THEN
        ALTER TABLE public.clients DROP CONSTRAINT clients_stage_check;
        RAISE NOTICE 'Constraint clients_stage_check removida';
    END IF;
    
    -- Criar nova constraint mais flexível
    ALTER TABLE public.clients ADD CONSTRAINT clients_stage_check 
    CHECK (stage IS NOT NULL AND length(stage) > 0 AND length(stage) <= 100);
    RAISE NOTICE 'Nova constraint clients_stage_check criada';
END $$;

-- 3. Verificar e corrigir triggers problemáticos
DO $$
BEGIN
    -- Remover triggers que podem estar causando problemas
    IF EXISTS (
        SELECT 1 FROM information_schema.triggers
        WHERE event_object_table = 'clients'
        AND event_object_schema = 'public'
        AND trigger_name LIKE '%updated_at%'
    ) THEN
        DROP TRIGGER IF EXISTS set_updated_at ON public.clients;
        RAISE NOTICE 'Trigger set_updated_at removido';
    END IF;
    
    -- Criar trigger simples para updated_at
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
    END;
    $$ language 'plpgsql';
    
    CREATE TRIGGER set_updated_at
        BEFORE UPDATE ON public.clients
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    RAISE NOTICE 'Trigger set_updated_at recriado';
END $$;

-- 4. Verificar e corrigir dados problemáticos
DO $$
BEGIN
    -- Corrigir valores vazios ou nulos na coluna stage
    UPDATE public.clients 
    SET stage = 'lead'
    WHERE stage IS NULL OR stage = '';
    
    -- Verificar se houve correções
    IF FOUND THEN
        RAISE NOTICE 'Valores vazios/nulos na coluna stage corrigidos';
    ELSE
        RAISE NOTICE 'Nenhum valor vazio/nulo encontrado na coluna stage';
    END IF;
    
    -- Truncar valores muito longos na coluna stage
    UPDATE public.clients 
    SET stage = LEFT(stage, 100)
    WHERE LENGTH(stage) > 100;
    
    IF FOUND THEN
        RAISE NOTICE 'Valores muito longos na coluna stage truncados';
    ELSE
        RAISE NOTICE 'Nenhum valor muito longo encontrado na coluna stage';
    END IF;
END $$;

-- 5. Verificar se há problemas com RLS
DO $$
BEGIN
    -- Verificar se RLS está ativo
    IF EXISTS (
        SELECT 1 FROM pg_tables
        WHERE tablename = 'clients'
        AND schemaname = 'public'
        AND rowsecurity = true
    ) THEN
        RAISE NOTICE 'RLS está ativo na tabela clients';
        
        -- Verificar se há políticas RLS
        IF EXISTS (
            SELECT 1 FROM pg_policies
            WHERE tablename = 'clients'
            AND schemaname = 'public'
        ) THEN
            RAISE NOTICE 'Políticas RLS encontradas';
        ELSE
            RAISE NOTICE 'Nenhuma política RLS encontrada';
        END IF;
    ELSE
        RAISE NOTICE 'RLS não está ativo na tabela clients';
    END IF;
END $$;

-- 6. Verificar estrutura final
SELECT '=== ESTRUTURA FINAL DA TABELA CLIENTS ===' as info;
SELECT 
    column_name, 
    data_type, 
    character_maximum_length, 
    is_nullable, 
    column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 7. Verificar constraints finais
SELECT '=== CONSTRAINTS FINAIS ===' as info;
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

-- 8. Teste final de update
SELECT '=== TESTE FINAL DE UPDATE ===' as info;
UPDATE public.clients 
SET updated_at = NOW()
WHERE id IN (
    SELECT id FROM public.clients 
    WHERE is_active = true 
    LIMIT 1
);

SELECT 'Migração concluída com sucesso!' as resultado;
