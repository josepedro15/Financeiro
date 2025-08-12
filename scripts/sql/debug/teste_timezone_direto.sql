-- TESTE DIRETO DE TIMEZONE E DATAS
-- Executar este script no Supabase SQL Editor

-- 1. Verificar configuração de timezone do banco
SELECT 
  current_setting('timezone') as timezone_atual,
  current_setting('log_timezone') as log_timezone,
  now() as agora_utc,
  now() AT TIME ZONE 'UTC' as agora_utc_explicito,
  now() AT TIME ZONE 'America/Sao_Paulo' as agora_brasil;

-- 2. Testar inserção direta com diferentes formatos
DO $$
DECLARE
  data_teste DATE := '2025-01-12';
  data_teste_timestamp TIMESTAMP := '2025-01-12 12:00:00';
  data_teste_timestamptz TIMESTAMPTZ := '2025-01-12 12:00:00';
BEGIN
  RAISE NOTICE '=== TESTE DE DATAS ===';
  RAISE NOTICE 'Data teste (DATE): %', data_teste;
  RAISE NOTICE 'Data teste (TIMESTAMP): %', data_teste_timestamp;
  RAISE NOTICE 'Data teste (TIMESTAMPTZ): %', data_teste_timestamptz;
  RAISE NOTICE 'Data teste (TIMESTAMPTZ) em UTC: %', data_teste_timestamptz AT TIME ZONE 'UTC';
  RAISE NOTICE 'Data teste (TIMESTAMPTZ) em Brasil: %', data_teste_timestamptz AT TIME ZONE 'America/Sao_Paulo';
END $$;

-- 3. Testar inserção real na tabela
INSERT INTO transactions (
  user_id,
  description,
  amount,
  transaction_type,
  category,
  transaction_date,
  account_name,
  client_name
) VALUES (
  '2dc520e3-5f19-4dfe-838b-1aca7238ae36', -- master user
  'TESTE TIMEZONE - DIA 12',
  100.00,
  'income',
  'teste',
  '2025-01-12', -- Data exata que deveria ser salva
  'Conta Principal',
  'Teste'
) RETURNING id, transaction_date, created_at;

-- 4. Verificar o que foi salvo
SELECT 
  id,
  description,
  transaction_date,
  created_at,
  transaction_date::text as data_texto,
  EXTRACT(DAY FROM transaction_date) as dia_salvo,
  EXTRACT(MONTH FROM transaction_date) as mes_salvo,
  EXTRACT(YEAR FROM transaction_date) as ano_salvo
FROM transactions 
WHERE description = 'TESTE TIMEZONE - DIA 12'
ORDER BY created_at DESC
LIMIT 1;

-- 5. Testar com timestamp explícito
INSERT INTO transactions (
  user_id,
  description,
  amount,
  transaction_type,
  category,
  transaction_date,
  account_name,
  client_name
) VALUES (
  '2dc520e3-5f19-4dfe-838b-1aca7238ae36',
  'TESTE TIMEZONE - TIMESTAMP 12:00',
  200.00,
  'income',
  'teste',
  ('2025-01-12 12:00:00'::timestamp)::date, -- Forçar conversão
  'Conta Principal',
  'Teste'
) RETURNING id, transaction_date, created_at;

-- 6. Verificar estrutura da tabela
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
AND column_name = 'transaction_date';

-- 7. Limpar dados de teste
DELETE FROM transactions WHERE description LIKE 'TESTE TIMEZONE%';
