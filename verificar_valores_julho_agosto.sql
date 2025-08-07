-- Verificação dos valores de julho e agosto
-- Execute este script para comparar

-- VERIFICAR JULHO ATUAL NO BANCO
SELECT '=== JULHO ATUAL NO BANCO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho,
  SUM(amount) as faturamento_total_julho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- VERIFICAR AGOSTO ATUAL NO BANCO
SELECT '=== AGOSTO ATUAL NO BANCO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_agosto,
  SUM(amount) as faturamento_total_agosto,
  ROUND(SUM(amount), 2) as faturamento_arredondado_agosto
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31';

-- VERIFICAR TODAS AS TRANSACOES DE JULHO (DETALHADO)
SELECT '=== DETALHADO JULHO ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
ORDER BY transaction_date, description;

-- VERIFICAR TODAS AS TRANSACOES DE AGOSTO (DETALHADO)
SELECT '=== DETALHADO AGOSTO ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'
ORDER BY transaction_date, description;

-- COMPARAR TOTAIS
SELECT '=== COMPARAÇÃO ===' as info;

SELECT 
  'Julho 2025' as mes,
  COUNT(*) as transacoes,
  ROUND(SUM(amount), 2) as total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'

UNION ALL

SELECT 
  'Agosto 2025' as mes,
  COUNT(*) as transacoes,
  ROUND(SUM(amount), 2) as total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'; 