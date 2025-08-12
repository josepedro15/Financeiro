-- APAGAR TODAS AS TRANSAÇÕES DO USUÁRIO
-- Execute este script no Supabase SQL Editor
-- ⚠️ ATENÇÃO: Isso vai apagar TODAS as transações do usuário 8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6!

-- 1. Verificar quantas transações serão apagadas
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR ===' as info;

SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 2. Verificar transações por mês
SELECT '=== TRANSAÇÕES POR MÊS ===' as info;
SELECT 
    EXTRACT(YEAR FROM transaction_date::date) as ano,
    EXTRACT(MONTH FROM transaction_date::date) as mes,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;

-- 3. Verificar transações por mês na tabela mensal
SELECT '=== TRANSAÇÕES POR MÊS (TABELA MENSAIS) ===' as info;
SELECT 
    EXTRACT(YEAR FROM transaction_date::date) as ano,
    EXTRACT(MONTH FROM transaction_date::date) as mes,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;

-- 4. APAGAR TODAS AS TRANSAÇÕES DA TABELA PRINCIPAL
SELECT '=== APAGANDO TABELA PRINCIPAL ===' as info;
DELETE FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 5. APAGAR TODAS AS TRANSAÇÕES DA TABELA MENSAIS
SELECT '=== APAGANDO TABELA MENSAIS ===' as info;
DELETE FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 6. Verificar se foram apagadas
SELECT '=== VERIFICAÇÃO APÓS APAGAR ===' as info;

SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 7. Verificar se outros usuários não foram afetados
SELECT '=== VERIFICAÇÃO OUTROS USUÁRIOS ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    COUNT(*) as total_transacoes
FROM transactions
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    COUNT(*) as total_transacoes
FROM transactions_2025_08;

SELECT '=== TODAS AS TRANSAÇÕES DO USUÁRIO FORAM APAGADAS! ===' as info;
