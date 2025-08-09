-- Script para verificar carregamento do Dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as transações de abril no banco
SELECT '=== TODAS AS TRANSAÇÕES DE ABRIL NO BANCO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril,
  ROUND(SUM(amount), 2) as total_arredondado_abril
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Verificar se há transações com datas estranhas
SELECT '=== VERIFICAR DATAS ESTRANHAS ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as quantidade,
  SUM(amount) as valor_total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND (
    transaction_date < '2025-04-01' OR 
    transaction_date > '2025-04-30'
  )
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar se há transações com valores diferentes
SELECT '=== VERIFICAR VALORES DIFERENTES ===' as info;

SELECT 
  description,
  COUNT(DISTINCT amount) as valores_diferentes,
  STRING_AGG(DISTINCT amount::text, ', ') as valores
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY description
HAVING COUNT(DISTINCT amount) > 1
ORDER BY description;

-- 4. Verificar se há transações duplicadas
SELECT '=== VERIFICAR DUPLICATAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date, description, amount, account_name
HAVING COUNT(*) > 1
ORDER BY transaction_date, description;

-- 5. Simular exatamente o que o Dashboard faz
SELECT '=== SIMULAÇÃO EXATA DO DASHBOARD ===' as info;

-- O Dashboard filtra por: transactionMonth === 3 && transactionYear === 2025
-- Abril é mês 3 em JavaScript (0-based)
SELECT 
  COUNT(*) as transacoes_dashboard,
  SUM(amount) as valor_dashboard,
  ROUND(SUM(amount), 2) as valor_arredondado_dashboard
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND EXTRACT(MONTH FROM transaction_date::date) = 4  -- Abril é mês 4 no PostgreSQL
  AND EXTRACT(YEAR FROM transaction_date::date) = 2025;

-- 6. Comparação final
SELECT '=== COMPARAÇÃO FINAL ===' as info;

SELECT 
  'Banco de Dados (Abril)' as fonte,
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
  'Dashboard (Simulado)' as fonte,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND EXTRACT(MONTH FROM transaction_date::date) = 4
  AND EXTRACT(YEAR FROM transaction_date::date) = 2025

UNION ALL

SELECT 
  'Dashboard (Atual)' as fonte,
  0 as total_transacoes,
  5007.37 as total_valor,
  5007.37 as total_arredondado; 