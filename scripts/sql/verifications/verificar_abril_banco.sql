-- Script para verificar se as transações de abril estão no banco
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se as transações de abril existem
SELECT '=== VERIFICAÇÃO DE ABRIL NO BANCO ===' as info;

SELECT COUNT(*) as total_transacoes_abril, 
       SUM(amount) as faturamento_total_abril, 
       ROUND(SUM(amount), 2) as faturamento_arredondado_abril
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30';

-- 2. Verificar transações por dia
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
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar apenas transações de INCOME em abril
SELECT '=== TRANSAÇÕES DE INCOME EM ABRIL ===' as info;

SELECT COUNT(*) as total_income_abril, 
       SUM(amount) as faturamento_income_abril, 
       ROUND(SUM(amount), 2) as faturamento_income_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30' 
  AND transaction_type = 'income';

-- 4. Verificar algumas transações específicas
SELECT '=== ALGUMAS TRANSAÇÕES DE ABRIL ===' as info;

SELECT transaction_date, description, amount, transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
ORDER BY transaction_date, amount DESC
LIMIT 10; 