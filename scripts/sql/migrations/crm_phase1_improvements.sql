-- =====================================================
-- MELHORIAS CRM - FASE 1
-- =====================================================

-- 1. MELHORAR TABELA CLIENTS
-- =====================================================

-- Adicionar novos campos úteis para CRM
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS source VARCHAR(100),
ADD COLUMN IF NOT EXISTS industry VARCHAR(100),
ADD COLUMN IF NOT EXISTS company_size VARCHAR(50),
ADD COLUMN IF NOT EXISTS budget_range VARCHAR(50),
ADD COLUMN IF NOT EXISTS last_contact_date DATE,
ADD COLUMN IF NOT EXISTS next_follow_up DATE,
ADD COLUMN IF NOT EXISTS assigned_to UUID REFERENCES auth.users(id),
ADD COLUMN IF NOT EXISTS tags TEXT[],
ADD COLUMN IF NOT EXISTS social_media JSONB,
ADD COLUMN IF NOT EXISTS lead_score INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_value DECIMAL(15,2) DEFAULT 0;

-- 2. CRIAR TABELA DE ATIVIDADES
-- =====================================================

CREATE TABLE IF NOT EXISTS public.activities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('call', 'email', 'meeting', 'task', 'note', 'follow_up')),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled', 'overdue')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    duration_minutes INTEGER,
    location VARCHAR(255),
    attendees TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. CRIAR TABELA DE OPORTUNIDADES
-- =====================================================

CREATE TABLE IF NOT EXISTS public.opportunities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    value DECIMAL(15,2) NOT NULL DEFAULT 0,
    probability INTEGER DEFAULT 50 CHECK (probability >= 0 AND probability <= 100),
    expected_close_date DATE,
    stage VARCHAR(50) DEFAULT 'prospecting' CHECK (stage IN ('prospecting', 'qualification', 'proposal', 'negotiation', 'closed_won', 'closed_lost')),
    source VARCHAR(100),
    type VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. CRIAR TABELA DE HISTÓRICO
-- =====================================================

CREATE TABLE IF NOT EXISTS public.client_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id UUID REFERENCES public.clients(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    action VARCHAR(50) NOT NULL CHECK (action IN ('stage_change', 'note_added', 'activity_created', 'opportunity_created', 'contact_updated', 'lead_score_changed')),
    old_value TEXT,
    new_value TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. CRIAR TABELA DE NOTIFICAÇÕES
-- =====================================================

CREATE TABLE IF NOT EXISTS public.crm_notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('activity_reminder', 'stage_change', 'follow_up_due', 'opportunity_update', 'lead_assigned')),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    related_id UUID, -- ID do cliente, atividade, etc.
    related_type VARCHAR(50), -- 'client', 'activity', 'opportunity'
    is_read BOOLEAN DEFAULT false,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. CRIAR ÍNDICES PARA PERFORMANCE
-- =====================================================

