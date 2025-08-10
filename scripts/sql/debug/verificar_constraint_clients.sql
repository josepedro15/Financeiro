-- Script para verificar a constraint que está causando erro
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estrutura da tabela clients
SELECT '=== ESTRUTURA DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar constraints da tabela clients
SELECT '=== CONSTRAINTS DA TABELA CLIENTS ===' as info;
SELECT 
    constraint_name,
    constraint_type,
    check_clause
FROM information_schema.check_constraints
WHERE constraint_name LIKE '%clients%'
OR constraint_name LIKE '%stage%';

-- 3. Verificar constraints de tabela
SELECT '=== CONSTRAINTS DE TABELA CLIENTS ===' as info;
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
LEFT JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.table_name = 'clients'
AND tc.table_schema = 'public';

-- 4. Verificar se existe coluna stage na tabela clients
SELECT '=== VERIFICAR COLUNA STAGE ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
AND column_name = 'stage';

-- 5. Tentar inserir um cliente de teste para ver o erro completo
SELECT '=== TESTE DE INSERÇÃO ===' as info;
-- Descomente a linha abaixo para testar a inserção
-- INSERT INTO public.clients (user_id, name, email, phone, document, address, stage) 
-- VALUES ('test-user-id', 'Cliente Teste', 'teste@email.com', '123456789', '123.456.789-00', 'Endereço Teste', 'Negociação');
