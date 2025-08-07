-- Script para inserir dados de junho 2025 (dias 16, 17 e 18)
-- Execute este script no Supabase SQL Editor
-- NÃO APAGA NADA EXISTENTE - APENAS ADICIONA

-- 6/16/2025 - R$ 455.72 (11 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'JAQUELINE DOS REIS', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'JOAO RINALDO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'MIGUEL SOARES', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'CELIO FERREIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'SELMO LOPES', 50.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'LUANA MARIA', 34.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'MAIK DOUGLAS', 10.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'MARCIA DA SILVA', 65.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'CRISTIANA DE SOUZA', 45.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'GENEROSA DE OLIVEIRA', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-16', 'VAURY ALVES', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- 6/17/2025 - R$ 67.92 (2 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-17', 'ALZENIRA', 33.96, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-17', 'ESTEFANIA ALVES', 33.96, 'income', 'Conta PJ', NOW(), NOW());

-- 6/18/2025 - R$ 225.24 (6 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'COWORKING NEGOCIOS', 10.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'ELOI ADOLFO', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'GENOEVA DOS SANTOS', 39.50, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'ELIZANGELA BRITO', 27.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'JAMILE DE JESUS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-18', 'ELCIMAR ALVES', 39.95, 'income', 'Conta PJ', NOW(), NOW());

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