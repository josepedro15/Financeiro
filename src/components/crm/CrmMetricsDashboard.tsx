import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { 
  Users, 
  DollarSign, 
  TrendingUp, 
  Target, 
  Calendar, 
  Clock, 
  AlertTriangle,
  BarChart3,
  Activity,
  Star,
  CheckCircle
} from 'lucide-react';
import { CrmMetrics } from '@/integrations/supabase/crm-types';

interface CrmMetricsDashboardProps {
  metrics: CrmMetrics | null;
  loading?: boolean;
}

export const CrmMetricsDashboard = ({
  metrics,
  loading = false
}: CrmMetricsDashboardProps) => {
  if (loading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {[...Array(8)].map((_, i) => (
          <Card key={i} className="animate-pulse">
            <CardHeader className="pb-2">
              <div className="h-4 bg-gray-200 rounded w-3/4"></div>
            </CardHeader>
            <CardContent>
              <div className="h-8 bg-gray-200 rounded w-1/2"></div>
            </CardContent>
          </Card>
        ))}
      </div>
    );
  }

  if (!metrics) {
    return (
      <div className="text-center py-8">
        <BarChart3 className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h3 className="text-lg font-medium mb-2">Nenhuma métrica disponível</h3>
        <p className="text-muted-foreground">
          Comece a adicionar clientes e atividades para ver suas métricas
        </p>
      </div>
    );
  }

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value);
  };

  const formatPercentage = (value: number) => {
    return `${value.toFixed(1)}%`;
  };

  const getMetricColor = (metric: string, value: number) => {
    switch (metric) {
      case 'conversion_rate':
        return value >= 20 ? 'text-green-600' : value >= 10 ? 'text-yellow-600' : 'text-red-600';
      case 'average_lead_score':
        return value >= 70 ? 'text-green-600' : value >= 40 ? 'text-yellow-600' : 'text-red-600';
      case 'overdue_activities':
        return value > 0 ? 'text-red-600' : 'text-green-600';
      default:
        return 'text-gray-900';
    }
  };

  const getMetricIcon = (metric: string) => {
    switch (metric) {
      case 'total_clients':
        return <Users className="h-4 w-4" />;
      case 'total_opportunities':
        return <Target className="h-4 w-4" />;
      case 'total_value_pipeline':
        return <DollarSign className="h-4 w-4" />;
      case 'conversion_rate':
        return <TrendingUp className="h-4 w-4" />;
      case 'average_lead_score':
        return <Star className="h-4 w-4" />;
      case 'activities_this_month':
        return <Activity className="h-4 w-4" />;
      case 'overdue_activities':
        return <AlertTriangle className="h-4 w-4" />;
      case 'upcoming_follow_ups':
        return <Clock className="h-4 w-4" />;
      default:
        return <BarChart3 className="h-4 w-4" />;
    }
  };

  const metricCards = [
    {
      title: 'Total de Clientes',
      value: metrics.total_clients,
      description: 'Clientes ativos',
      icon: 'total_clients',
      format: (value: number) => value.toString(),
      color: 'text-blue-600'
    },
    {
      title: 'Oportunidades',
      value: metrics.total_opportunities,
      description: 'Oportunidades ativas',
      icon: 'total_opportunities',
      format: (value: number) => value.toString(),
      color: 'text-purple-600'
    },
    {
      title: 'Pipeline de Vendas',
      value: metrics.total_value_pipeline,
      description: 'Valor total em negociação',
      icon: 'total_value_pipeline',
      format: formatCurrency,
      color: 'text-green-600'
    },
    {
      title: 'Taxa de Conversão',
      value: metrics.conversion_rate,
      description: 'Clientes que viraram oportunidades',
      icon: 'conversion_rate',
      format: formatPercentage,
      color: getMetricColor('conversion_rate', metrics.conversion_rate)
    },
    {
      title: 'Lead Score Médio',
      value: metrics.average_lead_score,
      description: 'Qualidade média dos leads',
      icon: 'average_lead_score',
      format: (value: number) => `${value.toFixed(0)}/100`,
      color: getMetricColor('average_lead_score', metrics.average_lead_score)
    },
    {
      title: 'Atividades do Mês',
      value: metrics.activities_this_month,
      description: 'Atividades realizadas este mês',
      icon: 'activities_this_month',
      format: (value: number) => value.toString(),
      color: 'text-indigo-600'
    },
    {
      title: 'Atividades Atrasadas',
      value: metrics.overdue_activities,
      description: 'Atividades pendentes',
      icon: 'overdue_activities',
      format: (value: number) => value.toString(),
      color: getMetricColor('overdue_activities', metrics.overdue_activities)
    },
    {
      title: 'Follow-ups Próximos',
      value: metrics.upcoming_follow_ups,
      description: 'Follow-ups agendados',
      icon: 'upcoming_follow_ups',
      format: (value: number) => value.toString(),
      color: 'text-orange-600'
    }
  ];

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Dashboard CRM</h2>
          <p className="text-muted-foreground">
            Visão geral do seu pipeline de vendas
          </p>
        </div>
        <span className="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold bg-secondary text-secondary-foreground">
          Atualizado agora
        </span>
      </div>

      {/* Métricas Principais */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {metricCards.map((metric, index) => (
          <Card key={index} className="hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {metric.title}
              </CardTitle>
              <div className={metric.color}>
                {getMetricIcon(metric.icon)}
              </div>
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${metric.color}`}>
                {metric.format(metric.value)}
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                {metric.description}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Insights */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Performance */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <TrendingUp className="h-5 w-5" />
              Performance do Mês
            </CardTitle>
            <CardDescription>
              Resumo das atividades e conversões
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-sm text-muted-foreground">Atividades realizadas</span>
              <span className="font-medium">{metrics.activities_this_month}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm text-muted-foreground">Taxa de conversão</span>
              <span className={`font-medium ${getMetricColor('conversion_rate', metrics.conversion_rate)}`}>
                {formatPercentage(metrics.conversion_rate)}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm text-muted-foreground">Valor do pipeline</span>
              <span className="font-medium text-green-600">
                {formatCurrency(metrics.total_value_pipeline)}
              </span>
            </div>
          </CardContent>
        </Card>

        {/* Alertas */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <AlertTriangle className="h-5 w-5" />
              Alertas e Lembretes
            </CardTitle>
            <CardDescription>
              Ações que precisam de atenção
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {metrics.overdue_activities > 0 && (
              <div className="flex items-center justify-between p-3 bg-red-50 rounded-lg">
                <div className="flex items-center gap-2">
                  <Clock className="h-4 w-4 text-red-600" />
                  <span className="text-sm font-medium text-red-800">
                    {metrics.overdue_activities} atividades atrasadas
                  </span>
                </div>
                <span className="inline-flex items-center rounded-full border px-2 py-1 text-xs font-semibold bg-destructive text-destructive-foreground">
                  Urgente
                </span>
              </div>
            )}
            
            {metrics.upcoming_follow_ups > 0 && (
              <div className="flex items-center justify-between p-3 bg-blue-50 rounded-lg">
                <div className="flex items-center gap-2">
                  <Calendar className="h-4 w-4 text-blue-600" />
                  <span className="text-sm font-medium text-blue-800">
                    {metrics.upcoming_follow_ups} follow-ups agendados
                  </span>
                </div>
                <span className="inline-flex items-center rounded-full border px-2 py-1 text-xs font-semibold bg-secondary text-secondary-foreground">
                  Próximos
                </span>
              </div>
            )}

            {metrics.average_lead_score < 40 && (
              <div className="flex items-center justify-between p-3 bg-yellow-50 rounded-lg">
                <div className="flex items-center gap-2">
                  <Star className="h-4 w-4 text-yellow-600" />
                  <span className="text-sm font-medium text-yellow-800">
                    Lead score baixo ({metrics.average_lead_score.toFixed(0)}/100)
                  </span>
                </div>
                <span className="inline-flex items-center rounded-full border px-2 py-1 text-xs font-semibold border-border">
                  Atenção
                </span>
              </div>
            )}

            {metrics.overdue_activities === 0 && metrics.upcoming_follow_ups === 0 && metrics.average_lead_score >= 40 && (
              <div className="flex items-center justify-center p-6 text-center">
                <div className="space-y-2">
                  <CheckCircle className="h-8 w-8 text-green-600 mx-auto" />
                  <p className="text-sm font-medium text-green-800">
                    Tudo em dia!
                  </p>
                  <p className="text-xs text-muted-foreground">
                    Nenhum alerta pendente
                  </p>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
};
