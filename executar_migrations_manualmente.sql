-- =====================================================
-- SCRIPT PARA EXECUTAR MIGRATIONS MANUALMENTE
-- Execute este script no Supabase Dashboard > SQL Editor
-- =====================================================

-- 1. ADICIONAR CAMPOS CRM À TABELA CLIENTS
-- =====================================================

-- Perfil e classificação
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS contact_type VARCHAR(50) DEFAULT 'lead';

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS lead_source VARCHAR(100);

-- Dados complementares estratégicos
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS job_title VARCHAR(100);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS company VARCHAR(100);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS industry VARCHAR(100);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS estimated_ticket DECIMAL(10,2);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS clv DECIMAL(10,2);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS purchase_history JSONB;

-- Histórico de interações
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS last_contact_date TIMESTAMP WITH TIME ZONE;

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS next_follow_up TIMESTAMP WITH TIME ZONE;

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS days_since_last_contact INTEGER;

-- Customizações para negócio
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS delivery_deadline VARCHAR(100);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS technical_contact VARCHAR(100);

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS contract_type VARCHAR(50);

-- Adicionar índices para performance
CREATE INDEX IF NOT EXISTS idx_clients_contact_type ON public.clients(contact_type);
CREATE INDEX IF NOT EXISTS idx_clients_lead_source ON public.clients(lead_source);
CREATE INDEX IF NOT EXISTS idx_clients_industry ON public.clients(industry);
CREATE INDEX IF NOT EXISTS idx_clients_last_contact ON public.clients(last_contact_date);
CREATE INDEX IF NOT EXISTS idx_clients_next_follow_up ON public.clients(next_follow_up);

-- Comentários para documentação
COMMENT ON COLUMN public.clients.contact_type IS 'Tipo de contato: lead, client, partner';
COMMENT ON COLUMN public.clients.lead_source IS 'Fonte do lead: campaign, referral, organic, etc.';
COMMENT ON COLUMN public.clients.job_title IS 'Cargo do contato';
COMMENT ON COLUMN public.clients.company IS 'Empresa do contato';
COMMENT ON COLUMN public.clients.industry IS 'Indústria/Setor';
COMMENT ON COLUMN public.clients.estimated_ticket IS 'Ticket médio estimado em reais';
COMMENT ON COLUMN public.clients.clv IS 'Customer Lifetime Value em reais';
COMMENT ON COLUMN public.clients.purchase_history IS 'Histórico de compras em JSON';
COMMENT ON COLUMN public.clients.last_contact_date IS 'Data do último contato';
COMMENT ON COLUMN public.clients.next_follow_up IS 'Próximo follow-up agendado';
COMMENT ON COLUMN public.clients.days_since_last_contact IS 'Dias desde o último contato';
COMMENT ON COLUMN public.clients.payment_method IS 'Forma de pagamento preferida';
COMMENT ON COLUMN public.clients.delivery_deadline IS 'Prazo de entrega';
COMMENT ON COLUMN public.clients.technical_contact IS 'Responsável técnico';
COMMENT ON COLUMN public.clients.contract_type IS 'Tipo de contrato';

-- 2. CRIAR TABELA DE FOLLOW-UPS
-- =====================================================

-- Criar tabela de follow-ups para sistema de acompanhamento
CREATE TABLE IF NOT EXISTS public.follow_ups (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID NOT NULL REFERENCES public.clients(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Informações do follow-up
  title VARCHAR(255) NOT NULL,
  description TEXT,
  scheduled_date TIMESTAMP WITH TIME ZONE NOT NULL,
  completed_date TIMESTAMP WITH TIME ZONE,
  
  -- Status e prioridade
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'overdue', 'rescheduled', 'cancelled')),
  priority VARCHAR(50) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  
  -- Tipo de follow-up
  type VARCHAR(50) DEFAULT 'call' CHECK (type IN ('call', 'email', 'meeting', 'task', 'note', 'follow_up')),
  
  -- Configurações de notificação
  reminder_days INTEGER DEFAULT 1,
  notification_sent BOOLEAN DEFAULT FALSE,
  
  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_follow_ups_client_id ON public.follow_ups(client_id);
