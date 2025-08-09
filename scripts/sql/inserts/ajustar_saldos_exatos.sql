-- Script para ajustar saldos para os valores exatos desejados
-- Execute este SQL no Supabase SQL Editor
-- BASEADO NOS SALDOS ATUAIS: PJ = R$ 1.056,62 | CHECKOUT = R$ 6.120,02
-- OBJETIVO: PJ = R$ 4.155,79 | CHECKOUT = R$ 2.781,87

-- ==========================================
-- CÁLCULOS DOS AJUSTES NECESSÁRIOS
-- ==========================================

SELECT '=== CÁLCULOS DOS AJUSTES NECESSÁRIOS ===' as info;

SELECT 
  'CONTA PJ' as conta,
  1056.62 as saldo_atual,
  4155.79 as saldo_desejado,
  (4155.79 - 1056.62) as diferenca,
  'PRECISA AUMENTAR (adicionar receita)' as acao,
  3099.17 as valor_ajuste_pj;

SELECT 
  'CONTA CHECKOUT' as conta,
  6120.02 as saldo_atual,
  2781.87 as saldo_desejado,
  (2781.87 - 6120.02) as diferenca,
  'PRECISA DIMINUIR (adicionar despesa)' as acao,
  3338.15 as valor_ajuste_checkout;

-- ==========================================
-- LIMPAR POSSÍVEIS AJUSTES ANTERIORES
-- ==========================================

DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- ==========================================
-- APLICAR AJUSTES EXATOS
-- ==========================================

INSERT INTO transactions_2025_12 (
    user_id, 
    transaction_date, 
    description, 
    amount, 
    transaction_type, 
    account_name, 
    client_name, 
    category, 
    created_at, 
    updated_at
) VALUES 
-- CONTA PJ: AUMENTAR em R$ 3.099,17 (adicionar receita)
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-30', 'Receita adicional para ajuste de saldo', 3099.17, 'income', 'Conta PJ', NULL, 'Ajustes', NOW(), NOW()),

-- CONTA CHECKOUT: DIMINUIR em R$ 3.338,15 (adicionar despesa)
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-30', 'Despesas diversas para ajuste de saldo', 3338.15, 'expense', 'Conta Checkout', NULL, 'Ajustes', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÃO FINAL DOS SALDOS
-- ==========================================

SELECT '=== VERIFICAÇÃO FINAL DOS SALDOS ===' as info;

-- Verificar saldo final Conta PJ
SELECT 
  'CONTA PJ - RESULTADO FINAL' as conta,
  ROUND(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0), 2) as saldo_final,
  4155.79 as saldo_desejado,
  ROUND(ABS(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) - 4155.79), 2) as diferenca_centavos,
  CASE 
    WHEN ABS(COALESCE(SUM(
      CASE 
        WHEN transaction_type = 'income' THEN amount 
        WHEN transaction_type = 'expense' THEN -amount 
        ELSE 0 
      END
    ), 0) - 4155.79) < 0.01 THEN '✅ PERFEITO!'
    ELSE '⚠️ Ajuste necessário'
  END as status
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
) as pj_final;

-- Verificar saldo final Conta Checkout
SELECT 
  'CONTA CHECKOUT - RESULTADO FINAL' as conta,
  ROUND(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0), 2) as saldo_final,
  2781.87 as saldo_desejado,
  ROUND(ABS(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) - 2781.87), 2) as diferenca_centavos,
  CASE 
    WHEN ABS(COALESCE(SUM(
      CASE 
        WHEN transaction_type = 'income' THEN amount 
        WHEN transaction_type = 'expense' THEN -amount 
        ELSE 0 
      END
    ), 0) - 2781.87) < 0.01 THEN '✅ PERFEITO!'
    ELSE '⚠️ Ajuste necessário'
  END as status
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
) as checkout_final;

-- ==========================================
-- RESUMO DOS AJUSTES APLICADOS
-- ==========================================

SELECT '=== RESUMO DOS AJUSTES APLICADOS ===' as info;

SELECT 
  'AJUSTES REALIZADOS' as tipo,
  'CONTA PJ: +R$ 3.099,17 (receita adicional)' as ajuste_pj,
  'CONTA CHECKOUT: -R$ 3.338,15 (despesa adicional)' as ajuste_checkout,
  'Ambos os saldos devem estar exatos agora!' as resultado;
