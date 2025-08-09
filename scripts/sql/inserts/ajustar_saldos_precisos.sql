-- Script para ajustar saldos para valores específicos e precisos
-- Execute este SQL no Supabase SQL Editor
-- OBJETIVO: CONTA PJ = R$ 4.155,79 | CONTA CHECKOUT = R$ 2.781,87

-- ==========================================
-- CALCULAR SALDOS ATUAIS E DIFERENÇAS NECESSÁRIAS
-- ==========================================

-- Primeiro vamos ver os saldos atuais
WITH saldos_atuais AS (
  -- Saldo atual Conta PJ
  SELECT 
    'PJ' as conta,
    COALESCE(SUM(
      CASE 
        WHEN transaction_type = 'income' THEN amount 
        WHEN transaction_type = 'expense' THEN -amount 
        ELSE 0 
      END
    ), 0) as saldo_atual,
    4155.79 as saldo_desejado
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
  ) as pj_transactions

  UNION ALL

  -- Saldo atual Conta Checkout
  SELECT 
    'CHECKOUT' as conta,
    COALESCE(SUM(
      CASE 
        WHEN transaction_type = 'income' THEN amount 
        WHEN transaction_type = 'expense' THEN -amount 
        ELSE 0 
      END
    ), 0) as saldo_atual,
    2781.87 as saldo_desejado
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
  ) as checkout_transactions
)
SELECT 
  '=== ANÁLISE DOS SALDOS ===' as info,
  conta,
  saldo_atual,
  saldo_desejado,
  (saldo_atual - saldo_desejado) as diferenca,
  CASE 
    WHEN saldo_atual > saldo_desejado THEN 'Precisa DIMINUIR (adicionar despesa)'
    WHEN saldo_atual < saldo_desejado THEN 'Precisa AUMENTAR (adicionar receita)'
    ELSE 'Já está correto'
  END as acao_necessaria,
  ABS(saldo_atual - saldo_desejado) as valor_ajuste
FROM saldos_atuais;

-- ==========================================
-- AJUSTES PRECISOS BASEADOS NOS CÁLCULOS
-- ==========================================

-- Limpar possíveis ajustes anteriores na tabela de dezembro
DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- IMPORTANTE: Os valores abaixo são exemplos
-- Execute a query acima primeiro para ver os valores exatos necessários
-- Depois ajuste os valores abaixo conforme o resultado

-- Exemplo de ajustes (você deve ajustar os valores baseado no resultado da query acima):

-- Se CONTA PJ precisa diminuir, adicione uma despesa:
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
-- AJUSTE CONTA PJ (substitua 1000.00 pelo valor correto da diferença)
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-31', 'Ajuste para saldo correto - Despesas diversas', 1000.00, 'expense', 'Conta PJ', NULL, 'Ajustes', NOW(), NOW());

-- Se CONTA PJ precisa aumentar, mude para 'income' e ajuste o valor:
-- ('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-31', 'Ajuste para saldo correto - Receita adicional', 1000.00, 'income', 'Conta PJ', NULL, 'Ajustes', NOW(), NOW());

-- Se CONTA CHECKOUT precisa diminuir, adicione uma despesa:
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
-- AJUSTE CONTA CHECKOUT (substitua 500.00 pelo valor correto da diferença)
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-31', 'Ajuste para saldo correto - Taxas finais', 500.00, 'expense', 'Conta Checkout', NULL, 'Ajustes', NOW(), NOW());

-- Se CONTA CHECKOUT precisa aumentar, mude para 'income' e ajuste o valor:
-- ('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-31', 'Ajuste para saldo correto - Receita adicional', 500.00, 'income', 'Conta Checkout', NULL, 'Ajustes', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÃO FINAL DOS SALDOS
-- ==========================================

SELECT '=== SALDOS FINAIS APÓS AJUSTES ===' as info;

-- Verificar saldo final Conta PJ
SELECT 
  'CONTA PJ' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_final,
  4155.79 as saldo_desejado,
  ABS(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) - 4155.79) as diferenca_restante
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
  'CONTA CHECKOUT' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_final,
  2781.87 as saldo_desejado,
  ABS(COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) - 2781.87) as diferenca_restante
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
-- INSTRUÇÕES PARA AJUSTE FINO
-- ==========================================

SELECT '=== INSTRUÇÕES ===' as info;
SELECT 
  'PASSO 1: Execute até a primeira query e veja os valores de diferença' as instrucao_1,
  'PASSO 2: Edite os valores 1000.00 e 500.00 nos INSERTs com os valores corretos' as instrucao_2,
  'PASSO 3: Mude de expense para income se precisar aumentar o saldo' as instrucao_3,
  'PASSO 4: Execute novamente para confirmar os saldos finais' as instrucao_4;
