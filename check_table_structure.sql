-- Script para verificar a estrutura das tabelas
-- Vamos ver quais colunas existem em cada tabela

-- Verificar estrutura da tabela accounts
SELECT '=== ESTRUTURA DA TABELA ACCOUNTS ===' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'accounts'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Verificar estrutura da tabela clients
SELECT '=== ESTRUTURA DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Verificar estrutura da tabela transactions
SELECT '=== ESTRUTURA DA TABELA TRANSACTIONS ===' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'transactions'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- Verificar alguns dados de exemplo
SELECT '=== DADOS DE EXEMPLO - ACCOUNTS ===' as info;
SELECT * FROM public.accounts LIMIT 3;

SELECT '=== DADOS DE EXEMPLO - CLIENTS ===' as info;
SELECT * FROM public.clients LIMIT 3;

SELECT '=== DADOS DE EXEMPLO - TRANSACTIONS ===' as info;
SELECT * FROM public.transactions LIMIT 3; 