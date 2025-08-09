-- Script para remover transações de 8/7/2025 (julho)
-- Execute este script no Supabase SQL Editor

-- 1. Primeiro, vamos verificar quais transações serão removidas
SELECT '=== VERIFICAÇÃO ANTES DE REMOVER ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-07-08'
ORDER BY description;

-- 2. Verificar total de julho antes de remover
SELECT '=== TOTAL DE JULHO ANTES DE REMOVER ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho,
  SUM(amount) as faturamento_total_julho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- 3. REMOVER TRANSAÇÕES DE 8/7/2025
DELETE FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-07-08';

-- 4. Verificar se foram removidas
SELECT '=== VERIFICAÇÃO APÓS REMOVER ===' as info;

SELECT 
  COUNT(*) as total_transacoes_8_julho_restantes
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-07-08';

-- 5. Verificar total de julho após remover
SELECT '=== TOTAL DE JULHO APÓS REMOVER ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho_final,
  SUM(amount) as faturamento_total_julho_final,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho_final
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'; 