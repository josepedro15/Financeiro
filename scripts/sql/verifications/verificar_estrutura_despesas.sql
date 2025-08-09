-- Script para verificar a estrutura das tabelas mensais para despesas
-- Execute este SQL no Supabase SQL Editor

-- 1. Verificar estrutura das tabelas mensais
SELECT '=== ESTRUTURA TABELA MENSAL (EXEMPLO: JAN 2025) ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'transactions_2025_01' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 2. Verificar se existem despesas nas tabelas mensais
SELECT '=== DESPESAS EXISTENTES POR MÊS ===' as info;

SELECT 
  'transactions_2025_01' as tabela,
  COUNT(*) as total_despesas,
  COALESCE(SUM(amount), 0) as total_valor_despesas
FROM transactions_2025_01 
WHERE transaction_type = 'expense'
UNION ALL
SELECT 
  'transactions_2025_02' as tabela,
  COUNT(*) as total_despesas,
  COALESCE(SUM(amount), 0) as total_valor_despesas
FROM transactions_2025_02 
WHERE transaction_type = 'expense'
UNION ALL
SELECT 
  'transactions_2025_03' as tabela,
  COUNT(*) as total_despesas,
  COALESCE(SUM(amount), 0) as total_valor_despesas
FROM transactions_2025_03 
WHERE transaction_type = 'expense'
UNION ALL
SELECT 
  'transactions_2025_04' as tabela,
  COUNT(*) as total_despesas,
  COALESCE(SUM(amount), 0) as total_valor_despesas
FROM transactions_2025_04 
WHERE transaction_type = 'expense';

-- 3. Verificar categorias de despesas mais comuns (se existem)
SELECT '=== CATEGORIAS DE DESPESAS EXISTENTES ===' as info;

SELECT 
  category,
  COUNT(*) as quantidade,
  SUM(amount) as valor_total
FROM (
  SELECT category, amount FROM transactions_2025_01 WHERE transaction_type = 'expense'
  UNION ALL
  SELECT category, amount FROM transactions_2025_02 WHERE transaction_type = 'expense'
  UNION ALL
  SELECT category, amount FROM transactions_2025_03 WHERE transaction_type = 'expense'
  UNION ALL
  SELECT category, amount FROM transactions_2025_04 WHERE transaction_type = 'expense'
) as all_expenses
WHERE category IS NOT NULL AND category != ''
GROUP BY category
ORDER BY valor_total DESC;

-- 4. Verificar estrutura da tabela expenses (detalhes adicionais)
SELECT '=== ESTRUTURA TABELA EXPENSES ===' as info;

SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'expenses' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 5. Verificar contas disponíveis para despesas
SELECT '=== CONTAS DISPONÍVEIS PARA DESPESAS ===' as info;

SELECT 
  code,
  name,
  account_type
FROM public.accounts 
WHERE account_type = 'expense' 
   OR name ILIKE '%despesa%' 
   OR name ILIKE '%custo%'
ORDER BY code;
