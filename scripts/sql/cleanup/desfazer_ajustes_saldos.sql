-- Script para desfazer os ajustes incorretos de saldos
-- Execute este SQL no Supabase SQL Editor
-- OBJETIVO: Remover todos os ajustes que causaram saldos negativos

-- ==========================================
-- PRIMEIRO: VERIFICAR SALDOS ATUAIS (NEGATIVOS)
-- ==========================================

SELECT '=== SALDOS ANTES DE DESFAZER AJUSTES ===' as info;

-- Saldo atual Conta PJ
SELECT 
  'CONTA PJ - SALDO ATUAL (NEGATIVO)' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_atual
FROM (
  SELECT transaction_type, amount FROM transactions_2025_01 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_02 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_03 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_04 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_05 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_06 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_07 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_08 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_12 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as pj_transactions;

-- Saldo atual Conta Checkout
SELECT 
  'CONTA CHECKOUT - SALDO ATUAL (NEGATIVO)' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_atual
FROM (
  SELECT transaction_type, amount FROM transactions_2025_01 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_02 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_03 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_04 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_05 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_06 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_07 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_08 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_12 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as checkout_transactions;

-- ==========================================
-- REMOVER TODOS OS AJUSTES DE DEZEMBRO
-- ==========================================

SELECT '=== REMOVENDO AJUSTES INCORRETOS ===' as info;

-- Verificar quais ajustes existem antes de deletar
SELECT 
  'AJUSTES QUE SERÃO REMOVIDOS' as acao,
  transaction_date,
  description,
  amount,
  account_name
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY transaction_date, account_name;

-- DELETAR TODOS OS AJUSTES DE DEZEMBRO 2025
DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar se a exclusão foi bem-sucedida
SELECT 
  'AJUSTES RESTANTES APÓS EXCLUSÃO' as verificacao,
  COUNT(*) as quantidade_restante
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- ==========================================
-- VERIFICAR SALDOS APÓS REMOÇÃO DOS AJUSTES
-- ==========================================

SELECT '=== SALDOS APÓS REMOÇÃO DOS AJUSTES ===' as info;

-- Novo saldo Conta PJ (sem os ajustes)
SELECT 
  'CONTA PJ - SALDO CORRIGIDO' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_corrigido
FROM (
  SELECT transaction_type, amount FROM transactions_2025_01 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_02 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_03 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_04 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_05 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_06 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_07 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_08 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as pj_clean;

-- Novo saldo Conta Checkout (sem os ajustes)
SELECT 
  'CONTA CHECKOUT - SALDO CORRIGIDO' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_corrigido
FROM (
  SELECT transaction_type, amount FROM transactions_2025_01 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_02 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_03 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_04 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_05 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_06 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_07 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_08 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as checkout_clean;

-- ==========================================
-- RESUMO FINAL
-- ==========================================

SELECT '=== RESUMO DA CORREÇÃO ===' as info;

SELECT 
  'AÇÃO REALIZADA' as status,
  'Todos os ajustes de dezembro 2025 foram removidos' as descricao,
  'Os saldos foram restaurados para o estado anterior aos ajustes' as resultado;
