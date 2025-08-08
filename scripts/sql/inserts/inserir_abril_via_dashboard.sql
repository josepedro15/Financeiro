-- Script para inserir abril via Dashboard (execute quando estiver logado)
-- Execute este script no Supabase SQL Editor quando estiver logado

-- 1. Verificar se está logado
SELECT '=== VERIFICAR LOGIN ===' as info;

SELECT 
  auth.uid() as user_id_logado,
  '2dc520e3-5f19-4dfe-838b-1aca7238ae36' as user_id_esperado;

-- 2. Inserir apenas algumas transações de teste primeiro
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'TESTE ABRIL 1', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'TESTE ABRIL 2', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'TESTE ABRIL 3', 40.00, 'income', NOW(), NOW());

-- 3. Verificar se funcionou
SELECT '=== VERIFICAR INSERÇÃO ===' as info;

SELECT
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
  AND transaction_type = 'income'; 