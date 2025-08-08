-- Script para verificar total lançado em abril 2025
-- Execute este script no Supabase SQL Editor

-- 1. Total geral de abril
SELECT '=== TOTAL GERAL ABRIL 2025 ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  SUM(amount) as total_receitas,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Total por conta em abril
SELECT '=== TOTAL POR CONTA EM ABRIL ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_receitas,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY account_name
ORDER BY account_name;

-- 3. Total por dia em abril
SELECT '=== TOTAL POR DIA EM ABRIL ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_receitas,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 4. Verificar se há despesas em abril
SELECT '=== DESPESAS EM ABRIL ===' as info;

SELECT 
  COUNT(*) as total_despesas,
  SUM(amount) as total_despesas_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'expense';

-- 5. Resumo completo de abril
SELECT '=== RESUMO COMPLETO ABRIL ===' as info;

SELECT 
  'Receitas' as tipo,
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
  'Despesas' as tipo,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'expense'; 