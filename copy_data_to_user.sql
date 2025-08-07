-- Script para copiar todos os dados do usuário 2dc520e3-5f19-4dfe-838b-1aca7238ae36 
-- para o usuário 76868410-a183-47b7-8173-7f3bcb4d90e0

-- 1. Copiar contas (accounts)
INSERT INTO public.accounts (user_id, account_name, account_type, balance, created_at, updated_at)
SELECT 
    '76868410-a183-47b7-8173-7f3bcb4d90e0' as user_id,
    account_name,
    account_type,
    balance,
    created_at,
    updated_at
FROM public.accounts 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Copiar clientes (clients)
INSERT INTO public.clients (user_id, client_name, email, phone, address, created_at, updated_at)
SELECT 
    '76868410-a183-47b7-8173-7f3bcb4d90e0' as user_id,
    client_name,
    email,
    phone,
    address,
    created_at,
    updated_at
FROM public.clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 3. Copiar transações (transactions)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, client_id, account_id, created_at, updated_at)
SELECT 
    '76868410-a183-47b7-8173-7f3bcb4d90e0' as user_id,
    transaction_date,
    description,
    amount,
    transaction_type,
    client_id,
    account_id,
    created_at,
    updated_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Verificar se os dados foram copiados
SELECT 'Contas copiadas:' as info, COUNT(*) as total FROM public.accounts WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
UNION ALL
SELECT 'Clientes copiados:', COUNT(*) FROM public.clients WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
UNION ALL
SELECT 'Transações copiadas:', COUNT(*) FROM public.transactions WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'; 