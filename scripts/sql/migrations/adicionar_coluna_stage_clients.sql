-- Script para adicionar a coluna stage na tabela clients
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se a coluna stage já existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' 
        AND column_name = 'stage'
        AND table_schema = 'public'
    ) THEN
        -- Adicionar coluna stage
        ALTER TABLE public.clients 
        ADD COLUMN stage VARCHAR(100) DEFAULT 'lead';
        
        RAISE NOTICE 'Coluna stage adicionada com sucesso';
    ELSE
        RAISE NOTICE 'Coluna stage já existe';
    END IF;
END $$;

-- 2. Verificar se a coluna notes existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'clients' 
        AND column_name = 'notes'
        AND table_schema = 'public'
    ) THEN
        -- Adicionar coluna notes
        ALTER TABLE public.clients 
        ADD COLUMN notes TEXT;
        
        RAISE NOTICE 'Coluna notes adicionada com sucesso';
    ELSE
        RAISE NOTICE 'Coluna notes já existe';
    END IF;
END $$;

-- 3. Verificar estrutura final da tabela
SELECT '=== ESTRUTURA FINAL DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Testar inserção de um cliente
SELECT '=== TESTE DE INSERÇÃO ===' as info;
-- Descomente a linha abaixo para testar
-- INSERT INTO public.clients (user_id, name, email, phone, document, address, stage, notes) 
-- VALUES ('test-user-id', 'Cliente Teste', 'teste@email.com', '123456789', '123.456.789-00', 'Endereço Teste', 'Negociação', 'Observação teste');