CREATE INDEX IF NOT EXISTS idx_follow_ups_user_id ON public.follow_ups(user_id);
CREATE INDEX IF NOT EXISTS idx_follow_ups_scheduled_date ON public.follow_ups(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_follow_ups_status ON public.follow_ups(status);

-- Trigger para atualizar updated_at
CREATE OR REPLACE FUNCTION update_follow_ups_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_follow_ups_updated_at
  BEFORE UPDATE ON public.follow_ups
  FOR EACH ROW
  EXECUTE FUNCTION update_follow_ups_updated_at();

-- Função para calcular follow-ups atrasados
CREATE OR REPLACE FUNCTION get_overdue_follow_ups(user_uuid UUID)
RETURNS TABLE (
  id UUID,
  client_name VARCHAR,
  title VARCHAR,
  scheduled_date TIMESTAMP WITH TIME ZONE,
  days_overdue INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    fu.id,
    c.name as client_name,
    fu.title,
    fu.scheduled_date,
    EXTRACT(DAY FROM NOW() - fu.scheduled_date)::INTEGER as days_overdue
  FROM public.follow_ups fu
  JOIN public.clients c ON fu.client_id = c.id
  WHERE fu.user_id = user_uuid
    AND fu.status = 'pending'
    AND fu.scheduled_date < NOW()
  ORDER BY fu.scheduled_date ASC;
END;
$$ LANGUAGE plpgsql;

-- Função para obter follow-ups do dia
CREATE OR REPLACE FUNCTION get_today_follow_ups(user_uuid UUID)
RETURNS TABLE (
  id UUID,
  client_name VARCHAR,
  title VARCHAR,
  scheduled_date TIMESTAMP WITH TIME ZONE,
  priority VARCHAR,
  type VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    fu.id,
    c.name as client_name,
    fu.title,
    fu.scheduled_date,
    fu.priority,
    fu.type
  FROM public.follow_ups fu
  JOIN public.clients c ON fu.client_id = c.id
  WHERE fu.user_id = user_uuid
    AND fu.status = 'pending'
    AND DATE(fu.scheduled_date) = CURRENT_DATE
  ORDER BY fu.scheduled_date ASC;
END;
$$ LANGUAGE plpgsql;

-- Comentários para documentação
COMMENT ON TABLE public.follow_ups IS 'Sistema de follow-ups para acompanhamento de clientes';
COMMENT ON COLUMN public.follow_ups.title IS 'Título do follow-up';
COMMENT ON COLUMN public.follow_ups.description IS 'Descrição detalhada do follow-up';
COMMENT ON COLUMN public.follow_ups.scheduled_date IS 'Data e hora agendada';
COMMENT ON COLUMN public.follow_ups.completed_date IS 'Data e hora de conclusão';
COMMENT ON COLUMN public.follow_ups.status IS 'Status: pending, completed, overdue, rescheduled, cancelled';
COMMENT ON COLUMN public.follow_ups.priority IS 'Prioridade: low, medium, high, urgent';
COMMENT ON COLUMN public.follow_ups.type IS 'Tipo: call, email, meeting, task, note, follow_up';
COMMENT ON COLUMN public.follow_ups.reminder_days IS 'Dias antes para enviar lembrete';
COMMENT ON COLUMN public.follow_ups.notification_sent IS 'Se a notificação já foi enviada';

-- 3. CONFIGURAR RLS (ROW LEVEL SECURITY)
-- =====================================================

-- Habilitar RLS na tabela follow_ups
ALTER TABLE public.follow_ups ENABLE ROW LEVEL SECURITY;

-- Política: usuários só veem seus próprios follow-ups
CREATE POLICY "Users can view their own follow-ups" ON public.follow_ups
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own follow-ups" ON public.follow_ups
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own follow-ups" ON public.follow_ups
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own follow-ups" ON public.follow_ups
  FOR DELETE USING (auth.uid() = user_id);

-- 4. VERIFICAR SE TUDO FOI CRIADO CORRETAMENTE
-- =====================================================

-- Verificar se a tabela follow_ups foi criada
SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'follow_ups' 
ORDER BY ordinal_position;

-- Verificar se os campos foram adicionados à tabela clients
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'clients' 
  AND column_name IN ('contact_type', 'lead_source', 'job_title', 'company', 'industry', 'estimated_ticket', 'clv', 'purchase_history', 'last_contact_date', 'next_follow_up', 'days_since_last_contact', 'payment_method', 'delivery_deadline', 'technical_contact', 'contract_type')
ORDER BY column_name;

-- Verificar se as funções foram criadas
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_name IN ('get_overdue_follow_ups', 'get_today_follow_ups', 'update_follow_ups_updated_at');

-- Verificar se as políticas RLS foram criadas
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'follow_ups';

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================
