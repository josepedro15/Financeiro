-- Script para debugar o sistema de organização
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se as tabelas existem
SELECT 'Tabelas existentes:' as info;
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'organization_members')
ORDER BY table_name;

-- 2. Verificar se há dados na tabela profiles
SELECT 'Dados na tabela profiles:' as info;
SELECT id, email, created_at 
FROM profiles 
ORDER BY created_at DESC;

-- 3. Verificar dados na tabela organization_members
SELECT 'Dados na tabela organization_members:' as info;
SELECT 
  id,
  owner_id,
  member_id,
  email,
  status,
  created_at
FROM organization_members 
ORDER BY created_at DESC;

-- 4. Verificar relação específica para o usuário josepedro123nato88@gmail.com
SELECT 'Relações específicas para josepedro123nato88@gmail.com:' as info;

-- Como membro (pode ver dados de outros)
SELECT 
  'COMO MEMBRO:' as tipo,
  om.owner_id,
  p.email as owner_email,
  om.status
FROM organization_members om
JOIN profiles p ON p.id = om.owner_id
WHERE om.email = 'josepedro123nato88@gmail.com'
AND om.status = 'active';

-- Como owner (outros podem ver seus dados)
SELECT 
  'COMO OWNER:' as tipo,
  om.member_id,
  p.email as member_email,
  om.status
FROM organization_members om
JOIN profiles p ON p.id = om.member_id
WHERE om.owner_id IN (
  SELECT id FROM profiles WHERE email = 'josepedro123nato88@gmail.com'
)
AND om.status = 'active';

-- 5. Verificar função de acesso
SELECT 'Testando função can_access_user_data:' as info;

-- Para simular um usuário específico, vamos verificar a função
DO $$
DECLARE
    test_user_id UUID;
    owner_user_id UUID;
    can_access BOOLEAN;
BEGIN
    -- Buscar ID do usuário teste
    SELECT id INTO test_user_id 
    FROM profiles 
    WHERE email = 'josepedro123nato88@gmail.com';
    
    -- Buscar ID do owner
    SELECT id INTO owner_user_id 
    FROM profiles 
    WHERE email = 'jopedromkt@gmail.com';
    
    IF test_user_id IS NOT NULL AND owner_user_id IS NOT NULL THEN
        -- Testar se pode acessar dados do owner
        SELECT can_access_user_data(owner_user_id) INTO can_access;
        
        RAISE NOTICE 'Usuário %: pode acessar dados de %? %', 
            test_user_id, owner_user_id, can_access;
    ELSE
        RAISE NOTICE 'Usuários não encontrados: test_user=%, owner_user=%', 
            test_user_id, owner_user_id;
    END IF;
END $$;
