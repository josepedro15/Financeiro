-- Teste direto da consulta que o Dashboard está fazendo

-- 1. Confirmar seu user_id
SELECT 'Seu user_id:' as info;
SELECT id, email FROM profiles WHERE email = 'josepedro123nato88@gmail.com';

-- 2. Testar a consulta exata do Dashboard
SELECT 'Consulta do Dashboard:' as info;
SELECT owner_id 
FROM organization_members 
WHERE member_id = '5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de'
  AND status = 'active';

-- 3. Ver todos os dados da organization_members para debug
SELECT 'Todos os dados organization_members:' as info;
SELECT * FROM organization_members;

-- 4. Buscar o owner_id encontrado
SELECT 'Owner profile:' as info;
SELECT p.email 
FROM profiles p
JOIN organization_members om ON p.id = om.owner_id
WHERE om.member_id = '5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de'
  AND om.status = 'active';
