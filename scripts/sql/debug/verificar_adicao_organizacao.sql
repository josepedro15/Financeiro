-- Verificar se josepedro123nato88@gmail.com foi realmente adicionado à organização

-- 1. Primeiro, garantir que ambos os usuários estão na tabela profiles
INSERT INTO profiles (id, email, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'josepedro123nato88@gmail.com',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM profiles WHERE email = 'josepedro123nato88@gmail.com'
);

INSERT INTO profiles (id, email, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    'jopedromkt@gmail.com',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM profiles WHERE email = 'jopedromkt@gmail.com'
);

-- 2. Verificar se ambos existem agora
SELECT 'Verificação pós-inserção:' as info;
SELECT email, id, created_at FROM profiles 
WHERE email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com')
ORDER BY email;

-- 3. Adicionar josepedro123nato88@gmail.com à organização de jopedromkt@gmail.com (se não existir)
INSERT INTO organization_members (
    id,
    owner_id,
    member_id,
    email,
    status,
    created_at,
    updated_at
)
SELECT 
    gen_random_uuid(),
    (SELECT id FROM profiles WHERE email = 'jopedromkt@gmail.com'),
    (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com'),
    'josepedro123nato88@gmail.com',
    'active',
    NOW(),
    NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM organization_members 
    WHERE email = 'josepedro123nato88@gmail.com'
    AND owner_id = (SELECT id FROM profiles WHERE email = 'jopedromkt@gmail.com')
);

-- 4. Verificar resultado final
SELECT 'Resultado final da organização:' as info;
SELECT 
    om.id,
    om.email,
    om.status,
    p_owner.email as owner_email,
    p_member.email as member_email,
    om.created_at
FROM organization_members om
JOIN profiles p_owner ON p_owner.id = om.owner_id
JOIN profiles p_member ON p_member.id = om.member_id
ORDER BY om.created_at DESC;
