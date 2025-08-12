-- =====================================================
-- CRIAÇÃO DAS TABELAS DO CRM
-- =====================================================

-- 1. Criar tabela de estágios
CREATE TABLE IF NOT EXISTS stages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    key VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50) DEFAULT 'target',
    color VARCHAR(100) DEFAULT 'bg-gray-100 text-gray-800',
    order_index INTEGER DEFAULT 0,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, key)
);

-- 2. Criar tabela de clientes (se não existir)
CREATE TABLE IF NOT EXISTS clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    document VARCHAR(50),
    address TEXT,
    stage VARCHAR(50) NOT NULL DEFAULT 'lead',
    notes TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_clients_user_id ON clients(user_id);
CREATE INDEX IF NOT EXISTS idx_clients_stage ON clients(stage);
CREATE INDEX IF NOT EXISTS idx_clients_is_active ON clients(is_active);
CREATE INDEX IF NOT EXISTS idx_stages_user_id ON stages(user_id);
CREATE INDEX IF NOT EXISTS idx_stages_key ON stages(key);

-- 4. Habilitar RLS nas tabelas
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages ENABLE ROW LEVEL SECURITY;

-- 5. Criar políticas RLS para clients
DROP POLICY IF EXISTS "clients_select_policy" ON clients;
DROP POLICY IF EXISTS "clients_insert_policy" ON clients;
DROP POLICY IF EXISTS "clients_update_policy" ON clients;
DROP POLICY IF EXISTS "clients_delete_policy" ON clients;

CREATE POLICY "clients_select_policy" ON clients
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "clients_insert_policy" ON clients
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "clients_update_policy" ON clients
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "clients_delete_policy" ON clients
    FOR DELETE
    USING (auth.uid() = user_id);

-- 6. Criar políticas RLS para stages
DROP POLICY IF EXISTS "stages_select_policy" ON stages;
DROP POLICY IF EXISTS "stages_insert_policy" ON stages;
DROP POLICY IF EXISTS "stages_update_policy" ON stages;
DROP POLICY IF EXISTS "stages_delete_policy" ON stages;

CREATE POLICY "stages_select_policy" ON stages
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "stages_insert_policy" ON stages
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "stages_update_policy" ON stages
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "stages_delete_policy" ON stages
    FOR DELETE
    USING (auth.uid() = user_id);

-- 7. Criar função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 8. Criar triggers para atualizar updated_at
DROP TRIGGER IF EXISTS update_clients_updated_at ON clients;
DROP TRIGGER IF EXISTS update_stages_updated_at ON stages;

CREATE TRIGGER update_clients_updated_at
    BEFORE UPDATE ON clients
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stages_updated_at
    BEFORE UPDATE ON stages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 9. Verificar se as tabelas foram criadas
SELECT '=== VERIFICAÇÃO DAS TABELAS ===' as info;

SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('clients', 'stages')
ORDER BY table_name, ordinal_position;

-- 10. Verificar políticas RLS
SELECT '=== POLÍTICAS RLS ===' as info;

SELECT 
    tablename,
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename IN ('clients', 'stages')
ORDER BY tablename, cmd;

SELECT '=== TABELAS CRM CRIADAS COM SUCESSO ===' as info;
