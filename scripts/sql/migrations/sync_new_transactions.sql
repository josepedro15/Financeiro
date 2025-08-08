-- Script para sincronizar apenas transações novas
-- Execute este script sempre que quiser sincronizar dados novos

-- Verificar transações mais recentes do usuário origem
SELECT '=== TRANSAÇÕES MAIS RECENTES DO USUÁRIO ORIGEM ===' as info;
SELECT transaction_date, description, amount, transaction_type, created_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 5;

-- Copiar apenas transações que ainda não existem no usuário destino
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at)
SELECT 
    '76868410-a183-47b7-8173-7f3bcb4d90e0' as user_id,
    t1.transaction_date,
    t1.description,
    t1.amount,
    t1.transaction_type,
    t1.created_at,
    t1.updated_at
FROM public.transactions t1
WHERE t1.user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND NOT EXISTS (
    SELECT 1 FROM public.transactions t2
    WHERE t2.user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
    AND t2.transaction_date = t1.transaction_date
    AND t2.amount = t1.amount
    AND t2.description = t1.description
);

-- Verificar quantas transações foram sincronizadas
SELECT '=== TRANSAÇÕES SINCRONIZADAS ===' as info;
SELECT COUNT(*) as novas_transacoes FROM public.transactions 
WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
AND created_at >= NOW() - INTERVAL '1 hour'; 