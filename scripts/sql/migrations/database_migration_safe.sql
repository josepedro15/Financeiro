-- Migração segura para alterar os campos client_id e account_id para texto livre
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Verificar e alterar campo client_id para client_name (se necessário)
DO $$
BEGIN
    -- Verificar se client_name não existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'transactions' 
        AND column_name = 'client_name'
        AND table_schema = 'public'
    ) THEN
        -- Remover constraint se existir
        ALTER TABLE public.transactions 
        DROP CONSTRAINT IF EXISTS transactions_client_id_fkey;
        
        -- Remover coluna antiga se existir
        ALTER TABLE public.transactions 
        DROP COLUMN IF EXISTS client_id;
        
        -- Adicionar nova coluna
        ALTER TABLE public.transactions 
        ADD COLUMN client_name VARCHAR(255);
        
        RAISE NOTICE 'Coluna client_name criada com sucesso';
    ELSE
        RAISE NOTICE 'Coluna client_name já existe';
    END IF;
END $$;

-- 2. Verificar e alterar campo account_id para account_name (se necessário)
DO $$
BEGIN
    -- Verificar se account_name não existe
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'transactions' 
        AND column_name = 'account_name'
        AND table_schema = 'public'
    ) THEN
        -- Remover constraint se existir
        ALTER TABLE public.transactions 
        DROP CONSTRAINT IF EXISTS transactions_account_id_fkey;
        
        -- Remover coluna antiga se existir
        ALTER TABLE public.transactions 
        DROP COLUMN IF EXISTS account_id;
        
        -- Adicionar nova coluna
        ALTER TABLE public.transactions 
        ADD COLUMN account_name VARCHAR(50) NOT NULL DEFAULT 'Conta PJ';
        
        RAISE NOTICE 'Coluna account_name criada com sucesso';
    ELSE
        RAISE NOTICE 'Coluna account_name já existe';
    END IF;
END $$;

-- 3. Verificar estrutura final da tabela
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND table_schema = 'public'
ORDER BY ordinal_position; 