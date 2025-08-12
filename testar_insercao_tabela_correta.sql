-- TESTAR INSERÇÃO NA TABELA CORRETA
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se as tabelas mensais existem
SELECT '=== VERIFICANDO TABELAS MENSAIS ===' as info;
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

-- 2. Testar inserção na tabela correta para agosto
SELECT '=== TESTANDO INSERÇÃO AGOSTO ===' as info;

-- Inserir transação de teste para agosto
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    client_name,
    created_at,
    updated_at
) VALUES (
    '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6', 
    'TESTE TABELA CORRETA - AGOSTO', 
    1000.00, 
    'income', 
    'teste_tabela_correta', 
    '2025-08-12', 
    'Conta PJ',
    'Maria Regina',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, account_name;

-- 3. Verificar se foi inserida na tabela correta
SELECT '=== VERIFICANDO INSERÇÃO ===' as info;
SELECT 
    'transactions_2025_08' as tabela,
    id,
    description,
    amount,
    transaction_date,
    account_name,
    client_name
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE TABELA CORRETA - AGOSTO';

-- 4. Verificar se NÃO foi inserida na tabela principal
SELECT '=== VERIFICANDO TABELA PRINCIPAL ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_encontradas
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE TABELA CORRETA - AGOSTO';

-- 5. Testar inserção para julho (deve ir para transactions_2025_07)
SELECT '=== TESTANDO INSERÇÃO JULHO ===' as info;

INSERT INTO transactions_2025_07 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    client_name,
    created_at,
    updated_at
) VALUES (
    '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6', 
    'TESTE TABELA CORRETA - JULHO', 
    2000.00, 
    'income', 
    'teste_tabela_correta', 
    '2025-07-15', 
    'Conta PJ',
    'Maria Regina',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, account_name;

-- 6. Verificar inserção em julho
SELECT '=== VERIFICANDO INSERÇÃO JULHO ===' as info;
SELECT 
    'transactions_2025_07' as tabela,
    id,
    description,
    amount,
    transaction_date,
    account_name,
    client_name
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE TABELA CORRETA - JULHO';

-- 7. Verificar se NÃO foi inserida na tabela principal
SELECT '=== VERIFICANDO TABELA PRINCIPAL (JULHO) ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_encontradas
FROM transactions 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE TABELA CORRETA - JULHO';

-- 8. Limpar dados de teste
SELECT '=== LIMPANDO DADOS DE TESTE ===' as info;

DELETE FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE TABELA CORRETA%';

DELETE FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE TABELA CORRETA%';

-- 9. Verificar limpeza
SELECT '=== VERIFICANDO LIMPEZA ===' as info;
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE TABELA CORRETA%'
UNION ALL
SELECT 
    'transactions_2025_07' as tabela,
    COUNT(*) as transacoes_restantes
FROM transactions_2025_07 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE TABELA CORRETA%';

SELECT '=== TESTE CONCLUÍDO ===' as info;
