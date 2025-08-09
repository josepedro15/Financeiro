-- Corrigir usuário logotiq@gmail.com que está pendente

-- 1. Criar profile se não existir (usando ID do auth.users)
INSERT INTO profiles (id, email, created_at, updated_at)
SELECT 
    au.id,
    au.email,
    au.created_at,
    NOW()
FROM auth.users au
LEFT JOIN profiles p ON p.id = au.id
WHERE au.email = 'logotiq@gmail.com'
  AND p.id IS NULL;

-- 2. Atualizar member_id na organization_members para o ID correto
UPDATE organization_members 
SET 
    member_id = (SELECT id FROM auth.users WHERE email = 'logotiq@gmail.com'),
    status = 'active',
    updated_at = NOW()
WHERE email = 'logotiq@gmail.com';

-- 3. Verificar resultado final
SELECT 'Resultado final:' as info;
SELECT 
    om.email,
    om.member_id,
    om.status,
    au.id as auth_user_id,
    p.id as profile_id
FROM organization_members om
JOIN auth.users au ON au.email = om.email
JOIN profiles p ON p.email = om.email
WHERE om.email = 'logotiq@gmail.com';
