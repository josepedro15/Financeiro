-- Testar se a API agora funciona após a criação da política

-- 1. Simular o contexto do usuário josepedro123nato88@gmail.com
SET request.jwt.claims = '{"sub":"5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de"}';

-- 2. Testar a consulta exata que o Dashboard faz
SELECT 'Teste da consulta do Dashboard após política RLS:' as info;
SELECT owner_id 
FROM organization_members 
WHERE member_id = '5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de'
  AND status = 'active';

-- 3. Testar se auth.uid() funciona
SELECT 'auth.uid() atual:' as info;
SELECT auth.uid();

-- 4. Testar a função can_access_user_data
SELECT 'Teste can_access_user_data:' as info;
SELECT can_access_user_data('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid);

-- 5. Verificar todos os registros que o usuário pode ver
SELECT 'Todos os registros visíveis para o usuário:' as info;
SELECT * FROM organization_members;
