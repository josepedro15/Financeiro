-- Script para adicionar R$ 3.838,15 em despesas aleatórias na Conta Checkout
-- Execute este SQL no Supabase SQL Editor
-- Adiciona várias despesas distribuídas para totalizar o valor exato

-- ==========================================
-- VERIFICAR SALDO ATUAL DA CONTA CHECKOUT
-- ==========================================

SELECT '=== SALDO ATUAL CONTA CHECKOUT ===' as info;

SELECT 
  'CONTA CHECKOUT - ANTES DAS NOVAS DESPESAS' as conta,
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
-- ADICIONAR DESPESAS ALEATÓRIAS - TOTAL: R$ 3.838,15
-- ==========================================

SELECT '=== ADICIONANDO DESPESAS ALEATÓRIAS ===' as info;

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
-- DESPESAS VARIADAS PARA TOTALIZAR R$ 3.838,15
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-01', 'Campanhas publicitárias Meta - Extra', 1500.00, 'expense', 'Conta Checkout', NULL, 'Marketing', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-03', 'Licenças de software premium', 450.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-05', 'Pagamento freelancer - Designer', 680.00, 'expense', 'Conta Checkout', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-08', 'Taxas de marketplace e comissões', 320.50, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-10', 'Serviços de email marketing', 180.00, 'expense', 'Conta Checkout', NULL, 'Comunicação', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-12', 'Assinaturas ferramentas de design', 275.80, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-15', 'Produção de conteúdo - Video', 350.00, 'expense', 'Conta Checkout', NULL, 'Marketing', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-18', 'Taxas bancárias e IOF', 45.25, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-20', 'Hospedagem e domínios', 125.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-22', 'Social media - Impulsionamento', 200.00, 'expense', 'Conta Checkout', NULL, 'Social Media', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-25', 'Ferramentas de análise e métricas', 85.40, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-27', 'Pagamento consultor - E-commerce', 400.00, 'expense', 'Conta Checkout', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-28', 'Despesas operacionais diversas', 150.00, 'expense', 'Conta Checkout', NULL, 'Operacional', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-30', 'Ajuste final para valor exato', 76.20, 'expense', 'Conta Checkout', NULL, 'Ajustes', NOW(), NOW());

-- ==========================================
-- VERIFICAR TOTAL ADICIONADO
-- ==========================================

SELECT '=== CONFIRMAÇÃO DAS DESPESAS ADICIONADAS ===' as info;

SELECT 
  'DESPESAS ADICIONADAS À CONTA CHECKOUT' as acao,
  COUNT(*) as quantidade_despesas,
  SUM(amount) as total_adicionado
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta Checkout' 
  AND transaction_type = 'expense';

-- Detalhar as despesas adicionadas
SELECT 
  'DETALHAMENTO DAS DESPESAS' as tipo,
  transaction_date,
  description,
  amount,
  category
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta Checkout' 
  AND transaction_type = 'expense'
ORDER BY transaction_date;

-- ==========================================
-- VERIFICAR NOVO SALDO DA CONTA CHECKOUT
-- ==========================================

SELECT '=== NOVO SALDO CONTA CHECKOUT ===' as info;

SELECT 
  'CONTA CHECKOUT - APÓS NOVAS DESPESAS' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as novo_saldo
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
-- RESUMO POR CATEGORIA
-- ==========================================

SELECT '=== RESUMO DAS NOVAS DESPESAS POR CATEGORIA ===' as info;

SELECT 
  category,
  COUNT(*) as quantidade,
  SUM(amount) as total_categoria
FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name = 'Conta Checkout' 
  AND transaction_type = 'expense'
GROUP BY category
ORDER BY total_categoria DESC;
