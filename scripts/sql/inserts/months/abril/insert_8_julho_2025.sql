-- Script para inserir transações de 8/7/2025
-- Execute este script no Supabase SQL Editor

-- Inserir transações de 8/7/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'MARIA LEIDIANE', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'CLENIA MARIA', 64.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'JHONES WERTER', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-07-08', 'IRACEMA JANUARIA', 39.95, 'income', NOW(), NOW());

-- Verificar se foram inseridas corretamente
SELECT '=== VERIFICAÇÃO DAS TRANSAÇÕES INSERIDAS ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-07-08'
ORDER BY description;

-- Verificar total do dia
SELECT '=== TOTAL DO DIA 8/7/2025 ===' as info;

SELECT 
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date = '2025-07-08'; 