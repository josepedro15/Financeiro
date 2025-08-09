-- Script para investigar transações faltantes de abril
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de transações de abril no banco
SELECT '=== TOTAL DE TRANSAÇÕES DE ABRIL NO BANCO ===' as info;

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

-- 5. Verificar se há transações com valores nulos ou zero
SELECT '=== VERIFICAR VALORES NULOS OU ZERO ===' as info;

SELECT 
  COUNT(*) as transacoes_nulas_ou_zero
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
  AND (amount IS NULL OR amount = 0);

-- 6. Verificar se há transações com datas inválidas
SELECT '=== VERIFICAR DATAS INVÁLIDAS ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND (
    transaction_date IS NULL OR
    transaction_date::text = '' OR
    transaction_date::text NOT LIKE '____-__-__'
  )
GROUP BY transaction_date
ORDER BY transaction_date;

-- 7. Verificar se há transações com user_id diferente
SELECT '=== VERIFICAR USER_ID DIFERENTE ===' as info;

SELECT 
  user_id,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'
GROUP BY user_id
ORDER BY user_id;

-- 8. Comparação final: Banco vs Dashboard esperado
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
  5007.37 as total_arredondado; 