-- Migração para alterar o campo client_id para client_name como texto livre
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Remover a constraint de foreign key (se existir)
ALTER TABLE public.transactions 
DROP CONSTRAINT IF EXISTS transactions_client_id_fkey;

-- 2. Remover a coluna client_id
ALTER TABLE public.transactions 
DROP COLUMN IF EXISTS client_id;

-- 3. Adicionar a nova coluna client_name como texto
ALTER TABLE public.transactions 
ADD COLUMN client_name VARCHAR(255);

-- 4. Verificar se a alteração foi aplicada
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position; 