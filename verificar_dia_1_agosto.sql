-- Verificação detalhada do dia 1 de agosto
-- Execute este script para identificar o problema

-- VERIFICAR O QUE ESTÁ NO BANCO PARA DIA 1
SELECT '=== DIA 1 ATUAL NO BANCO ===' as info;

SELECT 
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-08-01'
ORDER BY description;

-- CALCULAR TOTAL ATUAL DO DIA 1
SELECT '=== TOTAL ATUAL DIA 1 ===' as info;

SELECT 
  COUNT(*) as transacoes,
  SUM(amount) as total_atual,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-08-01';

-- CALCULAR MANUALMENTE O QUE DEVERIA SER
SELECT '=== CÁLCULO MANUAL DIA 1 ===' as info;

SELECT 'MARISTELE DE JESUS' as cliente, 75.91 as valor UNION ALL
SELECT 'KARINNE NUNES', 40.00 UNION ALL
SELECT 'MARQUELVIA VITOR', 67.92 UNION ALL
SELECT 'WESLLEY MATHEUS', 39.50 UNION ALL
SELECT 'EDSON LUIS', 63.92 UNION ALL
SELECT 'ROSA GOURMET', 39.95 UNION ALL
SELECT 'MARCOS LUIZ', 39.95 UNION ALL
SELECT 'MALU', 39.95 UNION ALL
SELECT 'SILVANA LUCIA', 39.95 UNION ALL
SELECT 'DELMA APARECIDA', 39.95 UNION ALL
SELECT 'TATIANA ROXO', 39.95 UNION ALL
SELECT 'JULIANA RODRIGUES', 39.95;

-- CALCULAR TOTAL MANUAL
SELECT '=== TOTAL MANUAL DIA 1 ===' as info;

SELECT SUM(valor) as total_manual FROM (
  SELECT 75.91 as valor UNION ALL
  SELECT 40.00 UNION ALL
  SELECT 67.92 UNION ALL
  SELECT 39.50 UNION ALL
  SELECT 63.92 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95 UNION ALL
  SELECT 39.95
) as valores_dia1;

-- COMPARAR
SELECT '=== COMPARAÇÃO ===' as info;

SELECT 
  'Esperado' as tipo,
  594.87 as valor
UNION ALL
SELECT 
  'Atual no banco',
  ROUND(SUM(amount), 2)
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-08-01'; 