-- VERIFICAR CRESCIMENTO MENSAL
-- Execute este script no Supabase SQL Editor

-- 1. Verificar data atual
SELECT '=== DATA ATUAL ===' as info;
SELECT 
    CURRENT_DATE as data_atual,
    EXTRACT(DAY FROM CURRENT_DATE) as dia_atual,
    EXTRACT(MONTH FROM CURRENT_DATE) as mes_atual,
    EXTRACT(YEAR FROM CURRENT_DATE) as ano_atual;

-- 2. Calcular mês anterior
SELECT '=== MÊS ANTERIOR ===' as info;
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM CURRENT_DATE) = 1 THEN 12
        ELSE EXTRACT(MONTH FROM CURRENT_DATE) - 1
    END as mes_anterior,
    CASE 
        WHEN EXTRACT(MONTH FROM CURRENT_DATE) = 1 THEN EXTRACT(YEAR FROM CURRENT_DATE) - 1
        ELSE EXTRACT(YEAR FROM CURRENT_DATE)
    END as ano_anterior;

-- 3. Verificar tabelas mensais existentes
SELECT '=== TABELAS MENSAIS EXISTENTES ===' as info;
SELECT 
    table_name,
    CASE 
        WHEN table_name LIKE 'transactions_2025_%' THEN 'EXISTE'
        ELSE 'NÃO EXISTE'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN (
    'transactions_2025_07',  -- Julho
    'transactions_2025_08'   -- Agosto
  )
ORDER BY table_name;

-- 4. Verificar dados do mês atual (Agosto)
SELECT '=== DADOS MÊS ATUAL (AGOSTO) ===' as info;
SELECT 
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 5. Verificar dados acumulados até hoje no mês atual
SELECT '=== ACUMULADO ATÉ HOJE (AGOSTO) ===' as info;
SELECT 
    COUNT(*) as transacoes_ate_hoje,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_ate_hoje,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_ate_hoje
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND transaction_date <= CURRENT_DATE;

-- 6. Verificar dados do mês anterior (Julho)
SELECT '=== DADOS MÊS ANTERIOR (JULHO) ===' as info;
SELECT 
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- 7. Verificar dados acumulados até o mesmo dia no mês anterior
SELECT '=== ACUMULADO ATÉ MESMO DIA (JULHO) ===' as info;
SELECT 
    COUNT(*) as transacoes_ate_mesmo_dia,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas_ate_mesmo_dia,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas_ate_mesmo_dia
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND transaction_date <= (CURRENT_DATE - INTERVAL '1 month');

-- 8. Calcular crescimento mensal
SELECT '=== CÁLCULO CRESCIMENTO MENSAL ===' as info;
WITH 
atual AS (
    SELECT SUM(amount) as receitas_ate_hoje
    FROM transactions_2025_08 
    WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
      AND transaction_type = 'income'
      AND transaction_date <= CURRENT_DATE
),
anterior AS (
    SELECT SUM(amount) as receitas_ate_mesmo_dia
    FROM transactions_2025_07 
    WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
      AND transaction_type = 'income'
      AND transaction_date <= (CURRENT_DATE - INTERVAL '1 month')
)
SELECT 
    COALESCE(atual.receitas_ate_hoje, 0) as receitas_agosto_ate_hoje,
    COALESCE(anterior.receitas_ate_mesmo_dia, 0) as receitas_julho_ate_mesmo_dia,
    CASE 
        WHEN COALESCE(anterior.receitas_ate_mesmo_dia, 0) > 0 THEN
            ((COALESCE(atual.receitas_ate_hoje, 0) - COALESCE(anterior.receitas_ate_mesmo_dia, 0)) / COALESCE(anterior.receitas_ate_mesmo_dia, 0)) * 100
        ELSE 0
    END as crescimento_percentual
FROM atual, anterior;

-- 9. Verificar todas as transações de receita por data
SELECT '=== TRANSAÇÕES DE RECEITA POR DATA ===' as info;
SELECT 
    transaction_date,
    amount,
    description,
    'AGOSTO' as mes
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND transaction_type = 'income'
  AND transaction_date <= CURRENT_DATE
ORDER BY transaction_date

UNION ALL

SELECT 
    transaction_date,
    amount,
    description,
    'JULHO' as mes
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND transaction_type = 'income'
  AND transaction_date <= (CURRENT_DATE - INTERVAL '1 month')
ORDER BY transaction_date;

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as info;
