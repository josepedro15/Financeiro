-- Script para verificar a estrutura exata da tabela transactions

-- Verificar todas as colunas da tabela transactions
SELECT '=== ESTRUTURA DA TABELA TRANSACTIONS ===' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'transactions'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Verificar alguns dados de exemplo
SELECT '=== DADOS DE EXEMPLO ===' as info;
SELECT * FROM public.transactions LIMIT 3; 