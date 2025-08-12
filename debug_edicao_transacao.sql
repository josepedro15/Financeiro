-- DEBUG DETALHADO DE EDIÇÃO DE TRANSAÇÕES
-- Execute este script no Supabase SQL Editor

-- 1. Verificar todas as transações do usuário
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
ORDER BY created_at DESC;

-- 2. Verificar se há transações duplicadas
SELECT '=== VERIFICAR DUPLICATAS ===' as info;
SELECT 
    transaction_date,
    description,
    amount,
    COUNT(*) as quantidade,
    STRING_AGG(id::text, ', ') as ids,
    STRING_AGG(created_at::text, ', ') as created_dates
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
GROUP BY transaction_date, description, amount
HAVING COUNT(*) > 1
ORDER BY transaction_date;

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
    'DEBUG EDIÇÃO TESTE', 
    500.00, 
    'income', 
    'debug', 
    '2025-08-11', 
    'Conta PJ',
    'Cliente Debug',
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
  AND description = 'DEBUG EDIÇÃO TESTE';

-- 6. Testar delete direto
SELECT '=== TESTAR DELETE DIRETO ===' as info;
DELETE FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'DEBUG EDIÇÃO TESTE'
RETURNING id, description, transaction_date;

-- 7. Verificar se foi removida
SELECT '=== VERIFICAR REMOÇÃO ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'DEBUG EDIÇÃO TESTE';

-- 8. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08'
ORDER BY ordinal_position;

-- 9. Verificar constraints
SELECT '=== CONSTRAINTS ===' as info;
SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08';

SELECT '=== DEBUG CONCLUÍDO ===' as info;
