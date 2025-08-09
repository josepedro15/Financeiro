-- Script para verificar total lançado no mês 4 (Abril 2025)

-- 1. RESUMO GERAL - ABRIL 2025
SELECT 'RESUMO GERAL ABRIL 2025:' as info;
SELECT 
    COUNT(*) as total_transacoes,
    COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as total_receitas_qtd,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as total_despesas_qtd,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas_valor,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas_valor,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo_liquido
FROM public.transactions_2025_04;

-- 2. DETALHAMENTO POR CONTA - ABRIL 2025
SELECT 'DETALHAMENTO POR CONTA - ABRIL 2025:' as info;
SELECT 
    account_name,
    COUNT(*) as total_transacoes,
    COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas_qtd,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas_qtd,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as total_receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_despesas,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo_conta
FROM public.transactions_2025_04
GROUP BY account_name
ORDER BY account_name;

-- 3. RECEITAS POR DIA - ABRIL 2025
SELECT 'RECEITAS POR DIA - ABRIL 2025:' as info;
SELECT 
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as qtd_transacoes,
    SUM(amount) as total_receitas,
    STRING_AGG(CONCAT(description, ' (R$ ', amount::text, ')'), ' | ') as detalhes
FROM public.transactions_2025_04
WHERE transaction_type = 'income'
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 4. DESPESAS POR DIA - ABRIL 2025
SELECT 'DESPESAS POR DIA - ABRIL 2025:' as info;
SELECT 
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as qtd_transacoes,
    SUM(amount) as total_despesas,
    STRING_AGG(CONCAT(description, ' (R$ ', amount::text, ')'), ' | ') as detalhes
FROM public.transactions_2025_04
WHERE transaction_type = 'expense'
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 5. TOTAIS POR CATEGORIA - RECEITAS
SELECT 'RECEITAS POR CATEGORIA - ABRIL 2025:' as info;
SELECT 
    category,
    COUNT(*) as qtd_transacoes,
    SUM(amount) as total_valor,
    ROUND(AVG(amount), 2) as ticket_medio
FROM public.transactions_2025_04
WHERE transaction_type = 'income'
GROUP BY category
ORDER BY total_valor DESC;

-- 6. TOTAIS POR CATEGORIA - DESPESAS
SELECT 'DESPESAS POR CATEGORIA - ABRIL 2025:' as info;
SELECT 
    category,
    COUNT(*) as qtd_transacoes,
    SUM(amount) as total_valor,
    ROUND(AVG(amount), 2) as valor_medio
FROM public.transactions_2025_04
WHERE transaction_type = 'expense'
GROUP BY category
ORDER BY total_valor DESC;

-- 7. VERIFICAR DIAS SEM MOVIMENTO
SELECT 'DIAS SEM MOVIMENTO EM ABRIL:' as info;
SELECT 
    generate_series(1, 30) as dia
EXCEPT
SELECT 
    EXTRACT(DAY FROM transaction_date)::integer as dia
FROM public.transactions_2025_04
ORDER BY dia;

-- 8. MAIORES RECEITAS DO MÊS
SELECT 'TOP 10 MAIORES RECEITAS - ABRIL 2025:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    account_name,
    category
FROM public.transactions_2025_04
WHERE transaction_type = 'income'
ORDER BY amount DESC
LIMIT 10;

-- 9. MAIORES DESPESAS DO MÊS
SELECT 'TOP 10 MAIORES DESPESAS - ABRIL 2025:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    account_name,
    category
FROM public.transactions_2025_04
WHERE transaction_type = 'expense'
ORDER BY amount DESC
LIMIT 10;

-- 10. COMPARAÇÃO COM OUTROS MESES (se existirem)
SELECT 'COMPARAÇÃO COM OUTROS MESES 2025:' as info;
SELECT * FROM (
    SELECT 
        'Janeiro' as mes,
        1 as ordem,
        COUNT(*) as total_transacoes,
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
        SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
    FROM public.transactions_2025_01
    UNION ALL
    SELECT 
        'Fevereiro' as mes,
        2 as ordem,
        COUNT(*) as total_transacoes,
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
        SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
    FROM public.transactions_2025_02
    UNION ALL
    SELECT 
        'Março' as mes,
        3 as ordem,
        COUNT(*) as total_transacoes,
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
        SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
    FROM public.transactions_2025_03
    UNION ALL
    SELECT 
        'Abril' as mes,
        4 as ordem,
        COUNT(*) as total_transacoes,
        SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as receitas,
        SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as despesas
    FROM public.transactions_2025_04
) comparacao
ORDER BY ordem;
