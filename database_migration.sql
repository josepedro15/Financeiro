-- Migração para alterar os campos client_id e account_id para texto livre
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Alterar campo client_id para client_name
ALTER TABLE public.transactions 
DROP CONSTRAINT IF EXISTS transactions_client_id_fkey;

ALTER TABLE public.transactions 
DROP COLUMN IF EXISTS client_id;

ALTER TABLE public.transactions 
ADD COLUMN client_name VARCHAR(255);

-- 2. Alterar campo account_id para account_name
ALTER TABLE public.transactions 
DROP CONSTRAINT IF EXISTS transactions_account_id_fkey;

ALTER TABLE public.transactions 
DROP COLUMN IF EXISTS account_id;

ALTER TABLE public.transactions 
ADD COLUMN account_name VARCHAR(50) NOT NULL DEFAULT 'Conta PJ';

-- 3. Verificar se as alterações foram aplicadas
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position; 