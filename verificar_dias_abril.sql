-- Script para verificar quais dias de abril estão faltando
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todos os dias de abril que existem no banco
SELECT '=== DIAS DE ABRIL NO BANCO ===' as info;

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

-- 2. Verificar quais dias deveriam existir (1-10, exceto 6)
SELECT '=== DIAS ESPERADOS ===' as info;

SELECT 
  '2025-04-01' as dia_esperado,
  'Dia 1' as descricao
UNION ALL
SELECT 
  '2025-04-02' as dia_esperado,
  'Dia 2' as descricao
UNION ALL
SELECT 
  '2025-04-03' as dia_esperado,
  'Dia 3' as descricao
UNION ALL
SELECT 
  '2025-04-04' as dia_esperado,
  'Dia 4' as descricao
UNION ALL
SELECT 
  '2025-04-05' as dia_esperado,
  'Dia 5' as descricao
UNION ALL
SELECT 
  '2025-04-07' as dia_esperado,
  'Dia 7' as descricao
UNION ALL
SELECT 
  '2025-04-08' as dia_esperado,
  'Dia 8' as descricao
UNION ALL
SELECT 
  '2025-04-09' as dia_esperado,
  'Dia 9' as descricao
UNION ALL
SELECT 
  '2025-04-10' as dia_esperado,
  'Dia 10' as descricao;

-- 3. Comparação: dias que existem vs dias esperados
SELECT '=== COMPARAÇÃO ===' as info;

SELECT
  'Dias inseridos' as status,
  COUNT(DISTINCT transaction_date) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-10'
  AND transaction_type = 'income'

UNION ALL

SELECT
  'Dias esperados' as status,
  9 as quantidade; 