-- Script para corrigir políticas RLS das tabelas mensais

-- 1. Verificar se as políticas existem
SELECT 'Políticas existentes:' as info;
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename LIKE 'transactions_2025_%';

-- 2. Remover políticas antigas se existirem
DROP POLICY IF EXISTS "Users can view their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can create their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can update their own transactions" ON transactions_2025_08;
DROP POLICY IF EXISTS "Users can delete their own transactions" ON transactions_2025_08;

-- 3. Criar políticas corretas para transactions_2025_08
CREATE POLICY "Users can view their own transactions" ON transactions_2025_08 
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own transactions" ON transactions_2025_08 
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" ON transactions_2025_08 
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" ON transactions_2025_08 
FOR DELETE USING (auth.uid() = user_id);

-- 4. Verificar se RLS está habilitado
ALTER TABLE transactions_2025_08 ENABLE ROW LEVEL SECURITY;

-- 5. Verificar políticas criadas
SELECT 'Políticas criadas para transactions_2025_08:' as info;
SELECT schemaname, tablename, policyname, cmd 
FROM pg_policies 
WHERE tablename = 'transactions_2025_08';

-- 6. Testar permissões
SELECT 'Testando permissões:' as info;
SELECT COUNT(*) as transacoes_visiveis 
FROM transactions_2025_08 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';
