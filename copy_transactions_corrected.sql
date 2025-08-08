-- Script para copiar transações (versão corrigida)
-- Baseado na estrutura real da tabela transactions

-- Verificar transações existentes do usuário destino
SELECT '=== TRANSAÇÕES EXISTENTES DO USUÁRIO DESTINO ===' as info;
SELECT COUNT(*) as total_transacoes FROM public.transactions WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0';

-- Verificar transações do usuário origem
SELECT '=== TRANSAÇÕES DO USUÁRIO ORIGEM ===' as info;
SELECT COUNT(*) as total_transacoes FROM public.transactions WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar algumas transações de exemplo do usuário origem
SELECT '=== EXEMPLOS DE TRANSAÇÕES DO USUÁRIO ORIGEM ===' as info;
SELECT transaction_date, description, amount, transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY transaction_date DESC
LIMIT 5;

-- Copiar transações (versão simplificada sem client_id e account_id)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at)
SELECT 
    '76868410-a183-47b7-8173-7f3bcb4d90e0' as user_id,
    transaction_date,
    description,
    amount,
    transaction_type,
    created_at,
    updated_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND NOT EXISTS (
    SELECT 1 FROM public.transactions 
    WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
);

-- Verificar resultado final
SELECT '=== RESULTADO FINAL ===' as info;
SELECT 'Transações totais do usuário destino:', COUNT(*) FROM public.transactions WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0';

-- Verificar se as transações de julho foram copiadas
SELECT '=== TRANSAÇÕES DE JULHO COPIADAS ===' as info;
SELECT COUNT(*) as transacoes_julho FROM public.transactions 
WHERE user_id = '76868410-a183-47b7-8173-7f3bcb4d90e0'
AND transaction_date >= '2025-07-01' 
AND transaction_date <= '2025-07-31'; 