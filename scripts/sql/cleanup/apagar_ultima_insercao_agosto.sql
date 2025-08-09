-- Script para apagar a última inserção de agosto 2025
-- Execute este script no Supabase SQL Editor

-- PRIMEIRO: Verificar transações de agosto atuais
SELECT '=== VERIFICAÇÃO AGOSTO ATUAL ===' as info;

SELECT 
  COUNT(*) as total_transacoes_agosto,
  SUM(amount) as faturamento_total_agosto,
  ROUND(SUM(amount), 2) as faturamento_arredondado_agosto
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31';

-- MOSTRAR TODAS AS TRANSACOES DE AGOSTO (mais recentes primeiro)
SELECT '=== TODAS AS TRANSACOES DE AGOSTO ===' as info;

SELECT 
  id,
  transaction_date,
  description,
  amount,
  account_name,
  created_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'
ORDER BY created_at DESC;

-- APAGAR A ÚLTIMA INSERÇÃO (mais recente)
-- DESCOMENTE A LINHA ABAIXO PARA EXECUTAR A EXCLUSÃO
-- DELETE FROM public.transactions 
-- WHERE id = (
--   SELECT id 
--   FROM public.transactions 
--   WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
--     AND transaction_date >= '2025-08-01' 
--     AND transaction_date <= '2025-08-31'
--   ORDER BY created_at DESC 
--   LIMIT 1
-- );

-- VERIFICAÇÃO DEPOIS DE APAGAR
SELECT '=== VERIFICAÇÃO DEPOIS DE APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_agosto_depois,
  SUM(amount) as faturamento_total_agosto_depois,
  ROUND(SUM(amount), 2) as faturamento_arredondado_agosto_depois
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31';

-- MOSTRAR AS TRANSACOES RESTANTES DE AGOSTO
SELECT '=== TRANSACOES RESTANTES DE AGOSTO ===' as info;

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