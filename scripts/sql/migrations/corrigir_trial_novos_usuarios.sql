-- Script para corrigir sistema de trial para novos usuários
-- Garantir que novos usuários tenham 14 dias de acesso ao plano Starter

SELECT '=== CORRIGINDO SISTEMA DE TRIAL ===' as status;

-- 1. Corrigir função is_user_in_trial para verificar status 'trial' em vez de 'active'
CREATE OR REPLACE FUNCTION public.is_user_in_trial(target_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    trial_end_date TIMESTAMP WITH TIME ZONE;
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- Usuário master nunca está em trial (tem acesso ilimitado)
    IF target_user_id = master_user_id THEN
        RETURN false;
    END IF;

    -- Verificar se usuário existe
    IF NOT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) THEN
        RETURN false;
    END IF;

    -- Buscar data de fim do trial (CORRIGIDO: verificar status 'trial')
    SELECT trial_ends_at INTO trial_end_date
    FROM public.subscriptions
    WHERE user_id = target_user_id AND status = 'trial';

    -- Se não encontrou ou não tem trial, retornar false
    IF trial_end_date IS NULL THEN
        RETURN false;
    END IF;

    -- Verificar se trial ainda está ativo
    RETURN trial_end_date > NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Corrigir função check_plan_limits para considerar trial corretamente
CREATE OR REPLACE FUNCTION public.check_plan_limits(
    target_user_id UUID,
    check_type VARCHAR DEFAULT 'transaction'
) RETURNS TABLE (
    allowed BOOLEAN,
    current_count INTEGER,
    limit_count INTEGER,
    plan_type VARCHAR
) AS $$
DECLARE
    user_subscription RECORD;
    current_month VARCHAR := TO_CHAR(NOW(), 'YYYY-MM');
    usage_record RECORD;
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
    is_trial_active BOOLEAN := false;
    user_exists BOOLEAN := false;
