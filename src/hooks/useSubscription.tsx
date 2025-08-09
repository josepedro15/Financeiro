import { useState, useEffect } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from './useAuth';

export interface Subscription {
  id: string;
  user_id: string;
  plan_type: 'starter' | 'business' | 'unlimited';
  status: 'trial' | 'active' | 'inactive' | 'cancelled' | 'expired';
  started_at: string;
  expires_at?: string;
  trial_ends_at?: string;
  monthly_transaction_limit?: number;
  user_limit?: number;
  client_limit?: number;
  created_at: string;
  updated_at: string;
}

export interface UsageTracking {
  id: string;
  user_id: string;
  month_year: string;
  transactions_count: number;
  users_count: number;
  clients_count: number;
  created_at: string;
  updated_at: string;
}

export interface PlanLimits {
  allowed: boolean;
  current_count: number;
  limit_count: number;
  plan_type: string;
}

const MASTER_USER_ID = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

export const useSubscription = () => {
  const { user } = useAuth();
  const [subscription, setSubscription] = useState<Subscription | null>(null);
  const [usage, setUsage] = useState<UsageTracking | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Verifica se é o usuário master
  const isMasterUser = user?.id === MASTER_USER_ID;

  const loadSubscription = async () => {
    if (!user) return;

    try {
      setLoading(true);
      setError(null);

      // Buscar assinatura
      const { data: subscriptionData, error: subError } = await supabase
        .from('subscriptions')
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (subError && subError.code !== 'PGRST116') {
        throw subError;
      }

      setSubscription(subscriptionData);

      // Buscar uso atual
      const currentMonth = new Date().toISOString().slice(0, 7); // YYYY-MM
      const { data: usageData, error: usageError } = await supabase
        .from('usage_tracking')
        .select('*')
        .eq('user_id', user.id)
        .eq('month_year', currentMonth)
        .single();

      if (usageError && usageError.code !== 'PGRST116') {
        throw usageError;
      }

      setUsage(usageData);
    } catch (err) {
      console.error('Erro ao carregar assinatura:', err);
      setError(err instanceof Error ? err.message : 'Erro desconhecido');
    } finally {
      setLoading(false);
    }
  };

  const checkPlanLimits = async (
    checkType: 'transaction' | 'user' | 'client' = 'transaction'
  ): Promise<PlanLimits | null> => {
    if (!user) return null;

    try {
      const { data, error } = await supabase.rpc('check_plan_limits', {
        target_user_id: user.id,
        check_type: checkType
      });

      if (error) throw error;
      return data?.[0] || null;
    } catch (err) {
      console.error('Erro ao verificar limites:', err);
      return null;
    }
  };

  const incrementUsage = async (
    usageType: 'transaction' | 'user' | 'client',
    incrementBy: number = 1
  ): Promise<boolean> => {
    if (!user || isMasterUser) return true;

    try {
      const { error } = await supabase.rpc('increment_usage', {
        target_user_id: user.id,
        usage_type: usageType,
        increment_by: incrementBy
      });

      if (error) throw error;
      
      // Recarregar dados de uso
      await loadSubscription();
      return true;
    } catch (err) {
      console.error('Erro ao incrementar uso:', err);
      return false;
    }
  };

  const canPerformAction = async (actionType: 'transaction' | 'user' | 'client'): Promise<boolean> => {
    if (isMasterUser) return true;
    
    const limits = await checkPlanLimits(actionType);
    return limits?.allowed || false;
  };

  const getPlanName = (planType: string) => {
    switch (planType) {
      case 'starter': return 'Starter';
      case 'business': return 'Business';
      case 'unlimited': return 'Ilimitado';
      default: return 'Desconhecido';
    }
  };

  const getPlanPrice = (planType: string) => {
    switch (planType) {
      case 'starter': return 'R$ 79,90';
      case 'business': return 'R$ 159,90';
      case 'unlimited': return 'Gratuito';
      default: return '-';
    }
  };

  const isTrialActive = () => {
    if (!subscription || !subscription.trial_ends_at) return false;
    if (subscription.status !== 'trial') return false;
    return new Date(subscription.trial_ends_at) > new Date();
  };

  const getTrialDaysLeft = () => {
    if (!subscription || !subscription.trial_ends_at) return 0;
    const trialEnd = new Date(subscription.trial_ends_at);
    const now = new Date();
    const diffTime = trialEnd.getTime() - now.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return Math.max(0, diffDays);
  };

  const upgradePlan = async (newPlan: 'starter' | 'business') => {
    if (!user || isMasterUser) return false;

    try {
      const limits = {
        starter: { monthly_transaction_limit: 100, user_limit: 1, client_limit: 10 },
        business: { monthly_transaction_limit: 1000, user_limit: 3, client_limit: 50 }
      };

      const { error } = await supabase
        .from('subscriptions')
        .update({
          plan_type: newPlan,
          status: 'active',
          ...limits[newPlan],
          updated_at: new Date().toISOString()
        })
        .eq('user_id', user.id);

      if (error) throw error;

      await loadSubscription();
      return true;
    } catch (err) {
      console.error('Erro ao fazer upgrade:', err);
      return false;
    }
  };

  useEffect(() => {
    loadSubscription();
  }, [user]);

  return {
    subscription,
    usage,
    loading,
    error,
    isMasterUser,
    loadSubscription,
    checkPlanLimits,
    incrementUsage,
    canPerformAction,
    getPlanName,
    getPlanPrice,
    isTrialActive,
    getTrialDaysLeft,
    upgradePlan,
    // Informações úteis
    currentPlan: subscription?.plan_type || 'starter',
    isUnlimited: subscription?.plan_type === 'unlimited' || isMasterUser,
    hasActiveSubscription: subscription?.status === 'active',
    // Limites atuais
    transactionLimit: subscription?.monthly_transaction_limit,
    userLimit: subscription?.user_limit,
    clientLimit: subscription?.client_limit,
    // Uso atual
    currentTransactions: usage?.transactions_count || 0,
    currentUsers: usage?.users_count || 1,
    currentClients: usage?.clients_count || 0
  };
};
