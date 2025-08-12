-- SOLUÇÃO RÁPIDA PARA DELETE E DASHBOARD
-- Execute este script no Supabase SQL Editor

-- 1. Corrigir políticas RLS para DELETE
SELECT '=== CORRIGINDO POLÍTICAS DE DELETE ===' as info;

-- Para tabela transactions principal
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions;
CREATE POLICY "Users can delete their own transactions" ON transactions 
FOR DELETE USING (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- Para tabela transactions_2025_08
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;
CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- 2. Corrigir políticas RLS para SELECT (dashboard)
SELECT '=== CORRIGINDO POLÍTICAS DE SELECT ===' as info;

-- Para tabela transactions principal
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions;
CREATE POLICY "Users can view their own transactions" ON transactions 
FOR SELECT USING (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- Para tabela transactions_2025_08
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (is_master_user(auth.uid()) OR auth.uid() = user_id);

-- 3. Criar função is_master_user se não existir
CREATE OR REPLACE FUNCTION is_master_user(user_uuid UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN user_uuid = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'::UUID;
END;
$$;

-- 4. Testar DELETE
SELECT '=== TESTANDO DELETE ===' as info;

-- Inserir transação de teste
INSERT INTO transactions_2025_08 (
    user_id, 
    description, 
    amount, 
    transaction_type, 
    category, 
    transaction_date, 
    account_name,
    created_at,
    updated_at
) VALUES (
    '2dc520e3-5f19-4dfe-838b-1aca7238ae36', 
    'TESTE DELETE RÁPIDO', 
    500.00, 
    'income', 
    'teste_rapido', 
    '2025-08-12', 
    'Conta PJ',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 5. Testar DELETE da transação
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE DELETE RÁPIDO';

-- 6. Verificar se foi deletada
SELECT 
    'Transações restantes com descrição de teste:' as status,
    COUNT(*) as quantidade
FROM transactions_2025_08 
WHERE description = 'TESTE DELETE RÁPIDO';

-- 7. Testar SELECT (dashboard)
SELECT '=== TESTANDO SELECT (DASHBOARD) ===' as info;

-- Simular contexto do master user
SET LOCAL ROLE authenticated;
SET LOCAL "request.jwt.claim.sub" TO '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Testar consulta na tabela principal
SELECT 
    'transactions' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- Testar consulta na tabela mensal
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as transacoes_visiveis
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 8. Verificar políticas finais
SELECT '=== POLÍTICAS FINAIS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('transactions', 'transactions_2025_08')
  AND cmd IN ('SELECT', 'DELETE')
ORDER BY tablename, cmd, policyname;

-- 9. Verificar dados disponíveis para dashboard
SELECT '=== DADOS PARA DASHBOARD ===' as info;
SELECT 
    'transactions' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
UNION ALL
SELECT 
    'transactions_2025_08' as tabela,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

SELECT '=== DELETE E DASHBOARD CORRIGIDOS! ===' as info;
