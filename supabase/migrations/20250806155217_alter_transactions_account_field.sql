-- Alter transactions table to change account_id to account_name as text field
ALTER TABLE public.transactions 
DROP CONSTRAINT IF EXISTS transactions_account_id_fkey;

ALTER TABLE public.transactions 
DROP COLUMN IF EXISTS account_id;

ALTER TABLE public.transactions 
ADD COLUMN account_name VARCHAR(50) NOT NULL DEFAULT 'Conta PJ'; 