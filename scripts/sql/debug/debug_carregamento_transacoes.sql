-- Script para debugar o problema de carregamento das transações
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se há problema com o user_id
SELECT '=== VERIFICAR USER_ID ===' as info;

SELECT 
  user_id,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY user_id
ORDER BY user_id;

-- 2. Verificar se há transações com user_id nulo
SELECT '=== VERIFICAR USER_ID NULO ===' as info;

SELECT 
  COUNT(*) as transacoes_sem_user_id
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND user_id IS NULL;

-- 3. Verificar se há transações com user_id diferente
SELECT '=== VERIFICAR USER_ID DIFERENTE ===' as info;

SELECT 
  user_id,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND user_id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY user_id
ORDER BY user_id;

-- 4. Verificar se há transações com transaction_type diferente
SELECT '=== VERIFICAR TRANSACTION_TYPE ===' as info;

SELECT 
  transaction_type,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
GROUP BY transaction_type
ORDER BY transaction_type;

-- 5. Verificar se há transações com amount nulo ou zero
SELECT '=== VERIFICAR AMOUNT NULO OU ZERO ===' as info;

SELECT 
  COUNT(*) as transacoes_amount_nulo_ou_zero
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND (amount IS NULL OR amount = 0);

-- 6. Verificar se há transações com created_at muito antigo
SELECT '=== VERIFICAR CREATED_AT ===' as info;

SELECT 
  MIN(created_at) as primeira_transacao,
  MAX(created_at) as ultima_transacao,
  COUNT(*) as total_transacoes
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 7. Verificar se há transações com updated_at muito antigo
SELECT '=== VERIFICAR UPDATED_AT ===' as info;

SELECT 
  MIN(updated_at) as primeira_atualizacao,
  MAX(updated_at) as ultima_atualizacao,
  COUNT(*) as total_transacoes
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income';

-- 8. Verificar se há transações com description nulo
SELECT '=== VERIFICAR DESCRIPTION NULO ===' as info;

SELECT 
  COUNT(*) as transacoes_sem_descricao
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND (description IS NULL OR description = '');

-- 9. Verificar se há transações com account_name nulo
SELECT '=== VERIFICAR ACCOUNT_NAME NULO ===' as info;

SELECT 
  account_name,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY account_name
ORDER BY account_name;

-- 10. Comparação final: Todas as possibilidades
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
  'Dashboard (Atual)' as fonte,
  105 as total_transacoes,
  5007.37 as total_valor,
  5007.37 as total_arredondado

UNION ALL

SELECT 
  'Diferença' as fonte,
  174 - 105 as total_transacoes,
  8485.55 - 5007.37 as total_valor,
  ROUND(8485.55 - 5007.37, 2) as total_arredondado; 