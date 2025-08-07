-- Script para verificar transações de maio no banco
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- Verificar total de transações de maio no banco
SELECT '=== VERIFICAÇÃO ATUAL DO BANCO ===' as info;
SELECT 
    COUNT(*) as total_transacoes_banco,
    SUM(amount) as faturamento_total_banco,
    ROUND(SUM(amount), 2) as faturamento_arredondado_banco
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31';

-- Verificar por dia no banco
SELECT '=== TRANSAÇÕES POR DIA NO BANCO ===' as info;
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

-- Verificar dias que não têm transações no banco
SELECT '=== DIAS SEM TRANSAÇÕES NO BANCO ===' as info;
WITH dias_esperados AS (
    SELECT generate_series('2025-05-01'::date, '2025-05-31'::date, '1 day'::interval)::date as dia
),
dias_com_transacoes AS (
    SELECT DISTINCT transaction_date
    FROM public.transactions 
    WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
    AND transaction_date >= '2025-05-01' 
    AND transaction_date <= '2025-05-31'
)
SELECT 
    d.dia,
    CASE WHEN dt.transaction_date IS NULL THEN 'SEM TRANSAÇÕES' ELSE 'COM TRANSAÇÕES' END as status
FROM dias_esperados d
LEFT JOIN dias_com_transacoes dt ON d.dia = dt.transaction_date
WHERE dt.transaction_date IS NULL
ORDER BY d.dia;

-- Verificar transações com valores altos no banco
SELECT '=== TRANSAÇÕES COM VALORES ALTOS NO BANCO (>100) ===' as info;
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

-- Comparar com o esperado
SELECT '=== COMPARAÇÃO COM ESPERADO ===' as info;
SELECT 
    'ESPERADO' as tipo,
    330 as total_transacoes,
    20603.00 as faturamento_total
UNION ALL
SELECT 
    'BANCO' as tipo,
    COUNT(*) as total_transacoes,
    ROUND(SUM(amount), 2) as faturamento_total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'; 