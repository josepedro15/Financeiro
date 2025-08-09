-- Script para encontrar duplicatas em março 2025
-- Diferença: R$ 1.222,19 sem lançamentos de META

-- 1. Procurar duplicatas exatas (mesmo cliente, valor, data)
SELECT 
    'DUPLICATAS EXATAS:' as tipo,
    client_name,
    amount,
    transaction_date,
    account_name,
    COUNT(*) as quantidade,
    (COUNT(*) * amount) as valor_total_duplicado
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY client_name, amount, transaction_date, account_name
HAVING COUNT(*) > 1
ORDER BY (COUNT(*) * amount) DESC;

-- 2. Procurar duplicatas por cliente e data (mesmo cliente, mesma data, valores diferentes)
SELECT 
    'MESMO CLIENTE/DATA:' as tipo,
    client_name,
    transaction_date,
    COUNT(*) as quantidade_transacoes,
    STRING_AGG(amount::text, ', ') as valores,
    SUM(amount) as total_cliente_dia
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY client_name, transaction_date
HAVING COUNT(*) > 1
ORDER BY SUM(amount) DESC;

-- 3. Verificar os 20 maiores valores para identificar anomalias
SELECT 
    'MAIORES VALORES:' as tipo,
    transaction_date,
    client_name,
    amount,
    account_name,
    description,
    ROW_NUMBER() OVER (ORDER BY amount DESC) as ranking
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
ORDER BY amount DESC
LIMIT 20;

-- 4. Verificar valores suspeitos (muito diferentes do padrão R$ 39,95)
SELECT 
    'VALORES ATÍPICOS:' as tipo,
    transaction_date,
    client_name,
    amount,
    account_name,
    CASE 
        WHEN amount > 150 THEN 'Muito alto'
        WHEN amount < 20 THEN 'Muito baixo'
        WHEN amount NOT IN (39.95, 40.00, 39.90, 75.91, 113.81, 67.92) THEN 'Valor incomum'
        ELSE 'Normal'
    END as categoria
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND (
    amount > 150 OR 
    amount < 20 OR 
    amount NOT IN (39.95, 40.00, 39.90, 75.91, 113.81, 67.92, 76.00, 64.90, 99.90, 79.90, 132.81, 54.90, 35.96, 30.00, 25.00, 5.00, 0.00, 20.00, 37.95, 41.95, 36.00, 39.99, 39.02, 39.00, 39.50)
  )
ORDER BY amount DESC;
