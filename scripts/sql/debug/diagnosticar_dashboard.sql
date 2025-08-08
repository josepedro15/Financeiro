-- Script para diagnosticar por que o dashboard não está carregando todos os dados
-- Execute este script no Supabase SQL Editor

-- 1. Verificar total de dados no banco vs dashboard
SELECT '=== VERIFICAÇÃO TOTAL DE DADOS ===' as info;

-- Dados reais no banco
SELECT 
  'BANCO DE DADOS' as fonte,
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar se há problemas de RLS
SELECT '=== VERIFICAÇÃO DE RLS ===' as info;

SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions';

-- 3. Verificar políticas de acesso
SELECT '=== VERIFICAÇÃO DE POLÍTICAS ===' as info;

SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'transactions';

-- 4. Testar acesso direto (como o dashboard faria)
SELECT '=== TESTE DE ACESSO DIRETO ===' as info;

-- Simular consulta do dashboard (todas as transações)
SELECT 
  'CONSULTA COMPLETA' as tipo,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 5. Verificar se há transações com problemas
SELECT '=== VERIFICAÇÃO DE TRANSAÇÕES PROBLEMÁTICAS ===' as info;

SELECT
  'Transações sem user_id' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id IS NULL

UNION ALL

SELECT
  'Transações com user_id diferente' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id != '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT
  'Transações com amount NULL' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE amount IS NULL

UNION ALL

SELECT
  'Transações com transaction_type NULL' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE transaction_type IS NULL

UNION ALL

SELECT
  'Transações com transaction_date NULL' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE transaction_date IS NULL;

-- 6. Verificar transações por período (como o dashboard faz)
SELECT '=== VERIFICAÇÃO POR PERÍODO (2025) ===' as info;

SELECT 
  'TRANSACOES 2025' as tipo,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31';

-- 7. Verificar transações recentes (como o dashboard faz)
SELECT '=== VERIFICAÇÃO DE TRANSAÇÕES RECENTES ===' as info;

SELECT 
  'TRANSAÇÕES RECENTES (LIMITE 50)' as tipo,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM (
  SELECT * FROM public.transactions
  WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  ORDER BY created_at DESC
  LIMIT 50
) recent_transactions;

-- 8. Verificar se há problemas de cache ou sincronização
SELECT '=== VERIFICAÇÃO DE CACHE/SINCRONIZAÇÃO ===' as info;

SELECT
  'Última transação criada' as info,
  MAX(created_at) as ultima_criacao
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT
  'Última transação atualizada' as info,
  MAX(updated_at) as ultima_atualizacao
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT
  'Total de transações hoje' as info,
  COUNT(*) as total_hoje
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND DATE(created_at) = CURRENT_DATE;

-- 9. Verificar se há problemas de índices
SELECT '=== VERIFICAÇÃO DE ÍNDICES ===' as info;

SELECT 
  indexname,
  tablename,
  indexdef
FROM pg_indexes 
WHERE tablename = 'transactions'
ORDER BY indexname;

-- 10. Teste de performance das consultas
SELECT '=== TESTE DE PERFORMANCE ===' as info;

-- Simular consulta do dashboard com EXPLAIN
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 50;

-- 11. Verificar se há problemas de timezone ou data
SELECT '=== VERIFICAÇÃO DE DATAS ===' as info;

SELECT
  'Primeira transação' as info,
  MIN(transaction_date) as data
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT
  'Última transação' as info,
  MAX(transaction_date) as data
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT
  'Transações de hoje' as info,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date = CURRENT_DATE;

-- 12. Comparação final: banco vs dashboard esperado
SELECT '=== COMPARAÇÃO FINAL ===' as info;

SELECT 
  'DADOS REAIS NO BANCO' as fonte,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'DASHBOARD ESPERADO' as fonte,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01';
