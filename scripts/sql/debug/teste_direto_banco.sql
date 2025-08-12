-- TESTE DIRETO NO BANCO DE DADOS
-- Vamos testar inserir uma transação para domingo, 10 de agosto de 2025

-- 1. Verificar se a tabela transactions_2025_08 existe
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'transactions_2025_08'
) as tabela_existe;

-- 2. Verificar estrutura da tabela
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'transactions_2025_08' 
AND column_name IN ('transaction_date', 'created_at', 'updated_at');

-- 3. Testar inserção direta com data específica
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
    'TESTE DOMINGO 10/08 - INSERÇÃO DIRETA', 
    150.00, 
    'income', 
    'teste_direto', 
    '2025-08-10', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING 
    id, 
    description,
    transaction_date, 
    created_at, 
    updated_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp;

-- 4. Verificar se foi inserida corretamente
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    updated_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp,
    EXTRACT(EPOCH FROM (created_at::timestamp - transaction_date::timestamp))/3600 as diff_hours
FROM transactions_2025_08 
WHERE description = 'TESTE DOMINGO 10/08 - INSERÇÃO DIRETA'
ORDER BY created_at DESC;

-- 5. Verificar configuração de timezone
SHOW timezone;
