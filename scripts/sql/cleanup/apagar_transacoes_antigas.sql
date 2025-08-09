-- Script para apagar todas as transações antes de agosto 2025
-- Execute este script no Supabase SQL Editor

-- 1. Primeiro, vamos verificar quantas transações serão apagadas
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_para_apagar,
  MIN(transaction_date) as data_mais_antiga,
  MAX(transaction_date) as data_mais_recente
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date < '2025-08-01';

-- 2. Verificar transações por mês antes de apagar
SELECT '=== TRANSAÇÕES POR MÊS (ANTES DE APAGAR) ===' as info;

SELECT 
  EXTRACT(YEAR FROM transaction_date::date) as ano,
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date < '2025-08-01'
GROUP BY EXTRACT(YEAR FROM transaction_date::date), EXTRACT(MONTH FROM transaction_date::date)
ORDER BY ano, mes;

-- 3. APAGAR TRANSAÇÕES ANTIGAS
-- DESCOMENTE A LINHA ABAIXO PARA EXECUTAR A EXCLUSÃO
-- DELETE FROM public.transactions 
-- WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
--   AND transaction_date < '2025-08-01';

-- 4. Verificar resultado após apagar
SELECT '=== VERIFICAÇÃO APÓS APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_restantes,
  MIN(transaction_date) as data_mais_antiga,
  MAX(transaction_date) as data_mais_recente
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 5. Verificar transações restantes por mês
SELECT '=== TRANSAÇÕES RESTANTES POR MÊS ===' as info;

SELECT 
  EXTRACT(YEAR FROM transaction_date::date) as ano,
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(YEAR FROM transaction_date::date), EXTRACT(MONTH FROM transaction_date::date)
ORDER BY ano, mes; 