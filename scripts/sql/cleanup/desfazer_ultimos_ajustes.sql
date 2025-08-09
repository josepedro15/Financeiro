-- Script para desfazer os últimos ajustes de saldo aplicados
-- Execute este SQL no Supabase SQL Editor
-- Remove os ajustes que foram feitos baseados nos valores R$ 1.056,62 e R$ 6.120,02

-- ==========================================
-- VERIFICAR SALDOS ANTES DA REMOÇÃO
-- ==========================================

SELECT '=== SALDOS ANTES DE DESFAZER AJUSTES ===' as info;

-- Saldo atual Conta PJ
SELECT 
  'CONTA PJ - ANTES DA REMOÇÃO' as conta,
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
  'CONTA CHECKOUT - ANTES DA REMOÇÃO' as conta,
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
-- MOSTRAR AJUSTES QUE SERÃO REMOVIDOS
-- ==========================================

SELECT '=== AJUSTES QUE SERÃO REMOVIDOS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  transaction_type,
  account_name,
  'SERÁ REMOVIDO' as status
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY account_name, transaction_date;

-- ==========================================
-- REMOVER TODOS OS AJUSTES DE DEZEMBRO 2025
-- ==========================================

SELECT '=== REMOVENDO AJUSTES ===' as info;

DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- ==========================================
-- VERIFICAR SALDOS APÓS REMOÇÃO
-- ==========================================

SELECT '=== SALDOS APÓS REMOÇÃO DOS AJUSTES ===' as info;

-- Saldo restaurado Conta PJ
SELECT 
  'CONTA PJ - APÓS REMOÇÃO' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_restaurado
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

-- Saldo restaurado Conta Checkout  
SELECT 
  'CONTA CHECKOUT - APÓS REMOÇÃO' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_restaurado
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
-- CONFIRMAÇÃO DA REMOÇÃO
-- ==========================================

SELECT '=== CONFIRMAÇÃO ===' as info;

SELECT 
  'AÇÃO REALIZADA' as status,
  'Todos os ajustes de dezembro 2025 foram removidos' as descricao,
  'Os saldos foram restaurados para o estado original' as resultado;
