import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { 
  Cookie, 
  Settings, 
  Shield, 
  Eye, 
  Globe, 
  X,
  Info,
  CheckCircle,
  AlertTriangle
} from 'lucide-react';
import { cookieManager } from '@/utils/cookies';

const CookieConsent = () => {
  const [showBanner, setShowBanner] = useState(false);
  const [showDetails, setShowDetails] = useState(false);
  const [consent, setConsent] = useState({
    essential: true, // Sempre true, não pode ser desabilitado
    analytics: true,
    marketing: false
  });

  useEffect(() => {
    // Verificar se precisa mostrar o banner
    if (cookieManager.showCookieConsent()) {
      setShowBanner(true);
    }
  }, []);

  const handleAcceptAll = () => {
    cookieManager.setCookieConsent({
      essential: true,
      analytics: true,
      marketing: true
    });
    setShowBanner(false);
  };

  const handleAcceptSelected = () => {
    cookieManager.setCookieConsent(consent);
    setShowBanner(false);
  };

  const handleRejectAll = () => {
    cookieManager.setCookieConsent({
      essential: true,
      analytics: false,
      marketing: false
    });
    setShowBanner(false);
  };

  if (!showBanner) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 p-4 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 border-t">
      <div className="container mx-auto max-w-4xl">
        <Card className="shadow-lg">
          <CardHeader className="pb-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
                  <Cookie className="w-5 h-5 text-primary" />
                </div>
                <div>
                  <CardTitle className="text-lg">Configurações de Cookies</CardTitle>
                  <p className="text-sm text-muted-foreground">
                    Utilizamos cookies para melhorar sua experiência
                  </p>
                </div>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setShowDetails(!showDetails)}
              >
                <Settings className="w-4 h-4" />
              </Button>
            </div>
          </CardHeader>

          <CardContent className="space-y-4">
            {!showDetails ? (
              // Vista simplificada
              <div className="space-y-4">
                <p className="text-sm text-muted-foreground">
                  Utilizamos cookies essenciais para o funcionamento do site e cookies opcionais 
                  para análise e marketing. Você pode personalizar suas preferências.
                </p>
                
                <div className="flex flex-wrap gap-2">
                  <Button onClick={handleAcceptAll} size="sm">
                    <CheckCircle className="w-4 h-4 mr-2" />
                    Aceitar Todos
                  </Button>
                  <Button 
                    variant="outline" 
                    onClick={() => setShowDetails(true)}
                    size="sm"
                  >
                    <Settings className="w-4 h-4 mr-2" />
                    Personalizar
                  </Button>
                  <Button 
                    variant="ghost" 
                    onClick={handleRejectAll}
                    size="sm"
                  >
                    Rejeitar Todos
                  </Button>
                </div>
              </div>
            ) : (
              // Vista detalhada
              <div className="space-y-6">
                <div className="space-y-4">
                  {/* Cookies Essenciais */}
                  <div className="flex items-center justify-between p-4 bg-success/5 border border-success/10 rounded-lg">
                    <div className="flex items-center gap-3">
                      <Shield className="w-5 h-5 text-success" />
                      <div>
                        <Label className="font-semibold text-success">Cookies Essenciais</Label>
                        <p className="text-xs text-muted-foreground">
                          Necessários para o funcionamento básico do site
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Switch checked={true} disabled />
                      <Badge variant="secondary">Obrigatório</Badge>
                    </div>
                  </div>

                  {/* Cookies de Analytics */}
                  <div className="flex items-center justify-between p-4 bg-primary/5 border border-primary/10 rounded-lg">
                    <div className="flex items-center gap-3">
                      <Eye className="w-5 h-5 text-primary" />
                      <div>
                        <Label className="font-semibold text-primary">Cookies de Analytics</Label>
                        <p className="text-xs text-muted-foreground">
                          Nos ajudam a entender como você usa o site
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Switch
                        checked={consent.analytics}
                        onCheckedChange={(checked) => 
                          setConsent(prev => ({ ...prev, analytics: checked }))
                        }
                      />
                      <Badge variant={consent.analytics ? "default" : "outline"}>
                        {consent.analytics ? "Ativo" : "Inativo"}
                      </Badge>
                    </div>
                  </div>

                  {/* Cookies de Marketing */}
                  <div className="flex items-center justify-between p-4 bg-warning/5 border border-warning/10 rounded-lg">
                    <div className="flex items-center gap-3">
                      <Globe className="w-5 h-5 text-warning" />
                      <div>
                        <Label className="font-semibold text-warning">Cookies de Marketing</Label>
                        <p className="text-xs text-muted-foreground">
                          Usados para mostrar anúncios relevantes
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Switch
                        checked={consent.marketing}
                        onCheckedChange={(checked) => 
                          setConsent(prev => ({ ...prev, marketing: checked }))
                        }
                      />
                      <Badge variant={consent.marketing ? "destructive" : "outline"}>
                        {consent.marketing ? "Ativo" : "Inativo"}
                      </Badge>
                    </div>
                  </div>
                </div>

                {/* Informações adicionais */}
                <div className="bg-muted/50 p-4 rounded-lg">
                  <div className="flex items-start gap-2">
                    <Info className="w-4 h-4 text-muted-foreground mt-0.5 flex-shrink-0" />
                    <div className="text-xs text-muted-foreground">
                      <p className="font-medium mb-1">Sobre seus dados:</p>
                      <ul className="space-y-1">
                        <li>• Cookies essenciais são sempre ativos para o funcionamento do site</li>
                        <li>• Analytics nos ajuda a melhorar a experiência</li>
                        <li>• Marketing permite anúncios personalizados</li>
                        <li>• Você pode alterar essas configurações a qualquer momento</li>
                      </ul>
                    </div>
                  </div>
                </div>

                {/* Botões de ação */}
                <div className="flex flex-wrap gap-2 justify-end">
                  <Button 
                    variant="ghost" 
                    onClick={() => setShowDetails(false)}
                    size="sm"
                  >
                    <X className="w-4 h-4 mr-2" />
                    Voltar
                  </Button>
                  <Button 
                    variant="outline" 
                    onClick={handleAcceptSelected}
                    size="sm"
                  >
                    <CheckCircle className="w-4 h-4 mr-2" />
                    Salvar Preferências
                  </Button>
                  <Button 
                    onClick={handleAcceptAll}
                    size="sm"
                  >
                    <CheckCircle className="w-4 h-4 mr-2" />
                    Aceitar Todos
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default CookieConsent;
