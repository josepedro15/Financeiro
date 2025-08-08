-- Script otimizado para inserção massiva de mais de 3000 transações
-- Execute este script no Supabase SQL Editor

-- 1. Desabilitar RLS temporariamente para inserção massiva
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;

-- 2. Criar função para inserção em lotes (mais eficiente)
CREATE OR REPLACE FUNCTION insert_transactions_batch(
  transactions_data JSONB
) RETURNS VOID AS $$
BEGIN
  INSERT INTO public.transactions (
    user_id, 
    transaction_date, 
    description, 
    amount, 
    transaction_type, 
    created_at, 
    updated_at
  )
  SELECT 
    (value->>'user_id')::UUID,
    (value->>'transaction_date')::DATE,
    value->>'description',
    (value->>'amount')::DECIMAL(15,2),
    value->>'transaction_type',
    NOW(),
    NOW()
  FROM jsonb_array_elements(transactions_data);
END;
$$ LANGUAGE plpgsql;

-- 3. Exemplo de inserção em lote (substitua pelos seus dados)
-- Formato: array de objetos JSON com as transações
SELECT insert_transactions_batch('[
  {
    "user_id": "2dc520e3-5f19-4dfe-838b-1aca7238ae36",
    "transaction_date": "2025-04-18",
    "description": "CLIENTE EXEMPLO 1",
    "amount": 39.95,
    "transaction_type": "income"
  },
  {
    "user_id": "2dc520e3-5f19-4dfe-838b-1aca7238ae36",
    "transaction_date": "2025-04-18",
    "description": "CLIENTE EXEMPLO 2",
    "amount": 75.91,
    "transaction_type": "income"
  }
  -- Adicione mais transações aqui...
]'::jsonb);

-- 4. Verificar resultado da inserção
SELECT '=== VERIFICAÇÃO PÓS-INSERÇÃO ===' as info;

SELECT
  COUNT(*) as total_transacoes,
  COUNT(DISTINCT user_id) as usuarios_unicos,
  COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as receitas,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento_total
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 5. Verificar performance
SELECT '=== VERIFICAÇÃO DE PERFORMANCE ===' as info;

SELECT
  DATE(created_at) as data_insercao,
  COUNT(*) as transacoes_inseridas,
  SUM(amount) as total_inserido
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND created_at >= CURRENT_DATE
GROUP BY DATE(created_at)
ORDER BY data_insercao DESC;

-- 6. Reabilitar RLS após inserção
-- ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- 7. Criar índices para otimizar consultas (se não existirem)
CREATE INDEX IF NOT EXISTS idx_transactions_user_date 
ON public.transactions(user_id, transaction_date);

CREATE INDEX IF NOT EXISTS idx_transactions_created_at 
ON public.transactions(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_transactions_type 
ON public.transactions(transaction_type);

-- 8. Verificar índices criados
SELECT '=== VERIFICAÇÃO DE ÍNDICES ===' as info;

SELECT 
  indexname,
  tablename,
  indexdef
FROM pg_indexes 
WHERE tablename = 'transactions'
ORDER BY indexname;
