-- Script para inserir dados de julho 2025
-- Execute este script no Supabase SQL Editor

-- PRIMEIRO: Apagar transações de julho existentes (se houver)
DELETE FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- 7/1/2025 - R$ 317.73 (5 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-01', 'ELAINE GONÇALVES', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-01', 'JAQUELINE DIAS', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-01', 'TATIANE SANTOS', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-01', 'PONTO CERTO', 50.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-01', 'ADRIANA ZELESKI', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- 7/2/2025 - R$ 415.65 (8 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'FERNANDA PEREIRA', 35.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'JOSE HARLEY', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'MAGDA COSTA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'THALITA RIBEIRO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'CIBELE APARECIDA', 20.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'EDIANE FERNANDES', 99.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'GLAUCIA RODRIGUES', 100.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-02', 'ELIANA CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 7/3/2025 - R$ 155.81 (3 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-03', 'CARLA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-03', 'MARCELO DEL', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-03', 'ALINE FRANCIELI', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- 7/4/2025 - R$ 165.91 (3 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-04', 'RANIELE CRUVINEL', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-04', 'GIOVANI PEIXOTO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-04', 'PONTO CERTO', 50.00, 'income', 'Conta PJ', NOW(), NOW());

-- 7/5/2025 - R$ 227.73 (3 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-05', 'SILVANA SACCHIERO', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-05', 'MARINA KRAUSE', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-05', 'RENATA DA SILVA', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- 7/7/2025 - R$ 518.40 (10 transações)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'LILIANE WRASSE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'LUCIANA DE OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'NEILTA LIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'THAIS SANTOS', 67.92, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'REGIANE GADELHA', 39.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'MAURO SERGIO', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'REGIANE GOMES', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'JULIANA SANTOS', 28.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'EMILLY VASCONCELOS', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-07', 'KELVIN M CORREIA', 75.91, 'income', 'Conta Checkout', NOW(), NOW());

-- Verificar resultado parcial
SELECT '=== VERIFICAÇÃO PARCIAL JULHO ===' as info;

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