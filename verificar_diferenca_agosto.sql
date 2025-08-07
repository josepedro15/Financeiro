-- Verificação da diferença entre valores de agosto
-- Execute este script para identificar o problema

-- VERIFICAR TOTAL ATUAL NO BANCO
SELECT '=== TOTAL ATUAL NO BANCO ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31';

-- VERIFICAR POR DIA (DETALHADO)
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'
GROUP BY transaction_date
ORDER BY transaction_date;

-- VERIFICAR TODAS AS TRANSACOES (PARA COMPARAR COM SUA PLANILHA)
SELECT '=== TODAS AS TRANSACOES DE AGOSTO ===' as info;

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

-- VERIFICAR DUPLICATAS
SELECT '=== VERIFICAR DUPLICATAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY transaction_date, description;

-- COMPARAR COM VALORES ESPERADOS
SELECT '=== COMPARAÇÃO COM VALORES ESPERADOS ===' as info;

SELECT 
  'Planilha Excel' as fonte,
  3328.17 as valor_esperado
UNION ALL
SELECT 
  'Dashboard Site' as fonte,
  3300.00 as valor_esperado
UNION ALL
SELECT 
  'Banco Atual' as fonte,
  ROUND(SUM(amount), 2) as valor_esperado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'; 