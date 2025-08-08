-- Script para adicionar coluna de conta e corrigir Dashboard
-- Execute este script no Supabase SQL Editor

-- 1. Adicionar coluna account_name à tabela transactions
ALTER TABLE public.transactions 
ADD COLUMN account_name VARCHAR(50) DEFAULT 'Conta PJ';

-- 2. Atualizar transações existentes para ter conta
UPDATE public.transactions 
SET account_name = 'Conta PJ' 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND account_name IS NULL;

-- 3. Verificar estrutura atualizada
SELECT '=== ESTRUTURA ATUALIZADA ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Verificar transações com conta
SELECT '=== TRANSAÇÕES COM CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name;

-- 5. Criar algumas transações de exemplo para Conta Checkout
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-08', 'PAGAMENTO CHECKOUT 1', 100.00, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-08-08', 'PAGAMENTO CHECKOUT 2', 150.00, 'income', 'Conta Checkout', NOW(), NOW());

-- 6. Verificar resultado final
SELECT '=== RESULTADO FINAL ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name
ORDER BY account_name; 