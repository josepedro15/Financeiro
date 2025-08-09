-- Script DEFINITIVO para sistema de trial
-- Garantir que TODOS os novos usuários recebam 14 dias de trial
-- Execute este script no Supabase SQL Editor

SELECT '=== SISTEMA DE TRIAL DEFINITIVO ===' as status;

-- 1. Verificar e corrigir estrutura da tabela subscriptions
DO $$
BEGIN
    -- Adicionar coluna status se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'subscriptions' 
        AND column_name = 'status'
    ) THEN
        ALTER TABLE public.subscriptions ADD COLUMN status VARCHAR(20) DEFAULT 'trial';
    END IF;
    
    -- Adicionar constraint se não existir
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'subscriptions_status_check'
    ) THEN
        ALTER TABLE public.subscriptions ADD CONSTRAINT subscriptions_status_check 
        CHECK (status IN ('trial', 'active', 'inactive', 'cancelled', 'expired'));
    END IF;
    
    RAISE NOTICE 'Estrutura da tabela subscriptions verificada';
END $$;

-- 2. Criar função para criar trial automaticamente
CREATE OR REPLACE FUNCTION public.create_trial_for_user(target_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    user_exists BOOLEAN := false;
    subscription_exists BOOLEAN := false;
    master_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
BEGIN
    -- Usuário master não precisa de trial
    IF target_user_id = master_user_id THEN
        RETURN true;
    END IF;
    
    -- Verificar se usuário existe
    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) INTO user_exists;
    IF NOT user_exists THEN
        RAISE EXCEPTION 'Usuário não encontrado: %', target_user_id;
    END IF;
    
    -- Verificar se já tem assinatura
    SELECT EXISTS(SELECT 1 FROM public.subscriptions WHERE user_id = target_user_id) INTO subscription_exists;
    IF subscription_exists THEN
        RETURN true; -- Já tem assinatura
    END IF;
    
    -- Criar trial
    INSERT INTO public.subscriptions (
        user_id,
        plan_type,
        status,
        trial_ends_at,
        monthly_transaction_limit,
        user_limit,
        client_limit,
        started_at
    ) VALUES (
        target_user_id,
        'starter',
        'trial',
        NOW() + INTERVAL '14 days',
        100,  -- Limite do Starter
        1,    -- 1 usuário
        10    -- 10 clientes
    );
    
    -- Criar registro de uso inicial
    INSERT INTO public.usage_tracking (
        user_id,
        month_year,
        transactions_count,
        users_count,
        clients_count
    ) VALUES (
        target_user_id,
        TO_CHAR(NOW(), 'YYYY-MM'),
        0,
        1,  -- Usuário atual
        0
    ) ON CONFLICT (user_id, month_year) DO NOTHING;
    
    RAISE NOTICE 'Trial criado com sucesso para usuário: %', target_user_id;
    RETURN true;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Erro ao criar trial para %: %', target_user_id, SQLERRM;
    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Criar trigger para novos usuários
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Criar trial automaticamente para novos usuários
    PERFORM create_trial_for_user(NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Remover trigger se existir
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Criar trigger
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- 4. Corrigir função check_plan_limits para criar trial automaticamente
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

    -- Verificar se o usuário existe
    SELECT EXISTS(SELECT 1 FROM auth.users WHERE id = target_user_id) INTO user_exists;
    IF NOT user_exists THEN
        RAISE EXCEPTION 'Usuário não encontrado na tabela auth.users';
    END IF;

    -- Buscar assinatura do usuário
    SELECT * INTO user_subscription
    FROM public.subscriptions
    WHERE user_id = target_user_id
    ORDER BY created_at DESC
    LIMIT 1;

    -- Se não tem assinatura, criar trial automaticamente
    IF user_subscription IS NULL THEN
        PERFORM create_trial_for_user(target_user_id);
        
        -- Buscar a assinatura recém-criada
        SELECT * INTO user_subscription
        FROM public.subscriptions
        WHERE user_id = target_user_id;
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
            1,
            0
        ) ON CONFLICT (user_id, month_year) DO NOTHING;
        
        usage_record.transactions_count := 0;
        usage_record.users_count := 1;
        usage_record.clients_count := 0;
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

        -- Determinar contagem atual
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

-- 5. Aplicar trials para usuários existentes sem assinatura
DO $$
DECLARE
    user_record RECORD;
    trial_count INTEGER := 0;
BEGIN
    FOR user_record IN 
        SELECT au.id, au.email 
        FROM auth.users au
        LEFT JOIN public.subscriptions s ON au.id = s.user_id
        WHERE s.user_id IS NULL 
        AND au.id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    LOOP
        IF create_trial_for_user(user_record.id) THEN
            trial_count := trial_count + 1;
            RAISE NOTICE 'Trial criado para: % (%)', user_record.email, user_record.id;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Total de trials criados: %', trial_count;
END $$;

-- 6. Verificar resultado final
SELECT '=== RESULTADO FINAL ===' as status;

SELECT 
    au.email,
    s.plan_type,
    s.status,
    s.trial_ends_at,
    CASE 
        WHEN s.status = 'trial' AND s.trial_ends_at > NOW() THEN 'TRIAL ATIVO'
        WHEN s.status = 'active' THEN 'ASSINATURA ATIVA'
        WHEN s.plan_type = 'unlimited' THEN 'MASTER USER'
        ELSE 'SEM ACESSO'
    END as access_status
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id
ORDER BY au.created_at DESC;

-- 7. Contagem final
SELECT 
    'RESUMO FINAL:' as info,
    COUNT(*) as total_users,
    COUNT(CASE WHEN s.status = 'trial' AND s.trial_ends_at > NOW() THEN 1 END) as active_trials,
    COUNT(CASE WHEN s.status = 'active' THEN 1 END) as active_subscriptions,
    COUNT(CASE WHEN s.plan_type = 'unlimited' THEN 1 END) as master_users,
    COUNT(CASE WHEN s.user_id IS NULL THEN 1 END) as users_without_subscription
FROM auth.users au
LEFT JOIN public.subscriptions s ON au.id = s.user_id;

SELECT '=== SISTEMA DE TRIAL DEFINITIVO APLICADO ===' as final_status;
