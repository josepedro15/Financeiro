import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Separator } from '@/components/ui/separator';
import { 
  ArrowLeft, 
  Check, 
  X, 
  Crown, 
  Zap, 
  Star, 
  CreditCard, 
  Shield, 
  Users, 
  BarChart3,
  FileText,
  Globe,
  Clock,
  TrendingUp,
  Building
} from 'lucide-react';

const UpgradePlan = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { currentPlan, isTrialActive, getTrialDaysLeft, isMasterUser } = useSubscription();
  const [selectedPlan, setSelectedPlan] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const plans = [
    {
      id: 'starter',
      name: 'Starter',
      price: 'R$ 79,90',
      period: '/mês',
      description: 'Ideal para MEI e pequenos negócios',
      icon: Zap,
      color: 'bg-blue-500',
      features: [
        { text: 'Dashboard financeiro básico', included: true },
        { text: 'Até 1.000 transações/mês', included: true },
        { text: '1 usuário incluído', included: true },
        { text: 'CRM básico (até 50 clientes)', included: true },
        { text: 'Relatórios mensais', included: true },
        { text: 'Suporte por email', included: true }
      ],
      popular: false
    },
    {
      id: 'business',
      name: 'Business',
      price: 'R$ 159,90',
      period: '/mês',
      description: 'Para empresas em crescimento',
      icon: Building,
      color: 'bg-purple-500',
      features: [
        { text: 'Tudo do Starter +', included: true },
        { text: 'Transações ilimitadas', included: true },
        { text: 'Até 3 usuários', included: true },
        { text: 'CRM completo (clientes ilimitados)', included: true },
        { text: 'Sistema organizacional', included: true },
        { text: 'Relatórios avançados', included: true },
        { text: 'Múltiplas contas financeiras', included: true }
      ],
      popular: true
    }
  ];

  const handlePlanSelect = (planId: string) => {
    setSelectedPlan(planId);
  };

  const handleUpgrade = async () => {
    if (!selectedPlan) return;
    
    setIsLoading(true);
    try {
      // Redirecionar para checkout com o plano selecionado
      navigate(`/checkout?plan=${selectedPlan}`);
    } catch (error) {
      console.error('Erro ao processar upgrade:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const getCurrentPlanInfo = () => {
    if (isMasterUser) {
      return { name: 'Master', description: 'Acesso ilimitado' };
    }
    if (isTrialActive) {
      return { name: 'Trial', description: `${getTrialDaysLeft()} dias restantes` };
    }
    return { name: currentPlan?.plan_type || 'Nenhum', description: 'Plano atual' };
  };

  const currentPlanInfo = getCurrentPlanInfo();

  return (
    <div className="min-h-screen bg-gradient-to-br from-background to-muted/30">
      {/* Header */}
      <div className="border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button 
                variant="ghost" 
                size="sm"
                onClick={() => navigate(-1)}
                className="flex items-center space-x-2"
              >
                <ArrowLeft className="w-4 h-4" />
                <span>Voltar</span>
              </Button>
              <div className="h-6 w-px bg-border" />
              <h1 className="text-xl font-semibold">Upgrade de Plano</h1>
            </div>
            <div className="flex items-center space-x-2">
              <Badge variant="outline" className="text-sm">
                Plano Atual: {currentPlanInfo.name}
              </Badge>
              {isTrialActive && (
                <Badge variant="secondary" className="text-sm">
                  {currentPlanInfo.description}
                </Badge>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {/* Header Section */}
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold mb-4">Escolha o Plano Ideal</h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Atualize seu plano para desbloquear mais recursos e potencializar seu negócio
          </p>
        </div>

        {/* Plans Grid */}
        <div className="grid md:grid-cols-2 gap-8 mb-12 max-w-4xl mx-auto">
          {plans.map((plan) => {
            const IconComponent = plan.icon;
            const isSelected = selectedPlan === plan.id;
            const isCurrentPlan = currentPlan?.plan_type === plan.id;
            
            return (
              <Card 
                key={plan.id}
                className={`relative transition-all duration-300 hover:shadow-lg ${
                  isSelected ? 'ring-2 ring-primary shadow-lg' : ''
                } ${isCurrentPlan ? 'opacity-75' : ''}`}
              >
                {plan.popular && (
                  <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                    <Badge className="bg-primary text-primary-foreground">
                      <Star className="w-3 h-3 mr-1" />
                      Mais Popular
                    </Badge>
                  </div>
                )}
                
                {isCurrentPlan && (
                  <div className="absolute -top-3 right-4">
                    <Badge variant="secondary">
                      Plano Atual
                    </Badge>
                  </div>
                )}

                <CardHeader className="text-center pb-4">
                  <div className={`w-16 h-16 ${plan.color} rounded-xl flex items-center justify-center mx-auto mb-4`}>
                    <IconComponent className="w-8 h-8 text-white" />
                  </div>
                  <CardTitle className="text-2xl">{plan.name}</CardTitle>
                  <CardDescription className="text-base">{plan.description}</CardDescription>
                  
                  <div className="mt-4">
                    <div className="text-4xl font-bold">{plan.price}</div>
                    <div className="text-muted-foreground">{plan.period}</div>
                  </div>
                </CardHeader>

                <CardContent className="space-y-4">
                  <div className="space-y-3">
                    {plan.features.map((feature, index) => (
                      <div key={index} className="flex items-center space-x-3">
                        {feature.included ? (
                          <Check className="w-4 h-4 text-success flex-shrink-0" />
                        ) : (
                          <X className="w-4 h-4 text-muted-foreground flex-shrink-0" />
                        )}
                        <span className={`text-sm ${feature.included ? '' : 'text-muted-foreground'}`}>
                          {feature.text}
                        </span>
                      </div>
                    ))}
                  </div>

                  <Separator className="my-6" />

                  <Button 
                    className="w-full" 
                    variant={isSelected ? "default" : "outline"}
                    disabled={isCurrentPlan || isLoading}
                    onClick={() => handlePlanSelect(plan.id)}
                  >
                    {isCurrentPlan ? 'Plano Atual' : isSelected ? 'Selecionado' : `Começar com ${plan.name}`}
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Selected Plan Summary */}
        {selectedPlan && (
          <Card className="mb-8">
            <CardHeader>
              <CardTitle className="flex items-center space-x-2">
                <CreditCard className="w-5 h-5" />
                <span>Resumo da Seleção</span>
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="font-semibold text-lg">
                    {plans.find(p => p.id === selectedPlan)?.name}
                  </h3>
                  <p className="text-muted-foreground">
                    {plans.find(p => p.id === selectedPlan)?.price}{plans.find(p => p.id === selectedPlan)?.period}
                  </p>
                </div>
                <Button 
                  onClick={handleUpgrade}
                  disabled={isLoading}
                  className="px-8"
                >
                  {isLoading ? 'Processando...' : 'Continuar para Pagamento'}
                </Button>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Benefits Section */}
        <Card className="mb-8">
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <TrendingUp className="w-5 h-5" />
              <span>Por que fazer upgrade?</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-3 gap-6">
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Zap className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <h4 className="font-semibold mb-1">Mais Produtividade</h4>
                  <p className="text-sm text-muted-foreground">
                    Automatize processos e economize tempo com recursos avançados
                  </p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center flex-shrink-0">
                  <BarChart3 className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <h4 className="font-semibold mb-1">Insights Valiosos</h4>
                  <p className="text-sm text-muted-foreground">
                    Relatórios detalhados para tomar decisões mais inteligentes
                  </p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Shield className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <h4 className="font-semibold mb-1">Suporte Premium</h4>
                  <p className="text-sm text-muted-foreground">
                    Suporte especializado para resolver suas dúvidas rapidamente
                  </p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* FAQ Section */}
        <Card>
          <CardHeader>
            <CardTitle>Perguntas Frequentes</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <h4 className="font-semibold mb-2">Posso cancelar a qualquer momento?</h4>
              <p className="text-sm text-muted-foreground">
                Sim! Você pode cancelar sua assinatura a qualquer momento sem taxas adicionais.
              </p>
            </div>
            
            <div>
              <h4 className="font-semibold mb-2">Como funciona o período de trial?</h4>
              <p className="text-sm text-muted-foreground">
                Você tem 14 dias grátis para testar todas as funcionalidades. Após esse período, escolha o plano que melhor atende suas necessidades.
              </p>
            </div>
            
            <div>
              <h4 className="font-semibold mb-2">Posso mudar de plano depois?</h4>
              <p className="text-sm text-muted-foreground">
                Sim! Você pode fazer upgrade ou downgrade do seu plano a qualquer momento.
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default UpgradePlan;
