-- Script para inserir dados de julho 2025 (dias 29, 30 e 31 - ÚLTIMOS DIAS)
-- Execute este script no Supabase SQL Editor
-- NÃO APAGA NADA EXISTENTE - APENAS ADICIONA

-- 7/29/2025 - R$ 389.69 (9 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'ELAINE ESPIRIDIÃO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'CLAUDIA PEDROZO', 67.92, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'ADENIR RAQUEL', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'LETICIA NEUGEBAUER', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'IRIS ROSA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'ELAINE ESPIRIDIÃO', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'MARIA CRISTINA', 34.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'MARCIA FERNANDA', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-29', 'VETERINARIA CAES', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 7/30/2025 - R$ 291.77 (6 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'ANDREZA CRISPIM', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'TIAGO STAL', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'FRAN', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'ELISANGELA FERNANDES', 64.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'JANELICE BATISTA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-30', 'JANETE ROCHA', 40.00, 'income', 'Conta PJ', NOW(), NOW());

-- 7/31/2025 - R$ 338.61 (8 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'MARIA CRISTINA', 33.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'AMANDA FERNANDES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'REGINALDO APARECIDO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'FABRICIO LIMA', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'MAIK DOUGLAS', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'ALVARO OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'KARLA DE CARVALHO', 95.84, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-31', 'WALDIRENE', 34.00, 'income', 'Conta PJ', NOW(), NOW());

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