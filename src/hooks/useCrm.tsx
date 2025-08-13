import { useState, useEffect, useCallback } from 'react';
import { useAuth } from './useAuth';
import { supabase } from '@/integrations/supabase/client';
import { useToast } from './use-toast';
import {
  Client,
  Stage,
  Activity,
  Opportunity,
  ClientHistory,
  CrmNotification,
  ClientFilters,
  ActivityFilters,
  OpportunityFilters,
  CrmMetrics,
  StageMetrics
} from '@/integrations/supabase/crm-types';

export const useCrm = () => {
  const { user } = useAuth();
  const { toast } = useToast();
  
  // Estados
  const [clients, setClients] = useState<Client[]>([]);
  const [stages, setStages] = useState<Record<string, Stage>>({});
  const [activities, setActivities] = useState<Activity[]>([]);
  const [opportunities, setOpportunities] = useState<Opportunity[]>([]);
  const [notifications, setNotifications] = useState<CrmNotification[]>([]);
  const [metrics, setMetrics] = useState<CrmMetrics | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // =====================================================
  // CLIENTES
  // =====================================================

  const loadClients = useCallback(async (filters?: ClientFilters) => {
    if (!user) return;

    try {
      setLoading(true);
      let query = supabase
        .from('clients')
        .select('*')
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Aplicar filtros
      if (filters) {
        if (filters.stage) query = query.eq('stage', filters.stage);
        if (filters.source) query = query.eq('source', filters.source);
        if (filters.industry) query = query.eq('industry', filters.industry);
        if (filters.company_size) query = query.eq('company_size', filters.company_size);
        if (filters.assigned_to) query = query.eq('assigned_to', filters.assigned_to);
        if (filters.lead_score_min) query = query.gte('lead_score', filters.lead_score_min);
        if (filters.lead_score_max) query = query.lte('lead_score', filters.lead_score_max);
        if (filters.has_follow_up) query = query.not('next_follow_up', 'is', null);
        if (filters.search) {
          query = query.or(`name.ilike.%${filters.search}%,email.ilike.%${filters.search}%,phone.ilike.%${filters.search}%`);
        }
      }

      const { data, error } = await query.order('created_at', { ascending: false });

      if (error) throw error;

      setClients(data || []);
    } catch (err: any) {
      console.error('Erro ao carregar clientes:', err);
      setError(err.message);
      toast({
        title: "Erro",
        description: "Erro ao carregar clientes",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  }, [user, toast]);

  const createClient = useCallback(async (clientData: Omit<Client, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    if (!user) return null;

    try {
      const { data, error } = await supabase
        .from('clients')
        .insert([{ ...clientData, user_id: user.id }])
        .select()
        .single();

      if (error) throw error;

      setClients(prev => [data, ...prev]);
      toast({
        title: "Sucesso",
        description: "Cliente criado com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao criar cliente:', err);
      toast({
        title: "Erro",
        description: "Erro ao criar cliente",
        variant: "destructive"
      });
      return null;
    }
  }, [user, toast]);

  const updateClient = useCallback(async (id: string, updates: Partial<Client>) => {
    try {
      const { data, error } = await supabase
        .from('clients')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;

      setClients(prev => prev.map(client => client.id === id ? data : client));
      toast({
        title: "Sucesso",
        description: "Cliente atualizado com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao atualizar cliente:', err);
      toast({
        title: "Erro",
        description: "Erro ao atualizar cliente",
        variant: "destructive"
      });
      return null;
    }
  }, [toast]);

  const deleteClient = useCallback(async (id: string) => {
    try {
      const { error } = await supabase
        .from('clients')
        .update({ is_active: false })
        .eq('id', id);

      if (error) throw error;

      setClients(prev => prev.filter(client => client.id !== id));
      toast({
        title: "Sucesso",
        description: "Cliente removido com sucesso"
      });
    } catch (err: any) {
      console.error('Erro ao remover cliente:', err);
      toast({
        title: "Erro",
        description: "Erro ao remover cliente",
        variant: "destructive"
      });
    }
  }, [toast]);

  // =====================================================
  // ESTÁGIOS
  // =====================================================

  const loadStages = useCallback(async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .from('stages')
        .select('*')
        .eq('user_id', user.id)
        .order('order_index');

      if (error) throw error;

      const stagesObject = (data || []).reduce((acc, stage) => {
        acc[stage.key] = stage;
        return acc;
      }, {} as Record<string, Stage>);

      setStages(stagesObject);
    } catch (err: any) {
      console.error('Erro ao carregar estágios:', err);
      setError(err.message);
    }
  }, [user]);

  const createStage = useCallback(async (stageData: Omit<Stage, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    if (!user) return null;

    try {
      const { data, error } = await supabase
        .from('stages')
        .insert([{ ...stageData, user_id: user.id }])
        .select()
        .single();

      if (error) throw error;

      setStages(prev => ({ ...prev, [data.key]: data }));
      toast({
        title: "Sucesso",
        description: "Estágio criado com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao criar estágio:', err);
      toast({
        title: "Erro",
        description: "Erro ao criar estágio",
        variant: "destructive"
      });
      return null;
    }
  }, [user, toast]);

  // =====================================================
  // ATIVIDADES
  // =====================================================

  const loadActivities = useCallback(async (filters?: ActivityFilters) => {
    if (!user) return;

    try {
      let query = supabase
        .from('activities')
        .select('*')
        .eq('user_id', user.id);

      if (filters) {
        if (filters.client_id) query = query.eq('client_id', filters.client_id);
        if (filters.type) query = query.eq('type', filters.type);
        if (filters.status) query = query.eq('status', filters.status);
        if (filters.priority) query = query.eq('priority', filters.priority);
        if (filters.scheduled_from) query = query.gte('scheduled_at', filters.scheduled_from);
        if (filters.scheduled_to) query = query.lte('scheduled_at', filters.scheduled_to);
        if (filters.search) {
          query = query.or(`title.ilike.%${filters.search}%,description.ilike.%${filters.search}%`);
        }
      }

      const { data, error } = await query.order('scheduled_at', { ascending: true });

      if (error) throw error;

      setActivities(data || []);
    } catch (err: any) {
      console.error('Erro ao carregar atividades:', err);
      setError(err.message);
    }
  }, [user]);

  const createActivity = useCallback(async (activityData: Omit<Activity, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    if (!user) return null;

    try {
      const { data, error } = await supabase
        .from('activities')
        .insert([{ ...activityData, user_id: user.id }])
        .select()
        .single();

      if (error) throw error;

      setActivities(prev => [...prev, data]);
      toast({
        title: "Sucesso",
        description: "Atividade criada com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao criar atividade:', err);
      toast({
        title: "Erro",
        description: "Erro ao criar atividade",
        variant: "destructive"
      });
      return null;
    }
  }, [user, toast]);

  const updateActivity = useCallback(async (id: string, updates: Partial<Activity>) => {
    try {
      const { data, error } = await supabase
        .from('activities')
        .update(updates)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;

      setActivities(prev => prev.map(activity => activity.id === id ? data : activity));
      toast({
        title: "Sucesso",
        description: "Atividade atualizada com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao atualizar atividade:', err);
      toast({
        title: "Erro",
        description: "Erro ao atualizar atividade",
        variant: "destructive"
      });
      return null;
    }
  }, [toast]);

  // =====================================================
  // OPORTUNIDADES
  // =====================================================

  const loadOpportunities = useCallback(async (filters?: OpportunityFilters) => {
    if (!user) return;

    try {
      let query = supabase
        .from('opportunities')
        .select('*')
        .eq('user_id', user.id)
        .eq('is_active', true);

      if (filters) {
        if (filters.client_id) query = query.eq('client_id', filters.client_id);
        if (filters.stage) query = query.eq('stage', filters.stage);
        if (filters.source) query = query.eq('source', filters.source);
        if (filters.value_min) query = query.gte('value', filters.value_min);
        if (filters.value_max) query = query.lte('value', filters.value_max);
        if (filters.probability_min) query = query.gte('probability', filters.probability_min);
        if (filters.probability_max) query = query.lte('probability', filters.probability_max);
        if (filters.expected_close_from) query = query.gte('expected_close_date', filters.expected_close_from);
        if (filters.expected_close_to) query = query.lte('expected_close_date', filters.expected_close_to);
        if (filters.search) {
          query = query.or(`title.ilike.%${filters.search}%,description.ilike.%${filters.search}%`);
        }
      }

      const { data, error } = await query.order('created_at', { ascending: false });

      if (error) throw error;

      setOpportunities(data || []);
    } catch (err: any) {
      console.error('Erro ao carregar oportunidades:', err);
      setError(err.message);
    }
  }, [user]);

  const createOpportunity = useCallback(async (opportunityData: Omit<Opportunity, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    if (!user) return null;

    try {
      const { data, error } = await supabase
        .from('opportunities')
        .insert([{ ...opportunityData, user_id: user.id }])
        .select()
        .single();

      if (error) throw error;

      setOpportunities(prev => [data, ...prev]);
      toast({
        title: "Sucesso",
        description: "Oportunidade criada com sucesso"
      });

      return data;
    } catch (err: any) {
      console.error('Erro ao criar oportunidade:', err);
      toast({
        title: "Erro",
        description: "Erro ao criar oportunidade",
        variant: "destructive"
      });
      return null;
    }
  }, [user, toast]);

  // =====================================================
  // NOTIFICAÇÕES
  // =====================================================

  const loadNotifications = useCallback(async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .from('crm_notifications')
        .select('*')
        .eq('user_id', user.id)
        .eq('is_read', false)
        .order('created_at', { ascending: false });

      if (error) throw error;

      setNotifications(data || []);
    } catch (err: any) {
      console.error('Erro ao carregar notificações:', err);
      setError(err.message);
    }
  }, [user]);

  const markNotificationAsRead = useCallback(async (id: string) => {
    try {
      const { error } = await supabase
        .from('crm_notifications')
        .update({ is_read: true })
        .eq('id', id);

      if (error) throw error;

      setNotifications(prev => prev.filter(notification => notification.id !== id));
    } catch (err: any) {
      console.error('Erro ao marcar notificação como lida:', err);
    }
  }, []);

  // =====================================================
  // MÉTRICAS
  // =====================================================

  const loadMetrics = useCallback(async () => {
    if (!user) return;

    try {
      // Carregar métricas básicas
      const [
        { count: totalClients },
        { count: totalOpportunities },
        { data: opportunitiesData },
        { count: activitiesThisMonth },
        { count: overdueActivities },
        { count: upcomingFollowUps }
      ] = await Promise.all([
        supabase.from('clients').select('*', { count: 'exact', head: true }).eq('user_id', user.id).eq('is_active', true),
        supabase.from('opportunities').select('*', { count: 'exact', head: true }).eq('user_id', user.id).eq('is_active', true),
        supabase.from('opportunities').select('value').eq('user_id', user.id).eq('is_active', true),
        supabase.from('activities').select('*', { count: 'exact', head: true }).eq('user_id', user.id).gte('created_at', new Date().toISOString().slice(0, 7) + '-01'),
        supabase.from('activities').select('*', { count: 'exact', head: true }).eq('user_id', user.id).eq('status', 'overdue'),
        supabase.from('clients').select('*', { count: 'exact', head: true }).eq('user_id', user.id).not('next_follow_up', 'is', null).lte('next_follow_up', new Date().toISOString().slice(0, 10))
      ]);

      const totalValuePipeline = opportunitiesData?.reduce((sum, opp) => sum + (opp.value || 0), 0) || 0;
      const averageLeadScore = clients.length > 0 ? clients.reduce((sum, client) => sum + (client.lead_score || 0), 0) / clients.length : 0;

      setMetrics({
        total_clients: totalClients || 0,
        total_opportunities: totalOpportunities || 0,
        total_value_pipeline: totalValuePipeline,
        conversion_rate: totalClients > 0 ? (totalOpportunities || 0) / totalClients * 100 : 0,
        average_lead_score: averageLeadScore,
        activities_this_month: activitiesThisMonth || 0,
        overdue_activities: overdueActivities || 0,
        upcoming_follow_ups: upcomingFollowUps || 0
      });
    } catch (err: any) {
      console.error('Erro ao carregar métricas:', err);
      setError(err.message);
    }
  }, [user, clients]);

  // =====================================================
  // CARREGAMENTO INICIAL
  // =====================================================

  useEffect(() => {
    if (user) {
      loadClients();
      loadStages();
      loadActivities();
      loadOpportunities();
      loadNotifications();
      loadMetrics();
    }
  }, [user, loadClients, loadStages, loadActivities, loadOpportunities, loadNotifications, loadMetrics]);

  // =====================================================
  // UTILITÁRIOS
  // =====================================================

  const getClientsByStage = useCallback((stageKey: string) => {
    return clients.filter(client => client.stage === stageKey);
  }, [clients]);

  const getActivitiesByClient = useCallback((clientId: string) => {
    return activities.filter(activity => activity.client_id === clientId);
  }, [activities]);

  const getOpportunitiesByClient = useCallback((clientId: string) => {
    return opportunities.filter(opportunity => opportunity.client_id === clientId);
  }, [opportunities]);

  const getClientById = useCallback((id: string) => {
    return clients.find(client => client.id === id);
  }, [clients]);

  return {
    // Estados
    clients,
    stages,
    activities,
    opportunities,
    notifications,
    metrics,
    loading,
    error,

    // Clientes
    loadClients,
    createClient,
    updateClient,
    deleteClient,
    getClientsByStage,
    getClientById,

    // Estágios
    loadStages,
    createStage,

    // Atividades
    loadActivities,
    createActivity,
    updateActivity,
    getActivitiesByClient,

    // Oportunidades
    loadOpportunities,
    createOpportunity,
    getOpportunitiesByClient,

    // Notificações
    loadNotifications,
    markNotificationAsRead,

    // Métricas
    loadMetrics,

    // Utilitários
    refresh: () => {
      if (user) {
        loadClients();
        loadStages();
        loadActivities();
        loadOpportunities();
        loadNotifications();
        loadMetrics();
      }
    }
  };
};
