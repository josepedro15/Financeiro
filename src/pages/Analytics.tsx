import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  ArrowLeft, 
  DollarSign, 
  Users, 
  Eye, 
  Clock, 
  Calendar,
  TrendingUp,
  TrendingDown,
  BarChart3,
  PieChart,
  Activity,
  Globe,
  Smartphone,
  Monitor,
  Download,
  Trash2,
  RefreshCw,
  Info,
  AlertTriangle,
  CheckCircle,
  Settings
} from 'lucide-react';
import { useCookieAnalytics } from '@/hooks/useCookieAnalytics';
import { cookieManager } from '@/utils/cookies';

const Analytics = () => {
  const navigate = useNavigate();
  const { 
    preferences, 
    analytics, 
    isNewUser, 
    getUsageStats, 
    exportUserData, 
    clearNonEssentialCookies 
  } = useCookieAnalytics();

  const [stats, setStats] = useState(getUsageStats());
  const [exportedData, setExportedData] = useState<any>(null);

  // Atualizar estatísticas
  const refreshStats = () => {
    setStats(getUsageStats());
  };

  // Exportar dados
  const handleExportData = () => {
    const data = exportUserData();
    setExportedData(data);
    
    // Criar arquivo para download
    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `financeirologotiq-data-${new Date().toISOString().split('T')[0]}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  };

  // Limpar cookies
  const handleClearCookies = () => {
    if (confirm('Tem certeza que deseja limpar todos os cookies não essenciais? Esta ação não pode ser desfeita.')) {
      clearNonEssentialCookies();
      refreshStats();
    }
  };

  // Detectar dispositivo
  const getDeviceType = (userAgent: string) => {
    if (/Mobile|Android|iPhone|iPad/.test(userAgent)) {
      return 'Mobile';
    } else if (/Tablet|iPad/.test(userAgent)) {
      return 'Tablet';
    } else {
      return 'Desktop';
    }
  };

  const deviceType = getDeviceType(analytics.userAgent);

  // Calcular métricas
  const averageSessionMinutes = Math.round(stats.averageSessionTime / 60000 * 10) / 10;
  const totalSessionHours = Math.round(stats.totalSessionTime / 3600000 * 10) / 10;
  const daysSinceFirstVisit = Math.ceil((Date.now() - new Date(analytics.firstVisit).getTime()) / (1000 * 60 * 60 * 24));

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
            
            <div className="flex items-center gap-2">
              <Button variant="outline" onClick={refreshStats}>
                <RefreshCw className="w-4 h-4 mr-2" />
                Atualizar
              </Button>
              <Button variant="outline" onClick={() => navigate('/')}>
                <ArrowLeft className="w-4 h-4 mr-2" />
                Voltar
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-7xl mx-auto">
          {/* Page Header */}
          <div className="text-center mb-8">
            <div className="w-16 h-16 bg-primary/10 rounded-xl flex items-center justify-center mx-auto mb-4">
              <BarChart3 className="w-8 h-8 text-primary" />
            </div>
            <h1 className="text-4xl font-bold mb-4">Analytics e Dados</h1>
            <p className="text-xl text-muted-foreground">
              Visualize os dados coletados sobre seu uso do FinanceiroLogotiq
            </p>
          </div>

          {/* Status do Analytics */}
          <div className="mb-8">
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    {preferences.analytics ? (
                      <CheckCircle className="w-5 h-5 text-success" />
                    ) : (
                      <AlertTriangle className="w-5 h-5 text-warning" />
                    )}
                    <div>
                      <h3 className="font-semibold">
                        Status do Analytics: {preferences.analytics ? 'Ativo' : 'Inativo'}
                      </h3>
                      <p className="text-sm text-muted-foreground">
                        {preferences.analytics 
                          ? 'Coletando dados para melhorar sua experiência'
                          : 'Analytics desabilitado - alguns dados podem não estar disponíveis'
                        }
                      </p>
                    </div>
                  </div>
                  <Badge variant={preferences.analytics ? "default" : "secondary"}>
                    {preferences.analytics ? "Coletando" : "Pausado"}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Tabs */}
          <Tabs defaultValue="overview" className="space-y-6">
            <TabsList className="grid w-full grid-cols-4">
              <TabsTrigger value="overview">Visão Geral</TabsTrigger>
              <TabsTrigger value="usage">Uso Detalhado</TabsTrigger>
              <TabsTrigger value="preferences">Preferências</TabsTrigger>
              <TabsTrigger value="data">Gerenciar Dados</TabsTrigger>
            </TabsList>

            {/* Visão Geral */}
            <TabsContent value="overview" className="space-y-6">
              {/* Métricas Principais */}
              <div className="grid md:grid-cols-4 gap-6">
                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Total de Visitas</CardTitle>
                    <Users className="h-4 w-4 text-muted-foreground" />
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{stats.totalVisits}</div>
                    <p className="text-xs text-muted-foreground">
                      Desde {new Date(analytics.firstVisit).toLocaleDateString('pt-BR')}
                    </p>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Páginas Únicas</CardTitle>
                    <Eye className="h-4 w-4 text-muted-foreground" />
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{stats.uniquePages}</div>
                    <p className="text-xs text-muted-foreground">
                      Páginas diferentes visitadas
                    </p>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Tempo Total</CardTitle>
                    <Clock className="h-4 w-4 text-muted-foreground" />
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{totalSessionHours}h</div>
                    <p className="text-xs text-muted-foreground">
                      Tempo total de uso
                    </p>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Sessão Média</CardTitle>
                    <Activity className="h-4 w-4 text-muted-foreground" />
                  </CardHeader>
                  <CardContent>
                    <div className="text-2xl font-bold">{averageSessionMinutes}min</div>
                    <p className="text-xs text-muted-foreground">
                      Por sessão
                    </p>
                  </CardContent>
                </Card>
              </div>

              {/* Informações do Usuário */}
              <div className="grid md:grid-cols-2 gap-6">
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Info className="w-5 h-5" />
                      Informações do Usuário
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4 text-sm">
                      <div>
                        <span className="font-medium">Tipo de Usuário:</span>
                        <Badge variant={isNewUser ? "secondary" : "default"} className="ml-2">
                          {isNewUser ? "Novo" : "Recorrente"}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Dispositivo:</span>
                        <div className="flex items-center gap-1 mt-1">
                          {deviceType === 'Mobile' && <Smartphone className="w-4 h-4" />}
                          {deviceType === 'Desktop' && <Monitor className="w-4 h-4" />}
                          <span className="text-muted-foreground">{deviceType}</span>
                        </div>
                      </div>
                      <div>
                        <span className="font-medium">Primeira Visita:</span>
                        <p className="text-muted-foreground">
                          {new Date(analytics.firstVisit).toLocaleDateString('pt-BR')}
                        </p>
                      </div>
                      <div>
                        <span className="font-medium">Última Visita:</span>
                        <p className="text-muted-foreground">
                          {new Date(analytics.lastVisit).toLocaleDateString('pt-BR')}
                        </p>
                      </div>
                      <div>
                        <span className="font-medium">Dias Ativo:</span>
                        <p className="text-muted-foreground">{daysSinceFirstVisit} dias</p>
                      </div>
                      <div>
                        <span className="font-medium">Frequência:</span>
                        <p className="text-muted-foreground">
                          {daysSinceFirstVisit > 0 ? Math.round(stats.totalVisits / daysSinceFirstVisit * 10) / 10 : 0} visitas/dia
                        </p>
                      </div>
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <TrendingUp className="w-5 h-5" />
                      Tendências
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-sm">Engajamento</span>
                        <div className="flex items-center gap-2">
                          <div className="w-20 bg-muted rounded-full h-2">
                            <div 
                              className="bg-primary h-2 rounded-full" 
                              style={{ width: `${Math.min((stats.totalVisits / 30) * 100, 100)}%` }}
                            ></div>
                          </div>
                          <span className="text-xs text-muted-foreground">
                            {Math.min((stats.totalVisits / 30) * 100, 100).toFixed(0)}%
                          </span>
                        </div>
                      </div>
                      
                      <div className="flex items-center justify-between">
                        <span className="text-sm">Exploração</span>
                        <div className="flex items-center gap-2">
                          <div className="w-20 bg-muted rounded-full h-2">
                            <div 
                              className="bg-secondary h-2 rounded-full" 
                              style={{ width: `${Math.min((stats.uniquePages / 10) * 100, 100)}%` }}
                            ></div>
                          </div>
                          <span className="text-xs text-muted-foreground">
                            {Math.min((stats.uniquePages / 10) * 100, 100).toFixed(0)}%
                          </span>
                        </div>
                      </div>
                      
                      <div className="flex items-center justify-between">
                        <span className="text-sm">Retenção</span>
                        <div className="flex items-center gap-2">
                          <div className="w-20 bg-muted rounded-full h-2">
                            <div 
                              className="bg-success h-2 rounded-full" 
                              style={{ width: `${Math.min((averageSessionMinutes / 10) * 100, 100)}%` }}
                            ></div>
                          </div>
                          <span className="text-xs text-muted-foreground">
                            {Math.min((averageSessionMinutes / 10) * 100, 100).toFixed(0)}%
                          </span>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* Uso Detalhado */}
            <TabsContent value="usage" className="space-y-6">
              <div className="grid md:grid-cols-2 gap-6">
                {/* Páginas Visitadas */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Eye className="w-5 h-5" />
                      Páginas Visitadas
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-3">
                      {analytics.pagesVisited.length > 0 ? (
                        analytics.pagesVisited.map((page, index) => (
                          <div key={index} className="flex items-center justify-between p-2 bg-muted/50 rounded">
                            <span className="text-sm font-mono">{page}</span>
                            <Badge variant="outline">#{index + 1}</Badge>
                          </div>
                        ))
                      ) : (
                        <p className="text-muted-foreground text-center py-4">
                          Nenhuma página visitada ainda
                        </p>
                      )}
                    </div>
                  </CardContent>
                </Card>

                {/* Estatísticas de Sessão */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Clock className="w-5 h-5" />
                      Estatísticas de Sessão
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4 text-sm">
                      <div className="text-center p-3 bg-primary/5 rounded">
                        <div className="text-2xl font-bold text-primary">{stats.totalVisits}</div>
                        <div className="text-xs text-muted-foreground">Total de Visitas</div>
                      </div>
                      <div className="text-center p-3 bg-secondary/5 rounded">
                        <div className="text-2xl font-bold text-secondary">{stats.uniquePages}</div>
                        <div className="text-xs text-muted-foreground">Páginas Únicas</div>
                      </div>
                      <div className="text-center p-3 bg-success/5 rounded">
                        <div className="text-2xl font-bold text-success">{totalSessionHours}h</div>
                        <div className="text-xs text-muted-foreground">Tempo Total</div>
                      </div>
                      <div className="text-center p-3 bg-warning/5 rounded">
                        <div className="text-2xl font-bold text-warning">{averageSessionMinutes}min</div>
                        <div className="text-xs text-muted-foreground">Média/Sessão</div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* Preferências */}
            <TabsContent value="preferences" className="space-y-6">
              <div className="grid md:grid-cols-2 gap-6">
                {/* Preferências Atuais */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Settings className="w-5 h-5" />
                      Preferências Atuais
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4 text-sm">
                      <div>
                        <span className="font-medium">Tema:</span>
                        <Badge variant="outline" className="ml-2">
                          {preferences.theme}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Idioma:</span>
                        <Badge variant="outline" className="ml-2">
                          {preferences.language}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Moeda:</span>
                        <Badge variant="outline" className="ml-2">
                          {preferences.currency}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Layout:</span>
                        <Badge variant="outline" className="ml-2">
                          {preferences.dashboardLayout}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Notificações:</span>
                        <Badge variant={preferences.notifications ? "default" : "secondary"} className="ml-2">
                          {preferences.notifications ? "Ativo" : "Inativo"}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Analytics:</span>
                        <Badge variant={preferences.analytics ? "default" : "secondary"} className="ml-2">
                          {preferences.analytics ? "Ativo" : "Inativo"}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Marketing:</span>
                        <Badge variant={preferences.marketing ? "destructive" : "secondary"} className="ml-2">
                          {preferences.marketing ? "Ativo" : "Inativo"}
                        </Badge>
                      </div>
                      <div>
                        <span className="font-medium">Sidebar:</span>
                        <Badge variant={preferences.sidebarCollapsed ? "secondary" : "default"} className="ml-2">
                          {preferences.sidebarCollapsed ? "Recolhida" : "Expandida"}
                        </Badge>
                      </div>
                    </div>
                  </CardContent>
                </Card>

                {/* Informações do Sistema */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Globe className="w-5 h-5" />
                      Informações do Sistema
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="space-y-3 text-sm">
                      <div>
                        <span className="font-medium">User Agent:</span>
                        <p className="text-muted-foreground text-xs mt-1 break-all">
                          {analytics.userAgent}
                        </p>
                      </div>
                      <div>
                        <span className="font-medium">Referrer:</span>
                        <p className="text-muted-foreground text-xs mt-1">
                          {analytics.referrer || 'Direto'}
                        </p>
                      </div>
                      <div>
                        <span className="font-medium">Cookies Suportados:</span>
                        <Badge variant={cookieManager.isSupported() ? "default" : "destructive"} className="ml-2">
                          {cookieManager.isSupported() ? "Sim" : "Não"}
                        </Badge>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* Gerenciar Dados */}
            <TabsContent value="data" className="space-y-6">
              <div className="grid md:grid-cols-2 gap-6">
                {/* Exportar Dados */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Download className="w-5 h-5" />
                      Exportar Dados
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <p className="text-sm text-muted-foreground">
                      Baixe todos os seus dados em formato JSON. Isso inclui preferências, 
                      analytics e configurações de cookies.
                    </p>
                    <Button onClick={handleExportData} className="w-full">
                      <Download className="w-4 h-4 mr-2" />
                      Exportar Dados (LGPD)
                    </Button>
                    {exportedData && (
                      <div className="p-3 bg-success/5 border border-success/10 rounded">
                        <p className="text-sm text-success">
                          <CheckCircle className="w-4 h-4 inline mr-2" />
                          Dados exportados com sucesso!
                        </p>
                      </div>
                    )}
                  </CardContent>
                </Card>

                {/* Limpar Dados */}
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Trash2 className="w-5 h-5" />
                      Limpar Dados
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <p className="text-sm text-muted-foreground">
                      Remova todos os cookies não essenciais. Isso irá limpar suas 
                      preferências e dados de analytics.
                    </p>
                    <Button 
                      variant="destructive" 
                      onClick={handleClearCookies}
                      className="w-full"
                    >
                      <Trash2 className="w-4 h-4 mr-2" />
                      Limpar Cookies
                    </Button>
                    <div className="p-3 bg-warning/5 border border-warning/10 rounded">
                      <p className="text-sm text-warning">
                        <AlertTriangle className="w-4 h-4 inline mr-2" />
                        Esta ação não pode ser desfeita
                      </p>
                    </div>
                  </CardContent>
                </Card>
              </div>

              {/* Dados Exportados (Preview) */}
              {exportedData && (
                <Card>
                  <CardHeader>
                    <CardTitle>Preview dos Dados Exportados</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <pre className="bg-muted p-4 rounded text-xs overflow-auto max-h-96">
                      {JSON.stringify(exportedData, null, 2)}
                    </pre>
                  </CardContent>
                </Card>
              )}
            </TabsContent>
          </Tabs>
        </div>
      </main>
    </div>
  );
};

export default Analytics;
