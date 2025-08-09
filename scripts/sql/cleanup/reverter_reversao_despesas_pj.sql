-- Script para reverter a reversão (voltar ao estado da remoção de R$ 2.099,17)
-- Execute este SQL no Supabase SQL Editor
-- Desfaz as ações do script "reverter_remocao_despesas_pj.sql"
-- Mantém o estado original da remoção das despesas

-- ==========================================
-- VERIFICAR ESTADO ATUAL ANTES DA OPERAÇÃO
-- ==========================================

SELECT '=== ESTADO ANTES DE VOLTAR À REMOÇÃO ===' as info;

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
-- REMOVER NOVAMENTE AS DESPESAS QUE FORAM RE-INSERIDAS
-- ==========================================

SELECT '=== REMOVENDO NOVAMENTE AS DESPESAS RE-INSERIDAS ===' as info;

-- REMOÇÃO 1: Adicionado à meta de março (R$ 1.200,00)
DELETE FROM transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Adicionado à meta' 
  AND amount = 1200.00 
  AND transaction_date = '2025-03-01'
  AND category = 'Meta';

-- REMOÇÃO 2: Pagamento ao setor de vendas de março (R$ 673,00)
DELETE FROM transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Pagamento ao setor de vendas' 
  AND amount = 673.00 
  AND transaction_date = '2025-03-07'
  AND category = 'Pagamentos';

-- REMOÇÃO 3: Assinaturas de fevereiro (R$ 149,00)
DELETE FROM transactions_2025_02 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Assinaturas' 
  AND amount = 149.00 
  AND transaction_date = '2025-02-10'
  AND category = 'Assinaturas';

-- REMOÇÃO 4: Pagamento ao setor de vendas de fevereiro (R$ 100,00)
DELETE FROM transactions_2025_02 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Pagamento ao setor de vendas' 
  AND amount = 100.00 
  AND transaction_date = '2025-02-07'
  AND category = 'Pagamentos';

-- REMOÇÃO 5: Pagamento ao setor de vendas de janeiro (R$ 45,00)
DELETE FROM transactions_2025_01 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_type = 'expense' 
  AND account_name = 'Conta PJ'
  AND description = 'Pagamento ao setor de vendas' 
  AND amount = 45.00 
  AND transaction_date = '2025-01-31'
  AND category = 'Pagamentos';

-- ==========================================
-- RE-ADICIONAR O AJUSTE DE R$ 67,83
-- ==========================================

SELECT '=== RE-ADICIONANDO O AJUSTE ===' as info;

-- Adicionar novamente o ajuste para manter o valor exato de R$ 2.099,17 removidos
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
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-12-31', 'Ajuste para remoção exata de R$ 2.099,17', 67.83, 'expense', 'Conta PJ', NULL, 'Ajustes', NOW(), NOW());

-- ==========================================
-- VERIFICAR OPERAÇÃO COMPLETA
-- ==========================================

SELECT '=== CONFIRMAÇÃO DO RETORNO À REMOÇÃO ===' as info;

SELECT 
  'VOLTAMOS AO ESTADO DA REMOÇÃO' as acao,
  'META (Mar): R$ 1.200,00' as removida_1,
  'VENDAS (Mar): R$ 673,00' as removida_2,
  'ASSINATURAS (Fev): R$ 149,00' as removida_3,
  'VENDAS (Fev): R$ 100,00' as removida_4,
  'VENDAS (Jan): R$ 45,00' as removida_5,
  'AJUSTE RE-ADICIONADO: R$ 67,83' as ajuste_readd,
  'TOTAL LÍQUIDO REMOVIDO: R$ 2.099,17' as total_removido;

-- ==========================================
-- VERIFICAR SALDO FINAL DA CONTA PJ
-- ==========================================

SELECT '=== SALDO FINAL CONTA PJ (ESTADO DA REMOÇÃO) ===' as info;

SELECT 
  'CONTA PJ - COM REMOÇÃO MANTIDA' as conta,
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

SELECT '=== OPERAÇÃO CONCLUÍDA ===' as status;
SELECT 'Voltamos ao estado da remoção de R$ 2.099,17' as info;
SELECT 'As despesas foram removidas novamente' as info2;
SELECT 'O ajuste foi re-adicionado' as info3;
SELECT 'Saldo da Conta PJ mantém a redução desejada' as info4;
