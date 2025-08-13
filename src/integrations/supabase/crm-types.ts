// Tipos para o sistema CRM

export interface Client {
  id: string;
  user_id: string;
  name: string;
  email?: string;
  phone?: string;
  document?: string;
  address?: string;
  stage: string;
  notes?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  
  // Novos campos CRM
  source?: string;
  industry?: string;
  company_size?: string;
  budget_range?: string;
  last_contact_date?: string;
  next_follow_up?: string;
  assigned_to?: string;
  tags?: string[];
  social_media?: Record<string, string>;
  lead_score?: number;
  total_value?: number;
}

export interface Stage {
  id: string;
  user_id: string;
  key: string;
  name: string;
  description?: string;
  icon: string;
  color: string;
  order_index: number;
  is_default: boolean;
  created_at: string;
  updated_at: string;
}

export interface Activity {
  id: string;
  client_id: string;
  user_id: string;
  type: 'call' | 'email' | 'meeting' | 'task' | 'note' | 'follow_up';
  title: string;
  description?: string;
  scheduled_at?: string;
  completed_at?: string;
  status: 'pending' | 'completed' | 'cancelled' | 'overdue';
  priority: 'low' | 'medium' | 'high' | 'urgent';
  duration_minutes?: number;
  location?: string;
  attendees?: string[];
  created_at: string;
  updated_at: string;
}

export interface Opportunity {
  id: string;
  client_id: string;
  user_id: string;
  title: string;
  description?: string;
  value: number;
  probability: number; // 0-100
  expected_close_date?: string;
  stage: 'prospecting' | 'qualification' | 'proposal' | 'negotiation' | 'closed_won' | 'closed_lost';
  source?: string;
  type?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ClientHistory {
  id: string;
  client_id: string;
  user_id: string;
  action: 'stage_change' | 'note_added' | 'activity_created' | 'opportunity_created' | 'contact_updated' | 'lead_score_changed';
  old_value?: string;
  new_value?: string;
  metadata?: Record<string, any>;
  created_at: string;
}

export interface CrmNotification {
  id: string;
  user_id: string;
  type: 'activity_reminder' | 'stage_change' | 'follow_up_due' | 'opportunity_update' | 'lead_assigned';
  title: string;
  message: string;
  related_id?: string;
  related_type?: 'client' | 'activity' | 'opportunity';
  is_read: boolean;
  scheduled_at?: string;
  created_at: string;
}

// Tipos para formulários
export interface ClientFormData {
  name: string;
  email: string;
  phone: string;
  document: string;
  address: string;
  stage: string;
  notes: string;
  source?: string;
  industry?: string;
  company_size?: string;
  budget_range?: string;
  next_follow_up?: string;
  assigned_to?: string;
  tags?: string[];
  social_media?: Record<string, string>;
}

export interface ActivityFormData {
  client_id: string;
  type: Activity['type'];
  title: string;
  description?: string;
  scheduled_at?: string;
  priority: Activity['priority'];
  duration_minutes?: number;
  location?: string;
  attendees?: string[];
}

export interface OpportunityFormData {
  client_id: string;
  title: string;
  description?: string;
  value: number;
  probability: number;
  expected_close_date?: string;
  stage: Opportunity['stage'];
  source?: string;
  type?: string;
}

// Tipos para filtros
export interface ClientFilters {
  stage?: string;
  source?: string;
  industry?: string;
  company_size?: string;
  assigned_to?: string;
  lead_score_min?: number;
  lead_score_max?: number;
  has_follow_up?: boolean;
  tags?: string[];
  search?: string;
}

export interface ActivityFilters {
  client_id?: string;
  type?: Activity['type'];
  status?: Activity['status'];
  priority?: Activity['priority'];
  scheduled_from?: string;
  scheduled_to?: string;
  search?: string;
}

export interface OpportunityFilters {
  client_id?: string;
  stage?: Opportunity['stage'];
  source?: string;
  value_min?: number;
  value_max?: number;
  probability_min?: number;
  probability_max?: number;
  expected_close_from?: string;
  expected_close_to?: string;
  search?: string;
}

// Tipos para métricas e analytics
export interface CrmMetrics {
  total_clients: number;
  total_opportunities: number;
  total_value_pipeline: number;
  conversion_rate: number;
  average_lead_score: number;
  activities_this_month: number;
  overdue_activities: number;
  upcoming_follow_ups: number;
}

export interface StageMetrics {
  stage: string;
  count: number;
  value: number;
  conversion_rate: number;
  avg_time_in_stage: number;
}

export interface SalesFunnel {
  stage: string;
  count: number;
  value: number;
  conversion_to_next: number;
}

// Tipos para configurações
export interface CrmSettings {
  default_stages: Stage[];
  activity_types: string[];
  opportunity_stages: string[];
  lead_scoring_rules: LeadScoringRule[];
  notification_preferences: NotificationPreferences;
}

export interface LeadScoringRule {
  id: string;
  name: string;
  condition: string;
  points: number;
  is_active: boolean;
}

export interface NotificationPreferences {
  email_notifications: boolean;
  push_notifications: boolean;
  activity_reminders: boolean;
  stage_change_notifications: boolean;
  follow_up_reminders: boolean;
  opportunity_updates: boolean;
}

// Tipos para relatórios
export interface CrmReport {
  id: string;
  name: string;
  type: 'sales' | 'activity' | 'conversion' | 'performance';
  filters: Record<string, any>;
  created_at: string;
  last_run?: string;
}

// Tipos para automação
export interface AutomationRule {
  id: string;
  name: string;
  trigger: 'stage_change' | 'activity_completed' | 'opportunity_created' | 'follow_up_due';
  conditions: AutomationCondition[];
  actions: AutomationAction[];
  is_active: boolean;
  created_at: string;
}

export interface AutomationCondition {
  field: string;
  operator: 'equals' | 'not_equals' | 'contains' | 'greater_than' | 'less_than';
  value: any;
}

export interface AutomationAction {
  type: 'create_activity' | 'send_notification' | 'update_field' | 'assign_to';
  params: Record<string, any>;
}
