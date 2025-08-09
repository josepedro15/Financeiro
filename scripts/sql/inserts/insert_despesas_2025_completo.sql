-- Script para inserir despesas de Janeiro a Agosto 2025
-- Execute este SQL no Supabase SQL Editor
-- IMPORTANTE: Estes lançamentos debitam da Conta PJ

-- ==========================================
-- JANEIRO 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-01-31', 'Pagamento ao setor de vendas', 45.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- ==========================================
-- FEVEREIRO 2025 - DESPESAS
-- ==========================================

INSERT INTO transactions_2025_02 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-03', 'Adicionado à meta', 550.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-07', 'Pagamento ao setor de vendas', 100.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-10', 'Assinaturas', 149.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-11', 'Adicionado à meta', 700.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-14', 'Pagamento ao setor de vendas', 305.80, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-15', 'Adicionado à meta', 500.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-15', 'Assinaturas', 150.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-22', 'Adicionado à meta', 1100.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-22', 'Pagamento ao setor de vendas', 200.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-28', 'Pagamento ao setor de vendas', 310.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- ==========================================
-- MARÇO 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-01', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-02', 'Assinaturas', 37.50, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-04', 'Assinaturas', 53.90, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-07', 'Pagamento ao setor de vendas', 673.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-07', 'Adicionado à meta', 1354.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-12', 'Assinaturas', 160.08, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-14', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-14', 'Pagamento ao setor de vendas', 544.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-19', 'Assinaturas', 150.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-20', 'Assinaturas', 400.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-21', 'Pagamento ao setor de vendas', 613.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-21', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-26', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-28', 'Pagamento ao setor de vendas', 481.60, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-31', 'Adicionado à meta', 2094.32, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- ABRIL 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'Pagamento ao setor de vendas', 527.50, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'Assinaturas', 35.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-11', 'Pagamento ao setor de vendas', 800.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-17', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-18', 'Pagamento ao setor de vendas', 600.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-23', 'Adicionado à meta', 2380.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-26', 'Pagamento ao setor de vendas', 680.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-30', 'Adicionado à meta', 466.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- MAIO 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-02', 'Pagamento ao setor de vendas', 175.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-09', 'Pagamento ao setor de vendas', 720.30, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-10', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-16', 'Pagamento ao setor de vendas', 700.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-17', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'Pagamento ao setor de vendas', 600.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- JUNHO 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-06', 'Pagamento ao setor de vendas', 520.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-13', 'Pagamento ao setor de vendas', 488.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-14', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'Pagamento ao setor de vendas', 160.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'Pagamento ao setor de vendas', 170.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- ==========================================
-- JULHO 2025 - DESPESAS
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-04', 'Pagamento ao setor de vendas', 160.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'Adicionado à meta', 1500.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-11', 'Pagamento ao setor de vendas', 316.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-15', 'Adicionado à meta', 1500.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-18', 'Pagamento ao setor de vendas', 523.50, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-22', 'Adicionado à meta', 1500.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-25', 'Pagamento ao setor de vendas', 394.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'Adicionado à meta', 1500.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'Pagamento ao setor de vendas', 257.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- ==========================================
-- AGOSTO 2025 - DESPESAS
-- ==========================================

INSERT INTO transactions_2025_08 (
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-01', 'Pagamento ao setor de vendas', 70.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-05', 'Adicionado à meta', 2000.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÃO DOS DADOS INSERIDOS
-- ==========================================

-- Verificar totais por mês
SELECT '=== DESPESAS INSERIDAS POR MÊS ===' as info;

SELECT 
  'Janeiro 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_01 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Fevereiro 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_02 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Março 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_03 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Abril 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_04 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Maio 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_05 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Junho 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_06 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Julho 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_07 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
  'Agosto 2025' as mes,
  COUNT(*) as quantidade,
  SUM(amount) as total_despesas
FROM transactions_2025_08 
WHERE transaction_type = 'expense' 
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar totais por categoria
SELECT '=== DESPESAS POR CATEGORIA ===' as info;

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
