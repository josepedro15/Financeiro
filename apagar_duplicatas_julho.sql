-- Script para APAGAR DUPLICATAS de julho 2025
-- Execute este script no Supabase SQL Editor

-- PRIMEIRO: Verificar duplicatas antes de apagar
SELECT '=== VERIFICAR DUPLICATAS ANTES ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
GROUP BY transaction_date, description, amount, account_name
HAVING COUNT(*) > 1
ORDER BY transaction_date, description;

-- SEGUNDO: Apagar duplicatas (mantém apenas uma de cada)
DELETE FROM public.transactions 
WHERE id IN (
  SELECT id FROM (
    SELECT id,
           ROW_NUMBER() OVER (
             PARTITION BY transaction_date, description, amount, account_name 
             ORDER BY created_at
           ) as rn
    FROM public.transactions 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
      AND transaction_date >= '2025-07-01' 
      AND transaction_date <= '2025-07-31'
  ) t
  WHERE t.rn > 1
);

-- TERCEIRO: Verificar resultado após limpeza
SELECT '=== VERIFICAÇÃO APÓS LIMPEZA ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho,
  SUM(amount) as faturamento_total_julho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- Verificar por dia
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Verificar se ainda há duplicatas
SELECT '=== VERIFICAR SE AINDA HÁ DUPLICATAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name,
  COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
GROUP BY transaction_date, description, amount, account_name
HAVING COUNT(*) > 1
ORDER BY transaction_date, description; 