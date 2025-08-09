-- Script para investigar a diferença em março 2025
-- Valor esperado: R$ 16.819,01
-- Valor atual no banco: R$ 18.041,00
-- Diferença: +R$ 1.222,00

-- 1. Total atual no banco
SELECT 
    '🔍 TOTAL ATUAL NO BANCO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total_banco
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar se há duplicatas (mesmo client_name, amount, date)
SELECT 
    '🔄 POSSÍVEIS DUPLICATAS:' as status,
    client_name,
    amount,
    transaction_date,
    COUNT(*) as quantidade,
    SUM(amount) as valor_total_duplicata
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY client_name, amount, transaction_date
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, amount DESC;

-- 3. Verificar se há lançamentos de META
SELECT 
    '🎯 VERIFICAR LANÇAMENTOS DE META:' as status,
    client_name,
    description,
    amount,
    transaction_date
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (
    UPPER(description) LIKE '%META%' OR
    UPPER(client_name) LIKE '%META%' OR
    UPPER(description) LIKE '%SALDO%' OR
    UPPER(description) LIKE '%ADICIONAL%'
  )
ORDER BY transaction_date, amount DESC;

-- 4. Verificar transações por dia com totais
SELECT 
    '📅 RESUMO POR DIA:' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(amount) as menor_valor,
    MAX(amount) as maior_valor
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 5. Verificar as 20 maiores transações de março
SELECT 
    '💰 MAIORES TRANSAÇÕES DE MARÇO:' as status,
    transaction_date,
    client_name,
    amount,
    account_name,
    description,
    ROW_NUMBER() OVER (ORDER BY amount DESC) as ranking
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY amount DESC
LIMIT 20;

-- 6. Verificar valores suspeitos (muito altos ou redondos)
SELECT 
    '⚠️ VALORES SUSPEITOS:' as status,
    transaction_date,
    client_name,
    amount,
    account_name,
    'Valor muito alto ou suspeito' as motivo
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND (
    amount > 200 OR  -- Valores muito altos
    amount = 1200 OR -- Meta comum
    amount = 2094.32 -- Meta específica vista nas imagens
  )
ORDER BY amount DESC;

-- 7. Verificar se há dados na tabela principal também
SELECT 
    '📋 DADOS NA TABELA PRINCIPAL:' as status,
    COUNT(*) as total_transacoes_principal,
    SUM(amount) as valor_total_principal
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 8. Somatório por conta
SELECT 
    '💳 TOTAL POR CONTA:' as status,
    account_name,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    ROUND(AVG(amount), 2) as valor_medio
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY account_name
ORDER BY valor_total DESC;

-- 9. Verificar IDs duplicados
SELECT 
    '🆔 IDS DUPLICADOS:' as status,
    id,
    COUNT(*) as quantidade
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
  AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
GROUP BY id
HAVING COUNT(*) > 1;

-- 10. Diferença calculada
SELECT 
    '📊 ANÁLISE DA DIFERENÇA:' as status,
    18041.00 as valor_atual_banco,
    16819.01 as valor_esperado,
    (18041.00 - 16819.01) as diferenca,
    ROUND(((18041.00 - 16819.01) / 16819.01) * 100, 2) as percentual_diferenca;
