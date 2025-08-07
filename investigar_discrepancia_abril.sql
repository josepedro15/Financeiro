-- Script para investigar discrepância entre banco e dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as transações de abril no banco
SELECT '=== TRANSAÇÕES DE ABRIL NO BANCO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril,
  ROUND(SUM(amount), 2) as total_arredondado_abril
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 2. Verificar datas das transações de abril
SELECT '=== DATAS DAS TRANSAÇÕES DE ABRIL ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes_por_dia,
  SUM(amount) as valor_por_dia,
  ROUND(SUM(amount), 2) as valor_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar se há transações com datas incorretas
SELECT '=== VERIFICAR DATAS INCORRETAS ===' as info;

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
  AND transaction_type = 'income'
  AND (
    transaction_date < '2025-04-01' OR 
    transaction_date > '2025-04-30'
  )
ORDER BY transaction_date;

-- 4. Verificar formato das datas
SELECT '=== FORMATO DAS DATAS ===' as info;

SELECT 
  transaction_date,
  typeof(transaction_date) as tipo_data,
  LENGTH(transaction_date::text) as tamanho_string
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
LIMIT 5;

-- 5. Simular filtro do Dashboard (mês atual = abril)
SELECT '=== SIMULAÇÃO DO FILTRO DO DASHBOARD ===' as info;

-- Abril é mês 3 em JavaScript (0-based)
-- Dashboard filtra por: transactionMonth === 3 && transactionYear === 2025
SELECT 
  COUNT(*) as transacoes_filtro_dashboard,
  SUM(amount) as valor_filtro_dashboard,
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
  'Dashboard (Filtro Mês)' as fonte,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND EXTRACT(MONTH FROM transaction_date::date) = 4
  AND EXTRACT(YEAR FROM transaction_date::date) = 2025; 