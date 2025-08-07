-- Verificar dados de agosto ANTES de executar o script de julho
-- Execute este script primeiro para confirmar que agosto está intacto

SELECT '=== VERIFICAÇÃO AGOSTO ANTES DO SCRIPT JULHO ===' as info;

-- Verificar total de agosto
SELECT 
  COUNT(*) as total_transacoes_agosto,
  SUM(amount) as faturamento_total_agosto,
  ROUND(SUM(amount), 2) as faturamento_arredondado_agosto
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31';

-- Verificar por dia em agosto
SELECT '=== VERIFICAÇÃO AGOSTO POR DIA ===' as info;

SELECT 
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-08-01' 
  AND transaction_date <= '2025-08-31'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Verificar se há transações de julho atualmente
SELECT '=== VERIFICAÇÃO JULHO ATUAL ===' as info;

SELECT 
  COUNT(*) as total_transacoes_julho_atual,
  SUM(amount) as faturamento_total_julho_atual,
  ROUND(SUM(amount), 2) as faturamento_arredondado_julho_atual
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31';

-- Listar todas as transações de julho (se houver)
SELECT '=== LISTA JULHO ATUAL ===' as info;

SELECT 
  transaction_date,
  description,
  amount,
  account_name
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' 
  AND transaction_date >= '2025-07-01' 
  AND transaction_date <= '2025-07-31'
ORDER BY transaction_date, description; 