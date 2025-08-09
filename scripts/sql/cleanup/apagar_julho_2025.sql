-- Script para apagar todas as transações de julho 2025
-- Execute este script no Supabase SQL Editor

-- PRIMEIRO: Verificar quantas transações serão apagadas
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho,
  SUM(amount) as faturamento_total_julho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- MOSTRAR ALGUMAS TRANSACOES QUE SERÃO APAGADAS
SELECT '=== EXEMPLOS DE TRANSACOES QUE SERÃO APAGADAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
ORDER BY transaction_date
LIMIT 10;

-- APAGAR TODAS AS TRANSACOES DE JULHO 2025
-- DESCOMENTE A LINHA ABAIXO PARA EXECUTAR A EXCLUSÃO
-- DELETE FROM public.transactions 
-- WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
--   AND transaction_date >= '2025-07-01' 
--   AND transaction_date <= '2025-07-31';

-- VERIFICAÇÃO DEPOIS DE APAGAR (execute após descomentar o DELETE)
SELECT '=== VERIFICAÇÃO DEPOIS DE APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho_depois,
  SUM(amount) as faturamento_total_julho_depois
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- CONFIRMAR QUE AGOSTO AINDA EXISTE
SELECT '=== CONFIRMAÇÃO AGOSTO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_agosto,
  ROUND(SUM(amount), 2) as faturamento_total_agosto
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'; 