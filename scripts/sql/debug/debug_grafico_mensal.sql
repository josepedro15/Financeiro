-- Script para debugar o gráfico mensal
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as transações de 2025
SELECT '=== TODAS AS TRANSAÇÕES DE 2025 ===' as info;

SELECT 
  COUNT(*) as total_transacoes_2025,
  SUM(amount) as total_valor_2025,
  ROUND(SUM(amount), 2) as total_arredondado_2025
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-12-31'
  AND transaction_type = 'income';

-- 2. Verificar por mês (como o Dashboard faz)
SELECT '=== VERIFICAÇÃO POR MÊS (COMO DASHBOARD) ===' as info;

SELECT 
  EXTRACT(MONTH FROM transaction_date::date) as mes_numero,
  CASE 
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 1 THEN 'Jan'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 2 THEN 'Fev'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 3 THEN 'Mar'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 4 THEN 'Abr'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 5 THEN 'Mai'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 6 THEN 'Jun'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 7 THEN 'Jul'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 8 THEN 'Ago'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 9 THEN 'Set'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 10 THEN 'Out'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 11 THEN 'Nov'
    WHEN EXTRACT(MONTH FROM transaction_date::date) = 12 THEN 'Dez'
  END as mes_nome,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-12-31'
  AND transaction_type = 'income'
GROUP BY EXTRACT(MONTH FROM transaction_date::date)
ORDER BY mes_numero;

-- 3. Verificar especificamente abril
SELECT '=== VERIFICAÇÃO ESPECÍFICA DE ABRIL ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril,
  ROUND(SUM(amount), 2) as total_arredondado_abril,
  MIN(transaction_date) as primeira_data,
  MAX(transaction_date) as ultima_data
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(MONTH FROM transaction_date::date) = 4
  AND EXTRACT(YEAR FROM transaction_date::date) = 2025
  AND transaction_type = 'income';

-- 4. Verificar se há transações com datas estranhas
SELECT '=== VERIFICAR DATAS ESTRANHAS ===' as info;

SELECT 
  transaction_date,
  EXTRACT(YEAR FROM transaction_date::date) as ano,
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY transaction_date, EXTRACT(YEAR FROM transaction_date::date), EXTRACT(MONTH FROM transaction_date::date)
HAVING EXTRACT(YEAR FROM transaction_date::date) != 2025
ORDER BY transaction_date;

-- 5. Comparação final: Banco vs Dashboard esperado
SELECT '=== COMPARAÇÃO FINAL ===' as info;

SELECT 
  'Banco de Dados (Abril)' as fonte,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(MONTH FROM transaction_date::date) = 4
  AND EXTRACT(YEAR FROM transaction_date::date) = 2025
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'Dashboard (Esperado)' as fonte,
  174 as total_transacoes,
  8485.55 as total_valor,
  8485.55 as total_arredondado; 