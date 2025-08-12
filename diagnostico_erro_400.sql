-- DIAGNÓSTICO ESPECÍFICO PARA ERRO 400
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se há problemas com a URL da API
SELECT '=== VERIFICANDO CONFIGURAÇÃO DA API ===' as info;
SELECT 
    'Supabase URL' as config,
    'https://knbldcvwdpavelmbmdre.supabase.co' as valor
UNION ALL
SELECT 
    'API Key' as config,
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtuYmxkY3Z3ZHBhdmVsbWJtZHJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0OTQ0MDcsImV4cCI6MjA3MDA3MDQwN30.Cw3cnV4dj5eEN48AXMwxo2pps4Cj9IC-HXWFfydYyGc' as valor;

-- 2. Verificar se as tabelas existem e têm a estrutura correta
SELECT '=== VERIFICANDO ESTRUTURA DAS TABELAS ===' as info;
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('transactions', 'transactions_2025_08')
AND table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. Verificar se há dados nas tabelas
SELECT '=== VERIFICANDO DADOS NAS TABELAS ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_registros,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    MIN(created_at) as primeira_transacao,
    MAX(created_at) as ultima_transacao
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_registros,
    COUNT(DISTINCT user_id) as usuarios_unicos,
    MIN(created_at) as primeira_transacao,
    MAX(created_at) as ultima_transacao
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Verificar políticas RLS atuais
SELECT '=== POLÍTICAS RLS ATUAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    permissive,
    roles,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
ORDER BY tablename, cmd, policyname;

-- 5. Verificar se há triggers que podem causar problemas
SELECT '=== VERIFICANDO TRIGGERS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers
WHERE event_object_table IN ('transactions', 'transactions_2025_08')
AND event_object_schema = 'public'
ORDER BY event_object_table, event_manipulation;

-- 6. Verificar se há constraints que podem bloquear DELETE
SELECT '=== VERIFICANDO CONSTRAINTS ===' as info;
SELECT 
    tc.constraint_name,
    tc.constraint_type,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
LEFT JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
LEFT JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.table_name IN ('transactions', 'transactions_2025_08')
AND tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type;

-- 7. Testar uma consulta simples para verificar conectividade
SELECT '=== TESTE DE CONECTIVIDADE ===' as info;
SELECT 
    'Teste básico' as tipo_teste,
    COUNT(*) as resultado
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
LIMIT 1;

-- 8. Verificar se há problemas com o formato de data
SELECT '=== VERIFICANDO FORMATO DE DATAS ===' as info;

-- Verificar dados da tabela transactions
SELECT 
    'transactions' as tabela,
    transaction_date,
    created_at,
    updated_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 3;

-- Verificar dados da tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    transaction_date,
    created_at,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 3;

-- 9. Verificar se há problemas com UUIDs
SELECT '=== VERIFICANDO FORMATO DE UUIDs ===' as info;

-- Verificar UUIDs da tabela transactions
SELECT 
    'transactions' as tabela,
    id,
    user_id,
    LENGTH(id::text) as id_length,
    LENGTH(user_id::text) as user_id_length
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
LIMIT 3;

-- Verificar UUIDs da tabela transactions_2025_08
SELECT 
    'transactions_2025_08' as tabela,
    id,
    user_id,
    LENGTH(id::text) as id_length,
    LENGTH(user_id::text) as user_id_length
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
LIMIT 3;

-- 10. Verificar se há problemas com a função RPC
SELECT '=== VERIFICANDO FUNÇÃO RPC ===' as info;
SELECT 
    routine_name,
    routine_type,
    data_type,
    routine_definition
FROM information_schema.routines
WHERE routine_name = 'delete_transaction_safe'
AND routine_schema = 'public';

-- 11. Testar a função RPC diretamente
SELECT '=== TESTANDO FUNÇÃO RPC ===' as info;

-- Inserir transação de teste
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE ERRO 400', 
    777.00, 
    'income', 
    'teste_400', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 12. Verificar configuração de timezone
SELECT '=== CONFIGURAÇÃO DE TIMEZONE ===' as info;
SHOW timezone;
SHOW datestyle;
SHOW client_encoding;

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as info;
