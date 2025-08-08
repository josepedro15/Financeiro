-- Script para verificar valores lançados em abril de 2025
-- Execute este script no Supabase SQL Editor

-- 1. Verificação geral de abril
SELECT '=== VERIFICAÇÃO GERAL DE ABRIL 2025 ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as faturamento_total_abril,
  ROUND(SUM(amount), 2) as faturamento_arredondado_abril,
  COUNT(DISTINCT user_id) as usuarios_com_transacoes
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Verificação por dia em abril
SELECT '=== VERIFICAÇÃO POR DIA EM ABRIL ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes_do_dia,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado,
  MIN(description) as primeira_transacao,
  MAX(description) as ultima_transacao
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificação por conta em abril
SELECT '=== VERIFICAÇÃO POR CONTA EM ABRIL ===' as info;

SELECT 
  account_name,
  COUNT(*) as transacoes,
  SUM(amount) as total_conta,
  ROUND(SUM(amount), 2) as total_arredondado,
  AVG(amount) as valor_medio,
  MIN(amount) as menor_valor,
  MAX(amount) as maior_valor
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY account_name
ORDER BY total_conta DESC;

-- 4. Top 10 maiores transações de abril
SELECT '=== TOP 10 MAIORES TRANSAÇÕES DE ABRIL ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  user_id
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
ORDER BY amount DESC
LIMIT 10;

-- 5. Verificação de transações por usuário
SELECT '=== VERIFICAÇÃO POR USUÁRIO EM ABRIL ===' as info;

SELECT 
  user_id,
  COUNT(*) as transacoes,
  SUM(amount) as total_usuario,
  ROUND(SUM(amount), 2) as total_arredondado,
  AVG(amount) as valor_medio
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY user_id
ORDER BY total_usuario DESC;

-- 6. Verificação de transações com valores específicos
SELECT '=== VERIFICAÇÃO DE VALORES ESPECÍFICOS ===' as info;

SELECT 
  amount,
  COUNT(*) as quantidade,
  STRING_AGG(description, ', ') as exemplos
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY amount
ORDER BY amount DESC
LIMIT 10;

-- 7. Verificação de dias sem transações
SELECT '=== DIAS SEM TRANSAÇÕES EM ABRIL ===' as info;

WITH RECURSIVE dates AS (
  SELECT '2025-04-01'::date as date
  UNION ALL
  SELECT date + 1
  FROM dates
  WHERE date < '2025-04-30'
),
transactions_by_date AS (
  SELECT 
    transaction_date,
    COUNT(*) as transacoes
  FROM public.transactions 
  WHERE transaction_date >= '2025-04-01' 
    AND transaction_date <= '2025-04-30'
    AND transaction_type = 'income'
  GROUP BY transaction_date
)
SELECT 
  dates.date,
  COALESCE(transactions_by_date.transacoes, 0) as transacoes
FROM dates
LEFT JOIN transactions_by_date ON dates.date = transactions_by_date.transaction_date
WHERE COALESCE(transactions_by_date.transacoes, 0) = 0
ORDER BY dates.date;

-- 8. Resumo final
SELECT '=== RESUMO FINAL ABRIL 2025 ===' as info;

SELECT 
  'Total de transações' as metric,
  COUNT(*) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'Faturamento total' as metric,
  ROUND(SUM(amount), 2) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'Valor médio por transação' as metric,
  ROUND(AVG(amount), 2) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'Maior transação' as metric,
  MAX(amount) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'Menor transação' as metric,
  MIN(amount) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';
