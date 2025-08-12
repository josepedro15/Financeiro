-- VERIFICAÇÃO DE TRANSAÇÕES RECENTES E DASHBOARD
-- Execute este script no Supabase SQL Editor

-- 1. Verificar transações mais recentes
SELECT '=== TRANSAÇÕES MAIS RECENTES ===' as info;
SELECT 
    'transactions' as tabela,
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    account_name,
    created_at,
    updated_at
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 10;

-- 2. Verificar transações mais recentes da tabela mensal
SELECT '=== TRANSAÇÕES MAIS RECENTES (TABELA MENSAIS) ===' as info;
SELECT 
    'transactions_2025_08' as tabela,
    id,
    description,
    amount,
    transaction_type,
    transaction_date,
    account_name,
    created_at,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 10;

-- 3. Verificar total de transações por tabela
SELECT '=== TOTAL DE TRANSAÇÕES POR TABELA ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(created_at) as primeira_transacao,
    MAX(created_at) as ultima_transacao
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(created_at) as primeira_transacao,
    MAX(created_at) as ultima_transacao
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Verificar transações por mês (para dashboard)
SELECT '=== TRANSAÇÕES POR MÊS (DASHBOARD) ===' as info;
SELECT 
    EXTRACT(YEAR FROM transaction_date::date) as ano,
    EXTRACT(MONTH FROM transaction_date::date) as mes,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;

-- 5. Verificar transações por mês nas tabelas mensais
SELECT '=== TRANSAÇÕES POR MÊS (TABELAS MENSAIS) ===' as info;
SELECT 
    'transactions_2025_08' as tabela,
    EXTRACT(YEAR FROM transaction_date::date) as ano,
    EXTRACT(MONTH FROM transaction_date::date) as mes,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY ano, mes
ORDER BY ano DESC, mes DESC;

-- 6. Verificar transações de agosto especificamente
SELECT '=== TRANSAÇÕES DE AGOSTO 2025 ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    transaction_type,
    account_name,
    created_at
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-08-01'
  AND transaction_date <= '2025-08-31'
ORDER BY transaction_date DESC, created_at DESC;

-- 7. Verificar se há transações duplicadas
SELECT '=== VERIFICANDO DUPLICATAS ===' as info;
SELECT 
    description,
    amount,
    transaction_type,
    transaction_date,
    COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY description, amount, transaction_type, transaction_date
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 8. Verificar políticas RLS para SELECT
SELECT '=== POLÍTICAS RLS PARA SELECT ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
  AND cmd = 'SELECT'
ORDER BY tablename, policyname;

-- 9. Testar consulta como o usuário master
SELECT '=== TESTE DE CONSULTA COMO MASTER USER ===' as info;

-- Simular contexto do master user
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claim.sub" TO '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Testar consulta na tabela principal
SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Testar consulta na tabela mensal
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 10. Verificar configuração de timezone
SELECT '=== CONFIGURAÇÃO DE TIMEZONE ===' as info;
SHOW timezone;
SHOW datestyle;

SELECT '=== VERIFICAÇÃO CONCLUÍDA ===' as info;
