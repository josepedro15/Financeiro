-- Script para verificar a estrutura exata da tabela transactions
SELECT '=== ESTRUTURA DA TABELA TRANSACTIONS ===' as info;

-- Verificar colunas da tabela transactions
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'transactions'
ORDER BY ordinal_position;

-- Verificar dados de exemplo
SELECT '=== DADOS DE EXEMPLO ===' as info;

SELECT * FROM public.transactions LIMIT 5;

-- Verificar se as colunas client_id e account_id realmente existem
SELECT '=== VERIFICAÇÃO DE COLUNAS ESPECÍFICAS ===' as info;

SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'transactions' AND column_name = 'client_id')
        THEN 'client_id EXISTS'
        ELSE 'client_id NOT EXISTS'
    END as client_id_status,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'transactions' AND column_name = 'account_id')
        THEN 'account_id EXISTS'
        ELSE 'account_id NOT EXISTS'
    END as account_id_status;
