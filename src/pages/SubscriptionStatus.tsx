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

  // Debug: Log dos dados para verificar
  console.log('Subscription Status Debug:', {
    subscription,
    usage,
    isTrialActive: isTrialActive(),
    getTrialDaysLeft: getTrialDaysLeft(),
    isMasterUser,
    currentPlan,
    loading
  });

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

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button variant="outline" size="sm" onClick={() => navigate('/dashboard')}>
                <ArrowLeft className="w-4 h-4 mr-1" />
                Voltar ao Dashboard
              </Button>
              <div>
                <h1 className="text-2xl font-bold">Status da Assinatura</h1>
                <p className="text-muted-foreground">Gerencie sua conta e planos</p>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid gap-6 lg:grid-cols-3">
          
          {/* Status Card */}
          <div className="lg:col-span-2">
            <Card className="overflow-hidden">
              <div className={`${getStatusColor()} text-white p-6`}>
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    {getStatusIcon()}
                    <div>
                      <h2 className="text-xl font-bold">{getStatusText()}</h2>
                      <p className="text-white/80">
                        {user?.email}
                      </p>
                    </div>
                  </div>
                  {!isMasterUser && (
                    <Button 
                      variant="secondary" 
                      onClick={() => navigate('/plans')}
                      className="bg-white/20 hover:bg-white/30 text-white border-white/30"
                    >
                      <ArrowUpRight className="w-4 h-4 mr-1" />
                      {isTrialActive() ? 'Escolher Plano' : 'Upgrade'}
                    </Button>
                  )}
                </div>
              </div>

              <CardContent className="p-6">
                <div className="grid gap-4 md:grid-cols-2">
                  
                  {/* Plano Atual */}
                  <div className="space-y-2">
                    <div className="flex items-center space-x-2">
                      <Crown className="w-4 h-4 text-primary" />
                      <span className="font-medium">Plano Atual</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <Badge variant={isTrialActive() ? "default" : "secondary"}>
                        {isMasterUser ? 'Master' : getPlanName(currentPlan)}
                      </Badge>
                      {isTrialActive() && (
                        <Badge variant="outline">
                          Trial
                        </Badge>
                      )}
                    </div>
                  </div>

                  {/* Data de Expiração */}
                  <div className="space-y-2">
                    <div className="flex items-center space-x-2">
                      <Calendar className="w-4 h-4 text-primary" />
                      <span className="font-medium">
                        {isTrialActive() ? 'Trial Expira' : 'Próxima Cobrança'}
                      </span>
                    </div>
                    <p className="text-sm text-muted-foreground">
                      {subscription?.trial_ends_at 
                        ? new Date(subscription.trial_ends_at).toLocaleDateString('pt-BR')
                        : subscription?.expires_at
                        ? new Date(subscription.expires_at).toLocaleDateString('pt-BR')
                        : 'Não definido'
                      }
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Actions Card */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center space-x-2">
                <CreditCard className="w-5 h-5" />
                <span>Ações</span>
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {!isMasterUser && (
                <>
                  <Button 
                    className="w-full" 
                    onClick={() => navigate('/plans')}
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
                        {usage?.transactions || 0} / {subscription?.monthly_transaction_limit || 0}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.transactions || 0, subscription?.monthly_transaction_limit || 0)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {subscription?.monthly_transaction_limit - (usage?.transactions || 0)} restantes
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
                        {usage?.users || 0} / {subscription?.user_limit || 0}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.users || 0, subscription?.user_limit || 0)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {subscription?.user_limit - (usage?.users || 0)} restantes
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
                        {usage?.clients || 0} / {subscription?.client_limit || 0}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(usage?.clients || 0, subscription?.client_limit || 0)}
                      className="h-2"
                    />
                    <p className="text-xs text-muted-foreground">
                      {subscription?.client_limit - (usage?.clients || 0)} restantes
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
