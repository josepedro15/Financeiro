-- Script para apagar TODAS as transações
-- ⚠️ ATENÇÃO: Este script vai apagar TODAS as transações do usuário
-- Execute este script no Supabase SQL Editor

-- PRIMEIRO: Verificar quantas transações existem no total
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR TUDO ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- MOSTRAR RESUMO POR MÊS
SELECT '=== RESUMO POR MÊS ===' as info;

SELECT 
  EXTRACT(YEAR FROM transaction_date) as ano,
  EXTRACT(MONTH FROM transaction_date) as mes,
  COUNT(*) as transacoes,
  ROUND(SUM(amount), 2) as total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
ORDER BY ano, mes;

-- MOSTRAR ALGUMAS TRANSACOES QUE SERÃO APAGADAS
SELECT '=== EXEMPLOS DE TRANSACOES QUE SERÃO APAGADAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY transaction_date DESC
LIMIT 10;

-- ⚠️ APAGAR TODAS AS TRANSACOES
-- DESCOMENTE A LINHA ABAIXO PARA EXECUTAR A EXCLUSÃO
-- DELETE FROM public.transactions 
-- WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- VERIFICAÇÃO DEPOIS DE APAGAR
SELECT '=== VERIFICAÇÃO DEPOIS DE APAGAR TUDO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_depois,
  SUM(amount) as faturamento_total_depois
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- CONFIRMAR QUE ESTÁ VAZIO
SELECT '=== CONFIRMAÇÃO FINAL ===' as info;

SELECT 
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ TODAS AS TRANSACOES FORAM APAGADAS'
    ELSE '❌ AINDA EXISTEM ' || COUNT(*) || ' TRANSACOES'
  END as status
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'; 