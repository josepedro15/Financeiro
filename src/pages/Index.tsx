import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';

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
      {/* Simple Header */}
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
                    <span className="text-primary-foreground font-bold">F</span>
                  </div>
                  <h1 className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
                    FinanceiroLogotiq
                  </h1>
                </div>
              </Button>
            </div>
            <div className="flex items-center space-x-4">
              <Button onClick={() => navigate(user ? '/dashboard' : '/auth')}>
                {user ? 'Dashboard' : 'Acessar Sistema'}
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Simple Hero */}
      <main className="pt-20">
        <section className="container mx-auto px-4 py-20">
          <div className="text-center max-w-4xl mx-auto mb-16">
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
                className="text-lg px-8" 
                onClick={() => navigate(user ? '/dashboard' : '/auth')}
              >
                {user ? 'Acessar Dashboard' : 'Começar Gratuitamente'}
              </Button>
            </div>
          </div>
        </section>

        {/* Simple Benefits */}
        <section className="py-20">
          <div className="container mx-auto px-4">
            <div className="text-center mb-16">
              <h2 className="text-4xl font-bold mb-4">Por que escolher nossa plataforma?</h2>
              <p className="text-lg text-muted-foreground">Recursos poderosos para impulsionar seu negócio</p>
            </div>
            <div className="grid md:grid-cols-3 gap-8">
              <div className="text-center p-6">
                <div className="w-16 h-16 bg-primary/10 rounded-xl mx-auto mb-4 flex items-center justify-center">
                  <span className="text-2xl">💰</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Controle Total</h3>
                <p className="text-muted-foreground">Gerencie receitas, despesas e fluxo de caixa com precisão</p>
              </div>
              <div className="text-center p-6">
                <div className="w-16 h-16 bg-primary/10 rounded-xl mx-auto mb-4 flex items-center justify-center">
                  <span className="text-2xl">📊</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Relatórios Avançados</h3>
                <p className="text-muted-foreground">Insights detalhados para tomada de decisões estratégicas</p>
              </div>
              <div className="text-center p-6">
                <div className="w-16 h-16 bg-primary/10 rounded-xl mx-auto mb-4 flex items-center justify-center">
                  <span className="text-2xl">🔒</span>
                </div>
                <h3 className="text-xl font-semibold mb-2">Segurança Garantida</h3>
                <p className="text-muted-foreground">Seus dados protegidos com criptografia de ponta a ponta</p>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
};

export default Index;
