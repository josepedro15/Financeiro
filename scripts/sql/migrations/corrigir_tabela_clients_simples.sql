-- Script simples para corrigir a tabela clients
-- Execute este script no Supabase SQL Editor

-- 1. Adicionar coluna stage se não existir
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS stage VARCHAR(100) DEFAULT 'lead';

-- 2. Adicionar coluna notes se não existir
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS notes TEXT;

-- 3. Verificar estrutura final
SELECT '=== ESTRUTURA FINAL DA TABELA CLIENTS ===' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. Testar inserção
SELECT '=== TESTANDO INSERÇÃO ===' as info;
INSERT INTO public.clients (user_id, name, email, phone, document, address, stage, notes) 
VALUES ('00000000-0000-0000-0000-000000000001', 'Cliente Teste', 'teste@email.com', '123456789', '123.456.789-00', 'Endereço Teste', 'Negociação', 'Observação teste')
ON CONFLICT DO NOTHING;

-- 5. Verificar se foi inserido
SELECT '=== CLIENTE INSERIDO ===' as info;
SELECT name, email, stage, notes FROM public.clients WHERE user_id = '00000000-0000-0000-0000-000000000001';

-- 6. Limpar teste
DELETE FROM public.clients WHERE user_id = '00000000-0000-0000-0000-000000000001';
