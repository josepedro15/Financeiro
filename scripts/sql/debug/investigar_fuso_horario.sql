-- INVESTIGAÇÃO ESPECÍFICA DO PROBLEMA DE FUSO HORÁRIO
-- O problema está no banco salvando datas incorretas

-- 1. Verificar configuração atual do timezone
SHOW timezone;
SHOW datestyle;

-- 2. Verificar as últimas transações inseridas
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    updated_at,
    -- Verificar se há diferença de fuso horário
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp,
    -- Diferença em horas entre transaction_date e created_at
    EXTRACT(EPOCH FROM (created_at::timestamp - transaction_date::timestamp))/3600 as diff_hours,
    -- Verificar se a data está sendo interpretada como UTC ou local
    transaction_date::timestamp AT TIME ZONE 'UTC' as transaction_utc,
    transaction_date::timestamp AT TIME ZONE 'America/Sao_Paulo' as transaction_sp
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC 
LIMIT 5;

-- 3. Testar inserção com timezone explícito
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE TIMEZONE EXPLÍCITO', 
    200.00, 
    'income', 
    'teste_timezone', 
    '2025-08-10'::date, 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING 
    id, 
    description,
    transaction_date, 
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp,
    EXTRACT(EPOCH FROM (created_at::timestamp - transaction_date::timestamp))/3600 as diff_hours;

-- 4. Verificar se a inserção foi correta
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp
FROM transactions_2025_08 
WHERE description = 'TESTE TIMEZONE EXPLÍCITO'
ORDER BY created_at DESC;
