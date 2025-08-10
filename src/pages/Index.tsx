import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Check, DollarSign, TrendingUp, BarChart3, Shield, Users, Zap, Star, Crown, CreditCard, FileText, Mail } from 'lucide-react';

const Index = () => {
  const { user, loading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    if (!loading && user) {
      navigate('/dashboard');
    }
  }, [user, loading, navigate]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  const plans = [
    {
      name: 'Starter',
      description: 'Ideal para MEI e pequenos negócios',
      price: 'R$ 79,90',
      period: '/mês',
      features: [
        'Dashboard financeiro básico',
        'Até 1.000 transações/mês',
        '1 usuário incluído',
        'CRM básico (até 50 clientes)',
        'Relatórios mensais',
        'Suporte por email'
      ],
      popular: false,
      buttonText: 'Começar com Starter',
      buttonVariant: 'outline' as const
    },
    {
      name: 'Business',
      description: 'Para empresas em crescimento',
      price: 'R$ 159,90',
      period: '/mês',
      features: [
        'Tudo do Starter +',
        'Transações ilimitadas',
        'Até 3 usuários',
        'CRM completo (clientes ilimitados)',
        'Sistema organizacional',
        'Relatórios avançados',
        'Múltiplas contas financeiras'
      ],
      popular: true,
      buttonText: 'Começar com Business',
      buttonVariant: 'default' as const
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-muted/30 to-background">
      {/* Header */}
      <header className="container mx-auto px-4 py-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center">
              <DollarSign className="w-5 h-5 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
              FinanceiroLogotiq
            </h1>
          </div>
          <Button onClick={() => navigate('/auth')}>
            Acessar Sistema
          </Button>
        </div>
      </header>

      {/* Hero Section */}
      <main className="container mx-auto px-4 py-16">
        <div className="text-center max-w-4xl mx-auto mb-16">
          <h1 className="text-5xl md:text-6xl font-bold mb-6 bg-gradient-primary bg-clip-text text-transparent">
            Gestão Financeira
            <br />
            Inteligente
          </h1>
          <p className="text-xl text-muted-foreground mb-8 leading-relaxed">
            Sistema completo para controle financeiro empresarial. 
            Gerencie receitas, despesas, clientes e obtenha insights em tempo real.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button size="lg" className="text-lg px-8" onClick={() => navigate('/auth')}>
              Começar Agora
            </Button>
            <Button size="lg" variant="outline" className="text-lg px-8">
              Ver Demo
            </Button>
          </div>
        </div>

        {/* Features Grid */}
        <div className="grid md:grid-cols-3 gap-8 mb-16">
          <div className="text-center p-6 rounded-xl bg-gradient-card shadow-finance-md">
            <div className="w-16 h-16 bg-success/10 rounded-xl flex items-center justify-center mx-auto mb-4">
              <TrendingUp className="w-8 h-8 text-success" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Dashboard Intuitivo</h3>
            <p className="text-muted-foreground">
              Visualize seus dados financeiros em tempo real com gráficos e KPIs claros
            </p>
          </div>

          <div className="text-center p-6 rounded-xl bg-gradient-card shadow-finance-md">
            <div className="w-16 h-16 bg-info/10 rounded-xl flex items-center justify-center mx-auto mb-4">
              <BarChart3 className="w-8 h-8 text-info" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Relatórios Detalhados</h3>
            <p className="text-muted-foreground">
              Análises completas para tomada de decisão baseada em dados reais
            </p>
          </div>

          <div className="text-center p-6 rounded-xl bg-gradient-card shadow-finance-md">
            <div className="w-16 h-16 bg-warning/10 rounded-xl flex items-center justify-center mx-auto mb-4">
              <Shield className="w-8 h-8 text-warning" />
            </div>
            <h3 className="text-xl font-semibold mb-2">Segurança Total</h3>
            <p className="text-muted-foreground">
              Seus dados protegidos com autenticação segura e criptografia
            </p>
          </div>
        </div>

        {/* Pricing Section */}
        <div className="mb-16">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Planos e Preços</h2>
            <p className="text-xl text-muted-foreground">
              Escolha o plano ideal para o seu negócio
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {plans.map((plan) => (
              <Card key={plan.name} className={`relative ${plan.popular ? 'ring-2 ring-primary' : ''}`}>
                {plan.popular && (
                  <Badge className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-primary-foreground">
                    <Star className="w-3 h-3 mr-1" />
                    Mais Popular
                  </Badge>
                )}
                <CardHeader className="text-center pb-4">
                  <CardTitle className="text-2xl font-bold">{plan.name}</CardTitle>
                  <CardDescription className="text-base">{plan.description}</CardDescription>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="text-center">
                    <div className="flex items-baseline justify-center">
                      <span className="text-4xl font-bold">{plan.price}</span>
                      <span className="text-muted-foreground ml-1">{plan.period}</span>
                    </div>
                  </div>
                  
                  <ul className="space-y-3">
                    {plan.features.map((feature, index) => (
                      <li key={index} className="flex items-center">
                        <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                        <span className="text-sm">{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <Button 
                    variant={plan.buttonVariant} 
                    className="w-full" 
                    size="lg"
                    onClick={() => navigate('/auth')}
                  >
                    {plan.buttonText}
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Stats Section */}
        <div className="bg-primary/5 rounded-2xl p-8 mb-16">
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold mb-4">Funcionalidades Completas</h2>
            <p className="text-muted-foreground">
              Tudo que você precisa para gerenciar as finanças da sua empresa
            </p>
          </div>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="flex items-center justify-center mb-3">
                <Users className="w-6 h-6 text-primary mr-2" />
                <span className="text-2xl font-bold">Clientes</span>
              </div>
              <p className="text-muted-foreground">Gestão completa de clientes e relacionamentos</p>
            </div>
            <div className="text-center">
              <div className="flex items-center justify-center mb-3">
                <DollarSign className="w-6 h-6 text-primary mr-2" />
                <span className="text-2xl font-bold">Transações</span>
              </div>
              <p className="text-muted-foreground">Controle total de receitas e despesas</p>
            </div>
            <div className="text-center">
              <div className="flex items-center justify-center mb-3">
                <Zap className="w-6 h-6 text-primary mr-2" />
                <span className="text-2xl font-bold">Automação</span>
              </div>
              <p className="text-muted-foreground">Processos automatizados para eficiência</p>
            </div>
          </div>
        </div>

        {/* CTA Section */}
        <div className="text-center">
          <h2 className="text-3xl font-bold mb-4">Pronto para começar?</h2>
          <p className="text-xl text-muted-foreground mb-8">
            Junte-se a centenas de empresas que já transformaram sua gestão financeira
          </p>
          <Button size="lg" className="text-lg px-12" onClick={() => navigate('/auth')}>
            Criar Conta Gratuita
          </Button>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t bg-muted/30 mt-16">
        <div className="container mx-auto px-4 py-8">
          <div className="flex items-center justify-center">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center">
                <DollarSign className="w-4 h-4 text-primary-foreground" />
              </div>
              <span className="text-sm text-muted-foreground">
                © 2024 FinanceiroLogotiq. Todos os direitos reservados.
              </span>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
