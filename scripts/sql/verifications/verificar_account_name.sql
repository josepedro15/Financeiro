-- Script para verificar a coluna account_name
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se a coluna account_name existe
SELECT '=== VERIFICAÇÃO DA COLUNA ACCOUNT_NAME ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
  AND column_name = 'account_name';

-- 2. Verificar valores únicos na coluna account_name
SELECT '=== VALORES ÚNICOS EM ACCOUNT_NAME ===' as info;

SELECT DISTINCT account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 3. Verificar transações por conta
SELECT '=== TRANSAÇÕES POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name
ORDER BY account_name;

-- 4. Verificar algumas transações com account_name
SELECT '=== AMOSTRA DE TRANSAÇÕES COM CONTA ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  transaction_type,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 10; 