-- Script para verificar problemas de atualização no dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações no sistema
SELECT '=== VERIFICAÇÃO GERAL ===' as info;

SELECT
  COUNT(*) as total_transacoes,
  COUNT(DISTINCT user_id) as usuarios_unicos,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
  SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas
FROM public.transactions;

-- 2. Verificar transações por usuário específico
SELECT '=== VERIFICAÇÃO USUÁRIO ESPECÍFICO ===' as info;

SELECT
  user_id,
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
  SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY user_id;

-- 3. Verificar transações mais recentes (últimas 24h)
SELECT '=== TRANSAÇÕES ÚLTIMAS 24H ===' as info;

SELECT
  id,
  user_id,
  transaction_date,
  description,
  amount,
  transaction_type,
  created_at,
  updated_at
FROM public.transactions
WHERE created_at >= NOW() - INTERVAL '24 hours'
ORDER BY created_at DESC
LIMIT 10;

-- 4. Verificar se há transações duplicadas
SELECT '=== VERIFICAÇÃO DE DUPLICATAS ===' as info;

SELECT
  user_id,
  transaction_date,
  description,
  amount,
  transaction_type,
  COUNT(*) as quantidade
FROM public.transactions
GROUP BY user_id, transaction_date, description, amount, transaction_type
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 5. Verificar transações de abril especificamente
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

-- 6. Verificar por dia em abril
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

-- 7. Verificar se há problemas de sincronização
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

-- 8. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;

SELECT
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'transactions'
ORDER BY ordinal_position;

-- 9. Verificar políticas de acesso
SELECT '=== POLÍTICAS DE ACESSO ===' as info;

SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'transactions';

-- 10. Teste de inserção simulada
SELECT '=== TESTE DE INSERÇÃO ===' as info;

-- Simular uma nova transação para testar
INSERT INTO public.transactions (
  user_id, 
  transaction_date, 
  description, 
  amount, 
  transaction_type, 
  created_at, 
  updated_at
) VALUES (
  '2dc520e3-5f19-4dfe-838b-1aca7238ae36',
  CURRENT_DATE,
  'TESTE DE ATUALIZAÇÃO - ' || NOW(),
  100.00,
  'income',
  NOW(),
  NOW()
);

-- Verificar se foi inserida
SELECT
  'Nova transação inserida' as info,
  id,
  user_id,
  transaction_date,
  description,
  amount,
  created_at
FROM public.transactions
WHERE description LIKE 'TESTE DE ATUALIZAÇÃO%'
ORDER BY created_at DESC
LIMIT 1;

-- Remover a transação de teste
DELETE FROM public.transactions 
WHERE description LIKE 'TESTE DE ATUALIZAÇÃO%';

SELECT '=== TESTE CONCLUÍDO ===' as info;
