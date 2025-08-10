-- =====================================================
-- CORRIGIR STATUS DE USUÁRIOS NO TRIAL
-- =====================================================

-- 1. VERIFICAR USUÁRIOS ATUAIS
SELECT 
    '=== USUÁRIOS ATUAIS ===' as info,
    user_id,
    plan_type,
    status,
    trial_ends_at,
    started_at,
    created_at
FROM public.subscriptions
ORDER BY created_at DESC;

-- 2. CORRIGIR USUÁRIOS QUE DEVERIAM ESTAR NO TRIAL
-- Usuários com status 'active' mas ainda dentro do período de trial
UPDATE public.subscriptions 
SET status = 'trial'
WHERE status = 'active' 
  AND trial_ends_at IS NOT NULL 
  AND trial_ends_at > NOW()
  AND user_id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'; -- Não alterar usuário master

-- 3. CRIAR TRIAL PARA USUÁRIOS SEM ASSINATURA
DO $$
DECLARE
    user_record RECORD;
BEGIN
    FOR user_record IN 
        SELECT id FROM auth.users 
        WHERE id NOT IN (SELECT user_id FROM public.subscriptions)
        AND id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    LOOP
        BEGIN
            INSERT INTO public.subscriptions (
                user_id,
                plan_type,
                status,
                trial_ends_at,
                monthly_transaction_limit,
                user_limit,
                client_limit
            ) VALUES (
                user_record.id,
                'starter',
                'trial',
                NOW() + INTERVAL '14 days',
                100,
                1,
                10
            );
            
            RAISE NOTICE 'Trial criado para usuário: %', user_record.id;
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Erro ao criar trial para usuário %: %', user_record.id, SQLERRM;
        END;
    END LOOP;
END $$;

-- 4. VERIFICAR RESULTADO FINAL
SELECT 
    '=== RESULTADO FINAL ===' as info,
    user_id,
    plan_type,
    status,
    trial_ends_at,
    CASE 
        WHEN trial_ends_at > NOW() THEN 'Dentro do trial'
        ELSE 'Trial expirado'
    END as trial_status,
    CASE 
        WHEN trial_ends_at > NOW() THEN 
            EXTRACT(DAY FROM (trial_ends_at - NOW()))
        ELSE 0
    END as dias_restantes
FROM public.subscriptions
ORDER BY created_at DESC;

-- 5. VERIFICAR USUÁRIOS SEM ASSINATURA
SELECT 
    '=== USUÁRIOS SEM ASSINATURA ===' as info,
    id as user_id,
    email
FROM auth.users 
WHERE id NOT IN (SELECT user_id FROM public.subscriptions)
AND id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
