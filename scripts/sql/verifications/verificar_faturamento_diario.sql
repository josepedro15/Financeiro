-- Script para extrair faturamento diário de todos os dias já lançados
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todos os dias com transações
SELECT '=== DIAS COM TRANSAÇÕES ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_dia,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY transaction_date
ORDER BY transaction_date DESC;

-- 2. Faturamento diário apenas de receitas (income)
SELECT '=== FATURAMENTO DIÁRIO (APENAS RECEITAS) ===' as info;

SELECT 
  transaction_date as data,
  COUNT(*) as quantidade_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  AVG(amount) as valor_medio_transacao,
  ROUND(AVG(amount), 2) as valor_medio_arredondado,
  MIN(amount) as menor_transacao,
  MAX(amount) as maior_transacao
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date DESC;

-- 3. Resumo por mês
SELECT '=== RESUMO POR MÊS ===' as info;

SELECT 
  EXTRACT(YEAR FROM transaction_date) as ano,
  EXTRACT(MONTH FROM transaction_date) as mes,
  COUNT(DISTINCT transaction_date) as dias_com_transacoes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_mensal,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  AVG(amount) as valor_medio_mensal,
  ROUND(AVG(amount), 2) as valor_medio_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;

-- 4. Top 10 dias com maior faturamento
SELECT '=== TOP 10 DIAS COM MAIOR FATURAMENTO ===' as info;

SELECT 
  transaction_date as data,
  COUNT(*) as quantidade_transacoes,
  SUM(amount) as faturamento_dia,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  AVG(amount) as valor_medio,
  ROUND(AVG(amount), 2) as valor_medio_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY faturamento_dia DESC
LIMIT 10;

-- 5. Dias sem transações (últimos 30 dias)
SELECT '=== DIAS SEM TRANSAÇÕES (ÚLTIMOS 30 DIAS) ===' as info;

WITH RECURSIVE dates AS (
  SELECT CURRENT_DATE - INTERVAL '30 days' as date
  UNION ALL
  SELECT date + INTERVAL '1 day'
  FROM dates
  WHERE date < CURRENT_DATE
),
transactions_by_date AS (
  SELECT 
    transaction_date,
    COUNT(*) as transacoes
  FROM public.transactions
  WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    AND transaction_date >= CURRENT_DATE - INTERVAL '30 days'
  GROUP BY transaction_date
)
SELECT 
  dates.date as data,
  COALESCE(transactions_by_date.transacoes, 0) as transacoes
FROM dates
LEFT JOIN transactions_by_date ON dates.date = transactions_by_date.transaction_date
WHERE COALESCE(transactions_by_date.transacoes, 0) = 0
ORDER BY dates.date DESC;

-- 6. Estatísticas gerais
SELECT '=== ESTATÍSTICAS GERAIS ===' as info;

SELECT 
  COUNT(DISTINCT transaction_date) as total_dias_com_transacoes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  AVG(amount) as valor_medio_transacao,
  ROUND(AVG(amount), 2) as valor_medio_arredondado,
  MIN(transaction_date) as primeira_data,
  MAX(transaction_date) as ultima_data,
  MIN(amount) as menor_transacao,
  MAX(amount) as maior_transacao
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income';

-- 7. Faturamento por período específico (últimos 7 dias)
SELECT '=== FATURAMENTO ÚLTIMOS 7 DIAS ===' as info;

SELECT 
  transaction_date as data,
  COUNT(*) as quantidade_transacoes,
  SUM(amount) as faturamento_dia,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND transaction_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY transaction_date
ORDER BY transaction_date DESC;

-- 8. Comparação com mês anterior
SELECT '=== COMPARAÇÃO COM MÊS ANTERIOR ===' as info;

SELECT 
  'Mês Atual' as periodo,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND transaction_date >= DATE_TRUNC('month', CURRENT_DATE)

UNION ALL

SELECT 
  'Mês Anterior' as periodo,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND transaction_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND transaction_date < DATE_TRUNC('month', CURRENT_DATE);
