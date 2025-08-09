-- Script para apagar dados da tabela original transactions após migração para tabelas mensais
-- ATENÇÃO: Execute apenas APÓS confirmar que as tabelas mensais foram criadas e populadas corretamente!

-- 1. Verificar se as tabelas mensais existem e têm dados
SELECT '=== VERIFICAÇÃO PRÉ-LIMPEZA ===' as info;

-- Verificar se todas as tabelas mensais existem
SELECT 
    table_name,
    CASE 
        WHEN table_name IS NOT NULL THEN 'EXISTS'
        ELSE 'NOT EXISTS'
    END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'transactions_2025_%'
ORDER BY table_name;

-- Contar registros nas tabelas mensais
SELECT '=== CONTAGEM NAS TABELAS MENSAIS ===' as info;

SELECT 'Janeiro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_01
UNION ALL
SELECT 'Fevereiro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_02
UNION ALL
SELECT 'Março 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_03
UNION ALL
SELECT 'Abril 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_04
UNION ALL
SELECT 'Maio 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_05
UNION ALL
SELECT 'Junho 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_06
UNION ALL
SELECT 'Julho 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_07
UNION ALL
SELECT 'Agosto 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_08
UNION ALL
SELECT 'Setembro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_09
UNION ALL
SELECT 'Outubro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_10
UNION ALL
SELECT 'Novembro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_11
UNION ALL
SELECT 'Dezembro 2025' as mes, COUNT(*) as registros FROM public.transactions_2025_12;

-- Total nas tabelas mensais
SELECT '=== TOTAL NAS TABELAS MENSAIS ===' as info;

SELECT 
    'TOTAL TABELAS MENSAIS' as origem,
    SUM(registros) as total_registros
FROM (
    SELECT COUNT(*) as registros FROM public.transactions_2025_01
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_02
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_03
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_04
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_05
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_06
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_07
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_08
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_09
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_10
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_11
    UNION ALL
    SELECT COUNT(*) as registros FROM public.transactions_2025_12
) as totals;

-- Contar registros na tabela original
SELECT '=== TABELA ORIGINAL ===' as info;

SELECT 
    'TABELA ORIGINAL' as origem,
    COUNT(*) as total_registros
FROM public.transactions;

-- Comparar totais (devem ser iguais para prosseguir com segurança)
SELECT '=== COMPARAÇÃO DE TOTAIS ===' as info;

WITH original_count AS (
    SELECT COUNT(*) as total FROM public.transactions
),
monthly_count AS (
    SELECT SUM(registros) as total
    FROM (
        SELECT COUNT(*) as registros FROM public.transactions_2025_01
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_02
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_03
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_04
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_05
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_06
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_07
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_08
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_09
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_10
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_11
        UNION ALL
        SELECT COUNT(*) as registros FROM public.transactions_2025_12
    ) as totals
)
SELECT 
    o.total as tabela_original,
    m.total as tabelas_mensais,
    CASE 
        WHEN o.total = m.total THEN '✅ TOTAIS IGUAIS - SEGURO PROSSEGUIR'
        ELSE '❌ TOTAIS DIFERENTES - NÃO APAGUE!'
    END as status_migracao
FROM original_count o, monthly_count m;

-- 2. BACKUP antes de apagar (criar tabela de backup)
SELECT '=== CRIANDO BACKUP ===' as info;

-- Criar tabela de backup
CREATE TABLE IF NOT EXISTS public.transactions_backup_pre_cleanup AS 
SELECT * FROM public.transactions;

-- Verificar backup
SELECT 
    'BACKUP CRIADO' as status,
    COUNT(*) as registros_backup
FROM public.transactions_backup_pre_cleanup;

-- 3. APAGAR dados da tabela original (descomente apenas após verificar)
SELECT '=== PRONTO PARA LIMPEZA ===' as info;

-- DESCOMENTE AS LINHAS ABAIXO APENAS APÓS VERIFICAR QUE:
-- 1. As tabelas mensais têm TODOS os dados
-- 2. Os totais são IGUAIS
-- 3. O backup foi criado com sucesso

/*
-- ATENÇÃO: OPERAÇÃO IRREVERSÍVEL!
-- Desabilitar RLS temporariamente para garantir que todos os dados sejam apagados
ALTER TABLE public.transactions DISABLE ROW LEVEL SECURITY;

-- Apagar TODOS os dados da tabela original
DELETE FROM public.transactions;

-- Verificar se a tabela está vazia
SELECT 
    'TABELA ORIGINAL APÓS LIMPEZA' as status,
    COUNT(*) as registros_restantes
FROM public.transactions;

-- Reabilitar RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Recrear policies se necessário
DROP POLICY IF EXISTS "Users can view their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can create their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can update their own transactions" ON public.transactions;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON public.transactions;

CREATE POLICY "Users can view their own transactions" ON public.transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create their own transactions" ON public.transactions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own transactions" ON public.transactions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own transactions" ON public.transactions FOR DELETE USING (auth.uid() = user_id);
*/

SELECT '=== INSTRUÇÕES FINAIS ===' as info;

SELECT 'Para completar a limpeza:' as passo_1;
SELECT '1. Verifique se os totais são IGUAIS' as passo_2;
SELECT '2. Confirme que o backup foi criado' as passo_3;
SELECT '3. Descomente o bloco de limpeza acima' as passo_4;
SELECT '4. Execute novamente este script' as passo_5;

-- 4. Script para restaurar do backup (em caso de emergência)
SELECT '=== SCRIPT DE EMERGÊNCIA (EM CASO DE PROBLEMAS) ===' as info;

/*
-- APENAS EM CASO DE EMERGÊNCIA!
-- Para restaurar os dados do backup:

INSERT INTO public.transactions 
SELECT * FROM public.transactions_backup_pre_cleanup;
*/
