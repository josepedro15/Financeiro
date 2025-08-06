-- Script para verificar o formato das datas das transações
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Verificar estrutura da tabela transactions
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar algumas transações com suas datas
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    client_name,
    account_name,
    created_at
FROM public.transactions 
ORDER BY created_at DESC
LIMIT 10;

-- 3. Verificar tipos de transação
SELECT 
    transaction_type,
    COUNT(*) as total,
    SUM(amount) as total_amount
FROM public.transactions 
GROUP BY transaction_type;

-- 4. Verificar distribuição por mês/ano
SELECT 
    EXTRACT(YEAR FROM transaction_date) as year,
    EXTRACT(MONTH FROM transaction_date) as month,
    transaction_type,
    COUNT(*) as total_transactions,
    SUM(amount) as total_amount
FROM public.transactions 
GROUP BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date), transaction_type
ORDER BY year DESC, month DESC;

-- 5. Verificar se há transações de receita
SELECT 
    COUNT(*) as total_income_transactions,
    SUM(amount) as total_income_amount
FROM public.transactions 
WHERE transaction_type = 'income'; 