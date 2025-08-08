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

-- 3. Verificar transações mais recentes (simular o limite do dashboard)
SELECT '=== TRANSAÇÕES MAIS RECENTES (LIMITE 5) ===' as info;

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
LIMIT 5;

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
LIMIT 10;

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

-- 6. Verificar transações por data de criação
SELECT '=== TRANSAÇÕES POR DATA DE CRIAÇÃO ===' as info;

SELECT 
  DATE(created_at) as data_criacao,
  COUNT(*) as transacoes_criadas,
  SUM(amount) as total_criado
FROM public.transactions 
GROUP BY DATE(created_at)
ORDER BY data_criacao DESC
LIMIT 10;

-- 7. Verificar se há problemas de cache ou sincronização
SELECT '=== VERIFICAÇÃO DE SINCRONIZAÇÃO ===' as info;

SELECT 
  'Última transação criada' as info,
  MAX(created_at) as ultima_criacao
FROM public.transactions

UNION ALL

SELECT 
  'Última transação atualizada' as info,
  MAX(updated_at) as ultima_atualizacao
FROM public.transactions

UNION ALL

SELECT 
  'Total de transações hoje' as info,
  COUNT(*) as total_hoje
FROM public.transactions 
WHERE DATE(created_at) = CURRENT_DATE;

-- 8. Verificar transações de abril especificamente
SELECT '=== VERIFICAÇÃO ESPECÍFICA DE ABRIL ===' as info;

SELECT 
  COUNT(*) as total_abril,
  SUM(amount) as faturamento_abril,
  ROUND(SUM(amount), 2) as faturamento_arredondado,
  COUNT(DISTINCT user_id) as usuarios_abril
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 9. Verificar se há transações duplicadas que podem estar causando problemas
SELECT '=== VERIFICAÇÃO DE DUPLICATAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  user_id,
  COUNT(*) as quantidade
FROM public.transactions 
GROUP BY transaction_date, description, amount, account_name, user_id
HAVING COUNT(*) > 1
ORDER BY quantidade DESC
LIMIT 10;

-- 10. Resumo final para debug
SELECT '=== RESUMO PARA DEBUG ===' as info;

SELECT 
  'Total geral' as metric,
  COUNT(*) as value
FROM public.transactions

UNION ALL

SELECT 
  'Transações do usuário específico' as metric,
  COUNT(*) as value
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Transações de abril' as metric,
  COUNT(*) as value
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'

UNION ALL

SELECT 
  'Transações de 2025' as metric,
  COUNT(*) as value
FROM public.transactions 
WHERE transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-12-31'

UNION ALL

SELECT 
  'Transações de hoje' as metric,
  COUNT(*) as value
FROM public.transactions 
WHERE DATE(created_at) = CURRENT_DATE;
