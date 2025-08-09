-- Investigar dados de faturamento incorretos
-- Comparar valores esperados vs valores do dashboard

SELECT '=== INVESTIGAÇÃO DOS DADOS DE FATURAMENTO ===' as status;

-- 1. VERIFICAR FATURAMENTO REAL POR MÊS (APENAS RECEITAS)
-- =======================================================

SELECT '--- FATURAMENTO REAL POR MÊS (APENAS INCOME) ---' as secao;

-- Março 2025 - Valor esperado vs real
SELECT 'MARÇO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(amount) as faturamento_total,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_apenas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_apenas
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Abril 2025 - Valor esperado vs real  
SELECT 'ABRIL 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(amount) as faturamento_total,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_apenas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_apenas
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Junho 2025 - Valor esperado vs real
SELECT 'JUNHO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(amount) as faturamento_total,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_apenas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_apenas
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- Julho 2025 - Valor esperado vs real
SELECT 'JULHO 2025:' as mes,
       COUNT(*) as total_transacoes,
       SUM(amount) as faturamento_total,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_apenas,
       SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_apenas
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid;

-- 2. VERIFICAR FILTROS POR ACCOUNT_NAME
-- =====================================

SELECT '--- FATURAMENTO POR CONTA ---' as secao;

-- Março 2025 por conta
SELECT 'MARÇO 2025 POR CONTA:' as tipo,
       account_name,
       transaction_type,
       COUNT(*) as total_transacoes,
       SUM(amount) as total_valor
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY account_name, transaction_type
ORDER BY account_name, transaction_type;

-- Abril 2025 por conta
SELECT 'ABRIL 2025 POR CONTA:' as tipo,
       account_name,
       transaction_type,
       COUNT(*) as total_transacoes,
       SUM(amount) as total_valor
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY account_name, transaction_type
ORDER BY account_name, transaction_type;

-- Junho 2025 por conta
SELECT 'JUNHO 2025 POR CONTA:' as tipo,
       account_name,
       transaction_type,
       COUNT(*) as total_transacoes,
       SUM(amount) as total_valor
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY account_name, transaction_type
ORDER BY account_name, transaction_type;

-- Julho 2025 por conta
SELECT 'JULHO 2025 POR CONTA:' as tipo,
       account_name,
       transaction_type,
       COUNT(*) as total_transacoes,
       SUM(amount) as total_valor
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY account_name, transaction_type
ORDER BY account_name, transaction_type;

-- 3. VERIFICAR APENAS CONTA PJ (COMO NO DASHBOARD)
-- ===============================================

SELECT '--- FATURAMENTO CONTA PJ APENAS ---' as secao;

-- Março 2025 - Só Conta PJ
SELECT 'MARÇO 2025 - CONTA PJ:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_conta_pj
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND account_name = 'Conta PJ';

-- Abril 2025 - Só Conta PJ
SELECT 'ABRIL 2025 - CONTA PJ:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_conta_pj
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND account_name = 'Conta PJ';

-- Junho 2025 - Só Conta PJ
SELECT 'JUNHO 2025 - CONTA PJ:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_conta_pj
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND account_name = 'Conta PJ';

-- Julho 2025 - Só Conta PJ
SELECT 'JULHO 2025 - CONTA PJ:' as mes,
       COUNT(*) as total_transacoes,
       SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_conta_pj
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND account_name = 'Conta PJ';

-- 4. VERIFICAR TODOS OS TIPOS DE CONTA DISPONÍVEIS
-- ===============================================

SELECT '--- TIPOS DE CONTA NO SISTEMA ---' as secao;

SELECT 'CONTAS MARÇO:' as mes, DISTINCT account_name 
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
ORDER BY account_name;

SELECT 'CONTAS ABRIL:' as mes, DISTINCT account_name 
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
ORDER BY account_name;

SELECT 'CONTAS JUNHO:' as mes, DISTINCT account_name 
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
ORDER BY account_name;

SELECT 'CONTAS JULHO:' as mes, DISTINCT account_name 
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
ORDER BY account_name;

-- 5. SIMULAR QUERY DO DASHBOARD
-- ============================

SELECT '--- SIMULAÇÃO DA QUERY DO DASHBOARD ---' as secao;

-- Query similar à do Dashboard para Março
WITH marco_dashboard AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receita_pj
    FROM public.transactions_2025_03 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'MARÇO DASHBOARD SIMULATION:' as tipo, receita_pj FROM marco_dashboard;

-- Query similar à do Dashboard para Abril  
WITH abril_dashboard AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receita_pj
    FROM public.transactions_2025_04 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'ABRIL DASHBOARD SIMULATION:' as tipo, receita_pj FROM abril_dashboard;

-- Query similar à do Dashboard para Junho
WITH junho_dashboard AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receita_pj
    FROM public.transactions_2025_06 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'JUNHO DASHBOARD SIMULATION:' as tipo, receita_pj FROM junho_dashboard;

-- Query similar à do Dashboard para Julho
WITH julho_dashboard AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receita_pj
    FROM public.transactions_2025_07 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'JULHO DASHBOARD SIMULATION:' as tipo, receita_pj FROM julho_dashboard;

-- 6. VERIFICAR CATEGORIAS QUE PODEM ESTAR SENDO EXCLUÍDAS
-- =======================================================

SELECT '--- CATEGORIAS POR MÊS ---' as secao;

-- Março categorias
SELECT 'MARÇO CATEGORIAS:' as mes,
       category,
       transaction_type,
       COUNT(*) as total,
       SUM(amount) as valor_total
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY category, transaction_type
ORDER BY valor_total DESC;

-- Abril categorias  
SELECT 'ABRIL CATEGORIAS:' as mes,
       category,
       transaction_type,
       COUNT(*) as total,
       SUM(amount) as valor_total
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
GROUP BY category, transaction_type
ORDER BY valor_total DESC;

SELECT '=== INVESTIGAÇÃO CONCLUÍDA ===' as status;
SELECT 'Compare os valores acima com o que aparece no dashboard' as info;
SELECT 'Verifique especialmente os filtros por account_name e transaction_type' as dica;
