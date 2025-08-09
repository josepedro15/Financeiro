-- Script para remover duplicatas exatas de março 2025
-- Manter apenas 1 cópia de cada transação duplicada

DO $$
DECLARE
    user_uuid UUID := '2dc520e3-5f19-4dfe-838b-1aca7238ae36'; -- Seu user_id
    valor_antes DECIMAL(15,2);
    valor_depois DECIMAL(15,2);
    transacoes_antes INT;
    transacoes_depois INT;
    deleted_count INT;
BEGIN
    -- Verificar estado antes da limpeza
    SELECT COUNT(*), SUM(amount) INTO transacoes_antes, valor_antes
    FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3;

    RAISE NOTICE '--- ESTADO ANTES DA REMOÇÃO DE DUPLICATAS ---';
    RAISE NOTICE 'Transações: %, Valor total: R$ %', transacoes_antes, valor_antes;

    -- Mostrar quantas duplicatas existem
    SELECT COUNT(*) INTO deleted_count
    FROM (
        SELECT client_name, amount, transaction_date, account_name, COUNT(*)
        FROM public.transactions_2025_03
        WHERE user_id = user_uuid
          AND EXTRACT(YEAR FROM transaction_date) = 2025
          AND EXTRACT(MONTH FROM transaction_date) = 3
        GROUP BY client_name, amount, transaction_date, account_name
        HAVING COUNT(*) > 1
    ) duplicates;
    
    RAISE NOTICE 'Encontradas % grupos de transações duplicadas', deleted_count;

    -- Remover duplicatas mantendo apenas a primeira ocorrência
    -- Usando ROW_NUMBER() para identificar duplicatas
    WITH duplicates_to_remove AS (
        SELECT id,
               ROW_NUMBER() OVER (
                   PARTITION BY client_name, amount, transaction_date, account_name 
                   ORDER BY created_at
               ) as rn
        FROM public.transactions_2025_03
        WHERE user_id = user_uuid
          AND EXTRACT(YEAR FROM transaction_date) = 2025
          AND EXTRACT(MONTH FROM transaction_date) = 3
    )
    DELETE FROM public.transactions_2025_03
    WHERE id IN (
        SELECT id 
        FROM duplicates_to_remove 
        WHERE rn > 1
    );
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE 'Removidas % transações duplicadas', deleted_count;

    -- Verificar estado depois da limpeza
    SELECT COUNT(*), SUM(amount) INTO transacoes_depois, valor_depois
    FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3;

    RAISE NOTICE '--- ESTADO DEPOIS DA REMOÇÃO DE DUPLICATAS ---';
    RAISE NOTICE 'Transações: %, Valor total: R$ %', transacoes_depois, valor_depois;
    RAISE NOTICE 'Diferença removida: R$ %', (valor_antes - valor_depois);
    RAISE NOTICE 'Transações removidas: %', (transacoes_antes - transacoes_depois);

    -- Verificar se chegamos ao valor esperado
    IF valor_depois BETWEEN 16800 AND 16850 THEN
        RAISE NOTICE '✅ SUCESSO: Valor está próximo do esperado (R$ 16.819,01)';
    ELSE
        RAISE NOTICE '⚠️ ATENÇÃO: Valor ainda não está correto. Esperado: R$ 16.819,01, Atual: R$ %', valor_depois;
        RAISE NOTICE 'Diferença restante: R$ %', ABS(valor_depois - 16819.01);
    END IF;

    -- Verificar se ainda há duplicatas
    SELECT COUNT(*) INTO deleted_count
    FROM (
        SELECT client_name, amount, transaction_date, account_name, COUNT(*)
        FROM public.transactions_2025_03
        WHERE user_id = user_uuid
          AND EXTRACT(YEAR FROM transaction_date) = 2025
          AND EXTRACT(MONTH FROM transaction_date) = 3
        GROUP BY client_name, amount, transaction_date, account_name
        HAVING COUNT(*) > 1
    ) remaining_duplicates;
    
    IF deleted_count = 0 THEN
        RAISE NOTICE '✅ Nenhuma duplicata restante';
    ELSE
        RAISE NOTICE '⚠️ Ainda existem % grupos de duplicatas', deleted_count;
    END IF;

END $$;

-- Verificação final detalhada
SELECT 
    '🎯 VERIFICAÇÃO FINAL APÓS REMOÇÃO DE DUPLICATAS:' as status,
    COUNT(*) as total_transacoes_final,
    SUM(amount) as valor_total_final,
    16819.01 as valor_esperado,
    (SUM(amount) - 16819.01) as diferenca_restante,
    CASE 
        WHEN ABS(SUM(amount) - 16819.01) < 50 THEN '✅ MUITO PRÓXIMO'
        WHEN ABS(SUM(amount) - 16819.01) < 200 THEN '⚠️ PRÓXIMO'
        ELSE '❌ AINDA DISTANTE'
    END as status_correcao
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3;
