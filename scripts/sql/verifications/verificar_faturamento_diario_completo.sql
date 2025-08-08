-- Script para extrair faturamento diário COMPLETO sem limitações
-- Execute este script no Supabase SQL Editor

-- 1. TODOS os dias com transações (sem limite)
SELECT '=== TODOS OS DIAS COM TRANSAÇÕES (SEM LIMITE) ===' as info;

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

-- 2. Faturamento diário COMPLETO (apenas receitas, sem limite)
SELECT '=== FATURAMENTO DIÁRIO COMPLETO (TODOS OS DIAS) ===' as info;

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

-- 3. TODOS os meses com transações (sem limite)
SELECT '=== TODOS OS MESES COM TRANSAÇÕES ===' as info;

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

-- 4. TODOS os dias com maior faturamento (sem limite de 10)
SELECT '=== TODOS OS DIAS ORDENADOS POR FATURAMENTO ===' as info;

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
ORDER BY faturamento_dia DESC;

-- 5. Estatísticas COMPLETAS (sem limitações)
SELECT '=== ESTATÍSTICAS COMPLETAS ===' as info;

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
  MAX(amount) as maior_transacao,
  COUNT(DISTINCT EXTRACT(YEAR FROM transaction_date)) as anos_com_transacoes,
  COUNT(DISTINCT EXTRACT(MONTH FROM transaction_date)) as meses_com_transacoes
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income';

-- 6. Faturamento por ano (sem limite)
SELECT '=== FATURAMENTO POR ANO ===' as info;

SELECT 
  EXTRACT(YEAR FROM transaction_date) as ano,
  COUNT(DISTINCT transaction_date) as dias_com_transacoes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_anual,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  AVG(amount) as valor_medio_anual,
  ROUND(AVG(amount), 2) as valor_medio_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY ano
ORDER BY ano DESC;

-- 7. Detalhamento por período específico (sem limite de dias)
SELECT '=== DETALHAMENTO POR PERÍODO ===' as info;

-- Para abril 2025 (exemplo)
SELECT 
  transaction_date as data,
  COUNT(*) as quantidade_transacoes,
  SUM(amount) as faturamento_dia,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  STRING_AGG(description, ', ') as clientes_do_dia
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 8. Comparação entre todos os meses disponíveis
SELECT '=== COMPARAÇÃO ENTRE TODOS OS MESES ===' as info;

SELECT 
  CONCAT(EXTRACT(YEAR FROM transaction_date), '-', 
         LPAD(EXTRACT(MONTH FROM transaction_date)::text, 2, '0')) as ano_mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_mensal,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  COUNT(DISTINCT transaction_date) as dias_com_transacoes,
  ROUND(SUM(amount) / COUNT(DISTINCT transaction_date), 2) as faturamento_medio_por_dia
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY ano_mes
ORDER BY ano_mes DESC;

-- 9. Análise de tendência (todos os dados)
SELECT '=== ANÁLISE DE TENDÊNCIA ===' as info;

SELECT 
  transaction_date,
  SUM(amount) as faturamento_dia,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  COUNT(*) as transacoes_dia,
  ROUND(AVG(amount), 2) as valor_medio_dia,
  -- Média móvel de 7 dias
  ROUND(AVG(SUM(amount)) OVER (
    ORDER BY transaction_date 
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 2) as media_movel_7_dias
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 10. Resumo final completo
SELECT '=== RESUMO FINAL COMPLETO ===' as info;

SELECT 
  'TOTAL GERAL' as tipo,
  COUNT(*) as quantidade,
  SUM(amount) as valor_total,
  ROUND(SUM(amount), 2) as valor_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'MÉDIA POR DIA' as tipo,
  COUNT(DISTINCT transaction_date) as quantidade,
  SUM(amount) / COUNT(DISTINCT transaction_date) as valor_total,
  ROUND(SUM(amount) / COUNT(DISTINCT transaction_date), 2) as valor_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'

UNION ALL

SELECT 
  'MÉDIA POR TRANSAÇÃO' as tipo,
  COUNT(*) as quantidade,
  AVG(amount) as valor_total,
  ROUND(AVG(amount), 2) as valor_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income';
