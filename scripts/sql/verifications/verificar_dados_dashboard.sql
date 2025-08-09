-- Script para verificar dados do Dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações
SELECT '=== TOTAL DE TRANSAÇÕES ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as total_receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as total_despesas
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar totais por conta
SELECT '=== TOTAIS POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
  SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name
ORDER BY account_name;

-- 3. Verificar dados do mês atual (Janeiro 2025)
SELECT '=== DADOS DO MÊS ATUAL (JANEIRO 2025) ===' as info;

SELECT 
  COUNT(*) as total_transacoes_janeiro,
  SUM(amount) as total_receitas_janeiro,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-01-31'
  AND transaction_type = 'income';

-- 4. Verificar dados por mês do ano atual
SELECT '=== DADOS POR MÊS DO ANO ATUAL ===' as info;

SELECT 
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_receitas,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-12-31'
  AND transaction_type = 'income'
GROUP BY EXTRACT(MONTH FROM transaction_date::date)
ORDER BY mes;

-- 5. Verificar dados diários do mês atual
SELECT '=== DADOS DIÁRIOS DO MÊS ATUAL ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_receitas,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-01-31'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 6. Verificar transações mais recentes
SELECT '=== TRANSAÇÕES MAIS RECENTES ===' as info;

SELECT 
  id,
  transaction_date,
  description,
  amount,
  transaction_type,
  account_name,
  created_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 10; 