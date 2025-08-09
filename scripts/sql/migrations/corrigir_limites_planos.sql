-- Script para corrigir os limites dos planos
-- Execute este script para atualizar os limites para os valores corretos

-- Atualizar limites do plano Starter
UPDATE public.subscriptions 
SET 
    monthly_transaction_limit = 100,
    user_limit = 1,
    client_limit = 10
WHERE plan_type = 'starter' AND status IN ('trial', 'active');

-- Atualizar limites do plano Business  
UPDATE public.subscriptions 
SET 
    monthly_transaction_limit = 1000,
    user_limit = 3,
    client_limit = 50
WHERE plan_type = 'business' AND status IN ('trial', 'active');

-- Verificar as correções aplicadas
SELECT 
    user_id,
    plan_type,
    status,
    monthly_transaction_limit,
    user_limit,
    client_limit,
    CASE 
        WHEN plan_type = 'starter' AND monthly_transaction_limit = 100 AND user_limit = 1 AND client_limit = 10 THEN '✅ Starter OK'
        WHEN plan_type = 'business' AND monthly_transaction_limit = 1000 AND user_limit = 3 AND client_limit = 50 THEN '✅ Business OK'
        ELSE '❌ Precisa correção'
    END as status_correcao
FROM public.subscriptions 
WHERE status IN ('trial', 'active')
ORDER BY plan_type, created_at DESC;

-- Mostrar resumo das correções
SELECT 
    plan_type,
    COUNT(*) as total_assinaturas,
    AVG(monthly_transaction_limit) as media_transacoes,
    AVG(user_limit) as media_usuarios,
    AVG(client_limit) as media_clientes
FROM public.subscriptions 
WHERE status IN ('trial', 'active')
GROUP BY plan_type;
