-- Script para verificar informações de contas
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estrutura da tabela transactions
SELECT '=== ESTRUTURA DA TABELA ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar se há coluna de conta
SELECT '=== VERIFICAÇÃO DE COLUNAS DE CONTA ===' as info;

SELECT 
  CASE 
    WHEN column_name = 'account_name' THEN 'account_name existe'
    WHEN column_name = 'account_id' THEN 'account_id existe'
    WHEN column_name = 'account' THEN 'account existe'
    ELSE 'Nenhuma coluna de conta encontrada'
  END as status
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
  AND column_name IN ('account_name', 'account_id', 'account');

-- 3. Verificar algumas transações para ver se há dados de conta
SELECT '=== AMOSTRA DE TRANSAÇÕES ===' as info;

SELECT 
  id,
  user_id,
  transaction_date,
  description,
  amount,
  transaction_type,
  created_at,
  updated_at
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 5;

-- 4. Verificar se há tabela de contas separada
SELECT '=== VERIFICAÇÃO DE TABELA DE CONTAS ===' as info;

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE '%account%'; 