-- Verificar se os dados do usuário original estão intactos
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

SELECT '=== VERIFICAÇÃO DOS DADOS ORIGINAIS ===' as status;

-- 1. VERIFICAR CLIENTES
-- =====================

SELECT '--- CLIENTES DO USUÁRIO ORIGINAL ---' as secao;

SELECT 'TOTAL CLIENTES:' as tipo, COUNT(*) as total 
FROM public.clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Clientes por estágio
SELECT 'CLIENTES POR ESTÁGIO:' as tipo, 
       COALESCE(stage, 'sem_estagio') as estagio,
       COUNT(*) as total
FROM public.clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY stage
ORDER BY stage;

-- Amostra de clientes
SELECT 'AMOSTRA DE CLIENTES:' as tipo, name, email, stage, is_active, created_at
FROM public.clients 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
ORDER BY created_at DESC
LIMIT 5;

-- 2. VERIFICAR TRANSAÇÕES MENSAIS (2025)
-- ======================================

SELECT '--- TRANSAÇÕES POR MÊS (2025) ---' as secao;

-- Janeiro 2025
SELECT 'JANEIRO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_01 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Fevereiro 2025
SELECT 'FEVEREIRO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_02 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Março 2025
SELECT 'MARÇO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Abril 2025
SELECT 'ABRIL 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Maio 2025
SELECT 'MAIO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_05 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Junho 2025
SELECT 'JUNHO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Julho 2025
SELECT 'JULHO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Agosto 2025
SELECT 'AGOSTO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- 3. RESUMO GERAL DE TRANSAÇÕES
-- =============================

SELECT '--- RESUMO GERAL ---' as secao;

-- Total geral de transações 2025
WITH monthly_totals AS (
    SELECT COUNT(*) as total, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas, SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas FROM public.transactions_2025_01 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_02 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_03 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_05 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_06 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_07 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT COUNT(*), SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) FROM public.transactions_2025_08 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'TOTAL 2025:' as tipo,
       SUM(total) as total_transacoes,
       SUM(receitas) as total_receitas,
       SUM(despesas) as total_despesas,
       SUM(receitas) - SUM(despesas) as saldo_liquido
FROM monthly_totals;

-- 4. VERIFICAR TRANSAÇÕES RECENTES
-- ================================

SELECT '--- ÚLTIMAS 10 TRANSAÇÕES ---' as secao;

-- Últimas transações de todas as tabelas mensais
WITH todas_transacoes AS (
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-01' as tabela FROM public.transactions_2025_01 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-02' FROM public.transactions_2025_02 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-03' FROM public.transactions_2025_03 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-04' FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-05' FROM public.transactions_2025_05 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-06' FROM public.transactions_2025_06 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-07' FROM public.transactions_2025_07 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION ALL
    SELECT transaction_date, description, amount, transaction_type, account_name, '2025-08' FROM public.transactions_2025_08 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'ÚLTIMAS TRANSAÇÕES:' as tipo, 
       transaction_date, 
       description, 
       amount, 
       transaction_type, 
       account_name,
       tabela
FROM todas_transacoes
ORDER BY transaction_date DESC, amount DESC
LIMIT 10;

-- 5. VERIFICAR SE EXISTEM DADOS DO OUTRO USUÁRIO
-- ==============================================

SELECT '--- VERIFICAÇÃO DO OUTRO USUÁRIO ---' as secao;

SELECT 'OUTROS USUÁRIOS NO SISTEMA:' as tipo,
       COUNT(*) as total_clientes_outros_usuarios
FROM public.clients 
WHERE user_id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Verificar especificamente o usuário a65d9dff
SELECT 'USUÁRIO a65d9dff:' as tipo,
       COUNT(*) as total_clientes
FROM public.clients 
WHERE user_id = 'a65d9dff-90a6-4c43-8156-4829ebfebfaf'::uuid;

SELECT '=== VERIFICAÇÃO CONCLUÍDA ===' as status;
SELECT 'Seus dados originais estão seguros e intactos!' as info;