BEGIN
    -- USUÁRIO MASTER TEM ACESSO ILIMITADO
    IF target_user_id = master_user_id THEN
        RETURN QUERY SELECT 
            true as allowed,
            0 as current_count,
            999999 as limit_count,
            'unlimited'::VARCHAR as plan_type;
        RETURN;
    END IF;

    -- Verificar se o usuário existe na tabela auth.users
    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) INTO user_exists;
    
    IF NOT user_exists THEN
        RAISE EXCEPTION 'Usuário não encontrado na tabela auth.users';
    END IF;

    -- Buscar assinatura do usuário (incluindo trial)
    SELECT * INTO user_subscription
    FROM public.subscriptions
    WHERE user_id = target_user_id AND status IN ('trial', 'active')
    ORDER BY created_at DESC
    LIMIT 1;

    -- Se não tem assinatura, criar trial automaticamente
    IF user_subscription IS NULL THEN
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
                target_user_id,
                'starter',
                'trial',
                NOW() + INTERVAL '14 days',
                100,  -- Limite do Starter
                1,    -- 1 usuário
                10    -- 10 clientes
            );
            
            -- Buscar a assinatura recém-criada
            SELECT * INTO user_subscription
            FROM public.subscriptions
            WHERE user_id = target_user_id;
            
        EXCEPTION WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao criar trial para novo usuário: %', SQLERRM;
        END;
    END IF;

    -- Verificar se está em trial
    IF user_subscription.status = 'trial' AND user_subscription.trial_ends_at > NOW() THEN
        is_trial_active := true;
    END IF;

    -- Buscar uso atual
    SELECT * INTO usage_record
    FROM public.usage_tracking
    WHERE user_id = target_user_id AND month_year = current_month;

    -- Se não tem registro de uso, criar
    IF usage_record IS NULL THEN
        BEGIN
            INSERT INTO public.usage_tracking (
                user_id,
                month_year,
                transactions_count,
                users_count,
                clients_count
            ) VALUES (
                target_user_id,
                current_month,
                0,
                1,  -- Usuário atual
                0
            );
            
            usage_record.transactions_count := 0;
            usage_record.users_count := 1;
            usage_record.clients_count := 0;
            
        EXCEPTION WHEN OTHERS THEN
            -- Se falhar, usar valores padrão
            usage_record.transactions_count := 0;
            usage_record.users_count := 1;
            usage_record.clients_count := 0;
        END;
    END IF;

    -- Definir limites baseados no plano
    DECLARE
        transaction_limit INTEGER;
        user_limit INTEGER;
        client_limit INTEGER;
        current_count INTEGER;
    BEGIN
        CASE user_subscription.plan_type
            WHEN 'starter' THEN
                transaction_limit := 100;
                user_limit := 1;
                client_limit := 10;
            WHEN 'business' THEN
                transaction_limit := 1000;
                user_limit := 3;
                client_limit := 50;
            WHEN 'unlimited' THEN
                transaction_limit := 999999;
                user_limit := 999999;
                client_limit := 999999;
            ELSE
                transaction_limit := 100;
                user_limit := 1;
                client_limit := 10;
        END CASE;

        -- Determinar contagem atual baseada no tipo de verificação
        CASE check_type
            WHEN 'transaction' THEN
                current_count := usage_record.transactions_count;
            WHEN 'user' THEN
                current_count := usage_record.users_count;
            WHEN 'client' THEN
                current_count := usage_record.clients_count;
            ELSE
                current_count := 0;
        END CASE;

        -- Se está em trial, permitir acesso
        IF is_trial_active THEN
            RETURN QUERY SELECT 
                true as allowed,
                current_count,
                CASE check_type
                    WHEN 'transaction' THEN transaction_limit
                    WHEN 'user' THEN user_limit
                    WHEN 'client' THEN client_limit
                    ELSE 999999
                END as limit_count,
                user_subscription.plan_type::VARCHAR as plan_type;
        ELSE
            -- Verificar se está dentro dos limites
            DECLARE
                limit_for_check INTEGER;
                allowed BOOLEAN;
            BEGIN
                CASE check_type
                    WHEN 'transaction' THEN
                        limit_for_check := transaction_limit;
                        allowed := usage_record.transactions_count < transaction_limit;
                    WHEN 'user' THEN
                        limit_for_check := user_limit;
                        allowed := usage_record.users_count < user_limit;
                    WHEN 'client' THEN
                        limit_for_check := client_limit;
                        allowed := usage_record.clients_count < client_limit;
                    ELSE
                        limit_for_check := 999999;
                        allowed := true;
                END CASE;

                RETURN QUERY SELECT 
                    allowed,
                    current_count,
                    limit_for_check,
                    user_subscription.plan_type::VARCHAR as plan_type;
            END;
        END IF;
    END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Verificar e corrigir usuários existentes sem trial
DO $$
DECLARE
    user_record RECORD;
    trial_count INTEGER := 0;
BEGIN
    -- Para cada usuário que não tem assinatura, criar trial
    FOR user_record IN 
        SELECT au.id, au.email 
        FROM auth.users au
        LEFT JOIN public.subscriptions s ON au.id = s.user_id
        WHERE s.user_id IS NULL 
        AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'  -- Excluir master
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
            
            trial_count := trial_count + 1;
            RAISE NOTICE 'Trial criado para usuário: % (%)', user_record.email, user_record.id;
            
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Erro ao criar trial para %: %', user_record.email, SQLERRM;
        END;
    END LOOP;
    
    RAISE NOTICE 'Total de trials criados: %', trial_count;
END $$;

-- 4. Verificar status atual
SELECT '=== STATUS ATUAL ===' as info;

SELECT 
    'USUÁRIOS COM TRIAL:' as status,
    COUNT(*) as total_trials
FROM public.subscriptions 
WHERE status = 'trial' AND trial_ends_at > NOW();

SELECT 
    'USUÁRIOS SEM ASSINATURA:' as status,
    COUNT(*) as users_without_subscription
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
WHERE s.user_id IS NULL 
AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

SELECT 
    'MASTER USER STATUS:' as status,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM public.subscriptions 
            WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
            AND plan_type = 'unlimited'
        ) THEN 'CONFIGURADO CORRETAMENTE'
        ELSE 'PRECISA CORREÇÃO'
    END as master_status;

SELECT '=== SISTEMA DE TRIAL CORRIGIDO ===' as final_status;
