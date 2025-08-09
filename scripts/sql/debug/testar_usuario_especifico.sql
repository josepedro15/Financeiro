-- Testar com o usuário específico (simulando login)
-- Definir o usuário temporariamente para teste

-- 1. Verificar se o usuário josepedro123nato88@gmail.com foi ativado corretamente
SELECT 
    om.email,
    om.status,
    om.member_id,
    om.owner_id,
    au.email as auth_email
FROM public.organization_members om
LEFT JOIN auth.users au ON au.id = om.member_id
WHERE om.email = 'josepedro123nato88@gmail.com';

-- 2. Simular a função com IDs específicos
SELECT 
    public.is_organization_member('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID) as funcao_sem_contexto;

-- 3. Testar a função manualmente com lógica
DO $$
DECLARE
    owner_user_id UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
    member_user_id UUID;
    result BOOLEAN := FALSE;
BEGIN
    -- Buscar o ID do usuário membro
    SELECT au.id INTO member_user_id
    FROM auth.users au
    WHERE au.email = 'josepedro123nato88@gmail.com';
    
    IF member_user_id IS NOT NULL THEN
        -- Verificar se é membro ativo
        IF EXISTS (
            SELECT 1 
            FROM public.organization_members 
            WHERE owner_id = owner_user_id 
            AND member_id = member_user_id 
            AND status = 'active'
        ) THEN
            result := TRUE;
        END IF;
    END IF;
    
    RAISE NOTICE 'Owner ID: %', owner_user_id;
    RAISE NOTICE 'Member ID: %', member_user_id;
    RAISE NOTICE 'Pode ver dados: %', result;
END $$;

-- 4. Verificar se consegue acessar dados diretamente
SELECT 
    'Pode acessar como owner' as teste,
    COUNT(*) as total
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID

UNION ALL

SELECT 
    'Pode acessar como membro' as teste,
    COUNT(*) as total
FROM public.transactions_2025_04 t
WHERE EXISTS (
    SELECT 1 
    FROM public.organization_members om
    JOIN auth.users au ON au.id = om.member_id
    WHERE om.owner_id = t.user_id 
    AND au.email = 'josepedro123nato88@gmail.com'
    AND om.status = 'active'
);
