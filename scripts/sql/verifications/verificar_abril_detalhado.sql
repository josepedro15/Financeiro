-- Script para verificar detalhadamente todas as transações de abril
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as transações de abril
SELECT '=== TODAS AS TRANSAÇÕES DE ABRIL ===' as info;

SELECT
  id,
  transaction_date,
  description,
  amount,
  transaction_type,
  created_at,
  updated_at
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
ORDER BY transaction_date, created_at;

-- 2. Verificar total por dia
SELECT '=== TOTAL POR DIA ===' as info;

SELECT
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar se há transações com problemas de data
SELECT '=== VERIFICAR PROBLEMAS DE DATA ===' as info;

SELECT
  transaction_date,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND (
    transaction_date < '2025-04-01' OR
    transaction_date > '2025-04-30'
  )
GROUP BY transaction_date
ORDER BY transaction_date;

-- 4. Verificar se há transações duplicadas
SELECT '=== VERIFICAR DUPLICATAS ===' as info;

SELECT
  transaction_date,
  description,
  amount,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY transaction_date, description;

-- 5. Comparação final
SELECT '=== COMPARAÇÃO FINAL ===' as info;

SELECT
  'Banco de Dados' as fonte,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'

UNION ALL

SELECT
  'Dashboard (Atual)' as fonte,
  0 as total_transacoes,
  5045.45 as total_valor,
  5045.45 as total_arredondado

UNION ALL

SELECT
  'Esperado (9 dias)' as fonte,
  155 as total_transacoes,
  7624.88 as total_valor,
  7624.88 as total_arredondado; 