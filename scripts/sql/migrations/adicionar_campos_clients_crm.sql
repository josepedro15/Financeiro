-- Migração para adicionar campos de CRM na tabela clients
-- Execute este SQL no Supabase SQL Editor

-- Adicionar campo stage para o kanban
ALTER TABLE public.clients 
ADD COLUMN stage VARCHAR(20) DEFAULT 'lead' 
CHECK (stage IN ('lead', 'prospect', 'client', 'vip'));

-- Adicionar campo notes para observações
ALTER TABLE public.clients 
ADD COLUMN notes TEXT;

-- Atualizar clientes existentes para stage 'client' (já são clientes)
UPDATE public.clients 
SET stage = 'client' 
WHERE stage IS NULL;

-- Verificar a estrutura atualizada
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'clients' 
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- Verificar dados existentes
SELECT id, name, stage, notes, is_active, created_at
FROM public.clients
ORDER BY created_at DESC
LIMIT 5;

SELECT '=== MIGRAÇÃO CONCLUÍDA ===' as status;
SELECT 'Campos stage e notes adicionados à tabela clients' as info;
SELECT 'Clientes existentes marcados como "client"' as info2;
