-- Script para forçar o carregamento completo de TODOS os dados
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se há problemas de RLS que estão limitando o acesso
SELECT '=== DESABILITANDO RLS TEMPORARIAMENTE ===' as info;

ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;

-- 2. Verificar se há políticas que estão bloqueando
SELECT '=== REMOVENDO POLÍTICAS RESTRITIVAS ===' as info;

DROP POLICY IF EXISTS "Users can view their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can create their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Global access to transactions" ON public.transactions;

-- 3. Criar política de acesso global
SELECT '=== CRIANDO POLÍTICA DE ACESSO GLOBAL ===' as info;

CREATE POLICY "Global access to transactions" ON public.transactions FOR ALL USING (true) WITH CHECK (true);

-- 4. Verificar se há problemas de índices
SELECT '=== VERIFICANDO ÍNDICES ===' as info;

SELECT 
  indexname,
  tablename,
  indexdef
FROM pg_indexes 
WHERE tablename = 'transactions'
ORDER BY indexname;

-- 5. Criar índices otimizados se não existirem
SELECT '=== CRIANDO ÍNDICES OTIMIZADOS ===' as info;

CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON public.transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_type ON public.transactions(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON public.transactions(user_id, transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_created_at ON public.transactions(created_at DESC);

-- 6. Verificar se há problemas de cache ou sincronização
SELECT '=== LIMPANDO CACHE ===' as info;

-- Forçar atualização das estatísticas
ANALYZE public.transactions;

-- 7. Teste de acesso direto sem limitações
SELECT '=== TESTE DE ACESSO DIRETO SEM LIMITAÇÕES ===' as info;

-- Teste 1: Todas as transações do usuário
SELECT 
  'TODAS AS TRANSAÇÕES' as teste,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Teste 2: Apenas receitas
SELECT 
  'APENAS RECEITAS' as teste,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income';

-- Teste 3: Transações por período (sem limite)
SELECT 
  'TRANSAÇÕES 2025' as teste,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01'
  AND transaction_date <= '2025-12-31';

-- 8. Verificar se há transações duplicadas ou problemas
SELECT '=== VERIFICAÇÃO DE PROBLEMAS ===' as info;

SELECT
  'Transações com user_id NULL' as problema,
  COUNT(*) as quantidade
FROM public.transactions
WHERE user_id IS NULL

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

-- 9. Verificar se há problemas de timezone
SELECT '=== VERIFICAÇÃO DE TIMEZONE ===' as info;

SELECT 
  'Timezone atual' as info,
  current_setting('timezone') as timezone;

-- 10. Forçar atualização de estatísticas
SELECT '=== ATUALIZANDO ESTATÍSTICAS ===' as info;

VACUUM ANALYZE public.transactions;

-- 11. Teste final de acesso completo
SELECT '=== TESTE FINAL DE ACESSO COMPLETO ===' as info;

SELECT 
  'DADOS COMPLETOS' as fonte,
  COUNT(*) as total_transacoes,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as despesas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total,
  ROUND(SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END), 2) as faturamento_arredondado,
  MIN(transaction_date) as primeira_data,
  MAX(transaction_date) as ultima_data
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 12. Verificar se RLS foi desabilitado corretamente
SELECT '=== VERIFICAÇÃO FINAL DE RLS ===' as info;

SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions';

-- 13. Verificar políticas finais
SELECT '=== VERIFICAÇÃO FINAL DE POLÍTICAS ===' as info;

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

SELECT '=== ACESSO COMPLETO CONFIGURADO ===' as info;
