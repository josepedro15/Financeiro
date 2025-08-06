-- Alter transactions table to change client_id to client_name as text field
ALTER TABLE public.transactions 
DROP CONSTRAINT IF EXISTS transactions_client_id_fkey;

ALTER TABLE public.transactions 
DROP COLUMN IF EXISTS client_id;

ALTER TABLE public.transactions 
ADD COLUMN client_name VARCHAR(255); 