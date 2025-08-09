-- Script para inserir dados de junho 2025 (dias 28 e 30)
-- Execute este script no Supabase SQL Editor
-- NÃO APAGA NADA EXISTENTE - APENAS ADICIONA

-- 6/28/2025 - R$ 115.91 (2 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-28', 'SUELEN CONSOLAÇÃO SOUZA', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-28', 'JAQUELINE DIAS', 40.00, 'income', 'Conta PJ', NOW(), NOW());

-- 6/30/2025 - R$ 339.59 (6 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'FERNANDA PEREIRA', 39.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'RENE AMARU', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ROSEANE FRANÇA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'JUCIENE MORATO', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ACAII PARA COMERCIO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ISABELA NASCIMENTO', 67.92, 'income', 'Conta Checkout', NOW(), NOW());

-- Verificar resultado final
SELECT '=== VERIFICAÇÃO FINAL JUNHO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_junho,
  SUM(amount) as faturamento_total_junho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_junho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-06-01' 
  AND transaction_date <= '2025-06-30';

-- Verificar por dia
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-06-01' 
  AND transaction_date <= '2025-06-30'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Verificar por conta
SELECT '=== VERIFICAÇÃO POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-06-01' 
  AND transaction_date <= '2025-06-30'
GROUP BY account_name
ORDER BY account_name; 