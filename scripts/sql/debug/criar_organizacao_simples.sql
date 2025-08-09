-- Criar organização de forma simples, sem ON CONFLICT

-- 1. Verificar se a relação já existe
SELECT 'Verificando relação existente:' as info;
SELECT 
    om.id,
    om.email,
    om.status,
    p_owner.email as owner_email,
    p_member.email as member_email
FROM organization_members om
JOIN profiles p_owner ON p_owner.id = om.owner_id
JOIN profiles p_member ON p_member.id = om.member_id
WHERE p_owner.email = 'jopedromkt@gmail.com'
  AND p_member.email = 'josepedro123nato88@gmail.com';

-- 2. Deletar relação existente (se houver) para recriar
DELETE FROM organization_members
WHERE owner_id = (SELECT id FROM profiles WHERE email = 'jopedromkt@gmail.com')
  AND member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com');

-- 3. Criar a relação
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
    (SELECT id FROM profiles WHERE email = 'jopedromkt@gmail.com'),  -- owner
    (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com'), -- member
    'josepedro123nato88@gmail.com',
    'active',
    NOW(),
    NOW()
WHERE (SELECT id FROM profiles WHERE email = 'jopedromkt@gmail.com') IS NOT NULL
  AND (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com') IS NOT NULL;

-- 4. Verificar resultado final
SELECT 'RESULTADO FINAL:' as info;
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
WHERE p_member.email = 'josepedro123nato88@gmail.com'
ORDER BY om.created_at DESC;

-- 5. Testar a consulta que o Dashboard faz
SELECT 'TESTE DA CONSULTA DO DASHBOARD:' as info;
SELECT 
    om.owner_id,
    p.email as owner_email
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
  AND om.status = 'active';
