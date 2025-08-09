import React from 'react';
import { useSubscription } from '@/hooks/useSubscription';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Crown, Lock, AlertTriangle } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

interface SubscriptionGuardProps {
  children: React.ReactNode;
  feature: 'transaction' | 'user' | 'client';
  fallback?: React.ReactNode;
}

export const SubscriptionGuard: React.FC<SubscriptionGuardProps> = ({
  children,
  feature,
  fallback
}) => {
  const { isMasterUser, isTrialActive, canPerformAction, getPlanName, currentPlan } = useSubscription();
  const navigate = useNavigate();
  const [canAccess, setCanAccess] = React.useState<boolean | null>(null);

  React.useEffect(() => {
    const checkAccess = async () => {
      if (isMasterUser) {
        setCanAccess(true);
        return;
      }

      const hasAccess = await canPerformAction(feature);
      setCanAccess(hasAccess);
    };

    checkAccess();
  }, [isMasterUser, canPerformAction, feature]);

  // Se ainda está carregando, mostrar children
  if (canAccess === null) {
    return <>{children}</>;
  }

  // Se tem acesso, mostrar children
  if (canAccess) {
    return <>{children}</>;
  }

  // Se não tem acesso, mostrar fallback ou componente padrão
  if (fallback) {
    return <>{fallback}</>;
  }

  const getFeatureName = () => {
    switch (feature) {
      case 'transaction': return 'transações';
      case 'user': return 'usuários';
      case 'client': return 'clientes';
      default: return 'recursos';
    }
  };

  const getFeatureIcon = () => {
    switch (feature) {
      case 'transaction': return <AlertTriangle className="w-6 h-6" />;
      case 'user': return <Lock className="w-6 h-6" />;
      case 'client': return <Lock className="w-6 h-6" />;
      default: return <Lock className="w-6 h-6" />;
    }
  };

  return (
    <Card className="w-full max-w-md mx-auto">
      <CardHeader className="text-center">
        <div className="mx-auto mb-4 p-3 bg-yellow-100 rounded-full w-fit">
          {getFeatureIcon()}
        </div>
        <CardTitle className="text-lg">Limite Atingido</CardTitle>
        <CardDescription>
          Você atingiu o limite de {getFeatureName()} do seu plano atual.
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="text-center">
          <p className="text-sm text-muted-foreground mb-2">
            Plano atual: <span className="font-medium">{getPlanName(currentPlan)}</span>
          </p>
          {isTrialActive() && (
            <p className="text-sm text-blue-600 bg-blue-50 p-2 rounded">
              ⏰ Você está no período de teste gratuito
            </p>
          )}
        </div>
        
        <div className="space-y-2">
          <Button 
            className="w-full" 
            onClick={() => navigate('/subscription')}
          >
            <Crown className="w-4 h-4 mr-2" />
            {isTrialActive() ? 'Escolher Plano' : 'Fazer Upgrade'}
          </Button>
          
          <Button 
            variant="outline" 
            className="w-full"
            onClick={() => navigate('/dashboard')}
          >
            Voltar ao Dashboard
          </Button>
        </div>
      </CardContent>
    </Card>
  );
};
