-- Investigar problema com dados de abril no dashboard

-- 1. Verificar dados de abril nas tabelas mensais
SELECT 'VERIFICANDO TABELA ABRIL 2025:' as info;

SELECT 
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_receitas,
    SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_despesas,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions_2025_04
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'jopedromkt@gmail.com');

-- 2. Verificar algumas transações de exemplo
SELECT 'EXEMPLOS DE TRANSAÇÕES ABRIL:' as info;
SELECT 
    transaction_date,
    description,
    amount,
    type,
    account_name
FROM public.transactions_2025_04
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'jopedromkt@gmail.com')
ORDER BY transaction_date
LIMIT 10;

-- 3. Verificar se existem dados na tabela principal também
SELECT 'DADOS ABRIL NA TABELA PRINCIPAL:' as info;
SELECT 
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_receitas,
    SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) as total_despesas
FROM public.transactions
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'jopedromkt@gmail.com')
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 4;

-- 4. Verificar dados por mês para comparação
SELECT 'RESUMO POR MÊS 2025:' as info;
SELECT 
    EXTRACT(MONTH FROM transaction_date) as mes,
    COUNT(*) as total_transacoes,
    SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END) as total_receitas
FROM public.transactions
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'jopedromkt@gmail.com')
  AND EXTRACT(YEAR FROM transaction_date) = 2025
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY mes;

-- 5. Verificar se tabela transactions_2025_04 existe
SELECT 'VERIFICANDO EXISTÊNCIA DAS TABELAS MENSAIS:' as info;
SELECT 
    schemaname,
    tablename
FROM pg_tables 
WHERE tablename LIKE 'transactions_2025_%'
  AND schemaname = 'public'
ORDER BY tablename;

-- 6. Testar query similar ao dashboard para abril
SELECT 'TESTE QUERY SIMILAR AO DASHBOARD ABRIL:' as info;
SELECT 
    'abril' as mes,
    COALESCE(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 0) as receita_total
FROM public.transactions_2025_04
WHERE user_id = (SELECT id FROM auth.users WHERE email = 'jopedromkt@gmail.com');

-- 7. Verificar se há problema de permissão/RLS
SELECT 'VERIFICANDO RLS DA TABELA ABRIL:' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions_2025_04';

SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'transactions_2025_04';
