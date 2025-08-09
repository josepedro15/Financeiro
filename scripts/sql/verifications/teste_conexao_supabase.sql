-- Script para testar conexão com Supabase e verificar dados
-- Execute este script no Supabase SQL Editor

-- 1. Testar conexão básica
SELECT '=== TESTE DE CONEXÃO ===' as info;

SELECT COUNT(*) as total_transacoes
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;

SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'transactions' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 3. Verificar dados de abril com detalhes
SELECT '=== DADOS DE ABRIL DETALHADOS ===' as info;

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
ORDER BY transaction_date, amount DESC
LIMIT 5;

-- 4. Verificar se há problemas de data
SELECT '=== VERIFICAÇÃO DE DATAS ===' as info;

SELECT 
  transaction_date,
  EXTRACT(YEAR FROM transaction_date::date) as ano,
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  EXTRACT(DAY FROM transaction_date::date) as dia,
  COUNT(*) as total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
GROUP BY transaction_date
ORDER BY transaction_date; 