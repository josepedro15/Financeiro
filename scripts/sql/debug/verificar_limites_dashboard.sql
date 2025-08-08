-- Script para verificar limites do dashboard e quantidade de transações
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações no sistema
SELECT '=== TOTAL DE TRANSAÇÕES NO SISTEMA ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  COUNT(DISTINCT user_id) as usuarios_unicos,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas
FROM public.transactions;

-- 2. Verificar transações por usuário
SELECT '=== TRANSAÇÕES POR USUÁRIO ===' as info;

SELECT 
  user_id,
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total
FROM public.transactions 
GROUP BY user_id
ORDER BY total_transacoes DESC;

-- 3. Verificar transações mais recentes (simular o limite do dashboard - 20)
SELECT '=== TRANSAÇÕES MAIS RECENTES (LIMITE 20) ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  transaction_type,
  created_at,
  user_id
FROM public.transactions 
ORDER BY created_at DESC
LIMIT 20;

-- 4. Verificar transações mais recentes do usuário específico
SELECT '=== TRANSAÇÕES MAIS RECENTES DO USUÁRIO ESPECÍFICO ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  transaction_type,
  created_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 20;

-- 5. Verificar se há transações não processadas
SELECT '=== VERIFICAÇÃO DE TRANSAÇÕES NÃO PROCESSADAS ===' as info;

SELECT 
  COUNT(*) as transacoes_sem_data,
  COUNT(*) as transacoes_sem_valor,
  COUNT(*) as transacoes_sem_tipo
FROM public.transactions 
WHERE transaction_date IS NULL 
   OR amount IS NULL 
   OR transaction_type IS NULL;

-- 6. Verificar se há problemas de sincronização
SELECT '=== VERIFICAÇÃO DE SINCRONIZAÇÃO ===' as info;

SELECT
  'Transações sem user_id' as tipo,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id IS NULL

UNION ALL

SELECT
  'Transações com user_id vazio' as tipo,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = ''

UNION ALL

SELECT
  'Transações com amount NULL' as tipo,
  COUNT(*) as quantidade
FROM public.transactions
WHERE amount IS NULL

UNION ALL

SELECT
  'Transações com transaction_type NULL' as tipo,
  COUNT(*) as quantidade
FROM public.transactions
WHERE transaction_type IS NULL;

-- 7. Verificar se há duplicatas
SELECT '=== VERIFICAÇÃO DE DUPLICATAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 8. Verificar transações de abril especificamente
SELECT '=== VERIFICAÇÃO ABRIL 2025 ===' as info;

SELECT
  COUNT(*) as total_abril,
  SUM(amount) as faturamento_abril,
  COUNT(DISTINCT transaction_date) as dias_com_transacoes
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 9. Verificar por dia em abril
SELECT '=== ABRIL POR DIA ===' as info;

SELECT
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 10. Teste de limite do Supabase (1.000 registros)
SELECT '=== TESTE DE LIMITE DO SUPABASE ===' as info;

SELECT 
  'Total de transações' as info,
  COUNT(*) as quantidade
FROM public.transactions

UNION ALL

SELECT 
  'Transações do usuário específico' as info,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Transações de abril do usuário' as info,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30';

-- 11. Verificar se há problemas de performance
SELECT '=== VERIFICAÇÃO DE PERFORMANCE ===' as info;

SELECT 
  'Transações por mês' as tipo,
  EXTRACT(YEAR FROM transaction_date::date) as ano,
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;
