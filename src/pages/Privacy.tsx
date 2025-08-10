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
  Eye,
  Database,
  Globe,
  Mail,
  Phone,
  MapPin,
  Building,
  UserCheck,
  Key,
  Server,
  Zap,
  Heart
} from 'lucide-react';

const Privacy = () => {
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
                  FinanceiroLogotiq
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
              <Shield className="w-8 h-8 text-primary" />
            </div>
            <h1 className="text-4xl font-bold mb-4">Política de Privacidade</h1>
            <p className="text-xl text-muted-foreground">
              Como protegemos e utilizamos seus dados pessoais
            </p>
            <div className="mt-4 flex items-center justify-center gap-2">
              <Badge variant="secondary" className="bg-success/10 text-success">
                <CheckCircle className="w-3 h-3 mr-1" />
                Conforme LGPD
              </Badge>
              <Badge variant="secondary" className="bg-primary/10 text-primary">
                <Lock className="w-3 h-3 mr-1" />
                Dados Protegidos
              </Badge>
            </div>
          </div>

          {/* Privacy Content */}
          <div className="space-y-8">
            {/* 1. Introdução */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary" />
                  1. Introdução
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  A <strong>FinanceiroLogotiq</strong> está comprometida em proteger sua privacidade e garantir a segurança de seus dados pessoais. 
                  Esta Política de Privacidade explica como coletamos, usamos, armazenamos e protegemos suas informações.
                </p>
                <div className="bg-primary/5 p-4 rounded-lg">
                  <p className="text-sm">
                    <strong>Última atualização:</strong> {new Date().toLocaleDateString('pt-BR')}
                  </p>
                  <p className="text-sm text-muted-foreground mt-1">
                    Esta política está em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018).
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 2. Dados que Coletamos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Database className="w-5 h-5 text-primary" />
                  2. Dados que Coletamos
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <h4 className="font-semibold mb-3 flex items-center gap-2">
                      <UserCheck className="w-4 h-4 text-primary" />
                      Dados Pessoais
                    </h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• Nome completo</li>
                      <li>• Endereço de e-mail</li>
                      <li>• Senha (criptografada)</li>
                      <li>• Informações de perfil</li>
                      <li>• Preferências de uso</li>
                    </ul>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-3 flex items-center gap-2">
                      <Globe className="w-4 h-4 text-primary" />
                      Dados de Uso
                    </h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• Páginas visitadas</li>
                      <li>• Tempo de permanência</li>
                      <li>• Dispositivo utilizado</li>
                      <li>• Navegador e sistema operacional</li>
                      <li>• Endereço IP (anonimizado)</li>
                    </ul>
                  </div>
                </div>
                <div className="bg-warning/5 p-4 rounded-lg border border-warning/10">
                  <div className="flex items-start gap-2">
                    <AlertTriangle className="w-4 h-4 text-warning mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-medium text-warning">Dados Sensíveis</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        <strong>Não coletamos:</strong> dados biométricos, informações médicas, dados genéticos, 
                        opinião política, filiação sindical, dados sobre saúde ou vida sexual.
                      </p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 3. Como Usamos seus Dados */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Zap className="w-5 h-5 text-primary" />
                  3. Como Usamos seus Dados
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid md:grid-cols-2 gap-6">
                  <div className="space-y-4">
                    <div className="p-4 bg-primary/5 rounded-lg">
                      <h4 className="font-semibold mb-2 flex items-center gap-2">
                        <CheckCircle className="w-4 h-4 text-success" />
                        Finalidades Principais
                      </h4>
                      <ul className="space-y-1 text-sm text-muted-foreground">
                        <li>• Fornecer nossos serviços</li>
                        <li>• Processar transações financeiras</li>
                        <li>• Gerenciar sua conta</li>
                        <li>• Enviar comunicações importantes</li>
                        <li>• Melhorar nossos serviços</li>
                      </ul>
                    </div>
                  </div>
                  <div className="space-y-4">
                    <div className="p-4 bg-secondary/5 rounded-lg">
                      <h4 className="font-semibold mb-2 flex items-center gap-2">
                        <Eye className="w-4 h-4 text-secondary" />
                        Finalidades Secundárias
                      </h4>
                      <ul className="space-y-1 text-sm text-muted-foreground">
                        <li>• Análise de uso e performance</li>
                        <li>• Personalização da experiência</li>
                        <li>• Marketing (com consentimento)</li>
                        <li>• Pesquisa e desenvolvimento</li>
                        <li>• Conformidade legal</li>
                      </ul>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 4. Compartilhamento de Dados */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  4. Compartilhamento de Dados
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Seus dados pessoais são tratados com a máxima confidencialidade. Compartilhamos informações apenas nas seguintes situações:
                </p>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-success/5 rounded-lg border border-success/10">
                    <h4 className="font-semibold mb-2 text-success">Com seu Consentimento</h4>
                    <p className="text-sm text-muted-foreground">
                      Apenas quando você autorizar explicitamente o compartilhamento.
                    </p>
                  </div>
                  <div className="p-4 bg-warning/5 rounded-lg border border-warning/10">
                    <h4 className="font-semibold mb-2 text-warning">Por Obrigação Legal</h4>
                    <p className="text-sm text-muted-foreground">
                      Quando exigido por lei, ordem judicial ou autoridade competente.
                    </p>
                  </div>
                  <div className="p-4 bg-info/5 rounded-lg border border-info/10">
                    <h4 className="font-semibold mb-2 text-info">Prestadores de Serviço</h4>
                    <p className="text-sm text-muted-foreground">
                      Empresas que nos ajudam a fornecer nossos serviços (hosting, pagamentos, etc.).
                    </p>
                  </div>
                  <div className="p-4 bg-destructive/5 rounded-lg border border-destructive/10">
                    <h4 className="font-semibold mb-2 text-destructive">Proteção de Direitos</h4>
                    <p className="text-sm text-muted-foreground">
                      Para proteger nossos direitos, propriedade ou segurança.
                    </p>
                  </div>
                </div>
                <div className="bg-primary/5 p-4 rounded-lg">
                  <p className="text-sm font-medium">
                    <strong>Nunca vendemos, alugamos ou comercializamos seus dados pessoais.</strong>
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 5. Armazenamento e Segurança */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Server className="w-5 h-5 text-primary" />
                  5. Armazenamento e Segurança
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid md:grid-cols-2 gap-6">
                  <div>
                    <h4 className="font-semibold mb-3 flex items-center gap-2">
                      <Lock className="w-4 h-4 text-success" />
                      Medidas de Segurança
                    </h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• Criptografia SSL/TLS</li>
                      <li>• Senhas criptografadas</li>
                      <li>• Backup seguro</li>
                      <li>• Monitoramento 24/7</li>
                      <li>• Acesso restrito aos dados</li>
                      <li>• Auditorias regulares</li>
                    </ul>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-3 flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-info" />
                      Período de Retenção
                    </h4>
                    <ul className="space-y-2 text-sm text-muted-foreground">
                      <li>• <strong>Dados da conta:</strong> Enquanto ativa</li>
                      <li>• <strong>Dados de uso:</strong> 2 anos</li>
                      <li>• <strong>Logs de segurança:</strong> 1 ano</li>
                      <li>• <strong>Dados de pagamento:</strong> 5 anos (legal)</li>
                      <li>• <strong>Dados deletados:</strong> 30 dias (backup)</li>
                    </ul>
                  </div>
                </div>
                <div className="bg-success/5 p-4 rounded-lg border border-success/10">
                  <div className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-medium text-success">Infraestrutura Segura</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Utilizamos a <strong>Supabase</strong> e <strong>Vercel</strong> como provedores de infraestrutura, 
                        que possuem certificações de segurança internacionais e estão em conformidade com as melhores práticas da indústria.
                      </p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 6. Seus Direitos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Key className="w-5 h-5 text-primary" />
                  6. Seus Direitos (LGPD)
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Conforme a Lei Geral de Proteção de Dados (LGPD), você tem os seguintes direitos:
                </p>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-3 bg-primary/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Acesso</h4>
                    <p className="text-sm text-muted-foreground">
                      Solicitar informações sobre quais dados temos sobre você.
                    </p>
                  </div>
                  <div className="p-3 bg-secondary/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Correção</h4>
                    <p className="text-sm text-muted-foreground">
                      Corrigir dados incompletos, inexatos ou desatualizados.
                    </p>
                  </div>
                  <div className="p-3 bg-success/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Portabilidade</h4>
                    <p className="text-sm text-muted-foreground">
                      Receber seus dados em formato estruturado e interoperável.
                    </p>
                  </div>
                  <div className="p-3 bg-warning/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Eliminação</h4>
                    <p className="text-sm text-muted-foreground">
                      Solicitar a exclusão de seus dados pessoais.
                    </p>
                  </div>
                  <div className="p-3 bg-info/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Revogação</h4>
                    <p className="text-sm text-muted-foreground">
                      Revogar o consentimento a qualquer momento.
                    </p>
                  </div>
                  <div className="p-3 bg-destructive/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Oposição</h4>
                    <p className="text-sm text-muted-foreground">
                      Opor-se ao tratamento de seus dados pessoais.
                    </p>
                  </div>
                </div>
                <div className="bg-primary/5 p-4 rounded-lg">
                  <p className="text-sm">
                    <strong>Para exercer seus direitos:</strong> Entre em contato conosco através do e-mail: 
                    <a href="mailto:privacidade@financeirologotiq.com" className="text-primary hover:underline ml-1">
                      privacidade@financeirologotiq.com
                    </a>
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 7. Cookies */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary" />
                  7. Cookies e Tecnologias Similares
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Utilizamos cookies e tecnologias similares para melhorar sua experiência em nosso site.
                </p>
                <div className="grid md:grid-cols-3 gap-4">
                  <div className="p-4 bg-success/5 rounded-lg border border-success/10">
                    <h4 className="font-semibold mb-2 text-success">Essenciais</h4>
                    <p className="text-sm text-muted-foreground">
                      Necessários para o funcionamento básico do site.
                    </p>
                  </div>
                  <div className="p-4 bg-primary/5 rounded-lg border border-primary/10">
                    <h4 className="font-semibold mb-2 text-primary">Analytics</h4>
                    <p className="text-sm text-muted-foreground">
                      Nos ajudam a entender como você usa o site.
                    </p>
                  </div>
                  <div className="p-4 bg-warning/5 rounded-lg border border-warning/10">
                    <h4 className="font-semibold mb-2 text-warning">Marketing</h4>
                    <p className="text-sm text-muted-foreground">
                      Usados para mostrar anúncios relevantes.
                    </p>
                  </div>
                </div>
                <div className="bg-secondary/5 p-4 rounded-lg">
                  <p className="text-sm">
                    <strong>Controle de Cookies:</strong> Você pode gerenciar suas preferências de cookies através da 
                    <a href="/cookies" className="text-primary hover:underline ml-1">
                      nossa página de política de cookies
                    </a>.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 8. Menores de Idade */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  8. Proteção de Menores
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="bg-warning/5 p-4 rounded-lg border border-warning/10">
                  <div className="flex items-start gap-2">
                    <AlertTriangle className="w-4 h-4 text-warning mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-medium text-warning">Idade Mínima</p>
                      <p className="text-sm text-muted-foreground mt-1">
                        Nossos serviços são destinados a pessoas com <strong>18 anos ou mais</strong>. 
                        Não coletamos intencionalmente dados pessoais de menores de idade.
                      </p>
                    </div>
                  </div>
                </div>
                <p className="text-muted-foreground">
                  Se você é pai, mãe ou responsável legal e descobrir que seu filho nos forneceu dados pessoais, 
                  entre em contato conosco imediatamente para que possamos tomar as medidas necessárias.
                </p>
              </CardContent>
            </Card>

            {/* 9. Transferências Internacionais */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-primary" />
                  9. Transferências Internacionais
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Seus dados podem ser processados em servidores localizados fora do Brasil. 
                  Garantimos que todas as transferências internacionais seguem as melhores práticas de segurança.
                </p>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-primary/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Provedores Utilizados</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Supabase (Estados Unidos)</li>
                      <li>• Vercel (Estados Unidos)</li>
                      <li>• Google Analytics (Estados Unidos)</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-success/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Proteções Garantidas</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Acordos de proteção de dados</li>
                      <li>• Certificações de segurança</li>
                      <li>• Conformidade com LGPD</li>
                      <li>• Cláusulas contratuais padrão</li>
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 10. Alterações na Política */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-primary" />
                  10. Alterações na Política
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Esta Política de Privacidade pode ser atualizada periodicamente. 
                  Notificaremos você sobre mudanças significativas através de:
                </p>
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-primary/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Notificações</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• E-mail para usuários ativos</li>
                      <li>• Aviso no site e aplicativo</li>
                      <li>• Atualização da data de revisão</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-secondary/5 rounded-lg">
                    <h4 className="font-semibold mb-2">Continuidade</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Versões anteriores disponíveis</li>
                      <li>• Histórico de mudanças</li>
                      <li>• Período de transição</li>
                    </ul>
                  </div>
                </div>
                <div className="bg-info/5 p-4 rounded-lg border border-info/10">
                  <p className="text-sm">
                    <strong>Data da última atualização:</strong> {new Date().toLocaleDateString('pt-BR')}
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 11. Contato */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Mail className="w-5 h-5 text-primary" />
                  11. Entre em Contato
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Se você tiver dúvidas sobre esta Política de Privacidade ou sobre como tratamos seus dados pessoais, 
                  entre em contato conosco:
                </p>
                <div className="grid md:grid-cols-2 gap-6">
                  <div className="space-y-4">
                    <div className="flex items-center gap-3">
                      <Mail className="w-5 h-5 text-primary" />
                      <div>
                        <p className="font-semibold">E-mail</p>
                        <a href="mailto:privacidade@financeirologotiq.com" className="text-primary hover:underline text-sm">
                          privacidade@financeirologotiq.com
                        </a>
                      </div>
                    </div>
                    <div className="flex items-center gap-3">
                      <Building className="w-5 h-5 text-primary" />
                      <div>
                        <p className="font-semibold">Empresa</p>
                        <p className="text-sm text-muted-foreground">FinanceiroLogotiq</p>
                      </div>
                    </div>
                  </div>
                  <div className="space-y-4">
                    <div className="flex items-center gap-3">
                      <MapPin className="w-5 h-5 text-primary" />
                      <div>
                        <p className="font-semibold">Endereço</p>
                        <p className="text-sm text-muted-foreground">Brasil</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-3">
                      <Calendar className="w-5 h-5 text-primary" />
                      <div>
                        <p className="font-semibold">Resposta</p>
                        <p className="text-sm text-muted-foreground">Até 15 dias úteis</p>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="bg-success/5 p-4 rounded-lg border border-success/10">
                  <div className="flex items-start gap-2">
                    <Heart className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-medium text-success">Compromisso com a Privacidade</p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Sua privacidade é nossa prioridade. Estamos sempre disponíveis para esclarecer dúvidas 
                        e garantir que seus direitos sejam respeitados.
                      </p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Footer */}
          <div className="text-center mt-12 pt-8 border-t">
            <p className="text-muted-foreground mb-4">
              Esta política de privacidade é parte integrante dos nossos Termos de Uso.
            </p>
            <div className="flex gap-4 justify-center">
              <Button variant="outline" onClick={() => navigate('/terms')}>
                <FileText className="w-4 h-4 mr-2" />
                Ver Termos de Uso
              </Button>
              <Button variant="outline" onClick={() => navigate('/cookies')}>
                <FileText className="w-4 h-4 mr-2" />
                Política de Cookies
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

export default Privacy;
