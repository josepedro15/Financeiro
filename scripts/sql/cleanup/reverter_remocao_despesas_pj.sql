-- Script para reverter a remoção de R$ 2.099,17 em despesas da Conta PJ
-- Execute este SQL no Supabase SQL Editor
-- Reverte todas as ações do script "remover_despesas_pj_2099.sql"

-- ==========================================
-- VERIFICAR ESTADO ATUAL ANTES DA REVERSÃO
-- ==========================================

SELECT '=== ESTADO ANTES DA REVERSÃO ===' as info;

SELECT 
  'CONTA PJ - SALDO ATUAL' as conta,
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
) as pj_atual;

-- ==========================================
-- REMOVER O AJUSTE QUE FOI ADICIONADO
-- ==========================================

SELECT '=== REMOVENDO AJUSTE CRIADO ===' as info;

-- Remover o ajuste de R$ 67,83 que foi adicionado em dezembro
DELETE FROM transactions_2025_12 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Ajuste para remoção exata de R$ 2.099,17' 
  AND amount = 67.83 
  AND transaction_date = '2025-12-31'
  AND category = 'Ajustes';

-- ==========================================
-- RE-INSERIR TODAS AS DESPESAS QUE FORAM REMOVIDAS
-- ==========================================

SELECT '=== RE-INSERINDO DESPESAS REMOVIDAS ===' as info;

-- RE-INSERÇÃO 1: Adicionado à meta de março (R$ 1.200,00)
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-01', 'Adicionado à meta', 1200.00, 'expense', 'Conta PJ', NULL, 'Meta', NOW(), NOW());

-- RE-INSERÇÃO 2: Pagamento ao setor de vendas de março (R$ 673,00)
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-03-07', 'Pagamento ao setor de vendas', 673.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- RE-INSERÇÃO 3: Assinaturas de fevereiro (R$ 149,00)
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-10', 'Assinaturas', 149.00, 'expense', 'Conta PJ', NULL, 'Assinaturas', NOW(), NOW());

-- RE-INSERÇÃO 4: Pagamento ao setor de vendas de fevereiro (R$ 100,00)
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-02-07', 'Pagamento ao setor de vendas', 100.00, 'expense', 'Conta PJ', NULL, 'Pagamentos', NOW(), NOW());

-- RE-INSERÇÃO 5: Pagamento ao setor de vendas de janeiro (R$ 45,00)
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
-- VERIFICAR REVERSÃO COMPLETA
-- ==========================================

SELECT '=== CONFIRMAÇÃO DA REVERSÃO ===' as info;

SELECT 
  'DESPESAS RE-INSERIDAS NA CONTA PJ' as acao,
  'META (Mar): R$ 1.200,00' as reinserida_1,
  'VENDAS (Mar): R$ 673,00' as reinserida_2,
  'ASSINATURAS (Fev): R$ 149,00' as reinserida_3,
  'VENDAS (Fev): R$ 100,00' as reinserida_4,
  'VENDAS (Jan): R$ 45,00' as reinserida_5,
  'AJUSTE REMOVIDO: R$ 67,83' as ajuste_removido,
  'TOTAL LÍQUIDO REVERTIDO: R$ 2.099,17' as total_revertido;

-- ==========================================
-- VERIFICAR SALDO FINAL DA CONTA PJ
-- ==========================================

SELECT '=== SALDO FINAL CONTA PJ APÓS REVERSÃO ===' as info;

SELECT 
  'CONTA PJ - APÓS REVERSÃO' as conta,
  COALESCE(SUM(
    CASE 
      WHEN transaction_type = 'income' THEN amount 
      WHEN transaction_type = 'expense' THEN -amount 
      ELSE 0 
    END
  ), 0) as saldo_final
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

SELECT '=== REVERSÃO CONCLUÍDA COM SUCESSO ===' as status;
SELECT 'Todas as despesas foram re-inseridas' as info;
SELECT 'O ajuste foi removido' as info2;
SELECT 'Saldo da Conta PJ restaurado ao estado anterior' as info3;
