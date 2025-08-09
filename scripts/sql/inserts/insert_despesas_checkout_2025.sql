-- Script para inserir despesas saindo da Conta Checkout 2025
-- Execute este SQL no Supabase SQL Editor
-- IMPORTANTE: Estes lançamentos debitam da Conta Checkout

-- ==========================================
-- DEZEMBRO 2024 (incluído para histórico)
-- ==========================================

-- Nota: Como não temos tabela para 2024, estes irão para a tabela principal
INSERT INTO transactions (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2024-12-05', 'IDEOGRAM', 49.07, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2024-12-05', 'VERIFICADO INSTA', 53.90, 'expense', 'Conta Checkout', NULL, 'Social Media', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2024-12-05', 'TAXAS YAMPI', 24.47, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW());

-- ==========================================
-- JANEIRO 2025 - DESPESAS CHECKOUT
-- ==========================================

INSERT INTO transactions_2025_01 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-01-28', 'VIDEO CAMPANHA NOVA - VARLEY', 95.00, 'expense', 'Conta Checkout', NULL, 'Marketing', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-01-28', 'ADOBE', 95.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-01-28', 'TAXAS YAMPI', 40.68, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW());

-- ==========================================
-- ABRIL 2025 - DESPESAS CHECKOUT
-- ==========================================

INSERT INTO transactions_2025_04 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-18', 'BLACK', 147.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'IDEOGRAM', 19.40, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'YAMPI', 15.18, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'EMAIL', 12.99, 'expense', 'Conta Checkout', NULL, 'Comunicação', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'YAMPI', 18.30, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'VERIFICADO INSTA', 53.90, 'expense', 'Conta Checkout', NULL, 'Social Media', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-29', 'ADOBE', 95.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-30', 'META', 2000.00, 'expense', 'Conta Checkout', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- MAIO 2025 - DESPESAS CHECKOUT
-- ==========================================

INSERT INTO transactions_2025_05 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-17', 'BLACK', 147.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'META', 2000.00, 'expense', 'Conta Checkout', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- JUNHO 2025 - DESPESAS CHECKOUT
-- ==========================================

INSERT INTO transactions_2025_06 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'META', 2000.00, 'expense', 'Conta Checkout', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'ADOBE', 95.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'DESCONTO DA META NO CARTAO', 270.00, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'INSTA', 53.90, 'expense', 'Conta Checkout', NULL, 'Social Media', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'IDEOGRAM', 116.37, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'IDEOGRAM', 4.07, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'SOCIAL MEDIA', 300.00, 'expense', 'Conta Checkout', NULL, 'Social Media', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'BLACK', 147.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'YAMPI', 21.00, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW());

-- ==========================================
-- JULHO 2025 - DESPESAS CHECKOUT
-- ==========================================

INSERT INTO transactions_2025_07 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'GABRIEL', 400.00, 'expense', 'Conta Checkout', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-20', 'BLACK', 147.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'CHAT GPT', 115.70, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'IOF', 4.05, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'IDEOGRAM', 113.51, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'IOF', 3.84, 'expense', 'Conta Checkout', NULL, 'Taxas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'ADOBE', 95.00, 'expense', 'Conta Checkout', NULL, 'Ferramentas', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- ==========================================

-- Verificar despesas checkout por mês
SELECT '=== DESPESAS CHECKOUT POR MÊS ===' as info;

SELECT 
  'Janeiro 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_01 
WHERE transaction_type = 'expense' 
  AND account_name = 'Conta Checkout'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Abril 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_04 
WHERE transaction_type = 'expense' 
  AND account_name = 'Conta Checkout'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Maio 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_05 
WHERE transaction_type = 'expense' 
  AND account_name = 'Conta Checkout'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Junho 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_06 
WHERE transaction_type = 'expense' 
  AND account_name = 'Conta Checkout'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Julho 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_07 
WHERE transaction_type = 'expense' 
  AND account_name = 'Conta Checkout'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar despesas checkout por categoria
SELECT '=== DESPESAS CHECKOUT POR CATEGORIA ===' as info;

SELECT 
  category,
  COUNT(*) as quantidade,
  SUM(amount) as total_valor
FROM (
  SELECT category, amount FROM transactions_2025_01 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_04 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_05 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_06 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_07 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as all_checkout_expenses
GROUP BY category
ORDER BY total_valor DESC;

-- Total geral despesas checkout
SELECT '=== TOTAL GERAL DESPESAS CHECKOUT ===' as info;

SELECT 
  COUNT(*) as total_lancamentos,
  SUM(amount) as valor_total_checkout
FROM (
  SELECT amount FROM transactions_2025_01 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_04 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_05 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_06 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_07 WHERE transaction_type = 'expense' AND account_name = 'Conta Checkout' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as all_checkout;
