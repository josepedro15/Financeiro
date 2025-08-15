import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  Check, 
  DollarSign, 
  TrendingUp, 
  Shield, 
  Users, 
  Zap, 
  Star, 
  ArrowRight, 
  Play, 
  Clock, 
  MessageCircle, 
  ChevronDown,
  ChevronUp,
  Sparkles,
  Rocket,
  AlertTriangle,
  CheckCircle,
  XCircle
} from 'lucide-react';

const Index = () => {
  const { user, loading } = useAuth();
  const navigate = useNavigate();

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
      <header className="fixed top-0 left-0 right-0 z-50 bg-background/95 backdrop-blur-md border-b shadow-lg">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Button 
                variant="ghost" 
                className="p-0 h-auto hover:bg-transparent"
                onClick={() => navigate('/')}
              >
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center">
                    <DollarSign className="w-5 h-5 text-primary-foreground" />
                  </div>
                  <h1 className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
                    Financeiro
                  </h1>
                </div>
              </Button>
            </div>
            <div className="flex items-center space-x-4">
              <Button variant="ghost" onClick={() => document.getElementById('pricing')?.scrollIntoView({ behavior: 'smooth' })}>
                Planos
              </Button>
              <Button variant="ghost" onClick={() => document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth' })}>
                Contato
              </Button>
              <Button onClick={() => navigate(user ? '/dashboard' : '/auth')}>
                {user ? 'Dashboard' : 'Acessar Sistema'}
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="pt-20">
        <section className="container mx-auto px-4 py-20">
          <div className="text-center max-w-4xl mx-auto mb-16">
            <Badge className="mb-4 bg-primary/10 text-primary border-primary/20">
              <Sparkles className="w-3 h-3 mr-1" />
              Plataforma #1 em Gestão Financeira
            </Badge>
            <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-primary bg-clip-text text-transparent">
              Gestão Financeira
              <br />
              <span className="text-primary">Inteligente</span>
            </h1>
            <p className="text-xl text-muted-foreground mb-8 leading-relaxed max-w-2xl mx-auto">
              Sistema completo para controle financeiro empresarial. 
              Gerencie receitas, despesas, clientes e obtenha insights em tempo real.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-8">
              <Button 
                size="lg" 
                className="text-lg px-8 group hover:scale-105 transition-all" 
                onClick={() => navigate(user ? '/dashboard' : '/auth')}
              >
                {user ? 'Acessar Dashboard' : 'Começar Gratuitamente'}
                <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
              </Button>
              <Button 
                size="lg" 
                variant="outline" 
                className="text-lg px-8 group hover:scale-105 transition-all"
              >
                <Play className="w-4 h-4 mr-2" />
                Ver Demo
              </Button>
            </div>
            <div className="flex items-center justify-center space-x-8 text-sm text-muted-foreground">
              <div className="flex items-center">
                <Check className="w-4 h-4 text-success mr-1" />
                14 dias grátis
              </div>
              <div className="flex items-center">
                <Check className="w-4 h-4 text-success mr-1" />
                Sem cartão de crédito
              </div>
              <div className="flex items-center">
                <Check className="w-4 h-4 text-success mr-1" />
                Setup em 2 minutos
              </div>
            </div>
          </div>
        </section>

        {/* Problems & Solutions Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold mb-4">Problemas que Resolvemos</h2>
              <p className="text-xl text-muted-foreground">Transforme seus desafios em oportunidades</p>
            </div>
            
            <div className="grid md:grid-cols-2 gap-16 mb-16">
              {/* Problems */}
              <div>
                <h3 className="text-2xl font-bold mb-8 text-destructive">Antes</h3>
                <div className="space-y-6">
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover:shadow-lg transition-all">
                    <AlertTriangle className="w-6 h-6 text-destructive mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-destructive">Controle financeiro desorganizado</h4>
                      <p className="text-muted-foreground">Planilhas espalhadas, dados desatualizados, relatórios confusos</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover:shadow-lg transition-all">
                    <XCircle className="w-6 h-6 text-destructive mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-destructive">Perdendo dinheiro sem saber</h4>
                      <p className="text-muted-foreground">Falta de visibilidade sobre receitas, despesas e lucros</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover:shadow-lg transition-all">
                    <Clock className="w-6 h-6 text-destructive mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-destructive">Tempo demais com burocracia</h4>
                      <p className="text-muted-foreground">Processos manuais, relatórios demorados, erros frequentes</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Solutions */}
              <div>
                <h3 className="text-2xl font-bold mb-8 text-success">Depois</h3>
                <div className="space-y-6">
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover:shadow-lg transition-all">
                    <CheckCircle className="w-6 h-6 text-success mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-success">Tudo organizado em um só lugar</h4>
                      <p className="text-muted-foreground">Dashboard unificado com todas as informações financeiras</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover:shadow-lg transition-all">
                    <TrendingUp className="w-6 h-6 text-success mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-success">Insights em tempo real</h4>
                      <p className="text-muted-foreground">Relatórios automáticos e alertas inteligentes</p>
                    </div>
                  </div>
                  <div className="flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover:shadow-lg transition-all">
                    <Zap className="w-6 h-6 text-success mt-1 flex-shrink-0" />
                    <div>
                      <h4 className="font-semibold text-success">Automação completa</h4>
                      <p className="text-muted-foreground">Processos automatizados que economizam tempo</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Benefits Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold mb-4">Por que escolher o Financeiro?</h2>
              <p className="text-xl text-muted-foreground">Resultados comprovados por centenas de empresas</p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8 mb-16">
              <Card className="text-center p-6 hover:shadow-lg transition-all duration-300 hover:-translate-y-2">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <Clock className="w-8 h-8 text-primary" />
                </div>
                <h3 className="text-xl font-semibold mb-2">Economize 15h por semana</h3>
                <p className="text-muted-foreground">Automatize processos financeiros e foque no que realmente importa</p>
              </Card>
              <Card className="text-center p-6 hover:shadow-lg transition-all duration-300 hover:-translate-y-2">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <TrendingUp className="w-8 h-8 text-primary" />
                </div>
                <h3 className="text-xl font-semibold mb-2">Aumente lucro em 25%</h3>
                <p className="text-muted-foreground">Insights em tempo real para tomar decisões mais inteligentes</p>
              </Card>
              <Card className="text-center p-6 hover:shadow-lg transition-all duration-300 hover:-translate-y-2">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <Shield className="w-8 h-8 text-primary" />
                </div>
                <h3 className="text-xl font-semibold mb-2">100% Seguro e Confiável</h3>
                <p className="text-muted-foreground">Seus dados protegidos com criptografia de ponta a ponta</p>
              </Card>
            </div>
          </div>
        </section>

        {/* Metrics Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold mb-4">Números que Impressionam</h2>
              <p className="text-xl text-muted-foreground">Resultados reais de empresas que confiam em nós</p>
            </div>
            
            <div className="grid md:grid-cols-4 gap-8">
              <div className="text-center p-6 rounded-lg bg-white shadow-lg hover:shadow-xl transition-all">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <Users className="w-8 h-8 text-primary" />
                </div>
                <div className="text-4xl font-bold text-primary mb-2">500+</div>
                <div className="text-muted-foreground font-medium">Empresas Atendidas</div>
              </div>
              <div className="text-center p-6 rounded-lg bg-white shadow-lg hover:shadow-xl transition-all">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <Clock className="w-8 h-8 text-primary" />
                </div>
                <div className="text-4xl font-bold text-primary mb-2">15h</div>
                <div className="text-muted-foreground font-medium">Economia Semanal</div>
              </div>
              <div className="text-center p-6 rounded-lg bg-white shadow-lg hover:shadow-xl transition-all">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <TrendingUp className="w-8 h-8 text-primary" />
                </div>
                <div className="text-4xl font-bold text-primary mb-2">25%</div>
                <div className="text-muted-foreground font-medium">Aumento de Lucro</div>
              </div>
              <div className="text-center p-6 rounded-lg bg-white shadow-lg hover:shadow-xl transition-all">
                <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                  <Shield className="w-8 h-8 text-primary" />
                </div>
                <div className="text-4xl font-bold text-primary mb-2">99.9%</div>
                <div className="text-muted-foreground font-medium">Uptime Garantido</div>
              </div>
            </div>
          </div>
        </section>

        {/* Pricing Section */}
        <section id="pricing" className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold mb-4">Planos e Preços</h2>
              <p className="text-xl text-muted-foreground">
                Escolha o plano ideal para o seu negócio
              </p>
            </div>
            
            <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
              <Card className="relative hover:shadow-xl transition-all duration-300 hover:-translate-y-2">
                <CardHeader className="text-center pb-4">
                  <CardTitle className="text-2xl font-bold">Starter</CardTitle>
                  <CardDescription className="text-base">Ideal para MEI e pequenos negócios</CardDescription>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="text-center">
                    <div className="flex items-baseline justify-center">
                      <span className="text-4xl font-bold">R$ 79,90</span>
                      <span className="text-muted-foreground ml-1">/mês</span>
                    </div>
                  </div>
                  
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Dashboard financeiro básico</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Até 1.000 transações/mês</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">1 usuário incluído</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">CRM básico (até 50 clientes)</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Relatórios mensais</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Suporte por email</span>
                    </li>
                  </ul>
                  
                  <Button 
                    variant="outline" 
                    className="w-full group" 
                    size="lg"
                    onClick={() => navigate('/auth')}
                  >
                    Começar com Starter
                    <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
                  </Button>
                </CardContent>
              </Card>

              <Card className="relative hover:shadow-xl transition-all duration-300 hover:-translate-y-2 ring-2 ring-primary">
                <Badge className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-primary text-primary-foreground">
                  <Star className="w-3 h-3 mr-1" />
                  Mais Popular
                </Badge>
                <CardHeader className="text-center pb-4">
                  <CardTitle className="text-2xl font-bold">Business</CardTitle>
                  <CardDescription className="text-base">Para empresas em crescimento</CardDescription>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="text-center">
                    <div className="flex items-baseline justify-center">
                      <span className="text-4xl font-bold">R$ 159,90</span>
                      <span className="text-muted-foreground ml-1">/mês</span>
                    </div>
                  </div>
                  
                  <ul className="space-y-3">
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Tudo do Starter +</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Transações ilimitadas</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Até 3 usuários</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">CRM completo (clientes ilimitados)</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Sistema organizacional</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Relatórios avançados</span>
                    </li>
                    <li className="flex items-center">
                      <Check className="w-4 h-4 text-success mr-3 flex-shrink-0" />
                      <span className="text-sm">Múltiplas contas financeiras</span>
                    </li>
                  </ul>
                  
                  <Button 
                    className="w-full group" 
                    size="lg"
                    onClick={() => navigate('/auth')}
                  >
                    Começar com Business
                    <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
                  </Button>
                </CardContent>
              </Card>
            </div>
          </div>
        </section>

        {/* Final CTA Section */}
        <section className="py-20 bg-primary text-primary-foreground">
          <div className="container mx-auto px-4 text-center">
            <h2 className="text-3xl font-bold mb-4">Pronto para transformar sua gestão financeira?</h2>
            <p className="text-xl mb-8 opacity-90">
              Junte-se a centenas de empresas que já revolucionaram suas finanças
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button size="lg" variant="secondary" className="text-lg px-8 group" onClick={() => navigate(user ? '/dashboard' : '/auth')}>
                <Rocket className="w-4 h-4 mr-2" />
                {user ? 'Acessar Dashboard' : 'Começar Gratuitamente'}
                <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
              </Button>
              <Button size="lg" variant="outline" className="text-lg px-8 border-primary-foreground text-primary-foreground hover:bg-primary-foreground hover:text-primary">
                <MessageCircle className="w-4 h-4 mr-2" />
                Falar com Especialista
              </Button>
            </div>
            <div className="mt-8 flex items-center justify-center space-x-8 text-sm opacity-75">
              <div className="flex items-center">
                <Check className="w-4 h-4 mr-1" />
                14 dias grátis
              </div>
              <div className="flex items-center">
                <Check className="w-4 h-4 mr-1" />
                Sem cartão de crédito
              </div>
              <div className="flex items-center">
                <Check className="w-4 h-4 mr-1" />
                Cancelamento gratuito
              </div>
            </div>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer id="contact" className="border-t bg-muted/30">
        <div className="container mx-auto px-4 py-12">
          <div className="grid md:grid-cols-4 gap-8 mb-8">
            <div>
              <div className="flex items-center space-x-3 mb-4">
                <div className="w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center">
                  <DollarSign className="w-4 h-4 text-primary-foreground" />
                </div>
                <span className="text-lg font-bold">Financeiro</span>
              </div>
              <p className="text-muted-foreground mb-4">
                A plataforma mais completa para gestão financeira empresarial.
              </p>
              <div className="flex space-x-4">
                <Button variant="ghost" size="sm">
                  <MessageCircle className="w-4 h-4" />
                </Button>
              </div>
            </div>
            
            <div>
              <h3 className="font-semibold mb-4">Produto</h3>
              <ul className="space-y-2 text-muted-foreground">
                <li><a href="#" className="hover:text-foreground transition-colors">Dashboard</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">CRM</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Relatórios</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Integrações</a></li>
              </ul>
            </div>
            
            <div>
              <h3 className="font-semibold mb-4">Empresa</h3>
              <ul className="space-y-2 text-muted-foreground">
                <li><a href="#" className="hover:text-foreground transition-colors">Sobre nós</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Carreiras</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Blog</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Imprensa</a></li>
              </ul>
            </div>
            
            <div>
              <h3 className="font-semibold mb-4">Suporte</h3>
              <ul className="space-y-2 text-muted-foreground">
                <li><a href="#" className="hover:text-foreground transition-colors">Central de Ajuda</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Contato</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Status</a></li>
                <li><a href="#" className="hover:text-foreground transition-colors">Documentação</a></li>
              </ul>
            </div>
          </div>
          
          <div className="border-t pt-8 flex flex-col md:flex-row items-center justify-between">
            <div className="flex items-center space-x-3 mb-4 md:mb-0">
              <div className="w-6 h-6 bg-gradient-primary rounded flex items-center justify-center">
                <DollarSign className="w-3 h-3 text-primary-foreground" />
              </div>
              <span className="text-sm text-muted-foreground">
                © 2024 Financeiro. Todos os direitos reservados.
              </span>
            </div>
            <div className="flex space-x-6 text-sm text-muted-foreground">
              <a href="/privacy" className="hover:text-foreground transition-colors">Privacidade</a>
              <a href="/terms" className="hover:text-foreground transition-colors">Termos</a>
              <a href="/cookies" className="hover:text-foreground transition-colors">Cookies</a>
              <a href="/analytics" className="hover:text-foreground transition-colors">Analytics</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
