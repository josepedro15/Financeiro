-- Script para identificar e corrigir discrepância no cálculo do Dashboard
-- O Dashboard está calculando apenas receitas da "Conta PJ"

SELECT '=== DIAGNÓSTICO DO PROBLEMA DO DASHBOARD ===' as status;

-- 1. COMPARAR: RECEITAS TOTAIS vs RECEITAS APENAS "CONTA PJ"
-- ==========================================================

SELECT '--- MARÇO 2025: COMPARAÇÃO TOTAL vs CONTA PJ ---' as secao;

-- Total geral de receitas (todas as contas)
SELECT 'MARÇO - RECEITAS TOTAIS:' as tipo,
       SUM(amount) as valor_total,
       COUNT(*) as transacoes
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income';

-- Apenas receitas da "Conta PJ" (como o Dashboard calcula)
SELECT 'MARÇO - RECEITAS CONTA PJ:' as tipo,
       SUM(amount) as valor_conta_pj,
       COUNT(*) as transacoes
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name = 'Conta PJ';

-- Receitas de outras contas
SELECT 'MARÇO - OUTRAS CONTAS:' as tipo,
       account_name,
       SUM(amount) as valor,
       COUNT(*) as transacoes
FROM public.transactions_2025_03 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name != 'Conta PJ'
GROUP BY account_name;

SELECT '--- ABRIL 2025: COMPARAÇÃO TOTAL vs CONTA PJ ---' as secao;

-- Total geral de receitas (todas as contas)
SELECT 'ABRIL - RECEITAS TOTAIS:' as tipo,
       SUM(amount) as valor_total,
       COUNT(*) as transacoes
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income';

-- Apenas receitas da "Conta PJ" (como o Dashboard calcula)
SELECT 'ABRIL - RECEITAS CONTA PJ:' as tipo,
       SUM(amount) as valor_conta_pj,
       COUNT(*) as transacoes
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name = 'Conta PJ';

-- Receitas de outras contas
SELECT 'ABRIL - OUTRAS CONTAS:' as tipo,
       account_name,
       SUM(amount) as valor,
       COUNT(*) as transacoes
FROM public.transactions_2025_04 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name != 'Conta PJ'
GROUP BY account_name;

SELECT '--- JUNHO 2025: COMPARAÇÃO TOTAL vs CONTA PJ ---' as secao;

-- Total geral de receitas (todas as contas)
SELECT 'JUNHO - RECEITAS TOTAIS:' as tipo,
       SUM(amount) as valor_total,
       COUNT(*) as transacoes
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income';

-- Apenas receitas da "Conta PJ" (como o Dashboard calcula)
SELECT 'JUNHO - RECEITAS CONTA PJ:' as tipo,
       SUM(amount) as valor_conta_pj,
       COUNT(*) as transacoes
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name = 'Conta PJ';

-- Receitas de outras contas
SELECT 'JUNHO - OUTRAS CONTAS:' as tipo,
       account_name,
       SUM(amount) as valor,
       COUNT(*) as transacoes
FROM public.transactions_2025_06 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name != 'Conta PJ'
GROUP BY account_name;

SELECT '--- JULHO 2025: COMPARAÇÃO TOTAL vs CONTA PJ ---' as secao;

-- Total geral de receitas (todas as contas)
SELECT 'JULHO - RECEITAS TOTAIS:' as tipo,
       SUM(amount) as valor_total,
       COUNT(*) as transacoes
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income';

-- Apenas receitas da "Conta PJ" (como o Dashboard calcula)
SELECT 'JULHO - RECEITAS CONTA PJ:' as tipo,
       SUM(amount) as valor_conta_pj,
       COUNT(*) as transacoes
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name = 'Conta PJ';

-- Receitas de outras contas
SELECT 'JULHO - OUTRAS CONTAS:' as tipo,
       account_name,
       SUM(amount) as valor,
       COUNT(*) as transacoes
FROM public.transactions_2025_07 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
  AND transaction_type = 'income'
  AND account_name != 'Conta PJ'
GROUP BY account_name;

-- 2. LISTAR TODOS OS TIPOS DE CONTA UTILIZADOS
-- ============================================

SELECT '--- TIPOS DE CONTA NO SISTEMA ---' as secao;

-- Ver todas as combinações de account_name usadas
WITH todas_contas AS (
    SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_01 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_02 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_03 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_05 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_06 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_07 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
    UNION SELECT DISTINCT account_name, transaction_type FROM public.transactions_2025_08 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'CONTAS UTILIZADAS:' as tipo, account_name, transaction_type
FROM todas_contas
ORDER BY account_name, transaction_type;

-- 3. VALORES CORRETOS QUE O DASHBOARD DEVERIA MOSTRAR
-- ===================================================

SELECT '--- VALORES CORRETOS PARA O DASHBOARD ---' as secao;

-- Março: O que deveria aparecer
WITH marco_correto AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_totais,
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receitas_pj_apenas
    FROM public.transactions_2025_03 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'MARÇO CORRETO:' as mes, 
       receitas_totais,
       receitas_pj_apenas,
       'Dashboard mostra: ' || receitas_pj_apenas || ' | Deveria mostrar: ' || receitas_totais as comparacao
FROM marco_correto;

-- Abril: O que deveria aparecer
WITH abril_correto AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_totais,
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receitas_pj_apenas
    FROM public.transactions_2025_04 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'ABRIL CORRETO:' as mes, 
       receitas_totais,
       receitas_pj_apenas,
       'Dashboard mostra: ' || receitas_pj_apenas || ' | Deveria mostrar: ' || receitas_totais as comparacao
FROM abril_correto;

-- Junho: O que deveria aparecer
WITH junho_correto AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_totais,
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receitas_pj_apenas
    FROM public.transactions_2025_06 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'JUNHO CORRETO:' as mes, 
       receitas_totais,
       receitas_pj_apenas,
       'Dashboard mostra: ' || receitas_pj_apenas || ' | Deveria mostrar: ' || receitas_totais as comparacao
FROM junho_correto;

-- Julho: O que deveria aparecer
WITH julho_correto AS (
    SELECT 
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_totais,
        SUM(CASE WHEN transaction_type = 'income' AND account_name = 'Conta PJ' THEN amount ELSE 0 END) as receitas_pj_apenas
    FROM public.transactions_2025_07 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::uuid
)
SELECT 'JULHO CORRETO:' as mes, 
       receitas_totais,
       receitas_pj_apenas,
       'Dashboard mostra: ' || receitas_pj_apenas || ' | Deveria mostrar: ' || receitas_totais as comparacao
FROM julho_correto;

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as status;
SELECT 'PROBLEMA IDENTIFICADO: Dashboard calcula apenas receitas da "Conta PJ"' as problema;
SELECT 'SOLUÇÃO: Alterar o código para incluir todas as contas de receita' as solucao;
