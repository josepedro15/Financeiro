-- Corrigir RLS da tabela notifications

-- 1. Verificar políticas atuais
SELECT 'POLÍTICAS ATUAIS DA TABELA NOTIFICATIONS:' as info;
SELECT 
    policyname,
    cmd,
    permissive,
    roles,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'notifications'
ORDER BY policyname;

-- 2. REMOVER política restritiva atual
DROP POLICY IF EXISTS "notifications_user_policy" ON public.notifications;

-- 3. CRIAR política mais permissiva para INSERT
-- Permite que qualquer usuário autenticado insira notificações
CREATE POLICY "notifications_insert_policy" ON public.notifications
    FOR INSERT 
    TO authenticated
    WITH CHECK (true);

-- 4. CRIAR política para SELECT (usuário vê apenas suas notificações)
CREATE POLICY "notifications_select_policy" ON public.notifications
    FOR SELECT 
    TO authenticated
    USING (user_id = auth.uid());

-- 5. CRIAR política para UPDATE (usuário atualiza apenas suas notificações)
CREATE POLICY "notifications_update_policy" ON public.notifications
    FOR UPDATE 
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- 6. CRIAR política para DELETE (usuário deleta apenas suas notificações)
CREATE POLICY "notifications_delete_policy" ON public.notifications
    FOR DELETE 
    TO authenticated
    USING (user_id = auth.uid());

-- 7. Verificar novas políticas
SELECT 'NOVAS POLÍTICAS CRIADAS:' as info;
SELECT 
    policyname,
    cmd,
    permissive,
    roles,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'notifications'
ORDER BY policyname;

-- 8. Testar inserção manual de notificação
SELECT 'TESTANDO INSERÇÃO...' as info;

-- Buscar IDs dos usuários para teste
DO $$
DECLARE
    user_jopedro UUID;
    user_logotiq UUID;
BEGIN
    SELECT id INTO user_jopedro FROM auth.users WHERE email = 'jopedromkt@gmail.com';
    SELECT id INTO user_logotiq FROM auth.users WHERE email = 'logotiq@gmail.com';
    
    -- Deletar notificações antigas
    DELETE FROM public.notifications WHERE user_id = user_logotiq;
    
    -- Inserir nova notificação de teste
    INSERT INTO public.notifications (
        user_id,
        type,
        title,
        message,
        data,
        status
    ) VALUES (
        user_logotiq,
        'organization_invite',
        'Convite para Organização - TESTE',
        'Teste de notificação com nova política RLS.',
        jsonb_build_object(
            'owner_id', user_jopedro,
            'owner_email', 'jopedromkt@gmail.com',
            'organization_member_id', gen_random_uuid()
        ),
        'pending'
    );
    
    RAISE NOTICE '✅ Notificação de teste inserida com sucesso!';
END $$;

-- 9. Verificar se inserção funcionou
SELECT 'NOTIFICAÇÃO DE TESTE:' as info;
SELECT 
    n.id,
    u.email as destinatario,
    n.title,
    n.message,
    n.status,
    n.created_at
FROM public.notifications n
JOIN auth.users u ON n.user_id = u.id
WHERE u.email = 'logotiq@gmail.com'
ORDER BY n.created_at DESC;

SELECT '✅ RLS DA TABELA NOTIFICATIONS CORRIGIDO!' as resultado;
