import { useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  Check, 
  Crown, 
  ArrowLeft, 
  Zap,
  Building,
  Star,
  Clock
} from 'lucide-react';

interface PlanFeature {
  name: string;
  included: boolean;
}

interface Plan {
  id: 'starter' | 'business';
  name: string;
  price: number;
  period: string;
  description: string;
  features: PlanFeature[];
  popular?: boolean;
  icon: any;
  color: string;
  limits: {
    transactions: number;
    users: number;
    clients: number;
  };
}

const plans: Plan[] = [
  {
    id: 'starter',
    name: 'Starter',
    price: 29.90,
    period: 'mês',
    description: 'Perfeito para freelancers e pequenos negócios',
    icon: Zap,
    color: 'from-blue-500 to-cyan-500',
    limits: {
      transactions: 100,
      users: 1,
      clients: 10
    },
    features: [
      { name: 'Até 100 transações por mês', included: true },
      { name: '1 usuário', included: true },
      { name: 'Até 10 clientes', included: true },
      { name: 'Dashboard financeiro', included: true },
      { name: 'Relatórios básicos', included: true },
      { name: 'CRM simples', included: true },
      { name: 'Suporte por email', included: true },
      { name: 'Múltiplos usuários', included: false },
      { name: 'Relatórios avançados', included: false },
      { name: 'API access', included: false }
    ]
  },
  {
    id: 'business',
    name: 'Business',
    price: 79.90,
    period: 'mês',
    description: 'Ideal para empresas em crescimento',
    icon: Building,
    color: 'from-purple-500 to-pink-500',
    popular: true,
    limits: {
      transactions: 1000,
      users: 3,
      clients: 50
    },
    features: [
      { name: 'Até 1.000 transações por mês', included: true },
      { name: 'Até 3 usuários', included: true },
      { name: 'Até 50 clientes', included: true },
      { name: 'Dashboard financeiro', included: true },
      { name: 'Relatórios avançados', included: true },
      { name: 'CRM completo', included: true },
      { name: 'Suporte prioritário', included: true },
      { name: 'Múltiplos usuários', included: true },
      { name: 'Análises detalhadas', included: true },
      { name: 'API access', included: true }
    ]
  }
];

