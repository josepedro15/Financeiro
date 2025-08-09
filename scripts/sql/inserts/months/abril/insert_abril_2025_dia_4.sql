-- Script para inserir dados de 4 de abril 2025
-- Execute este script no Supabase SQL Editor

-- 4/4/2025 - R$ 456.95 (12 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LARISSA BUSATO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'THAIS DE OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ELOILSON COUTO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'FABIANA SOUZA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'EDGAR DA SILVA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LILIAN VIEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LUANA GABRIELLE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LUANA ELAINE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'SANDRA MICHELINI', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'PAULA DANIELA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ANTONIO FH L SANTANA', 17.45, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'NADYA ADRIANY', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- Verificar resultado
SELECT '=== VERIFICAÇÃO DIA 4 ABRIL ===' as info;

SELECT
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-04-04'; 