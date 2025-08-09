-- Script para inserir transações finais de junho de 2025
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- 6/23/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-23', 'WILLIAN RAMOS', 39.95, 'income', NOW(), NOW());

-- 6/24/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELIANA CRISTINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELIANA KATIA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-24', 'ELANIA KAZOTTI', 39.90, 'income', NOW(), NOW());

-- 6/25/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'RENATO SOUZA', 64.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'WILLIAN RAMOS', 39.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-25', 'MARISTELA DE SORDI', 39.95, 'income', NOW(), NOW());

-- 6/26/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'STUDIO LM', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'CLEITON FERREIRA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'DAIANE FLAVIA', 37.75, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-26', 'SANDRA FATIMA', 75.91, 'income', NOW(), NOW());

-- 6/27/2025 (primeira parte)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'VANUSA CRISTINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'LEISSANDRO MOREIRA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'FANESCA FATIMA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'CARLA OLIVEIRA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'IRACEMA GONZAGA', 35.00, 'income', NOW(), NOW());

-- 6/27/2025 (segunda parte)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'SUELEN CONSOLAÇÃO SOUZA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-27', 'JAQUELINE DIAS', 40.00, 'income', NOW(), NOW());

-- 6/30/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'FERNANDA PEREIRA', 39.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'RENE AMARU', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ROSEANE FRANÇA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'JUCIENE MORATO', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ACAII PARA COMERCIO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-06-30', 'ISABELA NASCIMENTO', 67.92, 'income', NOW(), NOW());

-- Verificar total de transações inseridas
SELECT '=== TOTAL DE TRANSAÇÕES INSERIDAS ===' as info;
SELECT COUNT(*) as total_transacoes FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-06-23' 
AND transaction_date <= '2025-06-30';

-- Verificar total geral de junho
SELECT '=== TOTAL GERAL DE JUNHO ===' as info;
SELECT COUNT(*) as total_junho FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-06-01' 
AND transaction_date <= '2025-06-30'; 