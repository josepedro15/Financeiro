-- Script para otimizar o dashboard para grandes volumes de dados (3000+ transações)
-- Execute este script no Supabase SQL Editor

-- 1. Criar índices otimizados para consultas do dashboard
SELECT '=== CRIANDO ÍNDICES OTIMIZADOS ===' as info;

-- Índice composto para consultas por usuário e data
CREATE INDEX IF NOT EXISTS idx_transactions_user_date_type 
ON public.transactions(user_id, transaction_date, transaction_type);

-- Índice para consultas recentes (mais importantes primeiro)
CREATE INDEX IF NOT EXISTS idx_transactions_user_created_desc 
ON public.transactions(user_id, created_at DESC);

-- Índice para cálculos mensais
CREATE INDEX IF NOT EXISTS idx_transactions_user_year_month 
ON public.transactions(user_id, EXTRACT(YEAR FROM transaction_date), EXTRACT(MONTH FROM transaction_date));

-- Índice para filtros de tipo de transação
CREATE INDEX IF NOT EXISTS idx_transactions_user_type 
ON public.transactions(user_id, transaction_type);

-- 2. Criar view materializada para cálculos mensais (opcional - para volumes muito grandes)
SELECT '=== CRIANDO VIEW MATERIALIZADA ===' as info;

CREATE MATERIALIZED VIEW IF NOT EXISTS monthly_revenue_summary AS
SELECT 
  user_id,
  EXTRACT(YEAR FROM transaction_date) as year,
  EXTRACT(MONTH FROM transaction_date) as month,
  COUNT(*) as transaction_count,
  SUM(amount) as total_revenue,
  AVG(amount) as avg_transaction_value
FROM public.transactions
WHERE transaction_type = 'income'
GROUP BY user_id, year, month;

-- Criar índice na view materializada
CREATE INDEX IF NOT EXISTS idx_monthly_revenue_user_year_month 
ON monthly_revenue_summary(user_id, year, month);

-- 3. Criar função para atualizar a view materializada
CREATE OR REPLACE FUNCTION refresh_monthly_revenue()
RETURNS VOID AS $$
BEGIN
  REFRESH MATERIALIZED VIEW monthly_revenue_summary;
END;
$$ LANGUAGE plpgsql;

-- 4. Verificar performance atual
SELECT '=== VERIFICAÇÃO DE PERFORMANCE ATUAL ===' as info;

-- Verificar tempo de consulta para transações recentes
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC 
LIMIT 20;

-- Verificar tempo de consulta para cálculos mensais
EXPLAIN (ANALYZE, BUFFERS)
SELECT 
  EXTRACT(YEAR FROM transaction_date) as year,
  EXTRACT(MONTH FROM transaction_date) as month,
  COUNT(*) as transaction_count,
  SUM(amount) as total_revenue
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_type = 'income'
  AND transaction_date >= '2025-01-01'
GROUP BY year, month
ORDER BY year, month;

-- 5. Configurar autovacuum para otimizar performance
SELECT '=== CONFIGURAÇÃO DE AUTOVACUUM ===' as info;

-- Verificar configurações atuais
SELECT 
  schemaname,
  tablename,
  autovacuum_enabled,
  autovacuum_vacuum_threshold,
  autovacuum_analyze_threshold
FROM pg_stat_user_tables 
WHERE tablename = 'transactions';

-- 6. Criar função para limpeza de dados antigos (opcional)
CREATE OR REPLACE FUNCTION cleanup_old_transactions(
  days_to_keep INTEGER DEFAULT 365
) RETURNS INTEGER AS $$
DECLARE
  deleted_count INTEGER;
BEGIN
  DELETE FROM public.transactions 
  WHERE created_at < CURRENT_DATE - INTERVAL '1 day' * days_to_keep
    AND transaction_type = 'expense'; -- Manter apenas receitas, limpar despesas antigas
  
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- 7. Verificar estatísticas da tabela
SELECT '=== ESTATÍSTICAS DA TABELA ===' as info;

SELECT 
  schemaname,
  tablename,
  n_tup_ins as inserts,
  n_tup_upd as updates,
  n_tup_del as deletes,
  n_live_tup as live_tuples,
  n_dead_tup as dead_tuples,
  last_vacuum,
  last_autovacuum,
  last_analyze,
  last_autoanalyze
FROM pg_stat_user_tables 
WHERE tablename = 'transactions';

-- 8. Verificar tamanho da tabela
SELECT '=== TAMANHO DA TABELA ===' as info;

SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as total_size,
  pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) as table_size,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename) - pg_relation_size(schemaname||'.'||tablename)) as index_size
FROM pg_tables 
WHERE tablename = 'transactions';

-- 9. Verificar todos os índices criados
SELECT '=== ÍNDICES CRIADOS ===' as info;

SELECT 
  indexname,
  tablename,
  indexdef
FROM pg_indexes 
WHERE tablename = 'transactions'
ORDER BY indexname;

-- 10. Recomendações para o dashboard
SELECT '=== RECOMENDAÇÕES PARA O DASHBOARD ===' as info;

SELECT 
  'Para volumes grandes (>3000 transações):' as recomendacao
UNION ALL
SELECT '1. Usar view materializada para cálculos mensais'
UNION ALL
SELECT '2. Implementar paginação nas consultas'
UNION ALL
SELECT '3. Usar cache no frontend'
UNION ALL
SELECT '4. Limitar consultas por período'
UNION ALL
SELECT '5. Usar índices compostos'
UNION ALL
SELECT '6. Configurar autovacuum adequadamente';
