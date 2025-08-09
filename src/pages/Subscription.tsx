import { useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { 
  Crown, 
  TrendingUp, 
  Calendar, 
  Users, 
  CreditCard, 
  Clock,
  CheckCircle,
  AlertTriangle,
  Star,
  ArrowLeft,
  Shield,
  Zap
} from 'lucide-react';

export default function Subscription() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const {
    subscription,
    usage,
    loading,
    isMasterUser,
    getPlanName,
    getPlanPrice,
    isTrialActive,
    getTrialDaysLeft,
    upgradePlan,
    currentPlan,
    isUnlimited,
    hasActiveSubscription,
    transactionLimit,
    userLimit,
    clientLimit,
    currentTransactions,
    currentUsers,
    currentClients
  } = useSubscription();

  useEffect(() => {
    if (!user) {
      navigate('/auth');
    }
  }, [user, navigate]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  const getUsagePercentage = (current: number, limit: number | null) => {
    if (limit === null) return 0;
    return Math.min((current / limit) * 100, 100);
  };

  const isNearLimit = (current: number, limit: number | null) => {
    if (limit === null) return false;
    return (current / limit) >= 0.8;
  };

  const handleUpgrade = async (planType: 'starter' | 'business') => {
    const success = await upgradePlan(planType);
    if (success) {
      // Mostrar sucesso
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-muted/30 to-background">
      {/* Header */}
      <header className="bg-background/80 backdrop-blur-md border-b sticky top-0 z-40">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Button variant="ghost" size="sm" onClick={() => navigate('/dashboard')}>
                <ArrowLeft className="w-4 h-4 mr-2" />
                Voltar
              </Button>
              <div>
                <h1 className="text-2xl font-bold">Minha Assinatura</h1>
                <p className="text-muted-foreground">Gerencie seu plano e uso</p>
              </div>
            </div>
            
            {isMasterUser && (
              <Badge variant="outline" className="border-primary text-primary">
                <Crown className="w-4 h-4 mr-1" />
                Usuário Master
              </Badge>
            )}
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-8">
          {/* Coluna Principal */}
          <div className="lg:col-span-2 space-y-6">
            {/* Plano Atual */}
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="flex items-center gap-2">
                      {currentPlan === 'unlimited' && <Crown className="w-5 h-5 text-primary" />}
                      {currentPlan === 'business' && <Star className="w-5 h-5 text-primary" />}
                      {currentPlan === 'starter' && <Zap className="w-5 h-5 text-primary" />}
                      Plano {getPlanName(currentPlan)}
                    </CardTitle>
                    <CardDescription>
                      {getPlanPrice(currentPlan)}/mês
                    </CardDescription>
                  </div>
                  
                  <Badge 
                    variant={hasActiveSubscription ? "default" : "destructive"}
                    className="text-sm"
                  >
                    {hasActiveSubscription ? 'Ativo' : 'Inativo'}
                  </Badge>
                </div>
              </CardHeader>
              
              <CardContent className="space-y-4">
                {/* Trial Info */}
                {isTrialActive() && (
                  <Alert className="border-info/20 bg-info/5">
                    <Clock className="h-4 w-4 text-info" />
                    <AlertDescription className="text-info">
                      <strong>{getTrialDaysLeft()} dias</strong> restantes no seu período de teste gratuito
                    </AlertDescription>
                  </Alert>
                )}

                {/* Funcionalidades do Plano */}
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <h4 className="font-semibold flex items-center gap-2">
                      <CheckCircle className="w-4 h-4 text-success" />
                      Incluído no seu plano:
                    </h4>
                    <ul className="text-sm text-muted-foreground space-y-1">
                      <li>• Dashboard financeiro completo</li>
                      <li>• {transactionLimit ? `${transactionLimit} transações/mês` : 'Transações ilimitadas'}</li>
                      <li>• {userLimit ? `Até ${userLimit} usuários` : 'Usuários ilimitados'}</li>
                      <li>• {clientLimit ? `Até ${clientLimit} clientes` : 'Clientes ilimitados'}</li>
                      {currentPlan !== 'starter' && (
                        <>
                          <li>• Sistema organizacional</li>
                          <li>• Relatórios avançados</li>
                          <li>• Múltiplas contas</li>
                        </>
                      )}
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Uso Atual */}
            {!isUnlimited && (
              <Card>
                <CardHeader>
                  <CardTitle>Uso do Mês Atual</CardTitle>
                  <CardDescription>
                    Acompanhe seu uso e limites
                  </CardDescription>
                </CardHeader>
                
                <CardContent className="space-y-6">
                  {/* Transações */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium flex items-center gap-2">
                        <CreditCard className="w-4 h-4" />
                        Transações
                      </span>
                      <span className="text-sm text-muted-foreground">
                        {currentTransactions}/{transactionLimit || '∞'}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(currentTransactions, transactionLimit)} 
                      className="h-2"
                    />
                    {isNearLimit(currentTransactions, transactionLimit) && (
                      <p className="text-xs text-warning">Próximo do limite</p>
                    )}
                  </div>

                  {/* Usuários */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium flex items-center gap-2">
                        <Users className="w-4 h-4" />
                        Usuários
                      </span>
                      <span className="text-sm text-muted-foreground">
                        {currentUsers}/{userLimit || '∞'}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(currentUsers, userLimit)} 
                      className="h-2"
                    />
                  </div>

                  {/* Clientes */}
                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium flex items-center gap-2">
                        <Crown className="w-4 h-4" />
                        Clientes
                      </span>
                      <span className="text-sm text-muted-foreground">
                        {currentClients}/{clientLimit || '∞'}
                      </span>
                    </div>
                    <Progress 
                      value={getUsagePercentage(currentClients, clientLimit)} 
                      className="h-2"
                    />
                  </div>
                </CardContent>
              </Card>
            )}
          </div>

          {/* Sidebar - Upgrade Options */}
          <div className="space-y-6">
            {!isUnlimited && currentPlan === 'starter' && (
              <Card className="border-primary/20 bg-primary/5">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <TrendingUp className="w-5 h-5 text-primary" />
                    Upgrade Disponível
                  </CardTitle>
                </CardHeader>
                
                <CardContent className="space-y-4">
                  <div className="p-4 bg-background rounded-lg border">
                    <div className="flex items-center justify-between mb-2">
                      <h4 className="font-semibold">Business</h4>
                      <Badge className="bg-primary text-primary-foreground">
                        Recomendado
                      </Badge>
                    </div>
                    
                    <p className="text-sm text-muted-foreground mb-3">
                      Transações ilimitadas, 3 usuários, CRM completo
                    </p>
                    
                    <div className="flex items-center justify-between">
                      <span className="text-xl font-bold">R$ 159,90/mês</span>
                      <Button 
                        size="sm" 
                        onClick={() => handleUpgrade('business')}
                      >
                        Fazer Upgrade
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )}

            {/* Informações de Pagamento */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="w-5 h-5" />
                  Segurança
                </CardTitle>
              </CardHeader>
              
              <CardContent className="space-y-3 text-sm text-muted-foreground">
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-success" />
                  <span>Dados criptografados</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-success" />
                  <span>Backup automático</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-success" />
                  <span>Suporte 24/7</span>
                </div>
                <div className="flex items-center gap-2">
                  <CheckCircle className="w-4 h-4 text-success" />
                  <span>Cancele quando quiser</span>
                </div>
              </CardContent>
            </Card>

            {/* Próxima Cobrança */}
            {hasActiveSubscription && !isTrialActive() && (
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Calendar className="w-5 h-5" />
                    Próxima Cobrança
                  </CardTitle>
                </CardHeader>
                
                <CardContent>
                  <div className="text-center">
                    <p className="text-sm text-muted-foreground mb-1">
                      Será cobrado em
                    </p>
                    <p className="font-semibold">
                      {subscription?.expires_at 
                        ? new Date(subscription.expires_at).toLocaleDateString('pt-BR')
                        : '30 dias'
                      }
                    </p>
                    <p className="text-sm text-muted-foreground mt-1">
                      {getPlanPrice(currentPlan)}
                    </p>
                  </div>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
