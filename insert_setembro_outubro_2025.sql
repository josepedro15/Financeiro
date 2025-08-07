-- Script para inserir transações de setembro e outubro 2025
-- Execute este script no Supabase SQL Editor

-- 7/9/2025 (SETEMBRO) - NATALLI DA SILVA, FERNANDA VALLERIO, FRANCISCA RODRIGUES, NEILTA LIRA, JAIRO EUSTAQUIO, ANA LUCIA, JULIANA SANTOS, RENATA CARDOSO
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'NATALLI DA SILVA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'FERNANDA VALLERIO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'FRANCISCA RODRIGUES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'NEILTA LIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'JAIRO EUSTAQUIO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'ANA LUCIA', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'JULIANA SANTOS', 52.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-09-07', 'RENATA CARDOSO', 70.00, 'income', 'Conta PJ', NOW(), NOW());

-- 7/10/2025 (OUTUBRO) - VALDIR JOSE, TATIELLE MARQUES, MARIANA DIAS, DALVA HELENA, MAGDA COSTA, SULAMITA MOREIRA, LEILLIANE SILVA, I. C. DE BRITO
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'VALDIR JOSE', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'TATIELLE MARQUES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'MARIANA DIAS', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'DALVA HELENA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'MAGDA COSTA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'SULAMITA MOREIRA', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'LEILLIANE SILVA', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-10-07', 'I. C. DE BRITO', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- Verificar resultado de setembro
SELECT '=== VERIFICAÇÃO SETEMBRO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_setembro,
  SUM(amount) as faturamento_total_setembro,
  ROUND(SUM(amount), 2) as faturamento_arredondado_setembro
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-09-01' 
  AND transaction_date <= '2025-09-30';

-- Verificar resultado de outubro
SELECT '=== VERIFICAÇÃO OUTUBRO ===' as info;

SELECT 
  COUNT(*) as total_transacoes_outubro,
  SUM(amount) as faturamento_total_outubro,
  ROUND(SUM(amount), 2) as faturamento_arredondado_outubro
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-10-01' 
  AND transaction_date <= '2025-10-31';

-- Verificar por conta em setembro
SELECT '=== SETEMBRO POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-09-01' 
  AND transaction_date <= '2025-09-30'
GROUP BY account_name
ORDER BY account_name;

-- Verificar por conta em outubro
SELECT '=== OUTUBRO POR CONTA ===' as info;

SELECT 
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-10-01' 
  AND transaction_date <= '2025-10-31'
GROUP BY account_name
ORDER BY account_name; 