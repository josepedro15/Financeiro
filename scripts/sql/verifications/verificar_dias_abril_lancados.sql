-- Verificar quais dias de abril 2025 já foram lançados no banco
-- Script para mostrar os dias de abril com transações

-- 1. Verificar transações de abril por dia (tabela mensal)
SELECT 
    EXTRACT(DAY FROM transaction_date) as dia_abril,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia_abril;

-- 2. Também verificar na tabela principal (caso ainda existam dados lá)
SELECT 
    EXTRACT(DAY FROM transaction_date) as dia_abril,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia_abril;

-- 3. Resumo: quais dias têm dados e quais não têm
SELECT 
    dia,
    CASE 
        WHEN dia IN (
            SELECT DISTINCT EXTRACT(DAY FROM transaction_date)
            FROM public.transactions_2025_04
            WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
              AND EXTRACT(MONTH FROM transaction_date) = 4
        ) THEN '✅ LANÇADO'
        ELSE '❌ FALTANDO'
    END as status
FROM generate_series(1, 30) as dia  -- Abril tem 30 dias
ORDER BY dia;

-- 4. Primeiro e último dia lançados
SELECT 
    MIN(EXTRACT(DAY FROM transaction_date)) as primeiro_dia_lancado,
    MAX(EXTRACT(DAY FROM transaction_date)) as ultimo_dia_lancado,
    COUNT(DISTINCT EXTRACT(DAY FROM transaction_date)) as total_dias_com_dados
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4;

-- 5. Lista dos dias específicos que foram lançados
SELECT DISTINCT 
    EXTRACT(DAY FROM transaction_date) as dias_lancados
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4
ORDER BY dias_lancados;
