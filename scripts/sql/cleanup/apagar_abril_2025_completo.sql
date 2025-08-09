-- Script para apagar COMPLETAMENTE o mês de abril 2025
-- Execute este script no Supabase SQL Editor
-- ⚠️ ATENÇÃO: Remove TODOS os dados de abril 2025 das tabelas

-- ==========================================
-- VERIFICAÇÕES ANTES DA REMOÇÃO
-- ==========================================

-- 1. Verificar dados na tabela mensal de abril
SELECT 
    'TABELA MENSAL - ANTES DA REMOÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar dados na tabela principal (caso existam)
SELECT 
    'TABELA PRINCIPAL - ANTES DA REMOÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 3. Detalhamento por dia (tabela mensal)
SELECT 
    'DETALHAMENTO POR DIA - TABELA MENSAL:' as status,
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 4. Detalhamento por dia (tabela principal)
SELECT 
    'DETALHAMENTO POR DIA - TABELA PRINCIPAL:' as status,
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- ==========================================
-- REMOÇÃO COMPLETA DO MÊS DE ABRIL 2025
-- ==========================================

-- 5. APAGAR TODOS os dados de abril da tabela mensal
DELETE FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 6. APAGAR TODOS os dados de abril da tabela principal
DELETE FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- ==========================================
-- VERIFICAÇÕES APÓS A REMOÇÃO
-- ==========================================

-- 7. Verificar se a tabela mensal está vazia
SELECT 
    'VERIFICAÇÃO PÓS-REMOÇÃO - TABELA MENSAL:' as status,
    COUNT(*) as total_transacoes_restantes
FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 8. Verificar se não restaram dados na tabela principal
SELECT 
    'VERIFICAÇÃO PÓS-REMOÇÃO - TABELA PRINCIPAL:' as status,
    COUNT(*) as total_transacoes_restantes
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 9. Verificar outros meses que ainda existem
SELECT 
    'OUTROS MESES EXISTENTES - TABELA PRINCIPAL:' as status,
    EXTRACT(YEAR FROM transaction_date) as ano,
    EXTRACT(MONTH FROM transaction_date) as mes,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date)
ORDER BY ano, mes;

-- 10. Verificar outras tabelas mensais que existem
SELECT 
    'MAIO 2025 - VERIFICAÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_05
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

SELECT 
    'JUNHO 2025 - VERIFICAÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_06
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

SELECT 
    'JULHO 2025 - VERIFICAÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_07
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

SELECT 
    'AGOSTO 2025 - VERIFICAÇÃO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_08
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- ==========================================
-- RESUMO FINAL
-- ==========================================

-- 11. Resumo do estado atual do sistema
SELECT 
    '📊 RESUMO FINAL DO SISTEMA:' as status,
    'Abril 2025 foi COMPLETAMENTE removido' as resultado,
    'Outros meses permanecem intactos' as observacao;

-- 12. Próximos passos sugeridos
SELECT 
    '📋 PRÓXIMOS PASSOS:' as info,
    '1. Conferir se os outros meses estão OK' as passo_1,
    '2. Testar a página de transações' as passo_2,
    '3. Reinserir abril com dados corretos se necessário' as passo_3;
