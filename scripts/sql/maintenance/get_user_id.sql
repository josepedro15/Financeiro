-- Script para descobrir o user_id
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- Verificar se há usuários na tabela auth.users
SELECT 
    id,
    email,
    created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 5;

-- Verificar se há transações existentes para descobrir o user_id
SELECT 
    user_id,
    COUNT(*) as total_transactions,
    MIN(created_at) as first_transaction,
    MAX(created_at) as last_transaction
FROM public.transactions 
GROUP BY user_id
ORDER BY total_transactions DESC;

-- Verificar estrutura da tabela transactions
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position; 