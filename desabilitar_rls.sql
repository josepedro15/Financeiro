-- Script para desabilitar RLS temporariamente
-- Execute este script no Supabase SQL Editor

-- 1. Desabilitar RLS na tabela transactions
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;

-- 2. Verificar se foi desabilitado
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions';

-- 3. Agora você pode executar o script de inserção
-- Execute o script inserir_abril_completo_final.sql

-- 4. DEPOIS de inserir, reabilitar RLS
-- ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY; 