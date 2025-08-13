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
  reminder_days INTEGER DEFAULT 1, -- Dias antes para lembrar
  notification_sent BOOLEAN DEFAULT FALSE,
  
  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Índices para performance
  CONSTRAINT idx_follow_ups_client_id ON public.follow_ups(client_id),
  CONSTRAINT idx_follow_ups_user_id ON public.follow_ups(user_id),
  CONSTRAINT idx_follow_ups_scheduled_date ON public.follow_ups(scheduled_date),
  CONSTRAINT idx_follow_ups_status ON public.follow_ups(status)
);

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

-- RLS (Row Level Security)
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
