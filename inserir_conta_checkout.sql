-- Script para inserir transações de Conta Checkout
-- Execute este script no Supabase SQL Editor

-- 1. Inserir transações de Conta Checkout
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-08', 'PAGAMENTO CHECKOUT 1', 100.00, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-08', 'PAGAMENTO CHECKOUT 2', 150.00, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-09', 'PAGAMENTO CHECKOUT 3', 75.50, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-09', 'PAGAMENTO CHECKOUT 4', 200.00, 'income', 'Conta Checkout', NOW(), NOW());

-- 2. Verificar resultado
SELECT '=== VERIFICAÇÃO APÓS INSERIR CHECKOUT ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name
ORDER BY account_name;

-- 3. Verificar transações de agosto por conta
SELECT '=== TRANSAÇÕES DE AGOSTO POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-08-01'
  AND transaction_date <= '2025-08-31'
GROUP BY account_name
ORDER BY account_name; 