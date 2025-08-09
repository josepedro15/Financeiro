-- Verificar usuários existentes no sistema de autenticação

-- 1. Verificar usuários na tabela auth.users
SELECT 'Usuários no auth.users:' as info;
SELECT id, email, created_at, email_confirmed_at
FROM auth.users 
WHERE email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com')
ORDER BY email;

-- 2. Verificar usuários na tabela profiles
SELECT 'Usuários na tabela profiles:' as info;
SELECT id, email, created_at
FROM profiles 
WHERE email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com')
ORDER BY email;

-- 3. Verificar se há usuários auth.users sem profiles
SELECT 'Usuários auth.users sem profiles:' as info;
SELECT u.id, u.email, u.created_at
FROM auth.users u
LEFT JOIN profiles p ON p.id = u.id
WHERE p.id IS NULL
AND u.email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com');

-- 4. Criar profiles para usuários existentes no auth.users (se necessário)
INSERT INTO profiles (id, email, created_at, updated_at)
SELECT 
    u.id,
    u.email,
    u.created_at,
    NOW()
FROM auth.users u
LEFT JOIN profiles p ON p.id = u.id
WHERE p.id IS NULL
AND u.email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com');

-- 5. Verificar resultado final
SELECT 'Resultado final - profiles criados:' as info;
SELECT p.id, p.email, p.created_at
FROM profiles p
WHERE p.email IN ('josepedro123nato88@gmail.com', 'jopedromkt@gmail.com')
ORDER BY p.email;
