-- Habilitar tabela organization_members na API REST e ajustar RLS

-- 1. Garantir que a tabela está habilitada na API REST
-- (Isso normalmente é feito via interface do Supabase, mas vamos verificar)

-- 2. Verificar RLS atual
SELECT 'Políticas RLS atuais para organization_members:' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'organization_members';

-- 3. Verificar se RLS está habilitado
SELECT 'Status RLS organization_members:' as info;
SELECT 
    t.table_name,
    CASE 
        WHEN c.relrowsecurity THEN 'Habilitado'
        ELSE 'Desabilitado'
    END as rls_status
FROM information_schema.tables t
LEFT JOIN pg_class c ON c.relname = t.table_name
WHERE t.table_schema = 'public' 
AND t.table_name = 'organization_members';

-- 4. Criar política específica para SELECT na API
-- Permitir que usuários vejam organizações onde são membros
DROP POLICY IF EXISTS "organization_members_select_policy" ON organization_members;

CREATE POLICY "organization_members_select_policy"
ON organization_members
FOR SELECT
USING (
    -- Usuário pode ver registros onde é member
    member_id = auth.uid()
    OR
    -- Usuário pode ver registros onde é owner
    owner_id = auth.uid()
    OR
    -- Usar a função can_access_user_data para acesso organizacional
    can_access_user_data(owner_id)
);

-- 5. Testar a política
SELECT 'Teste da política após criação:' as info;
SET request.jwt.claims = '{"sub":"5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de"}';

SELECT owner_id 
FROM organization_members 
WHERE member_id = '5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de'
  AND status = 'active';

-- 6. Verificar se a nova política foi criada
SELECT 'Nova política criada:' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'organization_members'
AND policyname = 'organization_members_select_policy';
