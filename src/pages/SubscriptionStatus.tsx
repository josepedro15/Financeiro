import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { 
  Crown, 
  Calendar, 
  Users, 
  FileText, 
  CreditCard,
  ArrowLeft,
  ArrowUpRight,
  Clock,
  CheckCircle,
  AlertTriangle
} from 'lucide-react';

export default function SubscriptionStatus() {
  const { user } = useAuth();
  const { 
    subscription, 
    usage, 
    isTrialActive, 
    getTrialDaysLeft, 
    isMasterUser,
    getPlanName,
    currentPlan,
    loading 
  } = useSubscription();
  const navigate = useNavigate();

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
          <p className="text-muted-foreground">Carregando status da assinatura...</p>
        </div>
      </div>
    );
  }

  const getStatusColor = () => {
    if (isMasterUser) return 'bg-gradient-to-r from-purple-500 to-indigo-500';
    if (isTrialActive()) return 'bg-gradient-to-r from-blue-500 to-cyan-500';
    if (subscription?.status === 'active') return 'bg-gradient-to-r from-green-500 to-emerald-500';
    return 'bg-gradient-to-r from-gray-500 to-slate-500';
  };

  const getStatusIcon = () => {
    if (isMasterUser) return <Crown className="w-5 h-5" />;
    if (isTrialActive()) return <Clock className="w-5 h-5" />;
    if (subscription?.status === 'active') return <CheckCircle className="w-5 h-5" />;
    return <AlertTriangle className="w-5 h-5" />;
  };

  const getStatusText = () => {
    if (isMasterUser) return 'Conta Master';
    if (isTrialActive()) return `Trial Gratuito - ${getTrialDaysLeft()} dias restantes`;
    if (subscription?.status === 'active') return `Plano ${getPlanName(currentPlan)} Ativo`;
    return 'Sem assinatura ativa';
  };

  const getUsagePercentage = (used: number, limit: number) => {
    if (limit === 0) return 0;
    return Math.min((used / limit) * 100, 100);
  };

  const getUsageColor = (percentage: number) => {
    if (percentage >= 90) return 'bg-red-500';
    if (percentage >= 70) return 'bg-orange-500';
    return 'bg-green-500';
  };

  // Função para obter limites corretos baseados no status
  const getLimits = () => {
    if (isMasterUser) {
      return {
        transactions: 999999,
        users: 999999,
        clients: 999999
      };
    }
    
    if (isTrialActive()) {
      // Limites do trial (mesmos do Starter)
      return {
        transactions: 100,
        users: 1,
        clients: 10
      };
    }
    
    // Limites baseados no plano atual
    switch (subscription?.plan_type) {
      case 'starter':
        return {
          transactions: 100,
          users: 1,
          clients: 10
        };
      case 'business':
        return {
          transactions: 1000,
          users: 3,
          clients: 50
        };
      default:
        return {
          transactions: 100,
          users: 1,
          clients: 10
        };
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center space-x-4">
            <Button variant="ghost" onClick={() => navigate('/dashboard')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Voltar ao Dashboard
            </Button>
            <div>
              <h1 className="text-2xl font-bold">Status da Assinatura</h1>
              <p className="text-muted-foreground">Gerencie sua conta e planos</p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid gap-6 md:grid-cols-2">
          
          {/* Subscription Status */}
          <Card>
            <CardHeader>
              <CardTitle>Status da Assinatura</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              
              {/* Status Banner */}
              <div className={`${getStatusColor()} text-white p-4 rounded-lg flex items-center justify-between`}>
                <div className="flex items-center space-x-3">
                  {getStatusIcon()}
                  <div>
                    <p className="font-semibold">{getStatusText()}</p>
                    <p className="text-sm opacity-90">{user?.email}</p>
                  </div>
                </div>
                {!isMasterUser && (
                  <Button 
                    variant="secondary" 
                    size="sm"
                    onClick={() => navigate('/subscription')}
                  >
                    <ArrowUpRight className="w-4 h-4 mr-1" />
                    Upgrade
                  </Button>
                )}
              </div>

              {/* Plan Details */}
              <div className="grid grid-cols-2 gap-4">
                <div className="text-center p-3 bg-muted rounded-lg">
                  <Crown className="w-5 h-5 mx-auto mb-2 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground">Plano Atual</p>
                  <p className="font-semibold">{getPlanName(currentPlan)}</p>
                </div>
                
                <div className="text-center p-3 bg-muted rounded-lg">
                  <Calendar className="w-5 h-5 mx-auto mb-2 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground">Próxima Cobrança</p>
                  <p className="font-semibold">
                    {isTrialActive() ? `${getTrialDaysLeft()} dias` : 'Não definido'}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Actions */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <FileText className="w-5 h-5 mr-2" />
                Ações
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {!isMasterUser && (
                <>
                  <Button 
                    className="w-full" 
                    onClick={() => navigate('/subscription')}
                  >
                    <ArrowUpRight className="w-4 h-4 mr-2" />
                    {isTrialActive() ? 'Escolher Plano' : 'Alterar Plano'}
                  </Button>
                  
                  {!isTrialActive() && (
                    <Button variant="outline" className="w-full">
                      <CreditCard className="w-4 h-4 mr-2" />
                      Método de Pagamento
                    </Button>
                  )}
                </>
              )}
              
              <Button variant="outline" className="w-full">
                <FileText className="w-4 h-4 mr-2" />
                Histórico de Faturas
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Usage Statistics */}
        {!isMasterUser && (
          <div className="mt-8">
            <Card>
              <CardHeader>
                <CardTitle>Uso do Plano</CardTitle>
                <CardDescription>
                  Acompanhe seu uso mensal e limites do plano
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid gap-6 md:grid-cols-3">
                  
                  {/* Transações */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <FileText className="w-4 h-4 text-blue-500" />
                        <span className="font-medium">Transações</span>
                      </div>
                      <span className="text-sm text-muted-foreground">
                        {usage?.transactions_count || 0} / {getLimits().transactions}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.transactions_count || 0, getLimits().transactions)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {getLimits().transactions - (usage?.transactions_count || 0)} restantes
                    </p>
                  </div>

                  {/* Usuários */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <Users className="w-4 h-4 text-green-500" />
                        <span className="font-medium">Usuários</span>
                      </div>
                      <span className="text-sm text-muted-foreground">
                        {usage?.users_count || 0} / {getLimits().users}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.users_count || 0, getLimits().users)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {getLimits().users - (usage?.users_count || 0)} restantes
                    </p>
                  </div>

                  {/* Clientes */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <Users className="w-4 h-4 text-purple-500" />
                        <span className="font-medium">Clientes</span>
                      </div>
                      <span className="text-sm text-muted-foreground">
                        {usage?.clients_count || 0} / {getLimits().clients}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.clients_count || 0, getLimits().clients)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {getLimits().clients - (usage?.clients_count || 0)} restantes
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </main>
    </div>
  );
}
