-- Testar as consultas exatas que o Dashboard está fazendo

-- 1. Simular o user.id do josepedro123nato88@gmail.com
SELECT 'User ID do josepedro123nato88@gmail.com:' as info;
SELECT id as user_id, email 
FROM profiles 
WHERE email = 'josepedro123nato88@gmail.com';

-- 2. Testar a consulta direta sem foreign key
SELECT 'Consulta direta organization_members:' as info;
SELECT 
    om.owner_id,
    om.member_id,
    om.email,
    om.status
FROM organization_members om
WHERE om.member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
  AND om.status = 'active';

-- 3. Testar com JOIN manual (sem foreign key automática)
SELECT 'Consulta com JOIN manual:' as info;
SELECT 
    om.owner_id,
    p.email as owner_email
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
  AND om.status = 'active';

-- 4. Testar a consulta exata do Dashboard (com foreign key)
SELECT 'Consulta exata do Dashboard:' as info;
SELECT 
    om.owner_id,
    p.email
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
  AND om.status = 'active';

-- 5. Verificar se há dados na tabela
SELECT 'Todos os dados de organization_members:' as info;
SELECT * FROM organization_members;

-- 6. Verificar constraint e foreign keys
SELECT 'Constraints da tabela organization_members:' as info;
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    confrelid::regclass as referenced_table
FROM pg_constraint 
WHERE conrelid = 'organization_members'::regclass;
