-- DIAGNÓSTICO ESPECÍFICO PARA USUÁRIO 2dc520e3-5f19-4dfe-838b-1aca7238ae36
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se o usuário existe
SELECT '=== VERIFICANDO USUÁRIO ===' as info;
SELECT 
    id,
    email,
    created_at,
    last_sign_in_at
FROM auth.users 
WHERE id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar se o usuário tem perfil
SELECT '=== VERIFICANDO PERFIL ===' as info;
SELECT 
    id,
    email,
    full_name,
    created_at
FROM public.profiles 
WHERE id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 3. Verificar se o usuário tem assinatura
SELECT '=== VERIFICANDO ASSINATURA ===' as info;
SELECT 
    id,
    user_id,
    plan_type,
    status,
    started_at,
    expires_at,
    trial_ends_at
FROM public.subscriptions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Verificar transações existentes do usuário
SELECT '=== TRANSAÇÕES EXISTENTES ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total,
    COUNT(DISTINCT DATE(transaction_date)) as dias_unicos
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total,
    COUNT(DISTINCT DATE(transaction_date)) as dias_unicos
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 5. Verificar políticas RLS atuais
SELECT '=== POLÍTICAS RLS ATUAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, policyname;

-- 6. Testar se o usuário pode ver suas próprias transações
SELECT '=== TESTE DE VISUALIZAÇÃO ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 7. Testar inserção como o usuário específico
SELECT '=== TESTE DE INSERÇÃO ===' as info;

-- Simular o contexto do usuário
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claim.sub" TO '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Tentar inserir na tabela principal
INSERT INTO transactions (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE USUÁRIO ESPECÍFICO - 12/08/2025', 
    2000.00, 
    'income', 
    'teste_usuario', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, created_at;

-- 8. Verificar se foi inserida
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    created_at
FROM transactions 
WHERE description = 'TESTE USUÁRIO ESPECÍFICO - 12/08/2025'
ORDER BY created_at DESC;

-- 9. Limpar teste
SELECT '=== LIMPANDO TESTE ===' as info;
DELETE FROM transactions 
WHERE description = 'TESTE USUÁRIO ESPECÍFICO - 12/08/2025';

-- 10. Verificar se há problemas específicos com o usuário
SELECT '=== VERIFICANDO PROBLEMAS ESPECÍFICOS ===' as info;

-- Verificar se o usuário está em alguma organização
SELECT 
    'organization_members' as tabela,
    COUNT(*) as registros
FROM organization_members 
WHERE owner_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
   OR member_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Verificar se há triggers ou constraints específicas
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table IN ('transactions', 'transactions_2025_08')
ORDER BY trigger_name;

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as info;
