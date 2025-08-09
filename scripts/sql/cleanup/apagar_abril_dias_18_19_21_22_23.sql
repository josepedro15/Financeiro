-- Script para apagar transações específicas de abril 2025 (dias 18, 19, 21, 22, 23)
-- Execute este script no Supabase SQL Editor para remover apenas estes dados

-- ATENÇÃO: Este script remove APENAS os dados dos dias específicos mencionados
-- Não afeta outras transações de abril

-- 1. Verificar quantas transações serão removidas ANTES de apagar
SELECT 
    'ANTES DA REMOÇÃO - Contagem por dia:' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_04
WHERE transaction_date IN ('2025-04-18', '2025-04-19', '2025-04-21', '2025-04-22', '2025-04-23')
GROUP BY transaction_date
ORDER BY transaction_date;

-- 2. Mostrar total geral que será removido
SELECT 
    'TOTAL A SER REMOVIDO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_04
WHERE transaction_date IN ('2025-04-18', '2025-04-19', '2025-04-21', '2025-04-22', '2025-04-23');

-- 3. APAGAR os dados dos dias específicos (tabela mensal)
DELETE FROM public.transactions_2025_04
WHERE transaction_date IN ('2025-04-18', '2025-04-19', '2025-04-21', '2025-04-22', '2025-04-23')
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 4. Também apagar da tabela principal (caso existam dados lá)
DELETE FROM public.transactions
WHERE transaction_date IN ('2025-04-18', '2025-04-19', '2025-04-21', '2025-04-22', '2025-04-23')
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 5. Verificar se foi removido corretamente (deve retornar 0 resultados)
SELECT 
    'DEPOIS DA REMOÇÃO - Verificação:' as status,
    transaction_date,
    COUNT(*) as total_transacoes
FROM public.transactions_2025_04
WHERE transaction_date IN ('2025-04-18', '2025-04-19', '2025-04-21', '2025-04-22', '2025-04-23')
GROUP BY transaction_date
ORDER BY transaction_date;

-- 6. Verificar estado atual de abril (dias restantes)
SELECT 
    'ESTADO ATUAL DE ABRIL:' as status,
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 7. Resumo final
SELECT 
    'RESUMO PÓS-LIMPEZA:' as status,
    COUNT(*) as total_transacoes_abril,
    SUM(amount) as valor_total_abril,
    MIN(EXTRACT(DAY FROM transaction_date)) as primeiro_dia,
    MAX(EXTRACT(DAY FROM transaction_date)) as ultimo_dia
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4;
