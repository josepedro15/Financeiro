import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  Check, 
  Star, 
  Crown, 
  Users, 
  FileText, 
  ArrowLeft,
  Zap,
  Shield,
  Headphones
} from 'lucide-react';

export default function PlanSelection() {
  const { user } = useAuth();
  const { isMasterUser, isTrialActive, getTrialDaysLeft } = useSubscription();
  const navigate = useNavigate();

  const plans = [
    {
      id: 'starter',
      name: 'Starter',
      price: 'R$ 79,90',
      period: '/mês',
      description: 'Perfeito para pequenos negócios',
      features: [
        '100 transações por mês',
        '1 usuário',
        '10 clientes',
        'Dashboard completo',
        'Relatórios básicos',
        'Suporte por email'
      ],
      popular: false,
      icon: <Zap className="w-6 h-6" />
    },
    {
      id: 'business',
      name: 'Business',
      price: 'R$ 159,90',
      period: '/mês',
      description: 'Ideal para empresas em crescimento',
      features: [
        '1.000 transações por mês',
        '3 usuários',
        '50 clientes',
        'Dashboard avançado',
        'Relatórios detalhados',
        'CRM completo',
        'Suporte prioritário',
        'Backup automático'
      ],
      popular: true,
      icon: <Crown className="w-6 h-6" />
    }
  ];

  const handleSelectPlan = (planId: string) => {
    // Redirecionar para checkout com o plano selecionado
    navigate(`/checkout?plan=${planId}`);
  };

  const getCurrentPlan = () => {
    if (isMasterUser) return 'Master';
    if (isTrialActive()) return 'Trial';
    return 'Starter'; // Default
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center space-x-4">
            <Button variant="ghost" onClick={() => navigate('/subscription')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Voltar
            </Button>
            <div>
              <h1 className="text-2xl font-bold">Escolha seu Plano</h1>
              <p className="text-muted-foreground">
                {isTrialActive() 
                  ? `Você está no trial gratuito - ${getTrialDaysLeft()} dias restantes`
                  : 'Selecione o plano ideal para seu negócio'
                }
              </p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        
        {/* Current Status */}
        {!isMasterUser && (
          <div className="mb-8">
            <Card className="bg-blue-50 border-blue-200">
              <CardContent className="pt-6">
                <div className="flex items-center space-x-3">
                  <div className="p-2 bg-blue-100 rounded-full">
                    <Shield className="w-5 h-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="font-medium text-blue-900">
                      Plano Atual: {getCurrentPlan()}
                    </p>
                    <p className="text-sm text-blue-700">
                      {isTrialActive() 
                        ? 'Aproveite o período de teste gratuito para conhecer todas as funcionalidades'
                        : 'Faça upgrade para acessar mais recursos'
                      }
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Plans Grid */}
        <div className="grid gap-6 md:grid-cols-2 max-w-4xl mx-auto">
          {plans.map((plan) => (
            <Card 
              key={plan.id} 
              className={`relative transition-all duration-200 hover:shadow-lg ${
                plan.popular ? 'ring-2 ring-primary' : ''
              }`}
            >
              {plan.popular && (
                <Badge className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-primary-foreground">
                  <Star className="w-3 h-3 mr-1" />
                  Mais Popular
                </Badge>
              )}
              
              <CardHeader className="text-center pb-4">
                <div className="mx-auto mb-4 p-3 bg-primary/10 rounded-full w-fit">
                  {plan.icon}
                </div>
                <CardTitle className="text-2xl">{plan.name}</CardTitle>
                <CardDescription>{plan.description}</CardDescription>
                
                <div className="mt-4">
                  <span className="text-3xl font-bold">{plan.price}</span>
                  <span className="text-muted-foreground">{plan.period}</span>
                </div>
              </CardHeader>
              
              <CardContent className="space-y-4">
                <ul className="space-y-3">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center space-x-3">
                      <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
                      <span className="text-sm">{feature}</span>
                    </li>
                  ))}
                </ul>
                
                <Button 
                  className="w-full mt-6"
                  onClick={() => handleSelectPlan(plan.id)}
                  disabled={isMasterUser}
                >
                  {isMasterUser ? 'Conta Master' : 'Escolher Plano'}
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Features Comparison */}
        <div className="mt-12">
          <Card>
            <CardHeader className="text-center">
              <CardTitle className="text-xl">Comparativo de Recursos</CardTitle>
              <CardDescription>
                Veja as diferenças entre os planos
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b">
                      <th className="text-left py-3 px-4 font-medium">Recurso</th>
                      <th className="text-center py-3 px-4 font-medium">Starter</th>
                      <th className="text-center py-3 px-4 font-medium">Business</th>
                    </tr>
                  </thead>
                  <tbody className="space-y-2">
                    <tr className="border-b">
                      <td className="py-3 px-4">
                        <div className="flex items-center space-x-2">
                          <FileText className="w-4 h-4 text-blue-500" />
                          <span>Transações por mês</span>
                        </div>
                      </td>
                      <td className="text-center py-3 px-4">100</td>
                      <td className="text-center py-3 px-4">1.000</td>
                    </tr>
                    <tr className="border-b">
                      <td className="py-3 px-4">
                        <div className="flex items-center space-x-2">
                          <Users className="w-4 h-4 text-green-500" />
                          <span>Usuários</span>
                        </div>
                      </td>
                      <td className="text-center py-3 px-4">1</td>
                      <td className="text-center py-3 px-4">3</td>
                    </tr>
                    <tr className="border-b">
                      <td className="py-3 px-4">
                        <div className="flex items-center space-x-2">
                          <Users className="w-4 h-4 text-purple-500" />
                          <span>Clientes</span>
                        </div>
                      </td>
                      <td className="text-center py-3 px-4">10</td>
                      <td className="text-center py-3 px-4">50</td>
                    </tr>
                    <tr className="border-b">
                      <td className="py-3 px-4">
                        <div className="flex items-center space-x-2">
                          <Headphones className="w-4 h-4 text-orange-500" />
                          <span>Suporte</span>
                        </div>
                      </td>
                      <td className="text-center py-3 px-4">Email</td>
                      <td className="text-center py-3 px-4">Prioritário</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* FAQ Section */}
        <div className="mt-12">
          <Card>
            <CardHeader>
              <CardTitle>Perguntas Frequentes</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="font-medium mb-2">Posso cancelar a qualquer momento?</h4>
                <p className="text-sm text-muted-foreground">
                  Sim! Você pode cancelar sua assinatura a qualquer momento sem taxas adicionais.
                </p>
              </div>
              <div>
                <h4 className="font-medium mb-2">Como funciona o período de teste?</h4>
                <p className="text-sm text-muted-foreground">
                  Você tem 14 dias gratuitos para testar todas as funcionalidades. Não é necessário cartão de crédito.
                </p>
              </div>
              <div>
                <h4 className="font-medium mb-2">Posso fazer upgrade ou downgrade?</h4>
                <p className="text-sm text-muted-foreground">
                  Sim, você pode alterar seu plano a qualquer momento. As mudanças são aplicadas imediatamente.
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  );
}
