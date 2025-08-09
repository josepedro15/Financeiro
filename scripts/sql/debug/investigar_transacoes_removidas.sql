-- Script para investigar o que foi removido incorretamente
-- Valor atual: R$ 13.349,21
-- Valor esperado: R$ 16.819,01
-- Faltando: R$ 3.469,80

-- 1. Verificar estado atual
SELECT 
    '📊 ESTADO ATUAL:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    16819.01 as valor_esperado,
    (16819.01 - SUM(amount)) as valor_faltando
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3;

-- 2. Verificar se ainda há duplicatas restantes
SELECT 
    '🔄 DUPLICATAS RESTANTES:' as status,
    client_name,
    amount,
    transaction_date,
    account_name,
    COUNT(*) as quantidade
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY client_name, amount, transaction_date, account_name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- 3. Resumo por dia para verificar se algum dia ficou vazio
SELECT 
    '📅 RESUMO POR DIA ATUAL:' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY transaction_date
ORDER BY transaction_date;

-- 4. Identificar dias que podem estar com valores muito baixos
SELECT 
    '⚠️ DIAS COM VALORES BAIXOS:' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    CASE 
        WHEN SUM(amount) < 200 THEN '❌ MUITO BAIXO'
        WHEN SUM(amount) < 500 THEN '⚠️ BAIXO'
        ELSE '✅ OK'
    END as status_dia
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY transaction_date
HAVING SUM(amount) < 500
ORDER BY SUM(amount);

-- 5. Verificar se há dados na tabela principal que precisam ser migrados
SELECT 
    '📋 DADOS NA TABELA PRINCIPAL:' as status,
    COUNT(*) as total_transacoes_principal,
    SUM(amount) as valor_total_principal
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3;
