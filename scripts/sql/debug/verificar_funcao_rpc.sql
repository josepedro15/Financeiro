-- VERIFICAR EXATAMENTE O QUE ESTÁ ACONTECENDO NA FUNÇÃO RPC
-- O problema persiste mesmo após a correção

-- 1. Verificar a função atual
SELECT 
    routine_name,
    routine_definition
FROM information_schema.routines 
WHERE routine_name = 'insert_transaction_safe';

-- 2. Testar com debug detalhado
CREATE OR REPLACE FUNCTION insert_transaction_safe_debug(
    p_user_id UUID,
    p_description TEXT,
    p_amount DECIMAL,
    p_transaction_type TEXT,
    p_category TEXT,
    p_transaction_date DATE,
    p_account_name TEXT,
    p_client_name TEXT DEFAULT NULL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_table_name TEXT;
    v_result JSON;
    v_inserted_id UUID;
    v_actual_date DATE;
BEGIN
    -- DEBUG: Log dos parâmetros recebidos
    RAISE NOTICE 'DEBUG: p_transaction_date recebido = %', p_transaction_date;
    RAISE NOTICE 'DEBUG: Tipo de p_transaction_date = %', pg_typeof(p_transaction_date);
    
    -- Determinar tabela baseada na data
    IF EXTRACT(YEAR FROM p_transaction_date) = 2025 THEN
        v_table_name := 'transactions_' || EXTRACT(YEAR FROM p_transaction_date) || '_' || 
                       LPAD(EXTRACT(MONTH FROM p_transaction_date)::TEXT, 2, '0');
    ELSE
        v_table_name := 'transactions';
    END IF;
    
    RAISE NOTICE 'DEBUG: Tabela escolhida = %', v_table_name;
    
    -- Verificar se a tabela mensal existe
    IF v_table_name != 'transactions' AND NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = v_table_name
    ) THEN
        v_table_name := 'transactions';
        RAISE NOTICE 'DEBUG: Tabela mensal não existe, usando transactions';
    END IF;
    
    -- CORREÇÃO: Usar a data fornecida, NÃO NOW()
    v_actual_date := p_transaction_date;
    RAISE NOTICE 'DEBUG: v_actual_date definido = %', v_actual_date;
    
    -- Inserir na tabela determinada com data explícita
    EXECUTE format('
        INSERT INTO %I (
            user_id, 
            description, 
            amount, 
            transaction_type, 
            category, 
            transaction_date, 
            account_name, 
            client_name,
            created_at,
            updated_at
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW())
        RETURNING id, transaction_date, created_at
    ', v_table_name)
    INTO v_inserted_id, v_actual_date, v_actual_date
    USING p_user_id, p_description, p_amount, p_transaction_type, p_category, 
          v_actual_date, p_account_name, p_client_name;
    
    RAISE NOTICE 'DEBUG: Transação inserida com ID = %', v_inserted_id;
    RAISE NOTICE 'DEBUG: Data retornada = %', v_actual_date;
    
    -- Retornar resultado
    v_result := json_build_object(
        'success', true,
        'table_name', v_table_name,
        'id', v_inserted_id,
        'transaction_date', v_actual_date,
        'message', 'Transação inserida com sucesso'
    );
    
    RETURN v_result;
    
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'DEBUG: ERRO = %', SQLERRM;
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'table_name', COALESCE(v_table_name, 'unknown')
    );
END;
$$;

-- 3. Testar a função com debug
SELECT insert_transaction_safe_debug(
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID,
    'TESTE DEBUG RPC - DOMINGO 10/08',
    400.00,
    'income',
    'teste_debug',
    '2025-08-10'::DATE,
    'Conta PJ',
    NULL
);

-- 4. Verificar se foi inserida corretamente
SELECT 
    id,
    description,
    transaction_date,
    created_at,
    transaction_date::timestamp as transaction_timestamp,
    created_at::timestamp as created_timestamp
FROM transactions_2025_08 
WHERE description = 'TESTE DEBUG RPC - DOMINGO 10/08'
ORDER BY created_at DESC;
