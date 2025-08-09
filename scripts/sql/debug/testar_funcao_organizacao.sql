-- Testar se a função is_organization_member está funcionando
-- Substitua 'SEU_USER_ID' pelo ID do usuário owner (2dc520e3-5f19-4dfe-838b-1aca7238ae36)

-- 1. Verificar se a função existe e funciona
SELECT public.is_organization_member('2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID) as pode_ver_dados;

-- 2. Testar com o próprio usuário (deve retornar TRUE)
SELECT 
    auth.uid() as meu_user_id,
    public.is_organization_member(auth.uid()) as posso_ver_meus_dados;

-- 3. Verificar membros da organização
SELECT 
    om.email,
    om.status,
    om.owner_id,
    om.member_id,
    CASE 
        WHEN om.member_id = auth.uid() THEN 'SOU EU'
        WHEN om.owner_id = auth.uid() THEN 'SOU OWNER'
        ELSE 'OUTRO USUÁRIO'
    END as relacao
FROM public.organization_members om;

-- 4. Testar se consigo ver dados compartilhados
SELECT COUNT(*) as total_contas
FROM public.accounts 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;

-- 5. Verificar se as políticas estão permitindo acesso
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * 
FROM public.accounts 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
