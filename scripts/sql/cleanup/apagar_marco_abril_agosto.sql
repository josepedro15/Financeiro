-- Script para apagar transações de março, abril e agosto de 2025
-- Execute este script no Supabase SQL Editor

-- 1. Verificar quantas transações serão apagadas
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR ===' as info;

SELECT
  'Março 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-03-01'
  AND transaction_date <= '2025-03-31'

UNION ALL

SELECT
  'Abril 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'

UNION ALL

SELECT
  'Agosto 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-08-01'
  AND transaction_date <= '2025-08-31';

-- 2. Mostrar algumas transações que serão apagadas (amostra)
SELECT '=== AMOSTRA DAS TRANSAÇÕES QUE SERÃO APAGADAS ===' as info;

SELECT
  transaction_date,
  description,
  amount,
  transaction_type,
  created_at
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (
    (transaction_date >= '2025-03-01' AND transaction_date <= '2025-03-31') OR
    (transaction_date >= '2025-04-01' AND transaction_date <= '2025-04-30') OR
    (transaction_date >= '2025-08-01' AND transaction_date <= '2025-08-31')
  )
ORDER BY transaction_date DESC
LIMIT 10;

-- 3. APAGAR TRANSAÇÕES DE MARÇO 2025
SELECT '=== APAGANDO TRANSAÇÕES DE MARÇO 2025 ===' as info;

DELETE FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-03-01'
  AND transaction_date <= '2025-03-31';

-- 4. APAGAR TRANSAÇÕES DE ABRIL 2025
SELECT '=== APAGANDO TRANSAÇÕES DE ABRIL 2025 ===' as info;

DELETE FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30';

-- 5. APAGAR TRANSAÇÕES DE AGOSTO 2025
SELECT '=== APAGANDO TRANSAÇÕES DE AGOSTO 2025 ===' as info;

DELETE FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-08-01'
  AND transaction_date <= '2025-08-31';

-- 6. Verificar resultado final
SELECT '=== VERIFICAÇÃO APÓS APAGAR ===' as info;

SELECT
  'Total de transações restantes' as info,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 7. Verificar transações por mês restantes
SELECT '=== TRANSAÇÕES RESTANTES POR MÊS ===' as info;

SELECT
  EXTRACT(MONTH FROM transaction_date) as mes,
  EXTRACT(YEAR FROM transaction_date) as ano,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(MONTH FROM transaction_date), EXTRACT(YEAR FROM transaction_date)
ORDER BY ano, mes;

-- 8. Verificar se ainda existem transações nos meses apagados
SELECT '=== VERIFICAÇÃO SE AINDA EXISTEM TRANSAÇÕES NOS MESES APAGADOS ===' as info;

SELECT
  'Março 2025' as mes,
  COUNT(*) as transacoes_restantes
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-03-01'
  AND transaction_date <= '2025-03-31'

UNION ALL

SELECT
  'Abril 2025' as mes,
  COUNT(*) as transacoes_restantes
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'

UNION ALL

SELECT
  'Agosto 2025' as mes,
  COUNT(*) as transacoes_restantes
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-08-01'
  AND transaction_date <= '2025-08-31';

SELECT '=== LIMPEZA CONCLUÍDA ===' as info;
