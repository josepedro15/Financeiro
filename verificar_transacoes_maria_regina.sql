-- VERIFICAR TRANSAÇÕES DA MARIA REGINA
-- Execute este script no Supabase SQL Editor

-- 1. Verificar transações com "MARIA REGINA" na tabela principal
SELECT '=== TRANSAÇÕES MARIA REGINA - TABELA PRINCIPAL ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    account_name,
    transaction_date,
    created_at,
    updated_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (description ILIKE '%MARIA REGINA%' OR client_name ILIKE '%MARIA REGINA%')
ORDER BY amount DESC, created_at DESC;

-- 2. Verificar transações com "MARIA REGINA" na tabela mensal
SELECT '=== TRANSAÇÕES MARIA REGINA - TABELA MENSAIS ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    account_name,
    transaction_date,
    created_at,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (description ILIKE '%MARIA REGINA%' OR client_name ILIKE '%MARIA REGINA%')
ORDER BY amount DESC, created_at DESC;

-- 3. Verificar transações com valores específicos (R$ 200.000,00, R$ 1.599,00, R$ 17.666,00, R$ 2.000,00)
SELECT '=== TRANSAÇÕES COM VALORES ESPECÍFICOS ===' as info;

-- Verificar na tabela transactions
SELECT 
    'transactions' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    transaction_date,
    created_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND amount IN (200000.00, 1599.00, 17666.00, 2000.00)
  AND transaction_date = '2025-08-12'
ORDER BY amount DESC;

-- Verificar na tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND amount IN (200000.00, 1599.00, 17666.00, 2000.00)
  AND transaction_date = '2025-08-12'
ORDER BY amount DESC;

-- 4. Verificar todas as transações de 12/08/2025
SELECT '=== TODAS AS TRANSAÇÕES DE 12/08/2025 ===' as info;

-- Verificar na tabela transactions
SELECT 
    'transactions' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    client_name,
    created_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12'
ORDER BY amount DESC;

-- Verificar na tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    client_name,
    created_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12'
ORDER BY amount DESC;

-- 5. Verificar transações com "Sem descrição"
SELECT '=== TRANSAÇÕES "SEM DESCRIÇÃO" ===' as info;

-- Verificar na tabela transactions
SELECT 
    'transactions' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    client_name,
    transaction_date,
    created_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (description IS NULL OR description = '' OR description = 'Sem descrição')
ORDER BY created_at DESC;

-- Verificar na tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    id,
    description,
    amount,
    transaction_type,
    account_name,
    client_name,
    transaction_date,
    created_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (description IS NULL OR description = '' OR description = 'Sem descrição')
ORDER BY created_at DESC;

-- 6. Verificar contagem total por tabela
SELECT '=== CONTAGEM TOTAL POR TABELA ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes,
    COUNT(CASE WHEN amount = 200000.00 THEN 1 END) as transacoes_200k,
    COUNT(CASE WHEN amount = 1599.00 THEN 1 END) as transacoes_1599,
    COUNT(CASE WHEN amount = 17666.00 THEN 1 END) as transacoes_17666,
    COUNT(CASE WHEN amount = 2000.00 THEN 1 END) as transacoes_2000
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes,
    COUNT(CASE WHEN amount = 200000.00 THEN 1 END) as transacoes_200k,
    COUNT(CASE WHEN amount = 1599.00 THEN 1 END) as transacoes_1599,
    COUNT(CASE WHEN amount = 17666.00 THEN 1 END) as transacoes_17666,
    COUNT(CASE WHEN amount = 2000.00 THEN 1 END) as transacoes_2000
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12';

-- 7. Verificar transações por tipo de conta
SELECT '=== TRANSAÇÕES POR TIPO DE CONTA ===' as info;

-- Verificar na tabela transactions
SELECT 
    'transactions' as tabela,
    account_name,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12'
GROUP BY account_name
ORDER BY valor_total DESC;

-- Verificar na tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    account_name,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-08-12'
GROUP BY account_name
ORDER BY valor_total DESC;

SELECT '=== VERIFICAÇÃO CONCLUÍDA ===' as info;
