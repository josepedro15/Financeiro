-- Script para investigar problemas com trial de usuários
-- Execute este script no Supabase SQL Editor

SELECT '=== INVESTIGAÇÃO SISTEMA DE ASSINATURAS ===' as info;

-- 1. Verificar se as tabelas existem
SELECT 
    'TABELAS EXISTENTES:' as status,
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
    AND table_name IN ('subscriptions', 'usage_tracking')
ORDER BY table_name;

-- 2. Verificar assinaturas existentes
SELECT 
    '=== ASSINATURAS ATIVAS ===' as info,
    user_id,
    plan_type,
    status,
    trial_ends_at,
    CASE 
        WHEN trial_ends_at IS NOT NULL AND trial_ends_at > NOW() THEN 'TRIAL ATIVO'
        WHEN trial_ends_at IS NOT NULL AND trial_ends_at <= NOW() THEN 'TRIAL EXPIRADO'
        ELSE 'SEM TRIAL'
    END as trial_status,
    monthly_transaction_limit,
    user_limit,
    client_limit,
    created_at
FROM public.subscriptions
ORDER BY created_at DESC;

-- 3. Verificar uso atual
SELECT 
    '=== USO ATUAL ===' as info,
    ut.user_id,
    ut.month_year,
    ut.transactions_count,
    ut.users_count,
    ut.clients_count,
    s.plan_type,
    s.monthly_transaction_limit
FROM public.usage_tracking ut
LEFT JOIN public.subscriptions s ON ut.user_id = s.user_id
ORDER BY ut.created_at DESC;

-- 4. Testar função check_plan_limits para usuários específicos
SELECT 
    '=== TESTE FUNÇÃO LIMITS ===' as info,
    user_id,
    'Resultado da função:' as teste
FROM public.subscriptions
LIMIT 1;

-- Para cada usuário, testar a função
DO $$
DECLARE
    test_user_id UUID;
    result_record RECORD;
BEGIN
    -- Pegar um usuário de teste (não master)
    SELECT user_id INTO test_user_id 
    FROM public.subscriptions 
    WHERE user_id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    LIMIT 1;
    
    IF test_user_id IS NOT NULL THEN
        -- Testar função
        SELECT * INTO result_record
        FROM public.check_plan_limits(test_user_id, 'transaction');
        
        RAISE NOTICE 'Usuário: %, Permitido: %, Uso atual: %, Limite: %, Plano: %', 
            test_user_id, 
            result_record.allowed, 
            result_record.current_count, 
            result_record.limit_count, 
            result_record.plan_type;
    END IF;
END $$;

-- 5. Verificar usuário master
SELECT 
    '=== USUÁRIO MASTER ===' as info,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM public.subscriptions 
            WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
        ) THEN 'MASTER CONFIGURADO'
        ELSE 'MASTER NÃO ENCONTRADO'
    END as master_status;

-- 6. Verificar políticas RLS
SELECT 
    '=== POLÍTICAS RLS ===' as info,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public' 
    AND tablename IN ('subscriptions', 'usage_tracking')
ORDER BY tablename, policyname;
