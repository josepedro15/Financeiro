import { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  Check, 
  DollarSign, 
  TrendingUp, 
  BarChart3, 
  Shield, 
  Users, 
  Zap, 
  Star, 
  Crown, 
  CreditCard, 
  FileText, 
  Mail, 
  ArrowRight, 
  Play, 
  Clock, 
  Award, 
  Lock, 
  Database, 
  Headphones, 
  MessageCircle, 
  ChevronDown,
  ChevronUp,
  Target,
  PieChart,
  Calendar,
  Smartphone,
  Globe,
  Sparkles,
  Rocket,
  ThumbsUp,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Building
} from 'lucide-react';

const Index = () => {
  const { user, loading } = useAuth();
  const navigate = useNavigate();
  const [isNavbarScrolled, setIsNavbarScrolled] = useState(false);
  const [openFaq, setOpenFaq] = useState<number | null>(null);
  const [animatedElements, setAnimatedElements] = useState<Set<string>>(new Set());
  const [counters, setCounters] = useState<{ [key: string]: number }>({});
  const sectionRefs = useRef<{ [key: string]: HTMLDivElement | null }>({});

  useEffect(() => {
    if (!loading && user) {
      navigate('/dashboard');
    }
  }, [user, loading, navigate]);

  useEffect(() => {
    const handleScroll = () => {
      setIsNavbarScrolled(window.scrollY > 50);
      
      // Animações de scroll
      Object.keys(sectionRefs.current).forEach((key) => {
        const element = sectionRefs.current[key];
        if (element) {
          const rect = element.getBoundingClientRect();
          const isVisible = rect.top < window.innerHeight * 0.8 && rect.bottom > 0;
          
          if (isVisible && !animatedElements.has(key)) {
            setAnimatedElements(prev => new Set([...prev, key]));
            
            // Animar contadores quando a seção de métricas aparecer
            if (key === 'metrics') {
              metrics.forEach((metric, index) => {
                const target = parseInt(metric.number.replace(/\D/g, ''));
                const duration = 2000; // 2 segundos
                const steps = 60;
                const increment = target / steps;
                let current = 0;
                
                const timer = setInterval(() => {
                  current += increment;
                  if (current >= target) {
                    current = target;
                    clearInterval(timer);
                  }
                  setCounters(prev => ({
                    ...prev,
                    [metric.number]: Math.floor(current)
                  }));
                }, duration / steps);
              });
            }
          }
        }
      });
    };
    
    window.addEventListener('scroll', handleScroll);
    handleScroll(); // Executar uma vez para elementos já visíveis
    return () => window.removeEventListener('scroll', handleScroll);
  }, [animatedElements]);

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

  const testimonials = [
    {
      name: 'Maria Silva',
      role: 'CEO, Silva Consultoria',
      content: 'O FinanceiroLogotiq revolucionou nossa gestão financeira. Agora temos controle total e economia de 15h por semana.',
      rating: 5
    },
    {
      name: 'João Santos',
      role: 'Proprietário, Santos Tech',
      content: 'Sistema intuitivo e completo. O CRM integrado é fantástico para acompanhar nossos clientes.',
      rating: 5
    },
    {
      name: 'Ana Costa',
      role: 'Diretora Financeira, Costa & Associados',
      content: 'Relatórios detalhados e dashboard em tempo real. Nossa lucratividade aumentou 30% em 3 meses.',
      rating: 5
    }
  ];

  const benefits = [
    {
      icon: Clock,
      title: 'Economize 15h por semana',
      description: 'Automatize processos financeiros e foque no que realmente importa'
    },
    {
      icon: TrendingUp,
      title: 'Aumente lucro em 25%',
      description: 'Insights em tempo real para tomar decisões mais inteligentes'
    },
    {
      icon: Shield,
      title: '100% Seguro e Confiável',
      description: 'Seus dados protegidos com criptografia de ponta a ponta'
    }
  ];

  const problems = [
    {
      icon: AlertTriangle,
      title: 'Controle financeiro desorganizado?',
      description: 'Planilhas espalhadas, dados desatualizados, relatórios confusos'
    },
    {
      icon: XCircle,
      title: 'Perdendo dinheiro sem saber?',
      description: 'Falta de visibilidade sobre receitas, despesas e lucros'
    },
    {
      icon: Clock,
      title: 'Tempo demais com burocracia?',
      description: 'Processos manuais, relatórios demorados, erros frequentes'
    }
  ];

  const solutions = [
    {
      icon: CheckCircle,
      title: 'Tudo organizado em um só lugar',
      description: 'Dashboard unificado com todas as informações financeiras'
    },
    {
      icon: TrendingUp,
      title: 'Insights em tempo real',
      description: 'Relatórios automáticos e alertas inteligentes'
    },
    {
      icon: Zap,
      title: 'Automação completa',
      description: 'Processos automatizados que economizam tempo'
    }
  ];

  const faqs = [
    {
      question: 'Como funciona o período de teste gratuito?',
      answer: 'Oferecemos 14 dias de teste gratuito sem compromisso. Você pode testar todas as funcionalidades sem cartão de crédito.'
    },
    {
      question: 'Posso cancelar a qualquer momento?',
      answer: 'Sim! Você pode cancelar sua assinatura a qualquer momento sem taxas ou multas.'
    },
    {
      question: 'Meus dados estão seguros?',
      answer: 'Absolutamente! Utilizamos criptografia de ponta a ponta e seguimos todas as normas de segurança e LGPD.'
    },
    {
      question: 'Oferecem suporte técnico?',
      answer: 'Sim! Oferecemos suporte por email, chat e telefone para todos os planos.'
    }
  ];

  const metrics = [
    { number: '500+', label: 'Empresas Atendidas', icon: Users },
    { number: '15h', label: 'Economia Semanal', icon: Clock },
    { number: '25%', label: 'Aumento de Lucro', icon: TrendingUp },
    { number: '99.9%', label: 'Uptime Garantido', icon: Shield }
  ];

  const integrations = [
    { name: 'Banco do Brasil', logo: '🏦' },
    { name: 'Itaú', logo: '🏦' },
    { name: 'Bradesco', logo: '🏦' },
    { name: 'Santander', logo: '🏦' },
    { name: 'Nubank', logo: '🟣' },
    { name: 'Inter', logo: '🟡' }
  ];

  const features = [
    {
      icon: BarChart3,
      title: 'Dashboard Intuitivo',
      description: 'Visualize todos os dados financeiros em um só lugar'
    },
    {
      icon: Users,
      title: 'CRM Integrado',
      description: 'Gerencie clientes e vendas em uma única plataforma'
    },
    {
      icon: FileText,
      title: 'Relatórios Automáticos',
      description: 'Relatórios detalhados gerados automaticamente'
    },
    {
      icon: Shield,
      title: 'Segurança Total',
      description: 'Seus dados protegidos com criptografia de ponta a ponta'
    },
    {
      icon: Zap,
      title: 'Automação Inteligente',
      description: 'Processos automatizados que economizam tempo'
    },
    {
      icon: Globe,
      title: 'Acesso Multiplataforma',
      description: 'Acesse de qualquer dispositivo, a qualquer hora'
    }
  ];

  const caseStudies = [
    {
      company: 'Silva Consultoria',
      industry: 'Consultoria',
      results: {
        timeSaved: '15h/semana',
        profitIncrease: '30%',
        clientsManaged: '150+'
      },
      testimonial: 'O FinanceiroLogotiq revolucionou nossa gestão financeira. Agora temos controle total e economia de 15h por semana.',
      before: 'Planilhas espalhadas, dados desatualizados',
      after: 'Dashboard unificado, dados em tempo real'
    },
    {
      company: 'Santos Tech',
      industry: 'Tecnologia',
      results: {
        timeSaved: '12h/semana',
        profitIncrease: '25%',
        clientsManaged: '80+'
      },
      testimonial: 'Sistema intuitivo e completo. O CRM integrado é fantástico para acompanhar nossos clientes.',
      before: 'Sistema desorganizado, perda de informações',
      after: 'Organização completa, informações centralizadas'
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-muted/30 to-background">
      <style>{`
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes fadeInLeft {
          from {
            opacity: 0;
            transform: translateX(-30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        
        @keyframes fadeInRight {
          from {
            opacity: 0;
            transform: translateX(30px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        
        @keyframes scaleIn {
          from {
            opacity: 0;
            transform: scale(0.9);
          }
          to {
            opacity: 1;
            transform: scale(1);
          }
        }
        
        @keyframes slideInUp {
          from {
            opacity: 0;
            transform: translateY(50px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        @keyframes pulse {
          0%, 100% {
            transform: scale(1);
          }
          50% {
            transform: scale(1.05);
          }
        }
        
        @keyframes float {
          0%, 100% {
            transform: translateY(0px);
          }
          50% {
            transform: translateY(-10px);
          }
        }
        
        @keyframes gradient {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }
        
        .animate-fade-in-up {
          animation: fadeInUp 0.8s ease-out forwards;
        }
        
        .animate-fade-in-left {
          animation: fadeInLeft 0.8s ease-out forwards;
        }
        
        .animate-fade-in-right {
          animation: fadeInRight 0.8s ease-out forwards;
        }
        
        .animate-scale-in {
          animation: scaleIn 0.6s ease-out forwards;
        }
        
        .animate-slide-in-up {
          animation: slideInUp 0.8s ease-out forwards;
        }
        
        .animate-pulse-slow {
          animation: pulse 3s ease-in-out infinite;
        }
        
        .animate-float {
          animation: float 3s ease-in-out infinite;
        }
        
        .animate-gradient {
          background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
          background-size: 400% 400%;
          animation: gradient 15s ease infinite;
        }
        
        .opacity-0 {
          opacity: 0;
        }
        
        .opacity-1 {
          opacity: 1;
        }
        
        .transition-all {
          transition: all 0.3s ease;
        }
        
        .hover-scale:hover {
          transform: scale(1.05);
        }
        
        .hover-lift:hover {
          transform: translateY(-5px);
        }
        
        .text-gradient {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
        
        .text-gradient-2 {
          background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
        
        .text-gradient-3 {
          background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }
      `}</style>
      {/* Fixed Navbar */}
      <header className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isNavbarScrolled ? 'bg-background/95 backdrop-blur-md border-b shadow-lg' : 'bg-transparent'
      }`}>
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center">
                <DollarSign className="w-5 h-5 text-primary-foreground" />
              </div>
              <h1 className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
                FinanceiroLogotiq
              </h1>
            </div>
            <div className="flex items-center space-x-4">
              <Button variant="ghost" onClick={() => document.getElementById('pricing')?.scrollIntoView({ behavior: 'smooth' })}>
                Planos
              </Button>
              <Button variant="ghost" onClick={() => document.getElementById('contact')?.scrollIntoView({ behavior: 'smooth' })}>
                Contato
              </Button>
              <Button onClick={() => navigate('/auth')}>
                Acessar Sistema
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="pt-20">
        <section className="container mx-auto px-4 py-20">
          <div 
            ref={(el) => sectionRefs.current['hero'] = el}
            className={`text-center max-w-4xl mx-auto mb-16 ${animatedElements.has('hero') ? 'animate-fade-in-up' : 'opacity-0'}`}
          >
            <Badge className="mb-4 bg-primary/10 text-primary border-primary/20 animate-pulse-slow">
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
                className="text-lg px-8 group hover-scale transition-all" 
                onClick={() => navigate('/auth')}
              >
                Começar Gratuitamente
                <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
              </Button>
              <Button 
                size="lg" 
                variant="outline" 
                className="text-lg px-8 group hover-scale transition-all"
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
            <div 
              ref={(el) => sectionRefs.current['problems'] = el}
              className={`text-center mb-16 ${animatedElements.has('problems') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Problemas que Resolvemos</h2>
              <p className="text-xl text-muted-foreground">Transforme seus desafios em oportunidades</p>
            </div>
            
            <div className="grid md:grid-cols-2 gap-16 mb-16">
              {/* Problems */}
              <div 
                ref={(el) => sectionRefs.current['problems-left'] = el}
                className={`${animatedElements.has('problems-left') ? 'animate-fade-in-left' : 'opacity-0'}`}
              >
                <h3 className="text-2xl font-bold mb-8 text-destructive">Antes</h3>
                <div className="space-y-6">
                  {problems.map((problem, index) => (
                    <div 
                      key={index} 
                      className="flex items-start space-x-4 p-4 rounded-lg bg-destructive/5 border border-destructive/10 hover-lift transition-all hover:shadow-lg"
                      style={{ animationDelay: `${index * 0.2}s` }}
                    >
                      <problem.icon className="w-6 h-6 text-destructive mt-1 flex-shrink-0" />
                      <div>
                        <h4 className="font-semibold text-destructive">{problem.title}</h4>
                        <p className="text-muted-foreground">{problem.description}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Solutions */}
              <div 
                ref={(el) => sectionRefs.current['solutions-right'] = el}
                className={`${animatedElements.has('solutions-right') ? 'animate-fade-in-right' : 'opacity-0'}`}
              >
                <h3 className="text-2xl font-bold mb-8 text-success">Depois</h3>
                <div className="space-y-6">
                  {solutions.map((solution, index) => (
                    <div 
                      key={index} 
                      className="flex items-start space-x-4 p-4 rounded-lg bg-success/5 border border-success/10 hover-lift transition-all hover:shadow-lg"
                      style={{ animationDelay: `${index * 0.2}s` }}
                    >
                      <solution.icon className="w-6 h-6 text-success mt-1 flex-shrink-0" />
                      <div>
                        <h4 className="font-semibold text-success">{solution.title}</h4>
                        <p className="text-muted-foreground">{solution.description}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Benefits Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['benefits'] = el}
              className={`text-center mb-16 ${animatedElements.has('benefits') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Por que escolher o FinanceiroLogotiq?</h2>
              <p className="text-xl text-muted-foreground">Resultados comprovados por centenas de empresas</p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8 mb-16">
              {benefits.map((benefit, index) => (
                <Card 
                  key={index} 
                  ref={(el) => sectionRefs.current[`benefit-${index}`] = el}
                  className={`text-center p-6 hover-scale transition-all duration-300 hover:shadow-lg ${animatedElements.has(`benefit-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.2}s` }}
                >
                  <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4 animate-float">
                    <benefit.icon className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{benefit.title}</h3>
                  <p className="text-muted-foreground">{benefit.description}</p>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* Features Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['features'] = el}
              className={`text-center mb-16 ${animatedElements.has('features') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Funcionalidades Completas</h2>
              <p className="text-xl text-muted-foreground">Tudo que você precisa para gerenciar suas finanças</p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8 mb-16">
              {features.map((feature, index) => (
                <Card 
                  key={index} 
                  ref={(el) => sectionRefs.current[`feature-${index}`] = el}
                  className={`text-center p-6 hover-scale transition-all duration-300 hover:shadow-lg ${animatedElements.has(`feature-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.1}s` }}
                >
                  <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                    <feature.icon className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-semibold mb-2">{feature.title}</h3>
                  <p className="text-muted-foreground">{feature.description}</p>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* Demo/Preview Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['demo'] = el}
              className={`text-center mb-16 ${animatedElements.has('demo') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Veja o Sistema em Ação</h2>
              <p className="text-xl text-muted-foreground">Dashboard intuitivo e funcionalidades poderosas</p>
            </div>
            
            <div className="max-w-6xl mx-auto">
              <Card className="p-8">
                <div className="aspect-video bg-gradient-to-br from-primary/10 to-secondary/10 rounded-lg flex items-center justify-center">
                  <div className="text-center">
                    <Play className="w-16 h-16 text-primary mx-auto mb-4" />
                    <p className="text-lg font-semibold">Demo Interativo</p>
                    <p className="text-muted-foreground">Clique para ver o sistema funcionando</p>
                  </div>
                </div>
              </Card>
            </div>
          </div>
        </section>

        {/* Metrics Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['metrics'] = el}
              className={`text-center mb-16 ${animatedElements.has('metrics') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Números que Impressionam</h2>
              <p className="text-xl text-muted-foreground">Resultados reais de empresas que confiam em nós</p>
            </div>
            
            <div className="grid md:grid-cols-4 gap-8">
              {metrics.map((metric, index) => (
                <div 
                  key={index} 
                  ref={(el) => sectionRefs.current[`metric-${index}`] = el}
                  className={`text-center p-6 rounded-lg bg-white shadow-lg hover-lift transition-all ${animatedElements.has(`metric-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.2}s` }}
                >
                  <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
                    <metric.icon className="w-8 h-8 text-primary" />
                  </div>
                  <div className="text-4xl font-bold text-primary mb-2">
                    {counters[metric.number] || 0}
                    {metric.number.includes('+') && '+'}
                    {metric.number.includes('%') && '%'}
                    {metric.number.includes('h') && 'h'}
                  </div>
                  <div className="text-muted-foreground font-medium">{metric.label}</div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Integrations Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['integrations'] = el}
              className={`text-center mb-16 ${animatedElements.has('integrations') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Integrações Disponíveis</h2>
              <p className="text-xl text-muted-foreground">Conecte-se com os principais bancos e serviços</p>
            </div>
            
            <div className="grid md:grid-cols-6 gap-8 mb-16">
              {integrations.map((integration, index) => (
                <div 
                  key={index} 
                  ref={(el) => sectionRefs.current[`integration-${index}`] = el}
                  className={`text-center p-4 rounded-lg bg-white shadow-md hover-lift transition-all ${animatedElements.has(`integration-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.1}s` }}
                >
                  <div className="text-3xl mb-2">{integration.logo}</div>
                  <div className="text-sm font-medium text-muted-foreground">{integration.name}</div>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Testimonials Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['testimonials'] = el}
              className={`text-center mb-16 ${animatedElements.has('testimonials') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">O que nossos clientes dizem</h2>
              <p className="text-xl text-muted-foreground">Depoimentos reais de quem já transformou sua gestão</p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8">
              {testimonials.map((testimonial, index) => (
                <Card 
                  key={index} 
                  ref={(el) => sectionRefs.current[`testimonial-${index}`] = el}
                  className={`p-6 hover-lift transition-all ${animatedElements.has(`testimonial-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.2}s` }}
                >
                  <div className="flex mb-4">
                    {[...Array(testimonial.rating)].map((_, i) => (
                      <Star key={i} className="w-4 h-4 text-yellow-400 fill-current" />
                    ))}
                  </div>
                  <p className="text-muted-foreground mb-4 italic">"{testimonial.content}"</p>
                  <div>
                    <div className="font-semibold">{testimonial.name}</div>
                    <div className="text-sm text-muted-foreground">{testimonial.role}</div>
                  </div>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* Case Studies Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['case-studies'] = el}
              className={`text-center mb-16 ${animatedElements.has('case-studies') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Casos de Sucesso</h2>
              <p className="text-xl text-muted-foreground">Veja como empresas reais transformaram suas finanças</p>
            </div>
            
            <div className="space-y-12">
              {caseStudies.map((study, index) => (
                <Card 
                  key={index} 
                  ref={(el) => sectionRefs.current[`case-study-${index}`] = el}
                  className={`p-8 hover-lift transition-all ${animatedElements.has(`case-study-${index}`) ? 'animate-scale-in' : 'opacity-0'}`}
                  style={{ animationDelay: `${index * 0.3}s` }}
                >
                  <div className="grid md:grid-cols-2 gap-8">
                    <div>
                      <div className="flex items-center mb-4">
                        <div className="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center mr-4">
                          <Building className="w-6 h-6 text-primary" />
                        </div>
                        <div>
                          <h3 className="text-xl font-bold">{study.company}</h3>
                          <p className="text-muted-foreground">{study.industry}</p>
                        </div>
                      </div>
                      
                      <div className="grid grid-cols-3 gap-4 mb-6">
                        <div className="text-center p-3 bg-success/10 rounded-lg">
                          <div className="text-2xl font-bold text-success">{study.results.timeSaved}</div>
                          <div className="text-sm text-muted-foreground">Tempo Economizado</div>
                        </div>
                        <div className="text-center p-3 bg-primary/10 rounded-lg">
                          <div className="text-2xl font-bold text-primary">{study.results.profitIncrease}</div>
                          <div className="text-sm text-muted-foreground">Aumento de Lucro</div>
                        </div>
                        <div className="text-center p-3 bg-info/10 rounded-lg">
                          <div className="text-2xl font-bold text-info">{study.results.clientsManaged}</div>
                          <div className="text-sm text-muted-foreground">Clientes Gerenciados</div>
                        </div>
                      </div>
                      
                      <p className="text-muted-foreground italic mb-4">"{study.testimonial}"</p>
                    </div>
                    
                    <div>
                      <div className="grid grid-cols-2 gap-4">
                        <div className="p-4 bg-destructive/5 border border-destructive/10 rounded-lg">
                          <h4 className="font-semibold text-destructive mb-2">Antes</h4>
                          <p className="text-sm text-muted-foreground">{study.before}</p>
                        </div>
                        <div className="p-4 bg-success/5 border border-success/10 rounded-lg">
                          <h4 className="font-semibold text-success mb-2">Depois</h4>
                          <p className="text-sm text-muted-foreground">{study.after}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* Security Section */}
        <section className="py-20 bg-muted/30">
          <div className="container mx-auto px-4">
            <div 
              ref={(el) => sectionRefs.current['security'] = el}
              className={`text-center mb-16 ${animatedElements.has('security') ? 'animate-fade-in-up' : 'opacity-0'}`}
            >
              <h2 className="text-3xl font-bold mb-4">Segurança e Confiança</h2>
              <p className="text-xl text-muted-foreground">Seus dados protegidos com a mais alta tecnologia</p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8">
              <Card 
                ref={(el) => sectionRefs.current['security-1'] = el}
                className={`text-center p-6 hover-lift transition-all ${animatedElements.has('security-1') ? 'animate-scale-in' : 'opacity-0'}`}
                style={{ animationDelay: '0s' }}
              >
                <Lock className="w-12 h-12 text-primary mx-auto mb-4" />
                <h3 className="text-xl font-semibold mb-2">Criptografia SSL</h3>
                <p className="text-muted-foreground">Dados protegidos com criptografia de ponta a ponta</p>
              </Card>
              <Card 
                ref={(el) => sectionRefs.current['security-2'] = el}
                className={`text-center p-6 hover-lift transition-all ${animatedElements.has('security-2') ? 'animate-scale-in' : 'opacity-0'}`}
                style={{ animationDelay: '0.2s' }}
              >
                <Database className="w-12 h-12 text-primary mx-auto mb-4" />
                <h3 className="text-xl font-semibold mb-2">Backup Automático</h3>
                <p className="text-muted-foreground">Backup diário automático em servidores seguros</p>
              </Card>
              <Card 
                ref={(el) => sectionRefs.current['security-3'] = el}
                className={`text-center p-6 hover-lift transition-all ${animatedElements.has('security-3') ? 'animate-scale-in' : 'opacity-0'}`}
                style={{ animationDelay: '0.4s' }}
              >
                <Headphones className="w-12 h-12 text-primary mx-auto mb-4" />
                <h3 className="text-xl font-semibold mb-2">Suporte 24/7</h3>
                <p className="text-muted-foreground">Equipe especializada disponível quando você precisar</p>
              </Card>
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
              {plans.map((plan) => (
                <Card key={plan.name} className={`relative hover:shadow-xl transition-all duration-300 hover:-translate-y-2 ${plan.popular ? 'ring-2 ring-primary' : ''}`}>
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
                      className="w-full group" 
                      size="lg"
                      onClick={() => navigate('/auth')}
                    >
                      {plan.buttonText}
                      <ArrowRight className="w-4 h-4 ml-2 group-hover:translate-x-1 transition-transform" />
                    </Button>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* FAQ Section */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-3xl font-bold mb-4">Perguntas Frequentes</h2>
              <p className="text-xl text-muted-foreground">Tire suas dúvidas sobre nossa plataforma</p>
            </div>
            
            <div className="max-w-3xl mx-auto space-y-4">
              {faqs.map((faq, index) => (
                <Card key={index} className="overflow-hidden">
                  <button
                    className="w-full p-6 text-left flex items-center justify-between hover:bg-muted/50 transition-colors"
                    onClick={() => setOpenFaq(openFaq === index ? null : index)}
                  >
                    <h3 className="font-semibold">{faq.question}</h3>
                    {openFaq === index ? (
                      <ChevronUp className="w-5 h-5 text-muted-foreground" />
                    ) : (
                      <ChevronDown className="w-5 h-5 text-muted-foreground" />
                    )}
                  </button>
                  {openFaq === index && (
                    <div className="px-6 pb-6">
                      <p className="text-muted-foreground">{faq.answer}</p>
                    </div>
                  )}
                </Card>
              ))}
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
              <Button size="lg" variant="secondary" className="text-lg px-8 group" onClick={() => navigate('/auth')}>
                <Rocket className="w-4 h-4 mr-2" />
                Começar Gratuitamente
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
                <span className="text-lg font-bold">FinanceiroLogotiq</span>
              </div>
              <p className="text-muted-foreground mb-4">
                A plataforma mais completa para gestão financeira empresarial.
              </p>
              <div className="flex space-x-4">
                <Button variant="ghost" size="sm">
                  <Mail className="w-4 h-4" />
                </Button>
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
                © 2024 FinanceiroLogotiq. Todos os direitos reservados.
              </span>
            </div>
            <div className="flex space-x-6 text-sm text-muted-foreground">
              <a href="#" className="hover:text-foreground transition-colors">Privacidade</a>
              <a href="#" className="hover:text-foreground transition-colors">Termos</a>
              <a href="#" className="hover:text-foreground transition-colors">Cookies</a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
