-- Script para remover lançamentos de META de março 2025
-- Objetivo: Ajustar de R$ 18.041,20 para R$ 16.819,01
-- Diferença a remover: R$ 1.222,19

-- Substitua '2dc520e3-5f19-4dfe-838b-1aca7238ae36' pelo seu user_id real

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

    RAISE NOTICE '--- ESTADO ANTES DA LIMPEZA ---';
    RAISE NOTICE 'Transações: %, Valor total: R$ %', transacoes_antes, valor_antes;

    -- Mostrar lançamentos de META que serão removidos
    RAISE NOTICE '--- LANÇAMENTOS DE META A SEREM REMOVIDOS ---';
    PERFORM 
        transaction_date, 
        client_name, 
        description, 
        amount, 
        account_name
    FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3
      AND (
        UPPER(description) LIKE '%META%' OR
        UPPER(client_name) LIKE '%META%' OR
        UPPER(description) LIKE '%SALDO%' OR
        UPPER(description) LIKE '%ADICIONAL%' OR
        amount IN (1200.00, 2094.32) -- Valores específicos de META
      );

    -- 1. Remover lançamentos com palavras-chave de META
    RAISE NOTICE '--- REMOVENDO LANÇAMENTOS COM PALAVRAS-CHAVE DE META ---';
    DELETE FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3
      AND (
        UPPER(description) LIKE '%META%' OR
        UPPER(client_name) LIKE '%META%' OR
        UPPER(description) LIKE '%SALDO%' OR
        UPPER(description) LIKE '%ADICIONAL%'
      );
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE 'Removidos % lançamentos com palavras-chave de META', deleted_count;

    -- 2. Remover valores específicos de META (R$ 1.200,00 e R$ 2.094,32)
    RAISE NOTICE '--- REMOVENDO VALORES ESPECÍFICOS DE META ---';
    DELETE FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3
      AND amount IN (1200.00, 2094.32);
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RAISE NOTICE 'Removidos % lançamentos com valores específicos de META', deleted_count;

    -- 3. Verificar se ainda há valores suspeitos muito altos (acima de R$ 300)
    RAISE NOTICE '--- VERIFICANDO VALORES SUSPEITOS RESTANTES ---';
    SELECT COUNT(*) INTO deleted_count
    FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3
      AND amount > 300;
    
    IF deleted_count > 0 THEN
        RAISE NOTICE 'ATENÇÃO: Ainda há % transações com valores acima de R$ 300', deleted_count;
        -- Mostrar esses valores para análise
        PERFORM transaction_date, client_name, amount, account_name
        FROM public.transactions_2025_03
        WHERE user_id = user_uuid
          AND EXTRACT(YEAR FROM transaction_date) = 2025
          AND EXTRACT(MONTH FROM transaction_date) = 3
          AND amount > 300
        ORDER BY amount DESC;
    END IF;

    -- Verificar estado depois da limpeza
    SELECT COUNT(*), SUM(amount) INTO transacoes_depois, valor_depois
    FROM public.transactions_2025_03
    WHERE user_id = user_uuid
      AND EXTRACT(YEAR FROM transaction_date) = 2025
      AND EXTRACT(MONTH FROM transaction_date) = 3;

    RAISE NOTICE '--- ESTADO DEPOIS DA LIMPEZA ---';
    RAISE NOTICE 'Transações: %, Valor total: R$ %', transacoes_depois, valor_depois;
    RAISE NOTICE 'Diferença removida: R$ %', (valor_antes - valor_depois);
    RAISE NOTICE 'Transações removidas: %', (transacoes_antes - transacoes_depois);

    -- Verificar se chegamos ao valor esperado
    IF valor_depois BETWEEN 16800 AND 16850 THEN
        RAISE NOTICE '✅ SUCESSO: Valor está próximo do esperado (R$ 16.819,01)';
    ELSE
        RAISE NOTICE '⚠️ ATENÇÃO: Valor ainda não está correto. Esperado: R$ 16.819,01, Atual: R$ %', valor_depois;
    END IF;

END $$;

-- Verificação final detalhada
SELECT 
    '🎯 VERIFICAÇÃO FINAL:' as status,
    COUNT(*) as total_transacoes_final,
    SUM(amount) as valor_total_final,
    16819.01 as valor_esperado,
    (SUM(amount) - 16819.01) as diferenca_restante
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 3;
