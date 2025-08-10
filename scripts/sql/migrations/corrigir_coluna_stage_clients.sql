-- Corrigir coluna stage da tabela clients
-- O problema é que a coluna stage está limitada a VARCHAR(20) mas precisa de mais caracteres

-- 1. Verificar a estrutura atual
SELECT '=== ESTRUTURA ATUAL DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 2. Alterar a coluna stage para permitir mais caracteres
ALTER TABLE public.clients 
ALTER COLUMN stage TYPE VARCHAR(100);

-- 3. Verificar se a alteração foi aplicada
SELECT '=== ESTRUTURA APÓS ALTERAÇÃO ===' as info;
SELECT column_name, data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 4. Verificar se há dados na tabela
SELECT '=== DADOS ATUAIS NA TABELA CLIENTS ===' as info;
SELECT COUNT(*) as total_clientes FROM public.clients;

-- 5. Verificar valores únicos da coluna stage
SELECT '=== VALORES ÚNICOS DA COLUNA STAGE ===' as info;
SELECT DISTINCT stage, COUNT(*) as quantidade
FROM public.clients
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY quantidade DESC;
