-- Script para verificar e corrigir dados das transações existentes
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Verificar estrutura atual da tabela
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar transações existentes
SELECT 
    COUNT(*) as total_transactions,
    COUNT(CASE WHEN client_name IS NOT NULL THEN 1 END) as with_client_name,
    COUNT(CASE WHEN account_name IS NOT NULL THEN 1 END) as with_account_name,
    COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as income_transactions,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as expense_transactions
FROM public.transactions;

-- 3. Mostrar algumas transações para verificar
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

-- 4. Se account_name estiver vazio, definir como 'Conta PJ' (padrão)
UPDATE public.transactions 
SET account_name = 'Conta PJ'
WHERE account_name IS NULL OR account_name = '';

-- 5. Verificar resultado final
SELECT 
    'Transações totais' as status,
    COUNT(*) as total
FROM public.transactions 
UNION ALL
SELECT 
    'Com client_name' as status,
    COUNT(*) as total
FROM public.transactions 
WHERE client_name IS NOT NULL AND client_name != ''
UNION ALL
SELECT 
    'Com account_name' as status,
    COUNT(*) as total
FROM public.transactions 
WHERE account_name IS NOT NULL AND account_name != ''; 