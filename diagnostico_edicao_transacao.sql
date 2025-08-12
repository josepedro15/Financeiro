-- DIAGNÓSTICO DE EDIÇÃO DE TRANSAÇÕES
-- Execute este script no Supabase SQL Editor

-- 1. Verificar transações duplicadas
SELECT '=== VERIFICAR DUPLICATAS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    COUNT(*) as quantidade,
    STRING_AGG(id::text, ', ') as ids
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY transaction_date;

-- 2. Verificar todas as transações do usuário
SELECT '=== TODAS AS TRANSAÇÕES DO USUÁRIO ===' as info;
SELECT 
    id,
    transaction_date,
    description,
    amount,
    transaction_type,
    account_name,
    client_name,
    created_at,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
ORDER BY transaction_date DESC, created_at DESC;

-- 3. Verificar RLS da tabela
SELECT '=== VERIFICAR RLS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'transactions_2025_08'
ORDER BY cmd, policyname;

-- 4. Testar inserção direta
SELECT '=== TESTAR INSERÇÃO DIRETA ===' as info;
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
    'TESTE EDIÇÃO DIAGNÓSTICO', 
    999.99, 
    'income', 
    'teste', 
    '2025-08-11', 
    'Conta PJ',
    'Teste Cliente',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date, amount;

-- 5. Verificar se foi inserida
SELECT '=== VERIFICAR INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount,
    created_at
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE EDIÇÃO DIAGNÓSTICO';

-- 6. Testar update direto
SELECT '=== TESTAR UPDATE DIRETO ===' as info;
UPDATE transactions_2025_08 
SET 
    description = 'TESTE EDIÇÃO ATUALIZADO',
    amount = 888.88,
    updated_at = NOW()
WHERE description = 'TESTE EDIÇÃO DIAGNÓSTICO'
  AND user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
RETURNING id, description, amount, updated_at;

-- 7. Verificar resultado do update
SELECT '=== VERIFICAR UPDATE ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount,
    updated_at
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE EDIÇÃO%';

-- 8. Limpar testes
SELECT '=== LIMPAR TESTES ===' as info;
DELETE FROM transactions_2025_08 
WHERE description LIKE 'TESTE EDIÇÃO%'
  AND user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

SELECT '=== DIAGNÓSTICO CONCLUÍDO ===' as info;
