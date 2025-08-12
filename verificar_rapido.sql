-- VERIFICAÇÃO RÁPIDA - Execute este script no Supabase SQL Editor

-- 1. Verificar se há transações na tabela principal
SELECT '=== TABELA PRINCIPAL ===' as info;
SELECT COUNT(*) as total_transacoes FROM transactions WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 2. Verificar se há transações na tabela mensal
SELECT '=== TABELA MENSAIS ===' as info;
SELECT COUNT(*) as total_transacoes FROM transactions_2025_08 WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 3. Mostrar algumas transações da tabela principal
SELECT '=== ALGUMAS TRANSAÇÕES DA TABELA PRINCIPAL ===' as info;
SELECT id, description, amount, transaction_date, account_name 
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
ORDER BY created_at DESC
LIMIT 5;

-- 4. Mostrar algumas transações da tabela mensal
SELECT '=== ALGUMAS TRANSAÇÕES DA TABELA MENSAIS ===' as info;
SELECT id, description, amount, transaction_date, account_name 
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
ORDER BY created_at DESC
LIMIT 5;

-- 5. Verificar transações de 12/08/2025
SELECT '=== TRANSAÇÕES DE 12/08/2025 ===' as info;
SELECT 'Tabela Principal' as origem, COUNT(*) as quantidade
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6' AND transaction_date = '2025-08-12'
UNION ALL
SELECT 'Tabela Mensal' as origem, COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6' AND transaction_date = '2025-08-12';

SELECT '=== FIM DA VERIFICAÇÃO ===' as info;
