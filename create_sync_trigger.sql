-- Script para criar sincronização automática
-- Sempre que uma transação for inserida no usuário 2dc520e3-5f19-4dfe-838b-1aca7238ae36,
-- ela será automaticamente copiada para o usuário 76868410-a183-47b7-8173-7f3bcb4d90e0

-- Primeiro, vamos criar uma função que copia automaticamente
CREATE OR REPLACE FUNCTION sync_transactions_to_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Se a transação for do usuário origem, copiar para o usuário destino
    IF NEW.user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36' THEN
        INSERT INTO public.transactions (
            user_id, 
            transaction_date, 
            description, 
            amount, 
            transaction_type, 
            created_at, 
            updated_at
        ) VALUES (
            '76868410-a183-47b7-8173-7f3bcb4d90e0',
            NEW.transaction_date,
            NEW.description,
            NEW.amount,
            NEW.transaction_type,
            NEW.created_at,
            NEW.updated_at
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar o trigger que executa a função sempre que uma transação for inserida
DROP TRIGGER IF EXISTS sync_transactions_trigger ON public.transactions;
CREATE TRIGGER sync_transactions_trigger
    AFTER INSERT ON public.transactions
    FOR EACH ROW
    EXECUTE FUNCTION sync_transactions_to_user();

-- Verificar se o trigger foi criado
SELECT '=== TRIGGER CRIADO ===' as info;
SELECT trigger_name, event_manipulation, action_statement
FROM information_schema.triggers
WHERE trigger_name = 'sync_transactions_trigger'; 