-- Script para ativar usuário pendente e garantir que as políticas funcionem

-- 1. PRIMEIRO: Verificar usuários pendentes
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM public.organization_members
WHERE status = 'pending'
ORDER BY created_at DESC;

-- 2. ATIVAR USUÁRIO PENDENTE (substitua o email pelo email correto)
-- Procurar o usuário na tabela auth.users pelo email
DO $$
DECLARE
    user_uuid UUID;
    pending_email TEXT := 'josepedro123nato88@gmail.com'; -- SUBSTITUA PELO EMAIL CORRETO
BEGIN
    -- Buscar o UUID do usuário pelo email
    SELECT au.id INTO user_uuid
    FROM auth.users au
    WHERE au.email = pending_email;
    
    IF user_uuid IS NOT NULL THEN
        -- Atualizar o status para ativo
        UPDATE public.organization_members
        SET 
            member_id = user_uuid,
            status = 'active',
            updated_at = NOW()
        WHERE email = pending_email AND status = 'pending';
        
        -- Criar perfil se não existir
        INSERT INTO public.profiles (id, email)
        VALUES (user_uuid, pending_email)
        ON CONFLICT (id) DO UPDATE SET
            email = pending_email,
            updated_at = NOW();
        
        RAISE NOTICE 'Usuário % ativado com UUID %', pending_email, user_uuid;
    ELSE
        RAISE NOTICE 'Usuário % não encontrado na tabela auth.users', pending_email;
    END IF;
END $$;

-- 3. VERIFICAR SE O USUÁRIO FOI ATIVADO
SELECT 
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at
FROM public.organization_members
WHERE email = 'josepedro123nato88@gmail.com' -- SUBSTITUA PELO EMAIL CORRETO
ORDER BY created_at DESC;

-- 4. TESTAR A FUNÇÃO DE COMPARTILHAMENTO
SELECT 
    public.is_organization_member('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID) as pode_ver_dados_owner;

-- 5. VERIFICAR SE AS POLÍTICAS ESTÃO FUNCIONANDO
-- Contar dados que deveriam ser visíveis
SELECT 
    'accounts' as tabela,
    COUNT(*) as total_registros
FROM public.accounts 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'clients' as tabela,
    COUNT(*) as total_registros
FROM public.clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'expenses' as tabela,
    COUNT(*) as total_registros
FROM public.expenses 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;

-- 6. VERIFICAR TABELAS MENSAIS DE TRANSAÇÕES
SELECT 
    'transactions_2025_01' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_01 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'transactions_2025_03' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'transactions_2025_04' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'transactions_2025_06' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'transactions_2025_07' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_registros
FROM public.transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
