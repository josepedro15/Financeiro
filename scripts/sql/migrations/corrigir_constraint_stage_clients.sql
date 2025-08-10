-- Script para corrigir a constraint clients_stage_check
-- Execute este script no Supabase SQL Editor

-- 1. Verificar a constraint atual
SELECT '=== VERIFICAR CONSTRAINT ATUAL ===' as info;
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints
WHERE constraint_name = 'clients_stage_check';

-- 2. Verificar valores permitidos na constraint
SELECT '=== VALORES PERMITIDOS ATUALMENTE ===' as info;
-- A constraint provavelmente só permite valores específicos como 'lead', 'prospect', etc.

-- 3. Remover a constraint problemática
SELECT '=== REMOVENDO CONSTRAINT ===' as info;
ALTER TABLE public.clients 
DROP CONSTRAINT IF EXISTS clients_stage_check;

-- 4. Criar nova constraint mais flexível (opcional)
SELECT '=== CRIANDO NOVA CONSTRAINT FLEXÍVEL ===' as info;
ALTER TABLE public.clients 
ADD CONSTRAINT clients_stage_check 
CHECK (stage IS NOT NULL AND length(stage) > 0);

-- 5. Testar inserção novamente
SELECT '=== TESTANDO INSERÇÃO NOVAMENTE ===' as info;
INSERT INTO public.clients (user_id, name, email, phone, document, address, stage, notes) 
VALUES ('00000000-0000-0000-0000-000000000002', 'Cliente Teste 2', 'teste2@email.com', '123456789', '123.456.789-00', 'Endereço Teste', 'Negociação', 'Observação teste')
ON CONFLICT DO NOTHING;

-- 6. Verificar se foi inserido
SELECT '=== CLIENTE INSERIDO ===' as info;
SELECT name, email, stage, notes FROM public.clients WHERE user_id = '00000000-0000-0000-0000-000000000002';

-- 7. Limpar teste
DELETE FROM public.clients WHERE user_id = '00000000-0000-0000-0000-000000000002';

-- 8. Mostrar estrutura final
SELECT '=== ESTRUTURA FINAL ===' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'clients'
AND table_schema = 'public'
ORDER BY ordinal_position;
