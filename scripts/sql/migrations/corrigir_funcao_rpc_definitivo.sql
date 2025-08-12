-- CORREÇÃO DEFINITIVA: Função RPC que NÃO altera a data
-- Vamos fazer uma função ultra-simples que preserva a data exata

-- 1. Dropar a função antiga
DROP FUNCTION IF EXISTS insert_transaction_safe_debug;

-- 2. Criar função ULTRA-SIMPLES
CREATE OR REPLACE FUNCTION insert_transaction_safe_final(
    p_user_id UUID,
    p_description TEXT,
    p_amount DECIMAL,
    p_transaction_type TEXT,
    p_category TEXT,
    p_transaction_date TEXT, -- USAR TEXT PARA EVITAR CONVERSÕES
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
BEGIN
    -- Determinar tabela baseada na data (usando string)
    IF SUBSTRING(p_transaction_date, 1, 4) = '2025' THEN
        v_table_name := 'transactions_' || SUBSTRING(p_transaction_date, 1, 4) || '_' || 
                       SUBSTRING(p_transaction_date, 6, 2);
    ELSE
        v_table_name := 'transactions';
    END IF;
    
    -- Verificar se a tabela mensal existe
    IF v_table_name != 'transactions' AND NOT EXISTS (
        SELECT 1 FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = v_table_name
    ) THEN
        v_table_name := 'transactions';
    END IF;
    
    -- INSERÇÃO DIRETA: Usar a data exatamente como recebida
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
        ) VALUES ($1, $2, $3, $4, $5, $6::date, $7, $8, NOW(), NOW())
        RETURNING id, transaction_date
    ', v_table_name)
    INTO v_inserted_id, p_transaction_date
    USING p_user_id, p_description, p_amount, p_transaction_type, p_category, 
          p_transaction_date, p_account_name, p_client_name;
    
    -- Retornar resultado
    v_result := json_build_object(
        'success', true,
        'table_name', v_table_name,
        'id', v_inserted_id,
        'transaction_date', p_transaction_date,
        'message', 'Transação inserida com sucesso'
    );
    
    RETURN v_result;
    
EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'success', false,
        'error', SQLERRM,
        'table_name', COALESCE(v_table_name, 'unknown')
    );
END;
$$;

-- 3. Testar a função ULTRA-SIMPLES
SELECT insert_transaction_safe_final(
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID,
    'TESTE FUNÇÃO ULTRA-SIMPLES - DOMINGO 10/08',
    500.00,
    'income',
    'teste_ultra_simples',
    '2025-08-10', -- DATA EXATA COMO STRING
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
WHERE description = 'TESTE FUNÇÃO ULTRA-SIMPLES - DOMINGO 10/08'
ORDER BY created_at DESC;
