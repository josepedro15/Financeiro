-- Script para testar a lógica de filtro de data do Dashboard
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- Simular a lógica do Dashboard para abril de 2025
SELECT '=== TESTE DA LÓGICA DO DASHBOARD ===' as info;

-- 1. Verificar transações de abril de 2025
SELECT '=== TRANSAÇÕES DE ABRIL 2025 ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    EXTRACT(MONTH FROM transaction_date) as mes_banco,
    EXTRACT(YEAR FROM transaction_date) as ano_banco
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
ORDER BY transaction_date
LIMIT 10;

-- 2. Simular a lógica JavaScript do Dashboard
-- Dashboard usa: currentMonth = new Date().getMonth() (0-based)
-- Para abril 2025: currentMonth = 3 (abril é mês 3 em JS)
-- currentYear = 2025
SELECT '=== SIMULAÇÃO DA LÓGICA JS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    EXTRACT(MONTH FROM transaction_date) as mes_banco,
    EXTRACT(YEAR FROM transaction_date) as ano_banco,
    CASE 
        WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND EXTRACT(YEAR FROM transaction_date) = 2025 
        THEN 'ABRIL_2025_MATCH'
        ELSE 'NO_MATCH'
    END as match_status
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-04-01' 
AND transaction_date <= '2025-04-30'
ORDER BY transaction_date
LIMIT 10;

-- 3. Verificar se há transações de abril com problemas de data
SELECT '=== VERIFICAÇÃO DE PROBLEMAS DE DATA ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    EXTRACT(MONTH FROM transaction_date) as mes,
    EXTRACT(YEAR FROM transaction_date) as ano,
    CASE 
        WHEN EXTRACT(MONTH FROM transaction_date) != 4 THEN 'MÊS_ERRADO'
        WHEN EXTRACT(YEAR FROM transaction_date) != 2025 THEN 'ANO_ERRADO'
        ELSE 'OK'
    END as problema
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND (
    transaction_date >= '2025-04-01' AND transaction_date <= '2025-04-30'
    OR EXTRACT(MONTH FROM transaction_date) = 4
    OR EXTRACT(YEAR FROM transaction_date) = 2025
)
ORDER BY transaction_date;

-- 4. Verificar total de transações por mês (para confirmar que abril existe)
SELECT '=== TOTAL POR MÊS ===' as info;
SELECT 
    EXTRACT(MONTH FROM transaction_date) as mes,
    EXTRACT(YEAR FROM transaction_date) as ano,
    COUNT(*) as total_transacoes,
    SUM(amount) as faturamento_total,
    ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND EXTRACT(YEAR FROM transaction_date) = 2025
GROUP BY EXTRACT(MONTH FROM transaction_date), EXTRACT(YEAR FROM transaction_date)
ORDER BY mes;

-- 5. Verificar se há transações com datas inválidas
SELECT '=== VERIFICAÇÃO DE DATAS INVÁLIDAS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    CASE 
        WHEN transaction_date IS NULL THEN 'DATA_NULA'
        WHEN transaction_date < '2020-01-01' THEN 'DATA_MUITO_ANTIGA'
        WHEN transaction_date > '2030-12-31' THEN 'DATA_MUITO_FUTURA'
        ELSE 'OK'
    END as status_data
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND (
    transaction_date IS NULL
    OR transaction_date < '2020-01-01'
    OR transaction_date > '2030-12-31'
    OR (transaction_date >= '2025-04-01' AND transaction_date <= '2025-04-30')
)
ORDER BY transaction_date; 