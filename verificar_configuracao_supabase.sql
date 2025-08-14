-- =====================================================
-- VERIFICAR E CORRIGIR CONFIGURAÇÃO DO SUPABASE
-- =====================================================

-- 1. VERIFICAR CONFIGURAÇÕES ATUAIS
-- =====================================================

SELECT '=== CONFIGURAÇÕES ATUAIS ===' as info;

-- Verificar se há configurações de redirecionamento no banco
SELECT 
    'Configurações de autenticação' as tipo,
    'Verificar no Supabase Dashboard' as acao,
    'Authentication → Settings → Site URL' as localizacao;

-- 2. VERIFICAR USUÁRIOS RECENTES
-- =====================================================

SELECT '=== USUÁRIOS RECENTES ===' as info;

-- Verificar usuários que se registraram recentemente
SELECT 
    id,
    email,
    created_at,
    confirmed_at,
    last_sign_in_at,
    CASE 
        WHEN confirmed_at IS NULL THEN '❌ NÃO CONFIRMADO'
        ELSE '✅ CONFIRMADO'
    END as status_confirmacao
FROM auth.users 
WHERE created_at > NOW() - INTERVAL '7 days'
ORDER BY created_at DESC;

-- 3. VERIFICAR CONVITES PENDENTES
-- =====================================================

SELECT '=== CONVITES PENDENTES ===' as info;

-- Verificar convites que ainda estão pendentes
SELECT 
    om.id,
    om.email,
    om.status,
    om.created_at,
    CASE 
        WHEN au.id IS NOT NULL THEN '✅ USUÁRIO EXISTE'
        ELSE '❌ USUÁRIO NÃO EXISTE'
    END as status_usuario,
    au.confirmed_at as data_confirmacao
FROM public.organization_members om
LEFT JOIN auth.users au ON au.email = om.email
WHERE om.status = 'pending'
ORDER BY om.created_at DESC;

-- 4. VERIFICAR NOTIFICAÇÕES
-- =====================================================

SELECT '=== NOTIFICAÇÕES ===' as info;

-- Verificar notificações de convite
SELECT 
    id,
    user_id,
    type,
    title,
    status,
    created_at,
    read
FROM public.notifications 
WHERE type = 'organization_invite'
ORDER BY created_at DESC;

-- 5. INSTRUÇÕES PARA CONFIGURAR SUPABASE
-- =====================================================

SELECT 
    '=== INSTRUÇÕES PARA CONFIGURAR SUPABASE ===' as info,
    '1. Acesse: https://supabase.com/dashboard' as passo1,
    '2. Selecione seu projeto' as passo2,
    '3. Vá em: Authentication → Settings' as passo3,
    '4. Configure Site URL: https://financeiro-7.vercel.app' as passo4,
    '5. Configure Redirect URLs:' as passo5,
    '   - https://financeiro-7.vercel.app/**' as redirect1,
    '   - https://financeiro-7.vercel.app/auth/callback' as redirect2,
    '   - https://financeiro-7.vercel.app/dashboard' as redirect3,
    '6. Salve as configurações' as passo6;

-- 6. TESTE DE CONFIGURAÇÃO
-- =====================================================

SELECT 
    '=== TESTE DE CONFIGURAÇÃO ===' as info,
    'Após configurar o Supabase:' as instrucao1,
    '1. Crie um novo convite na página Settings' as instrucao2,
    '2. Verifique se o email tem a URL correta' as instrucao3,
    '3. Teste o registro do usuário convidado' as instrucao4,
    '4. Verifique se a notificação aparece' as instrucao5;

-- 7. VERIFICAÇÃO DE AMBIENTE
-- =====================================================

SELECT 
    '=== VERIFICAÇÃO DE AMBIENTE ===' as info,
    'URL atual: ' || current_setting('app.current_url', true) as url_atual,
    'Ambiente: ' || current_setting('app.environment', true) as ambiente,
    'Versão: ' || version() as versao_postgres;