-- Índices para activities
CREATE INDEX IF NOT EXISTS idx_activities_client_id ON activities(client_id);
CREATE INDEX IF NOT EXISTS idx_activities_user_id ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_scheduled_at ON activities(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_activities_status ON activities(status);
CREATE INDEX IF NOT EXISTS idx_activities_type ON activities(type);

-- Índices para opportunities
CREATE INDEX IF NOT EXISTS idx_opportunities_client_id ON opportunities(client_id);
CREATE INDEX IF NOT EXISTS idx_opportunities_user_id ON opportunities(user_id);
CREATE INDEX IF NOT EXISTS idx_opportunities_stage ON opportunities(stage);
CREATE INDEX IF NOT EXISTS idx_opportunities_expected_close_date ON opportunities(expected_close_date);
CREATE INDEX IF NOT EXISTS idx_opportunities_value ON opportunities(value);

-- Índices para client_history
CREATE INDEX IF NOT EXISTS idx_client_history_client_id ON client_history(client_id);
CREATE INDEX IF NOT EXISTS idx_client_history_user_id ON client_history(user_id);
CREATE INDEX IF NOT EXISTS idx_client_history_action ON client_history(action);
CREATE INDEX IF NOT EXISTS idx_client_history_created_at ON client_history(created_at);

-- Índices para crm_notifications
CREATE INDEX IF NOT EXISTS idx_crm_notifications_user_id ON crm_notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_crm_notifications_is_read ON crm_notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_crm_notifications_scheduled_at ON crm_notifications(scheduled_at);

-- Índices para novos campos de clients
CREATE INDEX IF NOT EXISTS idx_clients_source ON clients(source);
CREATE INDEX IF NOT EXISTS idx_clients_industry ON clients(industry);
CREATE INDEX IF NOT EXISTS idx_clients_assigned_to ON clients(assigned_to);
CREATE INDEX IF NOT EXISTS idx_clients_next_follow_up ON clients(next_follow_up);
CREATE INDEX IF NOT EXISTS idx_clients_lead_score ON clients(lead_score);

-- 7. HABILITAR RLS NAS NOVAS TABELAS
-- =====================================================

ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE crm_notifications ENABLE ROW LEVEL SECURITY;

-- 8. CRIAR POLÍTICAS RLS
-- =====================================================

-- Políticas para activities
CREATE POLICY "activities_select_policy" ON activities
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "activities_insert_policy" ON activities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "activities_update_policy" ON activities
    FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "activities_delete_policy" ON activities
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para opportunities
CREATE POLICY "opportunities_select_policy" ON opportunities
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "opportunities_insert_policy" ON opportunities
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "opportunities_update_policy" ON opportunities
    FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "opportunities_delete_policy" ON opportunities
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para client_history
CREATE POLICY "client_history_select_policy" ON client_history
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "client_history_insert_policy" ON client_history
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para crm_notifications
CREATE POLICY "crm_notifications_select_policy" ON crm_notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "crm_notifications_insert_policy" ON crm_notifications
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "crm_notifications_update_policy" ON crm_notifications
    FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- 9. CRIAR TRIGGERS PARA UPDATED_AT
-- =====================================================

CREATE TRIGGER update_activities_updated_at
    BEFORE UPDATE ON activities
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_opportunities_updated_at
    BEFORE UPDATE ON opportunities
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 10. CRIAR FUNÇÕES ÚTEIS
-- =====================================================

-- Função para registrar mudanças de estágio
CREATE OR REPLACE FUNCTION log_client_stage_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.stage IS DISTINCT FROM NEW.stage THEN
        INSERT INTO client_history (client_id, user_id, action, old_value, new_value)
        VALUES (NEW.id, NEW.user_id, 'stage_change', OLD.stage, NEW.stage);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para registrar mudanças de estágio
CREATE TRIGGER trigger_client_stage_change
    AFTER UPDATE ON clients
    FOR EACH ROW
    EXECUTE FUNCTION log_client_stage_change();

-- Função para calcular lead score baseado em atividades
CREATE OR REPLACE FUNCTION calculate_lead_score(client_uuid UUID)
RETURNS INTEGER AS $$
DECLARE
    score INTEGER := 0;
    activity_count INTEGER;
    recent_activity_count INTEGER;
    opportunity_value DECIMAL;
BEGIN
    -- Contar atividades
    SELECT COUNT(*) INTO activity_count
    FROM activities
    WHERE client_id = client_uuid AND status = 'completed';
    
    -- Contar atividades recentes (últimos 30 dias)
    SELECT COUNT(*) INTO recent_activity_count
    FROM activities
    WHERE client_id = client_uuid 
    AND status = 'completed'
    AND completed_at >= NOW() - INTERVAL '30 days';
    
    -- Soma do valor das oportunidades
    SELECT COALESCE(SUM(value), 0) INTO opportunity_value
    FROM opportunities
    WHERE client_id = client_uuid AND is_active = true;
    
    -- Calcular score
    score := activity_count * 10 + recent_activity_count * 20 + 
             CASE WHEN opportunity_value > 0 THEN 50 ELSE 0 END;
    
    -- Limitar score entre 0 e 100
    RETURN GREATEST(0, LEAST(100, score));
END;
$$ LANGUAGE plpgsql;

-- 11. VERIFICAR IMPLEMENTAÇÃO
-- =====================================================

SELECT '=== VERIFICAÇÃO DAS NOVAS TABELAS ===' as info;

SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('activities', 'opportunities', 'client_history', 'crm_notifications')
ORDER BY table_name, ordinal_position;

SELECT '=== VERIFICAÇÃO DOS NOVOS CAMPOS EM CLIENTS ===' as info;

SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'clients' 
AND column_name IN ('source', 'industry', 'company_size', 'budget_range', 'last_contact_date', 'next_follow_up', 'assigned_to', 'tags', 'social_media', 'lead_score', 'total_value')
ORDER BY ordinal_position;

SELECT '=== VERIFICAÇÃO DAS POLÍTICAS RLS ===' as info;

SELECT 
    tablename,
    policyname,
    cmd
FROM pg_policies 
WHERE tablename IN ('activities', 'opportunities', 'client_history', 'crm_notifications')
ORDER BY tablename, cmd;

SELECT '✅ MELHORIAS CRM FASE 1 IMPLEMENTADAS COM SUCESSO!' as resultado;
