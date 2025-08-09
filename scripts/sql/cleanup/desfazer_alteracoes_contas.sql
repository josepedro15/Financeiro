-- Script para desfazer as últimas alterações nas contas
-- Execute este SQL no Supabase SQL Editor
-- Reverte: remoção de despesas PJ (R$ 2.099,17) e adição de despesas Checkout (R$ 3.838,15)

-- ==========================================
-- VERIFICAR SALDOS ATUAIS ANTES DE DESFAZER
-- ==========================================

SELECT '=== SALDOS ANTES DE DESFAZER ===' as info;

-- Saldo atual Conta PJ
SELECT 
  'CONTA PJ - ANTES DE DESFAZER' as conta,
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
  'CONTA CHECKOUT - ANTES DE DESFAZER' as conta,
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
-- PARTE 1: RESTAURAR DESPESAS REMOVIDAS DA CONTA PJ
-- ==========================================

SELECT '=== RESTAURANDO DESPESAS REMOVIDAS DA CONTA PJ ===' as info;

-- Restaurar: META (Março) - R$ 1.200,00
INSERT INTO transactions_2025_03 (
    user_id, transaction_date, description, amount, transaction_type, 
    account_name, client_name, category, created_at, updated_at
) VALUES 
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-01', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- Restaurar: VENDAS (Março) - R$ 673,00
INSERT INTO transactions_2025_03 (
    user_id, transaction_date, description, amount, transaction_type, 
    account_name, client_name, category, created_at, updated_at
) VALUES 
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-07', 'Pagamento ao setor de vendas', 673.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- Restaurar: ASSINATURAS (Fevereiro) - R$ 149,00
INSERT INTO transactions_2025_02 (
    user_id, transaction_date, description, amount, transaction_type, 
    account_name, client_name, category, created_at, updated_at
) VALUES 
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-10', 'Assinaturas', 149.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW());

-- Restaurar: VENDAS (Fevereiro) - R$ 100,00
INSERT INTO transactions_2025_02 (
    user_id, transaction_date, description, amount, transaction_type, 
    account_name, client_name, category, created_at, updated_at
) VALUES 
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-07', 'Pagamento ao setor de vendas', 100.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- Restaurar: VENDAS (Janeiro) - R$ 45,00
INSERT INTO transactions_2025_01 (
    user_id, transaction_date, description, amount, transaction_type, 
    account_name, client_name, category, created_at, updated_at
) VALUES 
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-01-31', 'Pagamento ao setor de vendas', 45.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- ==========================================
-- PARTE 2: REMOVER DESPESAS ADICIONADAS À CONTA CHECKOUT
-- ==========================================

SELECT '=== REMOVENDO DESPESAS ADICIONADAS À CONTA CHECKOUT ===' as info;

-- Mostrar despesas que serão removidas
SELECT 
  'DESPESAS QUE SERÃO REMOVIDAS' as acao,
  transaction_date,
  description,
  amount,
  category
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta Checkout' 
  AND transaction_type = 'expense'
ORDER BY transaction_date;

-- Remover todas as despesas de dezembro da Conta Checkout
DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta Checkout' 
  AND transaction_type = 'expense';

-- ==========================================
-- PARTE 3: REMOVER AJUSTE DA CONTA PJ
-- ==========================================

SELECT '=== REMOVENDO AJUSTE DA CONTA PJ ===' as info;

-- Remover o ajuste de R$ 67,83 que foi adicionado
DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta PJ' 
  AND description = 'Ajuste para remoção exata de R$ 2.099,17'
  AND amount = 67.83;

-- ==========================================
-- VERIFICAR SALDOS RESTAURADOS
-- ==========================================

SELECT '=== SALDOS APÓS RESTAURAÇÃO ===' as info;

-- Novo saldo Conta PJ (deve voltar ao original)
SELECT 
  'CONTA PJ - APÓS RESTAURAÇÃO' as conta,
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
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_12 WHERE account_name = 'Conta PJ' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as pj_restored;

-- Novo saldo Conta Checkout (deve voltar ao original)
SELECT 
  'CONTA CHECKOUT - APÓS RESTAURAÇÃO' as conta,
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
  UNION ALL
  SELECT transaction_type, amount FROM transactions_2025_12 WHERE account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as checkout_restored;

-- ==========================================
-- RESUMO DA RESTAURAÇÃO
-- ==========================================

SELECT '=== RESUMO DA RESTAURAÇÃO ===' as info;

SELECT 
  'AÇÕES REALIZADAS' as status,
  'CONTA PJ: +R$ 2.167,00 (despesas restauradas) -R$ 67,83 (ajuste removido)' as acao_pj,
  'CONTA CHECKOUT: -R$ 3.838,15 (despesas removidas)' as acao_checkout,
  'Ambas as contas devem estar de volta aos saldos originais!' as resultado;
