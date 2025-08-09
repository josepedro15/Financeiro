-- Script para inserir despesas de PROLABORE 2025
-- Execute este SQL no Supabase SQL Editor
-- IMPORTANTE: Estes lançamentos debitam da Conta PJ

-- ==========================================
-- MARÇO 2025 - PROLABORE
-- ==========================================

INSERT INTO transactions_2025_03 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-31', 'PROLABORE MARÇO', 6000.00, 'expense', 'Conta PJ', NULL, 'Prolabore', NOW(), NOW());

-- ==========================================
-- ABRIL 2025 - PROLABORE
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-30', 'PROLABORE ABRIL', 7000.00, 'expense', 'Conta PJ', NULL, 'Prolabore', NOW(), NOW());

-- ==========================================
-- MAIO 2025 - PROLABORE
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'PROLABORE MAIO', 6000.00, 'expense', 'Conta PJ', NULL, 'Prolabore', NOW(), NOW());

-- ==========================================
-- JUNHO 2025 - PROLABORE (2 LANÇAMENTOS)
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-15', 'PROLABORE JUNHO', 3000.00, 'expense', 'Conta PJ', NULL, 'Prolabore', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'PROLABORE JUNHO', 4000.00, 'expense', 'Conta PJ', NULL, 'Prolabore', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- ==========================================

-- Verificar prolabore inserido por mês
SELECT '=== PROLABORE INSERIDO POR MÊS ===' as info;

SELECT 
  'Março 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_prolabore
FROM transactions_2025_03 
WHERE transaction_type = 'expense' 
  AND category = 'Prolabore'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Abril 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_prolabore
FROM transactions_2025_04 
WHERE transaction_type = 'expense' 
  AND category = 'Prolabore'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Maio 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_prolabore
FROM transactions_2025_05 
WHERE transaction_type = 'expense' 
  AND category = 'Prolabore'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Junho 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_prolabore
FROM transactions_2025_06 
WHERE transaction_type = 'expense' 
  AND category = 'Prolabore'
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar total geral de prolabore
SELECT '=== TOTAL GERAL PROLABORE ===' as info;

SELECT 
  COUNT(*) as total_lancamentos,
  SUM(amount) as valor_total_prolabore
FROM (
  SELECT amount FROM transactions_2025_03 WHERE transaction_type = 'expense' AND category = 'Prolabore' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_04 WHERE transaction_type = 'expense' AND category = 'Prolabore' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_05 WHERE transaction_type = 'expense' AND category = 'Prolabore' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT amount FROM transactions_2025_06 WHERE transaction_type = 'expense' AND category = 'Prolabore' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as all_prolabore;

-- Verificar todas as categorias de despesas após prolabore
SELECT '=== TODAS AS CATEGORIAS DE DESPESAS ===' as info;

SELECT 
  category,
  COUNT(*) as quantidade,
  SUM(amount) as total_valor
FROM (
  SELECT category, amount FROM transactions_2025_01 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_02 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_03 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_04 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_05 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_06 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_07 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT category, amount FROM transactions_2025_08 WHERE transaction_type = 'expense' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as all_expenses
GROUP BY category
ORDER BY total_valor DESC;
