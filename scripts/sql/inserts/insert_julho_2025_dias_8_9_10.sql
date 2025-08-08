-- Script para inserir dados de julho 2025 (dias 8, 9 e 10)
-- Execute este script no Supabase SQL Editor
-- NÃO APAGA NADA EXISTENTE - APENAS ADICIONA

-- 7/8/2025 - R$ 538.53 (11 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'MIRELLA TESSAROLLO', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'MARCELO DEL', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'THALITA RIBEIRO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'GIOVANI PEIXOTO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'MARIA APARECIDA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'RONALDO VARAO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'LUCIANA DE OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'ALECSANDRA OLIVEIRA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'ANGELICA BRAUN', 75.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'ISAAC DA SILVA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'DALVA HELENA', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 7/9/2025 - R$ 453.62 (8 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'NATALLI DA SILVA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'FERNANDA VALLERIO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'FRANCISCA RODRIGUES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'NEILTA LIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'JAIRO EUSTAQUIO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'ANA LUCIA', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'JULIANA SANTOS', 52.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-09', 'RENATA CARDOSO', 70.00, 'income', 'Conta PJ', NOW(), NOW());

-- 7/10/2025 - R$ 378.63 (8 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'VALDIR JOSE', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'TATIELLE MARQUES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'MARIANA DIAS', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'DALVA HELENA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'MAGDA COSTA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'SULAMITA MOREIRA', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'LEILLIANE SILVA', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-10', 'I. C. DE BRITO', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- Verificar resultado final
SELECT '=== VERIFICAÇÃO FINAL JULHO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho,
  SUM(amount) as faturamento_total_julho,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- Verificar por dia
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
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
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
GROUP BY account_name
ORDER BY account_name; 