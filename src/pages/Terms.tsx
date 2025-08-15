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
  XCircle
} from 'lucide-react';

const Terms = () => {
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
              <FileText className="w-8 h-8 text-primary" />
            </div>
            <h1 className="text-4xl font-bold mb-4">Termos de Uso</h1>
            <p className="text-xl text-muted-foreground">
              Última atualização: {new Date().toLocaleDateString('pt-BR')}
            </p>
          </div>

          {/* Terms Content */}
          <div className="space-y-8">
            {/* 1. Aceitação dos Termos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CheckCircle className="w-5 h-5 text-primary" />
                  1. Aceitação dos Termos
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Ao acessar e usar o Financeiro, você concorda em cumprir e estar vinculado a estes Termos de Uso. 
                  Se você não concordar com qualquer parte destes termos, não deve usar nosso serviço.
                </p>
                <div className="bg-muted/50 p-4 rounded-lg">
                  <p className="text-sm font-medium">
                    <AlertTriangle className="w-4 h-4 inline mr-2 text-warning" />
                    O uso contínuo do serviço após mudanças nos termos constitui aceitação das modificações.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 2. Descrição do Serviço */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-primary" />
                  2. Descrição do Serviço
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  O Financeiro é uma plataforma de gestão financeira que oferece:
                </p>
                <ul className="space-y-2 text-muted-foreground">
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Dashboard financeiro com métricas em tempo real
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Sistema CRM integrado para gestão de clientes
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Relatórios automáticos e personalizáveis
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Controle de transações e fluxo de caixa
                  </li>
                </ul>
              </CardContent>
            </Card>

            {/* 3. Conta e Registro */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  3. Conta e Registro
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Para usar nossos serviços, você deve:
                </p>
                <ul className="space-y-2 text-muted-foreground">
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Ter pelo menos 18 anos de idade
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Fornecer informações precisas e atualizadas
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Manter a confidencialidade de suas credenciais
                  </li>
                  <li className="flex items-start gap-2">
                    <CheckCircle className="w-4 h-4 text-success mt-0.5 flex-shrink-0" />
                    Notificar imediatamente qualquer uso não autorizado
                  </li>
                </ul>
                <div className="bg-destructive/5 border border-destructive/10 p-4 rounded-lg">
                  <p className="text-sm text-destructive">
                    <XCircle className="w-4 h-4 inline mr-2" />
                    Você é responsável por todas as atividades que ocorrem em sua conta.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 4. Planos e Pagamentos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-primary" />
                  4. Planos e Pagamentos
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Período de Teste</h4>
                    <p className="text-sm text-muted-foreground">
                      Oferecemos 14 dias de teste gratuito sem compromisso. 
                      Não é necessário cartão de crédito para iniciar.
                    </p>
                  </div>
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Planos Pagos</h4>
                    <p className="text-sm text-muted-foreground">
                      Após o período de teste, você pode escolher entre nossos planos Starter (R$ 79,90/mês) 
                      ou Business (R$ 159,90/mês).
                    </p>
                  </div>
                </div>
                <div className="bg-warning/5 border border-warning/10 p-4 rounded-lg">
                  <p className="text-sm text-warning-foreground">
                    <AlertTriangle className="w-4 h-4 inline mr-2" />
                    Os preços podem ser alterados com aviso prévio de 30 dias.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 5. Uso Aceitável */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="w-5 h-5 text-primary" />
                  5. Uso Aceitável
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Você concorda em usar o serviço apenas para fins legais e de acordo com estes termos.
                </p>
                
                <div className="grid md:grid-cols-2 gap-4">
                  <div>
                    <h4 className="font-semibold mb-2 text-success">Permitido</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Uso para gestão financeira pessoal ou empresarial</li>
                      <li>• Compartilhamento com membros autorizados da organização</li>
                      <li>• Exportação de dados para fins de backup</li>
                      <li>• Uso em conformidade com leis aplicáveis</li>
                    </ul>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2 text-destructive">Proibido</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Uso para atividades ilegais</li>
                      <li>• Tentativas de hackear ou comprometer o sistema</li>
                      <li>• Distribuição de malware ou spam</li>
                      <li>• Violação de direitos de propriedade intelectual</li>
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 6. Privacidade e Dados */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Lock className="w-5 h-5 text-primary" />
                  6. Privacidade e Proteção de Dados
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Sua privacidade é importante para nós. Nossa Política de Privacidade descreve como coletamos, 
                  usamos e protegemos suas informações.
                </p>
                
                <div className="grid md:grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-primary/5 rounded-lg">
                    <Shield className="w-8 h-8 text-primary mx-auto mb-2" />
                    <h4 className="font-semibold mb-1">Criptografia SSL</h4>
                    <p className="text-xs text-muted-foreground">
                      Dados protegidos com criptografia de ponta a ponta
                    </p>
                  </div>
                  <div className="text-center p-4 bg-primary/5 rounded-lg">
                    <Calendar className="w-8 h-8 text-primary mx-auto mb-2" />
                    <h4 className="font-semibold mb-1">Backup Diário</h4>
                    <p className="text-xs text-muted-foreground">
                      Backup automático em servidores seguros
                    </p>
                  </div>
                  <div className="text-center p-4 bg-primary/5 rounded-lg">
                    <FileText className="w-8 h-8 text-primary mx-auto mb-2" />
                    <h4 className="font-semibold mb-1">Conformidade LGPD</h4>
                    <p className="text-xs text-muted-foreground">
                      Totalmente em conformidade com a LGPD
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 7. Limitações de Responsabilidade */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="w-5 h-5 text-primary" />
                  7. Limitações de Responsabilidade
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  O Financeiro é fornecido "como está" e "conforme disponível". 
                  Não garantimos que o serviço será ininterrupto ou livre de erros.
                </p>
                
                <div className="bg-muted/50 p-4 rounded-lg">
                  <h4 className="font-semibold mb-2">Exclusões de Garantia</h4>
                  <ul className="space-y-1 text-sm text-muted-foreground">
                    <li>• Garantias de comercialização ou adequação a um propósito específico</li>
                    <li>• Garantias de que o serviço atenderá a todos os requisitos</li>
                    <li>• Garantias de que o serviço será ininterrupto ou livre de erros</li>
                    <li>• Garantias sobre a precisão ou completude dos dados</li>
                  </ul>
                </div>
              </CardContent>
            </Card>

            {/* 8. Cancelamento */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <XCircle className="w-5 h-5 text-primary" />
                  8. Cancelamento e Rescisão
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Você pode cancelar sua assinatura a qualquer momento através do painel de controle.
                </p>
                
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Cancelamento pelo Usuário</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Acesso até o final do período pago</li>
                      <li>• Exportação de dados disponível</li>
                      <li>• Sem taxas de cancelamento</li>
                      <li>• Reativação a qualquer momento</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-destructive/5 border border-destructive/10 rounded-lg">
                    <h4 className="font-semibold mb-2 text-destructive">Rescisão pela Empresa</h4>
                    <ul className="space-y-1 text-sm text-muted-foreground">
                      <li>• Violação dos termos de uso</li>
                      <li>• Uso não autorizado</li>
                      <li>• Atividades ilegais</li>
                      <li>• Não pagamento</li>
                    </ul>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* 9. Modificações */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="w-5 h-5 text-primary" />
                  9. Modificações dos Termos
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Reservamo-nos o direito de modificar estes termos a qualquer momento. 
                  Mudanças significativas serão comunicadas com pelo menos 30 dias de antecedência.
                </p>
                
                <div className="bg-warning/5 border border-warning/10 p-4 rounded-lg">
                  <p className="text-sm text-warning-foreground">
                    <AlertTriangle className="w-4 h-4 inline mr-2" />
                    O uso contínuo do serviço após as modificações constitui aceitação dos novos termos.
                  </p>
                </div>
              </CardContent>
            </Card>

            {/* 10. Contato */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  10. Contato
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">
                  Se você tiver dúvidas sobre estes termos, entre em contato conosco:
                </p>
                
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Suporte</h4>
                    <p className="text-sm text-muted-foreground">
                      Email: suporte@financeiro.com<br />
                      Horário: Segunda a Sexta, 9h às 18h
                    </p>
                  </div>
                  <div className="p-4 bg-muted/50 rounded-lg">
                    <h4 className="font-semibold mb-2">Legal</h4>
                    <p className="text-sm text-muted-foreground">
                      Email: legal@financeiro.com<br />
                      Para questões jurídicas e termos
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Footer */}
          <div className="text-center mt-12 pt-8 border-t">
            <p className="text-muted-foreground mb-4">
              Ao usar o Financeiro, você concorda com estes termos de uso.
            </p>
            <Button onClick={() => navigate('/')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Voltar ao Início
            </Button>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Terms;
