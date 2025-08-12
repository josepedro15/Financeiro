-- CORRIGIR ERROS 400 - PROBLEMAS DE COMUNICAÇÃO
-- Execute este script no Supabase SQL Editor

-- 1. Verificar se há problemas de RLS
SELECT '=== VERIFICAR RLS ===' as info;
SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'transactions_2025_08'
ORDER BY cmd, policyname;

-- 2. Verificar se RLS está habilitado
SELECT '=== VERIFICAR STATUS RLS ===' as info;
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'transactions_2025_08';

-- 3. Verificar estrutura da tabela
SELECT '=== ESTRUTURA DA TABELA ===' as info;
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08'
ORDER BY ordinal_position;

-- 4. Verificar constraints
SELECT '=== CONSTRAINTS ===' as info;
SELECT 
    constraint_name,
    constraint_type,
    table_name
FROM information_schema.table_constraints 
WHERE table_schema = 'public' 
  AND table_name = 'transactions_2025_08';

-- 5. Verificar se há triggers
SELECT '=== TRIGGERS ===' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'transactions_2025_08';

-- 6. Testar operações básicas
SELECT '=== TESTAR OPERAÇÕES BÁSICAS ===' as info;

-- Testar SELECT
SELECT COUNT(*) as total_transacoes
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6';

-- Testar INSERT
INSERT INTO transactions_2025_08 (
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
) VALUES (
    '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6', 
    'TESTE ERRO 400', 
    100.00, 
    'income', 
    'teste', 
    '2025-08-15', 
    'Conta PJ',
    'Cliente Teste',
    NOW(),
    NOW()
) RETURNING id, description, transaction_date;

-- 7. Verificar se foi inserida
SELECT '=== VERIFICAR INSERÇÃO ===' as info;
SELECT 
    id,
    description,
    transaction_date,
    amount
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description = 'TESTE ERRO 400';

-- 8. Testar UPDATE
SELECT '=== TESTAR UPDATE ===' as info;
UPDATE transactions_2025_08 
SET 
    description = 'TESTE ERRO 400 ATUALIZADO',
    amount = 200.00,
    updated_at = NOW()
WHERE description = 'TESTE ERRO 400'
  AND user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
RETURNING id, description, amount;

-- 9. Testar DELETE
SELECT '=== TESTAR DELETE ===' as info;
DELETE FROM transactions_2025_08 
WHERE description = 'TESTE ERRO 400 ATUALIZADO'
  AND user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
RETURNING id, description;

-- 10. Verificar se foi removida
SELECT '=== VERIFICAR REMOÇÃO ===' as info;
SELECT COUNT(*) as transacoes_restantes
FROM transactions_2025_08 
WHERE user_id = '8806b3ba-9a8a-4ed8-a4eb-d35cc40ff5d6'
  AND description LIKE 'TESTE ERRO 400%';

-- 11. Corrigir RLS se necessário
SELECT '=== CORRIGIR RLS ===' as info;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can insert their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;

-- Criar políticas simples
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 12. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'transactions_2025_08'
ORDER BY cmd, policyname;

SELECT '=== CORREÇÃO CONCLUÍDA ===' as info;
