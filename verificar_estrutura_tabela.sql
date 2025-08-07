-- Script para verificar a estrutura da tabela transactions
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA TRANSACTIONS ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar algumas transações de abril
SELECT '=== TRANSAÇÕES DE ABRIL ===' as info;

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
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
ORDER BY transaction_date
LIMIT 5;

-- 3. Verificar se há problemas com account_name
SELECT '=== VERIFICAÇÃO DE ACCOUNT_NAME ===' as info;

SELECT 
  CASE 
    WHEN column_name = 'account_name' THEN 'account_name existe'
    ELSE 'account_name NÃO existe'
  END as status
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
  AND column_name = 'account_name';

-- 4. Verificar todas as colunas disponíveis
SELECT '=== TODAS AS COLUNAS ===' as info;

SELECT column_name
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position; 