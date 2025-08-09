import React, { useEffect, useState } from 'react';
import { useSubscription } from '@/hooks/useSubscription';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { 
  Lock, 
  TrendingUp, 
  Users, 
  UserPlus, 
  CreditCard,
  AlertTriangle,
  Crown,
  Clock
} from 'lucide-react';

interface SubscriptionGuardProps {
  feature: 'transaction' | 'user' | 'client';
  children: React.ReactNode;
  fallback?: React.ReactNode;
  showUpgrade?: boolean;
}

export const SubscriptionGuard: React.FC<SubscriptionGuardProps> = ({
  feature,
  children,
  fallback,
  showUpgrade = true
}) => {
  const {
    isMasterUser,
    isUnlimited,
    subscription,
    usage,
    checkPlanLimits,
    getPlanName,
    getPlanPrice,
    isTrialActive,
    getTrialDaysLeft,
    currentPlan
  } = useSubscription();

  const [canAccess, setCanAccess] = useState(true);
  const [limits, setLimits] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const checkAccess = async () => {
      setLoading(true);
      
      // Usuário master ou plano ilimitado sempre pode
      if (isMasterUser || isUnlimited) {
        setCanAccess(true);
        setLoading(false);
        return;
      }

      // Verificar limites
      const limitsData = await checkPlanLimits(feature);
      setLimits(limitsData);
      setCanAccess(limitsData?.allowed || false);
      setLoading(false);
    };

    checkAccess();
  }, [feature, isMasterUser, isUnlimited, subscription, usage]);

  const getFeatureIcon = () => {
    switch (feature) {
      case 'transaction': return <CreditCard className="w-5 h-5" />;
      case 'user': return <Users className="w-5 h-5" />;
      case 'client': return <UserPlus className="w-5 h-5" />;
    }
  };

  const getFeatureName = () => {
    switch (feature) {
      case 'transaction': return 'transações';
      case 'user': return 'usuários';
      case 'client': return 'clientes';
    }
  };

  const getLimitText = () => {
    if (!limits) return '';
    
    if (limits.limit_count === null) return 'Ilimitado';
    return `${limits.current_count}/${limits.limit_count}`;
  };

  const getUsagePercentage = () => {
    if (!limits || limits.limit_count === null) return 0;
    return (limits.current_count / limits.limit_count) * 100;
  };

  const isNearLimit = () => {
    const percentage = getUsagePercentage();
    return percentage >= 80;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-4">
        <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary"></div>
      </div>
    );
  }

  // Se tem acesso, mostrar o conteúdo
  if (canAccess) {
    return (
      <div>
        {children}
        
        {/* Aviso se próximo do limite */}
        {isNearLimit() && !isUnlimited && (
          <Alert className="mt-4 border-warning/20 bg-warning/5">
            <AlertTriangle className="h-4 w-4 text-warning" />
            <AlertDescription className="text-warning">
              Você está próximo do limite de {getFeatureName()} do seu plano {getPlanName(currentPlan)}.
              {' '}
              <strong>{getLimitText()}</strong>
              {showUpgrade && (
                <Button variant="link" className="h-auto p-0 ml-2 text-warning">
                  Fazer upgrade
                </Button>
              )}
            </AlertDescription>
          </Alert>
        )}
      </div>
    );
  }

  // Se não tem acesso, mostrar fallback ou tela de upgrade
  if (fallback) {
    return <>{fallback}</>;
  }

  return (
    <Card className="border-destructive/20 bg-destructive/5">
      <CardHeader className="text-center">
        <div className="mx-auto w-16 h-16 bg-destructive/10 rounded-full flex items-center justify-center mb-4">
          <Lock className="w-8 h-8 text-destructive" />
        </div>
        
        <CardTitle className="flex items-center justify-center gap-2">
          {getFeatureIcon()}
          Limite de {getFeatureName()} atingido
        </CardTitle>
        
        <CardDescription>
          Você atingiu o limite de {getFeatureName()} do plano {getPlanName(currentPlan)}
          {limits && (
            <div className="mt-2">
              <Badge variant="outline" className="text-destructive border-destructive/20">
                {getLimitText()}
              </Badge>
            </div>
          )}
        </CardDescription>
      </CardHeader>

      {showUpgrade && (
        <CardContent className="space-y-4">
          {/* Mostrar trial se ativo */}
          {isTrialActive() && (
            <Alert className="border-info/20 bg-info/5">
              <Clock className="h-4 w-4 text-info" />
              <AlertDescription className="text-info">
                <strong>{getTrialDaysLeft()} dias</strong> restantes no seu período de teste
              </AlertDescription>
            </Alert>
          )}

          {/* Opções de upgrade */}
          <div className="space-y-3">
            <h4 className="font-semibold text-center">Fazer upgrade para ter mais recursos:</h4>
            
            {currentPlan === 'starter' && (
              <div className="p-4 border rounded-lg bg-primary/5 border-primary/20">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <Crown className="w-5 h-5 text-primary" />
                    <span className="font-semibold">Business</span>
                  </div>
                  <Badge className="bg-primary text-primary-foreground">
                    Recomendado
                  </Badge>
                </div>
                
                <div className="text-sm text-muted-foreground mb-3">
                  {feature === 'transaction' && 'Transações ilimitadas'}
                  {feature === 'user' && 'Até 3 usuários'}
                  {feature === 'client' && 'Clientes ilimitados'}
                  {' • Sistema organizacional • Relatórios avançados'}
                </div>
                
                <div className="flex items-center justify-between">
                  <span className="text-2xl font-bold">R$ 159,90/mês</span>
                  <Button>
                    <TrendingUp className="w-4 h-4 mr-2" />
                    Fazer Upgrade
                  </Button>
                </div>
              </div>
            )}
          </div>

          {/* Informações adicionais */}
          <div className="text-center text-sm text-muted-foreground">
            <p>• Upgrade imediato • Sem taxas extras • Cancele quando quiser</p>
          </div>
        </CardContent>
      )}
    </Card>
  );
};

export default SubscriptionGuard;
