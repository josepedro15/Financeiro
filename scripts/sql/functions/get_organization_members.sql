-- Criar função SQL para buscar organizações via RPC (bypass das limitações da API REST)

CREATE OR REPLACE FUNCTION get_organization_members(user_member_id UUID)
RETURNS TABLE(owner_id UUID)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT om.owner_id
    FROM organization_members om
    WHERE om.member_id = user_member_id
      AND om.status = 'active';
END;
$$;

-- Criar função para buscar email do profile
CREATE OR REPLACE FUNCTION get_profile_email(user_profile_id UUID)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    user_email TEXT;
BEGIN
    SELECT email INTO user_email
    FROM profiles
    WHERE id = user_profile_id;
    
    RETURN user_email;
END;
$$;

-- Testar as funções
SELECT 'Teste da função get_organization_members:' as info;
SELECT * FROM get_organization_members('5cf1e02f-8ffc-4ea0-8a77-a4c70c9379de'::uuid);

SELECT 'Teste da função get_profile_email:' as info;
SELECT get_profile_email('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid);
