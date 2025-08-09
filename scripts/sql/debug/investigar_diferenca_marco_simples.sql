-- Script simples para investigar diferença em março 2025
-- Diferença: R$ 1.221,99 a mais que o esperado

-- 1. Total geral
SELECT COUNT(*) as total_transacoes, SUM(amount) as valor_total
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar lançamentos de META (separadamente)
SELECT *
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (description LIKE '%META%' OR client_name LIKE '%META%' OR description LIKE '%SALDO%');

-- 3. Maiores valores (acima de R$ 200)
SELECT transaction_date, client_name, amount, account_name
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND amount > 200
ORDER BY amount DESC;

-- 4. Verificar valores exatos das metas conhecidas
SELECT *
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND amount IN (1200, 2094.32)
ORDER BY transaction_date;
