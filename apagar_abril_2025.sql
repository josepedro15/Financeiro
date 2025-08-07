-- Script para apagar todos os dados de abril 2025
-- Execute este script no Supabase SQL Editor
-- ⚠️ ATENÇÃO: Isso vai apagar TODOS os dados de abril 2025!

-- 1. Verificar quantas transações serão apagadas
SELECT '=== VERIFICAÇÃO ANTES DE APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as total_valor_abril,
  ROUND(SUM(amount), 2) as total_arredondado_abril
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30';

-- 2. Verificar por tipo de transação
SELECT '=== VERIFICAÇÃO POR TIPO ===' as info;

SELECT 
  transaction_type,
  COUNT(*) as quantidade,
  SUM(amount) as valor_total
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30'
GROUP BY transaction_type
ORDER BY transaction_type;

-- 3. APAGAR TODOS OS DADOS DE ABRIL 2025
-- ⚠️ EXECUTE ESTE COMANDO PARA APAGAR OS DADOS
DELETE FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30';

-- 4. Verificar se foi apagado (execute após apagar)
SELECT '=== VERIFICAÇÃO APÓS APAGAR ===' as info;

SELECT 
  COUNT(*) as total_transacoes_abril_restantes,
  SUM(amount) as total_valor_abril_restante
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01' 
  AND transaction_date <= '2025-04-30';

-- 5. Verificar dados de outros meses (para confirmar que não foram afetados)
SELECT '=== VERIFICAÇÃO OUTROS MESES ===' as info;

SELECT 
  EXTRACT(MONTH FROM transaction_date::date) as mes,
  COUNT(*) as total_transacoes,
  SUM(amount) as total_valor
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-01-01' 
  AND transaction_date <= '2025-12-31'
GROUP BY EXTRACT(MONTH FROM transaction_date::date)
ORDER BY mes; 