export default function PlanSelection() {
  const { user } = useAuth();
  const { 
    subscription, 
    isTrialActive, 
    getTrialDaysLeft, 
    isMasterUser,
    currentPlan 
  } = useSubscription();
  const navigate = useNavigate();
  const [selectedPlan, setSelectedPlan] = useState<'starter' | 'business' | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSelectPlan = async (planId: 'starter' | 'business') => {
    setSelectedPlan(planId);
    setLoading(true);

    try {
      // Aqui você redirecionaria para o checkout
      // Por enquanto, vamos simular
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Redirecionar para checkout (implementar depois)
      navigate(`/checkout?plan=${planId}`);
    } catch (error) {
      console.error('Erro ao selecionar plano:', error);
    } finally {
      setLoading(false);
      setSelectedPlan(null);
    }
  };

  const currentPlanId = subscription?.plan_type as 'starter' | 'business';
  
  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button variant="outline" size="sm" onClick={() => navigate('/subscription')}>
                <ArrowLeft className="w-4 h-4 mr-1" />
                Voltar
              </Button>
              <div>
                <h1 className="text-2xl font-bold">Escolha seu Plano</h1>
                <p className="text-muted-foreground">
                  Selecione o plano ideal para seu negócio
                </p>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Trial Banner */}
      {!isMasterUser && isTrialActive() && (
        <div className="bg-gradient-to-r from-blue-50 to-indigo-50 border-b border-blue-200">
          <div className="container mx-auto px-4 py-4">
            <div className="flex items-center justify-center space-x-2 text-blue-800">
              <Clock className="w-5 h-5" />
              <span className="font-medium">
                Você está no trial gratuito! {getTrialDaysLeft()} dias restantes
              </span>
            </div>
          </div>
        </div>
      )}

      {/* Main Content */}
      <main className="container mx-auto px-4 py-12">
        
        {/* Pricing Header */}
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold mb-4">
            Planos que crescem com seu negócio
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Escolha o plano ideal e tenha acesso a todas as ferramentas para gerenciar suas finanças
          </p>
        </div>

        {/* Plans Grid */}
        <div className="grid gap-8 lg:grid-cols-2 max-w-4xl mx-auto">
          {plans.map((plan) => {
            const Icon = plan.icon;
            const isCurrentPlan = currentPlanId === plan.id;
            const isDowngrade = currentPlanId === 'business' && plan.id === 'starter';
            
            return (
              <Card 
                key={plan.id} 
                className={`relative overflow-hidden transition-all duration-300 hover:shadow-lg ${
                  plan.popular ? 'ring-2 ring-primary' : ''
                } ${isCurrentPlan ? 'ring-2 ring-green-500' : ''}`}
              >
                {plan.popular && (
                  <Badge className="absolute top-4 right-4 bg-primary">
                    <Star className="w-3 h-3 mr-1" />
                    Mais Popular
                  </Badge>
                )}
                
                {isCurrentPlan && (
                  <Badge className="absolute top-4 left-4 bg-green-500">
                    <Check className="w-3 h-3 mr-1" />
                    Plano Atual
                  </Badge>
                )}

                <div className={`bg-gradient-to-r ${plan.color} text-white p-6`}>
                  <div className="flex items-center space-x-3 mb-4">
                    <div className="w-10 h-10 rounded-lg bg-white/20 flex items-center justify-center">
                      <Icon className="w-5 h-5" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold">{plan.name}</h3>
                      <p className="text-white/80 text-sm">{plan.description}</p>
                    </div>
                  </div>
                  
                  <div className="mb-4">
                    <div className="flex items-baseline space-x-1">
                      <span className="text-3xl font-bold">R$ {plan.price.toFixed(2)}</span>
                      <span className="text-white/80">/ {plan.period}</span>
                    </div>
                    {isTrialActive() && (
                      <p className="text-sm text-white/80 mt-1">
                        14 dias grátis • Cancele quando quiser
                      </p>
                    )}
                  </div>

                  <div className="grid grid-cols-3 gap-4 text-center">
                    <div>
                      <div className="text-2xl font-bold">{plan.limits.transactions}</div>
                      <div className="text-xs text-white/80">Transações</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold">{plan.limits.users}</div>
                      <div className="text-xs text-white/80">Usuários</div>
                    </div>
                    <div>
                      <div className="text-2xl font-bold">{plan.limits.clients}</div>
                      <div className="text-xs text-white/80">Clientes</div>
                    </div>
                  </div>
                </div>

                <CardContent className="p-6">
                  <ul className="space-y-3 mb-6">
                    {plan.features.map((feature, index) => (
                      <li key={index} className="flex items-start space-x-3">
                        <div className={`w-5 h-5 rounded-full flex items-center justify-center mt-0.5 ${
                          feature.included 
                            ? 'bg-green-100 text-green-600' 
                            : 'bg-gray-100 text-gray-400'
                        }`}>
                          <Check className="w-3 h-3" />
                        </div>
                        <span className={`text-sm ${
                          feature.included ? 'text-foreground' : 'text-muted-foreground'
                        }`}>
                          {feature.name}
                        </span>
                      </li>
                    ))}
                  </ul>

                  <Button 
                    className="w-full" 
                    variant={isCurrentPlan ? "outline" : "default"}
                    disabled={loading || isCurrentPlan || isDowngrade}
                    onClick={() => handleSelectPlan(plan.id)}
                  >
                    {loading && selectedPlan === plan.id ? (
                      <div className="flex items-center space-x-2">
                        <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-current"></div>
                        <span>Processando...</span>
                      </div>
                    ) : isCurrentPlan ? (
                      "Plano Atual"
                    ) : isDowngrade ? (
                      "Downgrade não disponível"
                    ) : (
                      `Escolher ${plan.name}`
                    )}
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Guarantee Section */}
        <div className="text-center mt-16 p-8 bg-muted/50 rounded-lg max-w-2xl mx-auto">
          <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Check className="w-8 h-8 text-green-600" />
          </div>
          <h3 className="text-xl font-bold mb-2">Garantia de 14 dias</h3>
          <p className="text-muted-foreground">
            Teste gratuitamente por 14 dias. Cancele quando quiser, sem compromisso.
          </p>
        </div>
      </main>
    </div>
  );
}
