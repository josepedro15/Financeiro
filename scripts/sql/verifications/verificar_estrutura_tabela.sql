-- Script para verificar a estrutura da tabela transactions
-- Execute este script no Supabase SQL Editor

-- 1. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;

SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar uma transação de exemplo
SELECT '=== EXEMPLO DE TRANSAÇÃO ===' as info;

SELECT *
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
LIMIT 1;

-- 3. Verificar se account_name existe
SELECT '=== VERIFICAR SE ACCOUNT_NAME EXISTE ===' as info;

SELECT 
  column_name
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
  AND column_name = 'account_name';

-- 4. Verificar colunas que existem
SELECT '=== COLUNAS QUE EXISTEM ===' as info;

SELECT 
  column_name
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 5. Testar consulta com diferentes colunas
SELECT '=== TESTE DE CONSULTA SIMPLES ===' as info;

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
LIMIT 3; 