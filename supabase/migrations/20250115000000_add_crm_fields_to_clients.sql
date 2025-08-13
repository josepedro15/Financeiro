-- Adicionar campos CRM avançados à tabela clients
-- Informações principais (identidade) - JÁ EXISTEM
-- name, email, phone, document, address

-- Perfil e classificação
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS contact_type VARCHAR(50) DEFAULT 'lead'; -- lead, client, partner

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS lead_source VARCHAR(100); -- campaign, referral, organic, etc.

-- Dados complementares estratégicos
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS job_title VARCHAR(100); -- cargo

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS company VARCHAR(100); -- empresa

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS industry VARCHAR(100); -- indústria

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS estimated_ticket DECIMAL(10,2); -- ticket médio estimado

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS clv DECIMAL(10,2); -- Customer Lifetime Value

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS purchase_history JSONB; -- histórico de compras

-- Histórico de interações
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS last_contact_date TIMESTAMP WITH TIME ZONE; -- data do último contato

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS next_follow_up TIMESTAMP WITH TIME ZONE; -- próximo passo agendado

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS days_since_last_contact INTEGER; -- tempo desde última interação

-- Customizações para negócio
ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50); -- forma de pagamento

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS delivery_deadline VARCHAR(100); -- prazo de entrega

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS technical_contact VARCHAR(100); -- responsável técnico

ALTER TABLE public.clients 
ADD COLUMN IF NOT EXISTS contract_type VARCHAR(50); -- tipo de contrato

-- Campos existentes que precisam ser mantidos
-- stage, notes, is_active, created_at, updated_at, user_id

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
