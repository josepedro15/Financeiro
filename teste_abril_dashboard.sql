-- Script para simular exatamente o que o Dashboard faz para abril
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- Simular a lógica do Dashboard para abril 2025
-- Dashboard usa: currentMonth = new Date().getMonth() (0-based)
-- Para abril 2025: currentMonth = 3 (abril é mês 3 em JS)
-- currentYear = 2025

SELECT '=== SIMULAÇÃO EXATA DO DASHBOARD ===' as info;

-- 1. Verificar se há transações de abril 2025
SELECT '=== TRANSAÇÕES DE ABRIL 2025 ===' as info;
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

-- 3. Verificar apenas transações de INCOME em abril
SELECT '=== TRANSAÇÕES DE INCOME EM ABRIL ===' as info;
SELECT 
    COUNT(*) as total_income_abril,
    SUM(amount) as faturamento_income_abril,
    ROUND(SUM(amount), 2) as faturamento_income_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
AND transaction_type = 'income';

-- 4. Verificar transações de income por dia em abril
SELECT '=== INCOME POR DIA EM ABRIL ===' as info;
SELECT 
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_dia,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
AND transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 5. Verificar se há transações com valores zero em abril
SELECT '=== TRANSAÇÕES COM VALOR ZERO EM ABRIL ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    transaction_type
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
AND amount = 0
ORDER BY transaction_date;

-- 6. Verificar total de income por mês (para comparar)
SELECT '=== INCOME POR MÊS ===' as info;
SELECT 
    EXTRACT(MONTH FROM transaction_date) as mes,
    EXTRACT(YEAR FROM transaction_date) as ano,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_total,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_type = 'income'
AND EXTRACT(YEAR FROM transaction_date) = 2025
GROUP BY EXTRACT(MONTH FROM transaction_date), EXTRACT(YEAR FROM transaction_date)
ORDER BY mes; 