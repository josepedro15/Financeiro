-- Script para permitir acesso global aos dados para todos os usuários
-- Execute este script no Supabase SQL Editor

-- 1. Desabilitar RLS (Row Level Security) em todas as tabelas
ALTER TABLE public.accounts DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses DISABLE ROW LEVEL SECURITY;

-- 2. Remover todas as políticas existentes
DROP POLICY IF EXISTS "Accounts are viewable by everyone" ON public.accounts;
DROP POLICY IF EXISTS "Users can view their own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can create their own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can update their own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can delete their own clients" ON public.clients;
DROP POLICY IF EXISTS "Users can view their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can create their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can view their own expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can create their own expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can update their own expenses" ON public.expenses;
DROP POLICY IF EXISTS "Users can delete their own expenses" ON public.expenses;

-- 3. Criar políticas de acesso global
-- Políticas para accounts (todos podem ver, criar, atualizar, deletar)
CREATE POLICY "Global access to accounts" ON public.accounts FOR ALL USING (true) WITH CHECK (true);

-- Políticas para clients (todos podem ver, criar, atualizar, deletar)
CREATE POLICY "Global access to clients" ON public.clients FOR ALL USING (true) WITH CHECK (true);

-- Políticas para transactions (todos podem ver, criar, atualizar, deletar)
CREATE POLICY "Global access to transactions" ON public.transactions FOR ALL USING (true) WITH CHECK (true);

-- Políticas para expenses (todos podem ver, criar, atualizar, deletar)
CREATE POLICY "Global access to expenses" ON public.expenses FOR ALL USING (true) WITH CHECK (true);

-- 4. Verificar se as políticas foram criadas
SELECT '=== VERIFICAÇÃO DAS POLÍTICAS ===' as info;

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
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- 5. Verificar se RLS está desabilitado
SELECT '=== VERIFICAÇÃO RLS ===' as info;

SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('accounts', 'clients', 'transactions', 'expenses')
ORDER BY tablename;

-- 6. Testar acesso aos dados
SELECT '=== TESTE DE ACESSO AOS DADOS ===' as info;

-- Contar total de transações
SELECT 
  COUNT(*) as total_transacoes,
  COUNT(DISTINCT user_id) as usuarios_unicos
FROM public.transactions;

-- Mostrar algumas transações de exemplo
SELECT 
  user_id,
  description,
  amount,
  transaction_date,
  account_name
FROM public.transactions 
ORDER BY created_at DESC 
LIMIT 5;

-- Verificar contas
SELECT 
  COUNT(*) as total_contas
FROM public.accounts;

-- Verificar clientes
SELECT 
  COUNT(*) as total_clientes,
  COUNT(DISTINCT user_id) as usuarios_com_clientes
FROM public.clients;

SELECT '=== ACESSO GLOBAL CONFIGURADO COM SUCESSO ===' as info;
