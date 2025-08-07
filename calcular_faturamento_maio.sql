-- Script para calcular o faturamento total de maio de 2025
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- Calcular faturamento total de maio
SELECT '=== FATURAMENTO TOTAL DE MAIO ===' as info;
SELECT 
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_total,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31';

-- Calcular faturamento por dia
SELECT '=== FATURAMENTO POR DIA ===' as info;
SELECT 
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_dia,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Verificar transações com valores altos
SELECT '=== TRANSAÇÕES COM VALORES ALTOS (>100) ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    ROUND(amount, 2) as valor_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'
AND amount > 100
ORDER BY amount DESC;

-- Verificar transações com valores zero
SELECT '=== TRANSAÇÕES COM VALOR ZERO ===' as info;
SELECT 
    transaction_date,
    description,
    amount
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'
AND amount = 0;

-- Calcular estatísticas de valores
SELECT '=== ESTATÍSTICAS DE VALORES ===' as info;
SELECT 
    MIN(amount) as valor_minimo,
    MAX(amount) as valor_maximo,
    AVG(amount) as valor_medio,
    ROUND(AVG(amount), 2) as valor_medio_arredondado,
    COUNT(CASE WHEN amount = 0 THEN 1 END) as transacoes_zero,
    COUNT(CASE WHEN amount > 0 THEN 1 END) as transacoes_positivas
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'; 