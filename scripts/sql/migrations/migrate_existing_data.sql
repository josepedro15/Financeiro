-- Script para migrar dados existentes das transações
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- 1. Atualizar client_name com dados dos clientes existentes
UPDATE public.transactions 
SET client_name = (
    SELECT c.name 
    FROM public.clients c 
    WHERE c.id = transactions.client_id
)
WHERE client_id IS NOT NULL 
AND client_name IS NULL;

-- 2. Atualizar account_name com dados das contas existentes
UPDATE public.transactions 
SET account_name = (
    SELECT 
        CASE 
            WHEN a.code LIKE '1%' THEN 'Conta PJ'
            WHEN a.code LIKE '2%' THEN 'Conta Checkout'
            ELSE 'Conta PJ'
        END
    FROM public.accounts a 
    WHERE a.id = transactions.account_id
)
WHERE account_id IS NOT NULL 
AND account_name = 'Conta PJ';

-- 3. Verificar quantas transações foram atualizadas
SELECT 
    'Transações com client_name preenchido' as status,
    COUNT(*) as total
FROM public.transactions 
WHERE client_name IS NOT NULL
UNION ALL
SELECT 
    'Transações com account_name preenchido' as status,
    COUNT(*) as total
FROM public.transactions 
WHERE account_name IS NOT NULL;

-- 4. Mostrar algumas transações para verificar
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    client_name,
    account_name
FROM public.transactions 
ORDER BY created_at DESC
LIMIT 10; 