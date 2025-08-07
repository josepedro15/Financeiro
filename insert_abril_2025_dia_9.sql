-- Script para inserir dados de 9 de abril 2025
-- Execute este script no Supabase SQL Editor

-- 9/4/2025 - R$ 1,202.59 (25 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'DANIELY CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'CELIA APARECIDA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'MARTIM BARBOSA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'DAIANE GODOI', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'WEMERSON FERNANDO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'RAFAEL VILAR', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'CLAUDIA DE SOLZA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'OTANIEL TOYOTA', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'MARLENE LEDA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'LIVIA DA CASSIA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'MAIANE DE JESUS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'KATIA ANGELICA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'WESLEY SHAM', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'ROSELIA DE JESUS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'LUANA GABRIELLE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'ADRIANA PANCOTI', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'ANDREA MARQUES', 144.70, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'MARIA NEUMA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'LUZIA CRISTOFARO', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'SALETE DE FATIMA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'STELA GLEIDE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'VALDIANE CALDEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'ALESSANDRA MARINALVA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-09', 'ROSILEIDE ALVES', 40.00, 'income', 'Conta PJ', NOW(), NOW());

-- Verificar resultado
SELECT '=== VERIFICAÇÃO DIA 9 ABRIL ===' as info;

SELECT
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = '2025-04-09'; 