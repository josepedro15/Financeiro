import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  ArrowLeft, 
  DollarSign, 
  Shield, 
  FileText, 
  Users, 
  Lock,
  Calendar,
  AlertTriangle,
  CheckCircle,
  XCircle,
  Settings,
  Eye,
  Database,
  Globe,
  Cookie,
  Info
} from 'lucide-react';

const Cookies = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-muted/30 to-background">
      {/* Header */}
      <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
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
            
            <Button variant="outline" onClick={() => navigate('/')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Voltar ao Início
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-12">
        <div className="max-w-4xl mx-auto">
          {/* Page Header */}
          <div className="text-center mb-12">
            <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
              <Cookie className="w-8 h-8 text-primary" />
            </div>
            <h1 className="text-4xl font-bold mb-4">Política de Cookies</h1>
            <p className="text-xl text-muted-foreground">
              Última atualização: {new Date().toLocaleDateString('pt-BR')}
            </p>
          </div>

          {/* Cookies Content */}
          <div className="space-y-8">
            {/* 1. O que são Cookies */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Cookie className="w-5 h-5 text-primary" />
                  1. O que são Cookies?
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Cookies são pequenos arquivos de texto que são armazenados no seu dispositivo (computador, 
                  tablet ou smartphone) quando você visita nosso site. Eles nos ajudam a melhorar sua experiência 
                  e fornecer funcionalidades personalizadas.
                </p>
                <div className="bg-muted/50 p-4 rounded-lg">
                  <p className="text-sm font-medium">
                    <Info className="w-4 h-4 inline mr-2 text-primary" />
                    Os cookies não contêm informações pessoais identificáveis e não podem executar código ou 
                    transmitir vírus para seu dispositivo.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 2. Tipos de Cookies que Utilizamos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Settings className="w-5 h-5 text-primary" />
                  2. Tipos de Cookies que Utilizamos
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid md:grid-cols-2 gap-6">
                  {/* Cookies Essenciais */}
                  <div className="p-4 bg-success/5 border border-success/10 rounded-lg">
                    <div className="flex items-center gap-2 mb-3">
                      <Shield className="w-5 h-5 text-success" />
                      <h4 className="font-semibold text-success">Cookies Essenciais</h4>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">
                      Necessários para o funcionamento básico do site. Não podem ser desativados.
                    </p>
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      <li>• Autenticação e sessão</li>
                      <li>• Segurança e proteção</li>
                      <li>• Preferências básicas</li>
                      <li>• Funcionalidades essenciais</li>
                    </ul>
                  </div>

                  {/* Cookies de Performance */}
                  <div className="p-4 bg-primary/5 border border-primary/10 rounded-lg">
                    <div className="flex items-center gap-2 mb-3">
                      <Eye className="w-5 h-5 text-primary" />
                      <h4 className="font-semibold text-primary">Cookies de Performance</h4>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">
                      Nos ajudam a entender como você usa o site para melhorar a experiência.
                    </p>
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      <li>• Análise de uso do site</li>
                      <li>• Métricas de performance</li>
                      <li>• Identificação de problemas</li>
                      <li>• Otimização de funcionalidades</li>
                    </ul>
                  </div>

                  {/* Cookies de Funcionalidade */}
                  <div className="p-4 bg-secondary/5 border border-secondary/10 rounded-lg">
                    <div className="flex items-center gap-2 mb-3">
                      <Settings className="w-5 h-5 text-secondary" />
                      <h4 className="font-semibold text-secondary">Cookies de Funcionalidade</h4>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">
                      Permitem que o site lembre suas escolhas e forneça funcionalidades aprimoradas.
                    </p>
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      <li>• Preferências de idioma</li>
                      <li>• Configurações de tema</li>
                      <li>• Lembrança de login</li>
                      <li>• Personalização da interface</li>
                    </ul>
                  </div>

                  {/* Cookies de Marketing */}
                  <div className="p-4 bg-warning/5 border border-warning/10 rounded-lg">
                    <div className="flex items-center gap-2 mb-3">
                      <Globe className="w-5 h-5 text-warning" />
                      <h4 className="font-semibold text-warning">Cookies de Marketing</h4>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">
                      Usados para rastrear visitantes e mostrar anúncios relevantes.
                    </p>
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      <li>• Anúncios personalizados</li>
                      <li>• Redes sociais</li>
                      <li>• Análise de campanhas</li>
                      <li>• Remarketing</li>
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 3. Cookies Específicos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Database className="w-5 h-5 text-primary" />
                  3. Cookies Específicos do Financeiro
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="overflow-x-auto">
                  <table className="w-full text-sm">
                    <thead>
                      <tr className="border-b">
                        <th className="text-left py-2 font-semibold">Nome do Cookie</th>
                        <th className="text-left py-2 font-semibold">Finalidade</th>
                        <th className="text-left py-2 font-semibold">Duração</th>
                        <th className="text-left py-2 font-semibold">Tipo</th>
                      </tr>
                    </thead>
                    <tbody className="space-y-2">
                      <tr className="border-b border-muted">
                        <td className="py-2 font-mono text-xs">auth_token</td>
                        <td className="py-2">Autenticação e sessão do usuário</td>
                        <td className="py-2">30 dias</td>
                        <td className="py-2"><Badge variant="secondary">Essencial</Badge></td>
                      </tr>
                      <tr className="border-b border-muted">
                        <td className="py-2 font-mono text-xs">user_preferences</td>
                        <td className="py-2">Preferências de interface e configurações</td>
                        <td className="py-2">1 ano</td>
                        <td className="py-2"><Badge variant="outline">Funcionalidade</Badge></td>
                      </tr>
                      <tr className="border-b border-muted">
                        <td className="py-2 font-mono text-xs">analytics_id</td>
                        <td className="py-2">Análise de uso e métricas de performance</td>
                        <td className="py-2">2 anos</td>
                        <td className="py-2"><Badge variant="default">Performance</Badge></td>
                      </tr>
                      <tr className="border-b border-muted">
                        <td className="py-2 font-mono text-xs">marketing_tracker</td>
                        <td className="py-2">Rastreamento de campanhas de marketing</td>
                        <td className="py-2">90 dias</td>
                        <td className="py-2"><Badge variant="destructive">Marketing</Badge></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </CardContent>
            </Card>

            {/* 4. Cookies de Terceiros */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-primary" />
                  4. Cookies de Terceiros
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Utilizamos serviços de terceiros que podem definir cookies em seu dispositivo:
                </p>
                
                <div className="space-y-4">
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Google Analytics</h4>
                    <p className="text-sm text-muted-foreground mb-2">
                      Para análise de tráfego e comportamento dos usuários.
                    </p>
                    <div className="flex gap-2">
                      <Badge variant="outline">_ga</Badge>
                      <Badge variant="outline">_gid</Badge>
                      <Badge variant="outline">_gat</Badge>
                    </div>
                  </div>

                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Supabase</h4>
                    <p className="text-sm text-muted-foreground mb-2">
                      Para autenticação e gerenciamento de dados.
                    </p>
                    <div className="flex gap-2">
                      <Badge variant="outline">sb-*</Badge>
                      <Badge variant="outline">supabase-*</Badge>
                    </div>
                  </div>

                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Vercel</h4>
                    <p className="text-sm text-muted-foreground mb-2">
                      Para hospedagem e análise de performance.
                    </p>
                    <div className="flex gap-2">
                      <Badge variant="outline">_vercel</Badge>
                      <Badge variant="outline">vercel-*</Badge>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 5. Controle de Cookies */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Settings className="w-5 h-5 text-primary" />
                  5. Como Controlar os Cookies
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Você tem controle total sobre os cookies. Aqui estão suas opções:
                </p>
                
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <h4 className="font-semibold mb-3 text-success">Configurações do Navegador</h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                        Bloquear todos os cookies
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                        Permitir apenas cookies essenciais
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                        Excluir cookies existentes
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                        Configurar notificações
                      </li>
                    </ul>
                  </div>
                  
                  <div>
                    <h4 className="font-semibold mb-3 text-primary">Configurações do Site</h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                        Painel de preferências
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                        Opt-out de marketing
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                        Configurações de privacidade
                      </li>
                      <li className="flex items-start gap-2">
                        <CheckCircle className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                        Solicitar exclusão de dados
                      </li>
                    </ul>
                  </div>
                </div>

                <div className="bg-warning/5 border border-warning/10 p-4 rounded-lg">
                  <p className="text-sm text-warning-foreground">
                    <AlertTriangle className="w-4 h-4 inline mr-2" />
                    <strong>Atenção:</strong> Desabilitar cookies essenciais pode afetar o funcionamento do site. 
                    Recomendamos manter pelo menos os cookies essenciais ativos.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 6. Atualizações da Política */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary" />
                  6. Atualizações desta Política
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Esta política pode ser atualizada periodicamente para refletir mudanças em nossas práticas 
                  ou por outros motivos operacionais, legais ou regulamentares.
                </p>
                
                <div className="bg-muted/50 p-4 rounded-lg">
                  <h4 className="font-semibold mb-2">Notificações de Mudanças</h4>
                  <ul className="space-y-1 text-sm text-muted-foreground">
                    <li>• Notificação por email para usuários registrados</li>
                    <li>• Aviso no site por 30 dias</li>
                    <li>• Atualização da data de "última modificação"</li>
                    <li>• Revisão obrigatória antes de mudanças significativas</li>
                  </ul>
                </div>
              </CardContent>
            </Card>

            {/* 7. Contato */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  7. Dúvidas sobre Cookies
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Se você tiver dúvidas sobre nossa política de cookies, entre em contato:
                </p>
                
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Suporte Técnico</h4>
                    <p className="text-sm text-muted-foreground">
                      Email: suporte@financeiro.com<br />
                      Para questões técnicas sobre cookies
                    </p>
                  </div>
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Privacidade</h4>
                    <p className="text-sm text-muted-foreground">
                      Email: privacidade@financeiro.com<br />
                      Para questões sobre proteção de dados
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Footer */}
          <div className="text-center mt-12 pt-8 border-t">
            <p className="text-muted-foreground mb-4">
              Esta política de cookies é parte integrante dos nossos Termos de Uso.
            </p>
            <div className="flex gap-4 justify-center">
              <Button variant="outline" onClick={() => navigate('/terms')}>
                <FileText className="w-4 h-4 mr-2" />
                Ver Termos de Uso
              </Button>
              <Button onClick={() => navigate('/')}>
                <ArrowLeft className="w-4 h-4 mr-2" />
                Voltar ao Início
              </Button>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Cookies;
