-- Script simples para verificar as datas das transações de receita
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- Verificar datas das transações de receita
SELECT 
    transaction_date,
    amount,
    description,
    EXTRACT(YEAR FROM transaction_date) as year,
    EXTRACT(MONTH FROM transaction_date) as month,
    EXTRACT(DAY FROM transaction_date) as day
FROM public.transactions 
WHERE transaction_type = 'income'
ORDER BY transaction_date DESC
LIMIT 10; 