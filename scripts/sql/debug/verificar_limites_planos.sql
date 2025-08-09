-- Script para verificar os limites atuais dos planos
-- Execute este script para ver os dados atuais

-- Verificar assinaturas existentes
SELECT 
    user_id,
    plan_type,
    status,
    monthly_transaction_limit,
    user_limit,
    client_limit,
    trial_ends_at,
    created_at
FROM public.subscriptions 
ORDER BY created_at DESC;

-- Verificar uso atual
SELECT 
    user_id,
    action_type,
    COUNT(*) as usage_count,
    MAX(created_at) as last_used
FROM public.usage_tracking 
GROUP BY user_id, action_type
ORDER BY user_id, action_type;

-- Verificar se há inconsistências nos limites
SELECT 
    s.user_id,
    s.plan_type,
    s.status,
    s.monthly_transaction_limit,
    s.user_limit,
    s.client_limit,
    CASE 
        WHEN s.plan_type = 'starter' AND s.monthly_transaction_limit != 100 THEN 'ERRO: Starter deve ter 100 transações'
        WHEN s.plan_type = 'business' AND s.monthly_transaction_limit != 1000 THEN 'ERRO: Business deve ter 1000 transações'
        ELSE 'OK'
    END as verificacao_transacoes,
    CASE 
        WHEN s.plan_type = 'starter' AND s.user_limit != 1 THEN 'ERRO: Starter deve ter 1 usuário'
        WHEN s.plan_type = 'business' AND s.user_limit != 3 THEN 'ERRO: Business deve ter 3 usuários'
        ELSE 'OK'
    END as verificacao_usuarios,
    CASE 
        WHEN s.plan_type = 'starter' AND s.client_limit != 10 THEN 'ERRO: Starter deve ter 10 clientes'
        WHEN s.plan_type = 'business' AND s.client_limit != 50 THEN 'ERRO: Business deve ter 50 clientes'
        ELSE 'OK'
    END as verificacao_clientes
FROM public.subscriptions s
WHERE s.status IN ('trial', 'active');
