-- Script para verificar por que abril está incompleto no Dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações de abril no banco
SELECT '=== TOTAL DE ABRIL NO BANCO ===' as info;

SELECT
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril,
  ROUND(SUM(amount), 2) as total_arredondado_abril
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Verificar por dia (para identificar qual dia está faltando)
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT
  transaction_date,
  COUNT(*) as transacoes_por_dia,
  SUM(amount) as valor_por_dia,
  ROUND(SUM(amount), 2) as valor_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar se há transações com problemas
SELECT '=== VERIFICAR PROBLEMAS ===' as info;

SELECT
  COUNT(*) as transacoes_com_problemas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND (amount IS NULL OR amount = 0 OR description IS NULL);

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

-- 5. Comparação: Banco vs Dashboard
SELECT '=== COMPARAÇÃO BANCO VS DASHBOARD ===' as info;

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