-- Investigar dados de abril - verificar se foram apagados ou têm problemas

-- 1. VERIFICAR SE A TABELA ABRIL EXISTE
SELECT 'VERIFICAÇÃO DA TABELA ABRIL:' as info;
SELECT 
    table_name,
    table_schema
FROM information_schema.tables 
WHERE table_name = 'transactions_2025_04';

-- 2. CONTAR TOTAL DE REGISTROS EM ABRIL
SELECT 'TOTAL DE REGISTROS ABRIL:' as info;
SELECT COUNT(*) as total_registros FROM public.transactions_2025_04;

-- 3. VERIFICAR TIPOS DE TRANSAÇÃO
SELECT 'TIPOS DE TRANSAÇÃO ABRIL:' as info;
SELECT 
    transaction_type,
    COUNT(*) as quantidade,
    SUM(amount) as total_valor,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions_2025_04
GROUP BY transaction_type
ORDER BY transaction_type;

-- 4. VERIFICAR PRIMEIROS 10 REGISTROS
SELECT 'PRIMEIROS 10 REGISTROS ABRIL:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    transaction_type,
    account_name,
    category,
    created_at
FROM public.transactions_2025_04
ORDER BY transaction_date, created_at
LIMIT 10;

-- 5. VERIFICAR ÚLTIMOS 10 REGISTROS
SELECT 'ÚLTIMOS 10 REGISTROS ABRIL:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    transaction_type,
    account_name,
    category,
    created_at
FROM public.transactions_2025_04
ORDER BY created_at DESC
LIMIT 10;

-- 6. VERIFICAR DESPESAS ESPECIFICAMENTE
SELECT 'DESPESAS EM ABRIL:' as info;
SELECT 
    COUNT(*) as total_despesas,
    SUM(amount) as valor_total_despesas,
    MIN(amount) as menor_despesa,
    MAX(amount) as maior_despesa
FROM public.transactions_2025_04
WHERE transaction_type = 'expense';

-- 7. LISTAR TODAS AS DESPESAS (se houver)
SELECT 'LISTA DE DESPESAS ABRIL:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    account_name,
    category
FROM public.transactions_2025_04
WHERE transaction_type = 'expense'
ORDER BY transaction_date;

-- 8. VERIFICAR RECEITAS POR DIA
SELECT 'RECEITAS POR DIA ABRIL:' as info;
SELECT 
    transaction_date,
    COUNT(*) as qtd_receitas,
    SUM(amount) as total_receitas
FROM public.transactions_2025_04
WHERE transaction_type = 'income'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 9. VERIFICAR SE HÁ DADOS DUPLICADOS
SELECT 'VERIFICAR DUPLICATAS:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    transaction_type,
    COUNT(*) as quantidade
FROM public.transactions_2025_04
GROUP BY transaction_date, description, amount, transaction_type
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

-- 10. COMPARAR COM TABELA PRINCIPAL (se ainda existir)
SELECT 'DADOS NA TABELA PRINCIPAL:' as info;
SELECT 
    COUNT(*) as total_na_principal,
    COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas_principal,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas_principal
FROM public.transactions
WHERE EXTRACT(MONTH FROM transaction_date) = 4 
  AND EXTRACT(YEAR FROM transaction_date) = 2025;

