-- Criar tabela para armazenar estágios personalizados do CRM

-- 1. Criar tabela stages
CREATE TABLE IF NOT EXISTS public.stages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    key TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    icon TEXT DEFAULT 'Target',
    color TEXT DEFAULT 'bg-gray-100 text-gray-800',
    order_index INTEGER DEFAULT 0,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Garantir que cada usuário tenha chaves únicas para estágios
    UNIQUE(user_id, key)
);

-- 2. Habilitar RLS
ALTER TABLE public.stages ENABLE ROW LEVEL SECURITY;

-- 3. Criar políticas RLS
CREATE POLICY "stages_user_policy" ON public.stages
    FOR ALL USING (user_id = auth.uid());

-- 4. Criar trigger para updated_at
CREATE TRIGGER update_stages_updated_at 
    BEFORE UPDATE ON public.stages 
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- 5. Inserir estágios padrão para todos os usuários existentes
INSERT INTO public.stages (user_id, key, name, description, icon, color, order_index, is_default)
SELECT 
    u.id as user_id,
    stage_data.key,
    stage_data.name,
    stage_data.description,
    stage_data.icon,
    stage_data.color,
    stage_data.order_index,
    TRUE as is_default
FROM auth.users u
CROSS JOIN (
    VALUES 
        ('lead', 'Lead', 'Interessados', 'Target', 'bg-yellow-100 text-yellow-800', 1),
        ('prospect', 'Prospect', 'Em negociação', 'User', 'bg-blue-100 text-blue-800', 2),
        ('client', 'Cliente', 'Compraram', 'UserCheck', 'bg-green-100 text-green-800', 3),
        ('vip', 'VIP', 'Clientes premium', 'Crown', 'bg-purple-100 text-purple-800', 4)
) AS stage_data(key, name, description, icon, color, order_index)
ON CONFLICT (user_id, key) DO NOTHING;

-- 6. Verificar dados inseridos
SELECT 'ESTÁGIOS CRIADOS POR USUÁRIO:' as info;
SELECT 
    u.email,
    s.key,
    s.name,
    s.description,
    s.icon,
    s.color,
    s.order_index,
    s.is_default,
    s.created_at
FROM public.stages s
JOIN auth.users u ON s.user_id = u.id
ORDER BY u.email, s.order_index;

SELECT '✅ TABELA STAGES CRIADA E POPULADA!' as resultado;
