-- Script para investigar problema de datas nas transações
-- Verificar como as datas estão sendo armazenadas

-- 1. Verificar estrutura da tabela transactions
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND column_name = 'transaction_date';

-- 2. Verificar algumas transações recentes com detalhes de data
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    -- Verificar se há diferença de fuso horário
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp,
    -- Diferença em horas entre transaction_date e created_at
    EXTRACT(EPOCH FROM (created_at::timestamp - transaction_date::timestamp))/3600 as diff_hours
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC 
LIMIT 10;

-- 3. Verificar transações de uma tabela mensal específica (agosto 2025)
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp,
    EXTRACT(EPOCH FROM (created_at::timestamp - transaction_date::timestamp))/3600 as diff_hours
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC 
LIMIT 10;

-- 4. Verificar configuração de timezone do banco
SHOW timezone;

-- 5. Testar inserção de uma data específica
-- (Este é apenas um teste, não executar em produção)
-- INSERT INTO transactions_2025_08 (user_id, description, amount, transaction_type, category, transaction_date, account_name)
-- VALUES ('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'TESTE DATA', 100.00, 'income', 'teste', '2025-08-10', 'Conta PJ')
-- RETURNING id, transaction_date, created_at;
