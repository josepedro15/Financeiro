-- INVESTIGAR TRIGGERS E CONSTRAINTS QUE PODEM ESTAR ALTERANDO A DATA
-- Vamos verificar se há algo no banco alterando a data automaticamente

-- 1. Verificar triggers na tabela transactions_2025_08
SELECT 
    trigger_name,
    event_manipulation,
    action_statement,
    action_timing
FROM information_schema.triggers 
WHERE event_object_table = 'transactions_2025_08'
ORDER BY trigger_name;

-- 2. Verificar constraints na tabela
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_name IN (
    SELECT constraint_name 
    FROM information_schema.table_constraints 
    WHERE table_name = 'transactions_2025_08'
);

-- 3. Verificar configuração de timezone do banco
SHOW timezone;
SHOW datestyle;

-- 4. Verificar se há funções que podem estar sendo chamadas
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines 
WHERE routine_definition LIKE '%transaction_date%'
AND routine_schema = 'public';

-- 5. Testar inserção direta com data explícita
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
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID, 
    'TESTE INSERÇÃO DIRETA - DOMINGO 10/08', 
    600.00, 
    'income', 
    'teste_direto', 
    '2025-08-10'::date, 
    'Conta PJ',
    NULL,
    NOW(),
    NOW()
) RETURNING 
    id, 
    description,
    transaction_date, 
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp;

-- 6. Verificar se foi inserida corretamente
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp
FROM transactions_2025_08 
WHERE description = 'TESTE INSERÇÃO DIRETA - DOMINGO 10/08'
ORDER BY created_at DESC;
