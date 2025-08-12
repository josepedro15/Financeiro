-- TESTE DE EDIÇÃO SIMPLES
-- Execute este script no Supabase SQL Editor

-- 1. Verificar transações existentes
SELECT '=== TRANSAÇÕES EXISTENTES ===' as info;
SELECT 
    id,
    transaction_date,
    description,
    amount,
    created_at,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
ORDER BY transaction_date DESC, created_at DESC;

-- 2. Criar uma transação de teste
SELECT '=== CRIANDO TRANSAÇÃO DE TESTE ===' as info;
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
    'TESTE EDIÇÃO SIMPLES', 
    1000.00, 
    'income', 
    'teste', 
    '2025-08-15', 
    'Conta PJ',
    'Cliente Teste',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, amount;

-- 3. Verificar se foi criada
SELECT '=== VERIFICANDO CRIAÇÃO ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE EDIÇÃO SIMPLES';

-- 4. Simular edição: criar nova transação no dia 11
SELECT '=== SIMULANDO EDIÇÃO (CRIAR NOVA) ===' as info;
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
    'TESTE EDIÇÃO SIMPLES ATUALIZADO', 
    1500.00, 
    'income', 
    'teste', 
    '2025-08-11', 
    'Conta PJ',
    'Cliente Teste Atualizado',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, amount;

-- 5. Verificar se nova transação foi criada
SELECT '=== VERIFICANDO NOVA TRANSAÇÃO ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE EDIÇÃO SIMPLES%'
ORDER BY transaction_date;

-- 6. Excluir transação original (dia 15)
SELECT '=== EXCLUINDO TRANSAÇÃO ORIGINAL ===' as info;
DELETE FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE EDIÇÃO SIMPLES'
  AND transaction_date = '2025-08-15';

-- 7. Verificar resultado final
SELECT '=== RESULTADO FINAL ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount,
    created_at
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE EDIÇÃO SIMPLES%'
ORDER BY transaction_date;

-- 8. Limpar testes
SELECT '=== LIMPANDO TESTES ===' as info;
DELETE FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE EDIÇÃO SIMPLES%';

SELECT '=== TESTE CONCLUÍDO ===' as info;
