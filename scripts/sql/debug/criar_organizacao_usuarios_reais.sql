-- Criar organização apenas se ambos usuários existem no sistema

-- 1. Verificar se ambos usuários existem
DO $$
DECLARE
    user_josepedro UUID;
    user_jopedro UUID;
BEGIN
    -- Buscar IDs dos usuários no auth.users
    SELECT id INTO user_josepedro 
    FROM auth.users 
    WHERE email = 'josepedro123nato88@gmail.com';
    
    SELECT id INTO user_jopedro 
    FROM auth.users 
    WHERE email = 'jopedromkt@gmail.com';
    
    RAISE NOTICE 'josepedro123nato88@gmail.com ID: %', user_josepedro;
    RAISE NOTICE 'jopedromkt@gmail.com ID: %', user_jopedro;
    
    IF user_josepedro IS NULL THEN
        RAISE NOTICE 'ERRO: Usuário josepedro123nato88@gmail.com não existe no auth.users';
        RAISE NOTICE 'Este usuário precisa fazer login pelo menos uma vez';
    END IF;
    
    IF user_jopedro IS NULL THEN
        RAISE NOTICE 'ERRO: Usuário jopedromkt@gmail.com não existe no auth.users';
        RAISE NOTICE 'Este usuário precisa fazer login pelo menos uma vez';
    END IF;
    
    IF user_josepedro IS NOT NULL AND user_jopedro IS NOT NULL THEN
        RAISE NOTICE 'Ambos usuários existem! Prosseguindo com criação da organização...';
        
        -- Criar profiles se não existirem
        INSERT INTO profiles (id, email, created_at, updated_at)
        VALUES (user_josepedro, 'josepedro123nato88@gmail.com', NOW(), NOW())
        ON CONFLICT (id) DO NOTHING;
        
        INSERT INTO profiles (id, email, created_at, updated_at)
        VALUES (user_jopedro, 'jopedromkt@gmail.com', NOW(), NOW())
        ON CONFLICT (id) DO NOTHING;
        
        -- Adicionar à organização
        INSERT INTO organization_members (
            id,
            owner_id,
            member_id,
            email,
            status,
            created_at,
            updated_at
        )
        VALUES (
            gen_random_uuid(),
            user_jopedro,  -- jopedromkt@gmail.com é o owner
            user_josepedro, -- josepedro123nato88@gmail.com é o member
            'josepedro123nato88@gmail.com',
            'active',
            NOW(),
            NOW()
        )
        ON CONFLICT (owner_id, member_id) DO UPDATE SET
            status = 'active',
            updated_at = NOW();
        
        RAISE NOTICE 'Organização criada com sucesso!';
    END IF;
END $$;

-- 2. Verificar resultado final
SELECT 'Resultado final da organização:' as info;
SELECT 
    om.id,
    om.email as member_email,
    om.status,
    p_owner.email as owner_email,
    p_member.email as member_email_from_profile,
    om.created_at
FROM organization_members om
JOIN profiles p_owner ON p_owner.id = om.owner_id
JOIN profiles p_member ON p_member.id = om.member_id
WHERE om.email = 'josepedro123nato88@gmail.com'
ORDER BY om.created_at DESC;
