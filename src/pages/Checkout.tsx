import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Separator } from '@/components/ui/separator';
import { 
  ArrowLeft, 
  CreditCard, 
  Lock, 
  Check,
  AlertCircle
} from 'lucide-react';
import { Alert, AlertDescription } from '@/components/ui/alert';

interface PlanInfo {
  id: string;
  name: string;
  price: number;
  period: string;
  features: string[];
}

const planDetails: Record<string, PlanInfo> = {
  starter: {
    id: 'starter',
    name: 'Starter',
    price: 29.90,
    period: 'mês',
    features: [
      'Até 100 transações por mês',
      '1 usuário',
      'Até 10 clientes',
      'Dashboard financeiro',
      'Relatórios básicos',
      'Suporte por email'
    ]
  },
  business: {
    id: 'business',
    name: 'Business',
    price: 79.90,
    period: 'mês',
    features: [
      'Até 1.000 transações por mês',
      'Até 5 usuários',
      'Até 100 clientes',
      'Dashboard financeiro',
      'Relatórios avançados',
      'CRM completo',
      'Suporte prioritário',
      'API access'
    ]
  }
};

export default function Checkout() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [loading, setLoading] = useState(false);
  const [paymentMethod, setPaymentMethod] = useState<'credit' | 'pix'>('credit');
  const [formData, setFormData] = useState({
    cardNumber: '',
    expiryDate: '',
    cvv: '',
    cardName: '',
    email: user?.email || '',
    document: ''
  });

  const planId = searchParams.get('plan') as 'starter' | 'business';
  const plan = planDetails[planId];

  useEffect(() => {
    if (!plan) {
      navigate('/plans');
    }
  }, [plan, navigate]);

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const formatCardNumber = (value: string) => {
    const v = value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
    const matches = v.match(/\d{4,16}/g);
    const match = matches && matches[0] || '';
    const parts = [];
    for (let i = 0; i < match.length; i += 4) {
      parts.push(match.substring(i, i + 4));
    }
    if (parts.length) {
      return parts.join(' ');
    } else {
      return v;
    }
  };

  const formatExpiryDate = (value: string) => {
    const v = value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
    if (v.length >= 2) {
      return v.substring(0, 2) + '/' + v.substring(2, 4);
    }
    return v;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // Simular processamento de pagamento
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Aqui você integraria com o gateway de pagamento real
      console.log('Processando pagamento:', {
        plan: planId,
        paymentMethod,
        formData
      });

      // Simular sucesso e redirecionar
      navigate('/subscription?success=true');
    } catch (error) {
      console.error('Erro no pagamento:', error);
      // Tratar erro
    } finally {
      setLoading(false);
    }
  };

  if (!plan) {
    return null;
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center space-x-4">
            <Button variant="outline" size="sm" onClick={() => navigate('/plans')}>
              <ArrowLeft className="w-4 h-4 mr-1" />
              Voltar aos Planos
            </Button>
            <div>
              <h1 className="text-2xl font-bold">Finalizar Assinatura</h1>
              <p className="text-muted-foreground">Complete seu pagamento</p>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid gap-8 lg:grid-cols-3">
          
          {/* Payment Form */}
          <div className="lg:col-span-2">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <CreditCard className="w-5 h-5" />
                  <span>Informações de Pagamento</span>
                </CardTitle>
                <CardDescription>
                  Seus dados estão protegidos com criptografia SSL
                </CardDescription>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleSubmit} className="space-y-6">
                  
                  {/* Payment Method Selection */}
                  <div className="space-y-3">
                    <Label>Método de Pagamento</Label>
                    <div className="grid grid-cols-2 gap-4">
                      <Button
                        type="button"
                        variant={paymentMethod === 'credit' ? 'default' : 'outline'}
                        onClick={() => setPaymentMethod('credit')}
                        className="h-12"
                      >
                        <CreditCard className="w-4 h-4 mr-2" />
                        Cartão de Crédito
                      </Button>
                      <Button
                        type="button"
                        variant={paymentMethod === 'pix' ? 'default' : 'outline'}
                        onClick={() => setPaymentMethod('pix')}
                        className="h-12"
                      >
                        PIX
                      </Button>
                    </div>
                  </div>

                  {paymentMethod === 'credit' && (
                    <>
                      {/* Card Information */}
                      <div className="space-y-4">
                        <div>
                          <Label htmlFor="cardNumber">Número do Cartão</Label>
                          <Input
                            id="cardNumber"
                            placeholder="1234 5678 9012 3456"
                            value={formData.cardNumber}
                            onChange={(e) => handleInputChange('cardNumber', formatCardNumber(e.target.value))}
                            maxLength={19}
                            required
                          />
                        </div>
                        
                        <div className="grid grid-cols-2 gap-4">
                          <div>
                            <Label htmlFor="expiryDate">Validade</Label>
                            <Input
                              id="expiryDate"
                              placeholder="MM/AA"
                              value={formData.expiryDate}
                              onChange={(e) => handleInputChange('expiryDate', formatExpiryDate(e.target.value))}
                              maxLength={5}
                              required
                            />
                          </div>
                          <div>
                            <Label htmlFor="cvv">CVV</Label>
                            <Input
                              id="cvv"
                              placeholder="123"
                              value={formData.cvv}
                              onChange={(e) => handleInputChange('cvv', e.target.value.replace(/\D/g, ''))}
                              maxLength={4}
                              required
                            />
                          </div>
                        </div>
                        
                        <div>
                          <Label htmlFor="cardName">Nome no Cartão</Label>
                          <Input
                            id="cardName"
                            placeholder="Nome como está no cartão"
                            value={formData.cardName}
                            onChange={(e) => handleInputChange('cardName', e.target.value)}
                            required
                          />
                        </div>
                      </div>
                    </>
                  )}

                  {paymentMethod === 'pix' && (
                    <Alert>
                      <AlertCircle className="h-4 w-4" />
                      <AlertDescription>
                        Após confirmar, você receberá um QR Code para pagamento via PIX.
                        O plano será ativado automaticamente após a confirmação do pagamento.
                      </AlertDescription>
                    </Alert>
                  )}

                  {/* Customer Information */}
                  <Separator />
                  
                  <div className="space-y-4">
                    <h3 className="text-lg font-medium">Informações Pessoais</h3>
                    
                    <div>
                      <Label htmlFor="email">Email</Label>
                      <Input
                        id="email"
                        type="email"
                        value={formData.email}
                        onChange={(e) => handleInputChange('email', e.target.value)}
                        required
                      />
                    </div>
                    
                    <div>
                      <Label htmlFor="document">CPF/CNPJ</Label>
                      <Input
                        id="document"
                        placeholder="000.000.000-00"
                        value={formData.document}
                        onChange={(e) => handleInputChange('document', e.target.value)}
                        required
                      />
                    </div>
                  </div>

                  {/* Security Notice */}
                  <div className="flex items-center space-x-2 text-sm text-muted-foreground bg-muted/50 p-3 rounded-lg">
                    <Lock className="w-4 h-4" />
                    <span>Seus dados são protegidos com criptografia SSL de 256 bits</span>
                  </div>

                  {/* Submit Button */}
                  <Button 
                    type="submit" 
                    className="w-full h-12 text-lg"
                    disabled={loading}
                  >
                    {loading ? (
                      <div className="flex items-center space-x-2">
                        <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-current"></div>
                        <span>Processando...</span>
                      </div>
                    ) : (
                      `Finalizar Pagamento - R$ ${plan.price.toFixed(2)}`
                    )}
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>

          {/* Order Summary */}
          <div>
            <Card>
              <CardHeader>
                <CardTitle>Resumo do Pedido</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                
                {/* Plan Info */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-medium">Plano {plan.name}</span>
                    <Badge variant="secondary">{plan.name}</Badge>
                  </div>
                  <div className="flex items-center justify-between text-sm text-muted-foreground">
                    <span>Cobrança mensal</span>
                    <span>R$ {plan.price.toFixed(2)}</span>
                  </div>
                </div>

                <Separator />

                {/* Features */}
                <div className="space-y-2">
                  <h4 className="font-medium">Incluído no plano:</h4>
                  <ul className="space-y-1">
                    {plan.features.slice(0, 4).map((feature, index) => (
                      <li key={index} className="flex items-center space-x-2 text-sm">
                        <Check className="w-3 h-3 text-green-500" />
                        <span>{feature}</span>
                      </li>
                    ))}
                    {plan.features.length > 4 && (
                      <li className="text-sm text-muted-foreground ml-5">
                        +{plan.features.length - 4} recursos adicionais
                      </li>
                    )}
                  </ul>
                </div>

                <Separator />

                {/* Total */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between font-medium">
                    <span>Total</span>
                    <span>R$ {plan.price.toFixed(2)}</span>
                  </div>
                  <p className="text-xs text-muted-foreground">
                    14 dias gratuitos • Cancele quando quiser
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}
