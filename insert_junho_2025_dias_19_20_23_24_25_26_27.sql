-- Script para inserir dados de junho 2025 (dias 19, 20, 23, 24, 25, 26 e 27)
-- Execute este script no Supabase SQL Editor
-- NÃO APAGA NADA EXISTENTE - APENAS ADICIONA

-- 6/19/2025 - R$ 225.29 (5 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-19', 'JAQUELINE OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-19', 'LUMA APARECIDA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-19', 'DAIANE GRACIELA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-19', 'JAQUELINE DOS REIS', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-19', 'DAIANE SOUZA', 70.44, 'income', 'Conta PJ', NOW(), NOW());

-- 6/20/2025 - R$ 329.69 (8 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'WESLEY GUSTAVO', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'HERON JOSIAS', 33.96, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'JEAN BARBOSA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'JOAO RINALDO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'ADRIANA ALVES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'ESTEFANY REGINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'LUANA MARIA', 34.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-20', 'ESTEFANIA ALVES', 33.96, 'income', 'Conta PJ', NOW(), NOW());

-- 6/23/2025 - R$ 39.95 (1 transação)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-23', 'WILLIAN RAMOS', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 6/24/2025 - R$ 155.76 (3 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELIANA CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELIANA KATIA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELANIA KAZOTTI', 39.90, 'income', 'Conta PJ', NOW(), NOW());

-- 6/25/2025 - R$ 144.75 (3 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'RENATO SOUZA', 64.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'WILLIAN RAMOS', 39.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'MARISTELA DE SORDI', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 6/26/2025 - R$ 265.48 (4 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'STUDIO LM', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'CLEITON FERREIRA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'DAIANE FLAVIA', 37.75, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'SANDRA FATIMA', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- 6/27/2025 - R$ 194.85 (5 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'VANUSA CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'LEISSANDRO MOREIRA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'FANESCA FATIMA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'CARLA OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'IRACEMA GONZAGA', 35.00, 'income', 'Conta PJ', NOW(), NOW());

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