-- Script final para testar transações de abril
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações de abril
SELECT '=== TESTE FINAL DE ABRIL ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as faturamento_total_abril,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Verificar transações por dia em abril
SELECT '=== TRANSAÇÕES POR DIA EM ABRIL ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_dia,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar algumas transações específicas
SELECT '=== ALGUMAS TRANSAÇÕES DE ABRIL ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
ORDER BY transaction_date, amount DESC
LIMIT 10; 