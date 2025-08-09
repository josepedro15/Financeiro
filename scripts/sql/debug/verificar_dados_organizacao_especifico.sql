-- Verificar dados específicos de organização para josepedro123nato88@gmail.com

-- 1. Verificar se o usuário existe na tabela profiles
SELECT 'Usuário josepedro123nato88@gmail.com:' as info;
SELECT id, email, created_at 
FROM profiles 
WHERE email = 'josepedro123nato88@gmail.com';

-- 2. Verificar se o usuário jopedromkt@gmail.com existe
SELECT 'Usuário jopedromkt@gmail.com:' as info;
SELECT id, email, created_at 
FROM profiles 
WHERE email = 'jopedromkt@gmail.com';

-- 3. Verificar todos os dados da tabela organization_members
SELECT 'Todos os dados de organization_members:' as info;
SELECT 
    om.*,
    p1.email as owner_email,
    p2.email as member_email_from_id
FROM organization_members om
LEFT JOIN profiles p1 ON p1.id = om.owner_id
LEFT JOIN profiles p2 ON p2.id = om.member_id
ORDER BY om.created_at DESC;

-- 4. Verificar se há relação específica
SELECT 'Buscar relação específica:' as info;
SELECT *
FROM organization_members
WHERE email = 'josepedro123nato88@gmail.com'
   OR member_id IN (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
   OR owner_id IN (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com');

-- 5. Verificar se o usuário atual pode executar a consulta que o Dashboard faz
SELECT 'Teste da consulta do Dashboard - como membro:' as info;
SELECT 
    om.owner_id,
    p.email
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.member_id = (SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com')
  AND om.status = 'active';

-- 6. Verificar se a função can_access_user_data está funcionando
SELECT 'Teste da função can_access_user_data:' as info;
DO $$
DECLARE
    user_id_josepedro UUID;
    user_id_jopedro UUID;
    can_access BOOLEAN;
BEGIN
    -- Buscar IDs
    SELECT id INTO user_id_josepedro FROM profiles WHERE email = 'josepedro123nato88@gmail.com';
    SELECT id INTO user_id_jopedro FROM profiles WHERE email = 'jopedromkt@gmail.com';
    
    RAISE NOTICE 'josepedro ID: %', user_id_josepedro;
    RAISE NOTICE 'jopedro ID: %', user_id_jopedro;
    
    IF user_id_josepedro IS NOT NULL AND user_id_jopedro IS NOT NULL THEN
        -- Simular contexto do josepedro testando acesso aos dados do jopedro
        PERFORM set_config('request.jwt.claims', 
            '{"sub":"' || user_id_josepedro || '"}', true);
        
        SELECT can_access_user_data(user_id_jopedro) INTO can_access;
        RAISE NOTICE 'josepedro pode acessar dados do jopedro? %', can_access;
    END IF;
END $$;
