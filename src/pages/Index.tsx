import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { DollarSign, TrendingUp, BarChart3, Shield, Users, Zap, Check, Star, ChevronDown } from 'lucide-react';

const Index = () => {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const [openFaq, setOpenFaq] = useState<number | null>(null);

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

        {/* Pricing Section */}
        <div className="mb-16">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-bold mb-4">Planos Simples e Transparentes</h2>
            <p className="text-xl text-muted-foreground">
              Escolha o plano ideal para o seu negócio
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            {/* Plano Starter */}
            <div className="relative p-8 rounded-2xl bg-gradient-card shadow-finance-lg border border-border/50 hover:shadow-finance-xl hover:scale-105 transition-all duration-300 group">
              <div className="text-center mb-6">
                <h3 className="text-2xl font-bold mb-2">Starter</h3>
                <p className="text-muted-foreground mb-4">Ideal para MEI e pequenos negócios</p>
                <div className="flex items-baseline justify-center">
                  <span className="text-4xl font-bold">R$ 79,90</span>
                  <span className="text-muted-foreground ml-2">/mês</span>
                </div>
              </div>
              
              <ul className="space-y-4 mb-8">
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Dashboard financeiro básico</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Até 1.000 transações/mês</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>1 usuário incluído</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>CRM básico (até 50 clientes)</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Relatórios mensais</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Suporte por email</span>
                </li>
              </ul>
              
              <Button 
                className="w-full text-lg py-6" 
                variant="outline"
                onClick={() => navigate('/auth')}
              >
                Começar com Starter
              </Button>
            </div>

            {/* Plano Business */}
            <div className="relative p-8 rounded-2xl bg-gradient-to-br from-primary/5 via-primary/10 to-primary/5 shadow-finance-lg border-2 border-primary/20 hover:shadow-finance-xl hover:scale-105 transition-all duration-300 group">
              <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                <div className="bg-primary text-primary-foreground px-4 py-2 rounded-full text-sm font-semibold flex items-center">
                  <Star className="w-4 h-4 mr-1" />
                  Mais Popular
                </div>
              </div>
              
              <div className="text-center mb-6 mt-4">
                <h3 className="text-2xl font-bold mb-2">Business</h3>
                <p className="text-muted-foreground mb-4">Para empresas em crescimento</p>
                <div className="flex items-baseline justify-center">
                  <span className="text-4xl font-bold">R$ 159,90</span>
                  <span className="text-muted-foreground ml-2">/mês</span>
                </div>
              </div>
              
              <ul className="space-y-4 mb-8">
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span className="font-medium">Tudo do Starter +</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Transações ilimitadas</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Até 3 usuários</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>CRM completo (clientes ilimitados)</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Sistema organizacional</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Relatórios avançados</span>
                </li>
                <li className="flex items-center">
                  <Check className="w-5 h-5 text-success mr-3 flex-shrink-0" />
                  <span>Múltiplas contas financeiras</span>
                </li>
              </ul>
              
              <Button 
                className="w-full text-lg py-6" 
                onClick={() => navigate('/auth')}
              >
                Começar com Business
              </Button>
            </div>
          </div>
          
          {/* Garantia */}
          <div className="text-center mt-12">
            <div className="inline-flex items-center px-8 py-4 bg-gradient-to-r from-success/10 via-success/20 to-success/10 rounded-full border border-success/20 shadow-lg">
              <Shield className="w-6 h-6 text-success mr-3" />
              <span className="text-success font-semibold text-lg">14 dias grátis • Sem compromisso • Cancele quando quiser</span>
            </div>
          </div>
        </div>

        {/* FAQ Section */}
        <div className="mb-16">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Perguntas Frequentes</h2>
            <p className="text-xl text-muted-foreground">
              Tire suas dúvidas sobre nossos planos
            </p>
          </div>
          
          <div className="max-w-3xl mx-auto space-y-4">
            {[
              {
                question: "Posso trocar de plano a qualquer momento?",
                answer: "Sim! Você pode fazer upgrade ou downgrade do seu plano a qualquer momento. As mudanças são aplicadas imediatamente e o valor é ajustado de forma proporcional."
              },
              {
                question: "O que acontece se eu exceder o limite de transações no Starter?",
                answer: "Oferecemos uma janela de flexibilidade. Se exceder ocasionalmente, não há problema. Para uso consistente acima do limite, recomendamos upgrade para o Business."
              },
              {
                question: "Os dados ficam seguros na plataforma?",
                answer: "Absolutamente. Utilizamos criptografia de ponta a ponta, autenticação segura via Supabase e backup automático. Seus dados financeiros estão completamente protegidos."
              },
              {
                question: "Como funciona o período de teste gratuito?",
                answer: "Oferecemos 14 dias totalmente grátis em qualquer plano. Não é necessário cartão de crédito para começar. Você pode cancelar a qualquer momento sem cobrança."
              },
              {
                question: "Posso integrar com meu banco?",
                answer: "Estamos desenvolvendo integrações bancárias via Open Finance. Por enquanto, a inserção é manual, mas nosso sistema torna o processo muito rápido e eficiente."
              },
              {
                question: "Há desconto para pagamento anual?",
                answer: "Sim! Oferecemos 2 meses gratuitos (equivalente a 16% de desconto) para quem escolhe o pagamento anual em qualquer plano."
              }
            ].map((faq, index) => (
              <div 
                key={index}
                className="border border-border/50 rounded-xl bg-gradient-card overflow-hidden"
              >
                <button
                  className="w-full p-6 text-left flex items-center justify-between hover:bg-muted/30 transition-colors"
                  onClick={() => setOpenFaq(openFaq === index ? null : index)}
                >
                  <span className="font-semibold text-lg">{faq.question}</span>
                  <ChevronDown 
                    className={`w-5 h-5 transition-transform ${
                      openFaq === index ? 'rotate-180' : ''
                    }`}
                  />
                </button>
                {openFaq === index && (
                  <div className="px-6 pb-6">
                    <p className="text-muted-foreground leading-relaxed">
                      {faq.answer}
                    </p>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* CTA Section */}
        <div className="text-center">
          <h2 className="text-3xl font-bold mb-4">Pronto para começar?</h2>
          <p className="text-xl text-muted-foreground mb-8">
            Junte-se a centenas de empresas que já transformaram sua gestão financeira
          </p>
          <Button size="lg" className="text-lg px-12" onClick={() => navigate('/auth')}>
            Começar Teste Gratuito
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
