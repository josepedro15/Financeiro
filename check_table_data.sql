-- Script para verificar todos os campos da tabela transactions
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- Verificar todos os campos das transações de receita
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    client_name,
    account_name,
    created_at,
    updated_at
FROM public.transactions 
WHERE transaction_type = 'income'
ORDER BY created_at DESC
LIMIT 10; 