-- Script para verificar transações de abril no sistema
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- 1. Verificar se as transações de abril existem no banco
SELECT '=== VERIFICAÇÃO DE ABRIL NO BANCO ===' as info;
SELECT 
    COUNT(*) as total_transacoes_abril,
    SUM(amount) as faturamento_total_abril,
    ROUND(SUM(amount), 2) as faturamento_arredondado_abril
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30';

-- 2. Verificar transações por dia em abril
SELECT '=== TRANSAÇÕES POR DIA EM ABRIL ===' as info;
SELECT 
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_dia,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 3. Verificar se há transações de abril com valores zero
SELECT '=== TRANSAÇÕES COM VALOR ZERO EM ABRIL ===' as info;
SELECT 
    transaction_date,
    description,
    amount
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
AND amount = 0
ORDER BY transaction_date;

-- 4. Verificar transações com valores altos em abril
SELECT '=== TRANSAÇÕES COM VALORES ALTOS EM ABRIL (>50) ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    ROUND(amount, 2) as valor_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
AND amount > 50
ORDER BY amount DESC;

-- 5. Verificar todas as transações por mês (para comparar)
SELECT '=== COMPARAÇÃO POR MÊS ===' as info;
SELECT 
    EXTRACT(MONTH FROM transaction_date) as mes,
    EXTRACT(YEAR FROM transaction_date) as ano,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_total,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-01-01' 
AND transaction_date <= '2025-12-31'
GROUP BY EXTRACT(MONTH FROM transaction_date), EXTRACT(YEAR FROM transaction_date)
ORDER BY ano, mes;

-- 6. Verificar se há problemas de data (transações em meses errados)
SELECT '=== VERIFICAÇÃO DE DATAS PROBLEMÁTICAS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    EXTRACT(MONTH FROM transaction_date) as mes,
    EXTRACT(YEAR FROM transaction_date) as ano
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND (
    EXTRACT(MONTH FROM transaction_date) = 4 
    OR EXTRACT(MONTH FROM transaction_date) = 5 
    OR EXTRACT(MONTH FROM transaction_date) = 6 
    OR EXTRACT(MONTH FROM transaction_date) = 7
)
AND EXTRACT(YEAR FROM transaction_date) = 2025
ORDER BY transaction_date;

-- 7. Verificar se há transações duplicadas
SELECT '=== VERIFICAÇÃO DE DUPLICATAS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    COUNT(*) as quantidade
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY transaction_date; 