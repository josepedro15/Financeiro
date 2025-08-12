-- Script para verificar transações e problemas de exclusão

-- 1. Verificar se há transações na tabela principal
SELECT 'Tabela transactions:' as info;
SELECT COUNT(*) as total_transactions FROM transactions WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. Verificar transações na tabela mensal de agosto
SELECT 'Tabela transactions_2025_08:' as info;
SELECT COUNT(*) as total_transactions FROM transactions_2025_08 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 3. Verificar algumas transações específicas
SELECT 'Transações em transactions_2025_08:' as info;
SELECT id, description, amount, transaction_type, account_name, transaction_date, created_at 
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
ORDER BY created_at DESC
LIMIT 5;

-- 4. Verificar políticas RLS na tabela transactions_2025_08
SELECT 'Políticas RLS em transactions_2025_08:' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'transactions_2025_08';

-- 5. Verificar se o usuário tem permissões
SELECT 'Permissões do usuário:' as info;
SELECT current_user, session_user;

-- 6. Testar uma exclusão (comentado para não executar)
-- DELETE FROM transactions_2025_08 WHERE id = 'ID_DA_TRANSACAO' AND user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
