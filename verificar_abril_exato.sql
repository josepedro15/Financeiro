-- Script para verificar EXATAMENTE as transações de abril
-- Execute este script no Supabase SQL Editor

-- 1. Verificar TODAS as transações de abril
SELECT '=== TODAS AS TRANSAÇÕES DE ABRIL ===' as info;

SELECT
  id,
  transaction_date,
  description,
  amount,
  transaction_type,
  created_at
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
ORDER BY transaction_date, created_at;

-- 2. Contar por dia
SELECT '=== CONTAGEM POR DIA ===' as info;

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

-- 3. Total geral
SELECT '=== TOTAL GERAL ===' as info;

SELECT
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 4. Verificar se há transações com datas estranhas
SELECT '=== VERIFICAR DATAS ESTRANHAS ===' as info;

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