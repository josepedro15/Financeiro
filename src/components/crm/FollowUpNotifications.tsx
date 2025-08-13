import React, { useState, useEffect } from 'react';
import { supabase } from '../../integrations/supabase/client';
import { useAuth } from '../../hooks/useAuth';
import { useToast } from '../../hooks/use-toast';
import { Card, CardContent, CardHeader, CardTitle } from '../ui/card';
import { Button } from '../ui/button';
import { Badge } from '../ui/badge';
import { 
  Bell, 
  Calendar, 
  Clock, 
  Phone, 
  Mail, 
  Users, 
  CheckCircle, 
  XCircle, 
  AlertCircle,
  CalendarDays,
  ChevronDown,
  ChevronUp
} from 'lucide-react';
import { FollowUpWithClient } from '../../integrations/supabase/crm-types';

interface FollowUpNotificationsProps {
  onFollowUpCompleted?: (followUpId: string) => void;
}

export const FollowUpNotifications: React.FC<FollowUpNotificationsProps> = ({ 
  onFollowUpCompleted 
}) => {
  const { user } = useAuth();
  const { toast } = useToast();
  const [todayFollowUps, setTodayFollowUps] = useState<FollowUpWithClient[]>([]);
  const [overdueFollowUps, setOverdueFollowUps] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [expanded, setExpanded] = useState(true);

  // Carregar follow-ups do dia
  const loadTodayFollowUps = async () => {
    if (!user) return;

    setLoading(true);
    try {
      const { data, error } = await supabase
        .from('follow_ups')
        .select(`
          *,
          client:clients(id, name, email, phone)
        `)
        .eq('user_id', user.id)
        .eq('status', 'pending')
        .gte('scheduled_date', new Date().toISOString().split('T')[0] + 'T00:00:00')
        .lt('scheduled_date', new Date().toISOString().split('T')[0] + 'T23:59:59')
        .order('scheduled_date', { ascending: true });

      if (error) throw error;

      setTodayFollowUps(data || []);
    } catch (error: any) {
      console.error('Erro ao carregar follow-ups do dia:', error);
    } finally {
      setLoading(false);
    }
  };

  // Carregar follow-ups atrasados
  const loadOverdueFollowUps = async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .rpc('get_overdue_follow_ups', { user_uuid: user.id });

      if (error) throw error;

      setOverdueFollowUps(data || []);
    } catch (error: any) {
      console.error('Erro ao carregar follow-ups atrasados:', error);
    }
  };

  // Marcar follow-up como concluído
  const markAsCompleted = async (followUpId: string) => {
    try {
      const { error } = await supabase
        .from('follow_ups')
        .update({
          status: 'completed',
          completed_date: new Date().toISOString()
        })
        .eq('id', followUpId);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Follow-up marcado como concluído"
      });

      // Recarregar dados
      await loadTodayFollowUps();
      await loadOverdueFollowUps();
      
      // Notificar componente pai
      onFollowUpCompleted?.(followUpId);
    } catch (error: any) {
      console.error('Erro ao marcar follow-up como concluído:', error);
      toast({
        title: "Erro",
        description: "Erro ao marcar follow-up como concluído",
        variant: "destructive"
      });
    }
  };

  // Obter ícone do tipo
  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'call': return <Phone className="w-4 h-4" />;
      case 'email': return <Mail className="w-4 h-4" />;
      case 'meeting': return <Users className="w-4 h-4" />;
      case 'task': return <CheckCircle className="w-4 h-4" />;
      case 'note': return <AlertCircle className="w-4 h-4" />;
      default: return <CalendarDays className="w-4 h-4" />;
    }
  };

  // Obter cor da prioridade
  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'urgent': return 'bg-red-100 text-red-800 border-red-200';
      case 'high': return 'bg-orange-100 text-orange-800 border-orange-200';
      case 'medium': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'low': return 'bg-green-100 text-green-800 border-green-200';
      default: return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  // Formatar hora
  const formatTime = (dateString: string) => {
    return new Date(dateString).toLocaleTimeString('pt-BR', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // Calcular se está atrasado
  const isOverdue = (scheduledDate: string) => {
    return new Date(scheduledDate) < new Date();
  };

  useEffect(() => {
    loadTodayFollowUps();
    loadOverdueFollowUps();
  }, [user]);

  const totalFollowUps = todayFollowUps.length + overdueFollowUps.length;

  if (totalFollowUps === 0) {
    return null; // Não mostrar nada se não há follow-ups
  }

  return (
    <Card className="mb-6 border-orange-200 bg-orange-50/50">
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center">
              <Bell className="w-5 h-5 text-orange-600" />
            </div>
            <div>
              <CardTitle className="text-lg text-orange-900">
                Lembretes de Follow-up
              </CardTitle>
              <p className="text-sm text-orange-700">
                {totalFollowUps} follow-up{totalFollowUps > 1 ? 's' : ''} para hoje
              </p>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            {overdueFollowUps.length > 0 && (
              <Badge className="bg-red-100 text-red-800 border-red-200">
                {overdueFollowUps.length} atrasado{overdueFollowUps.length > 1 ? 's' : ''}
              </Badge>
            )}
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setExpanded(!expanded)}
              className="text-orange-700 hover:text-orange-800"
            >
              {expanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
            </Button>
          </div>
        </div>
      </CardHeader>

      {expanded && (
        <CardContent className="pt-0">
          {loading ? (
            <div className="text-center py-4">
              <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-orange-600 mx-auto"></div>
              <p className="text-sm text-orange-700 mt-2">Carregando...</p>
            </div>
          ) : (
            <div className="space-y-3">
              {/* Follow-ups atrasados */}
              {overdueFollowUps.length > 0 && (
                <div>
                  <h4 className="font-semibold text-red-800 mb-2 flex items-center space-x-2">
                    <AlertCircle className="w-4 h-4" />
                    <span>Atrasados</span>
                  </h4>
                  <div className="space-y-2">
                    {overdueFollowUps.map((followUp) => (
                      <div
                        key={followUp.id}
                        className="p-3 bg-red-50 border border-red-200 rounded-lg"
                      >
                        <div className="flex items-start justify-between">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2 mb-1">
                              {getTypeIcon(followUp.type)}
                              <span className="font-medium text-red-900">
                                {followUp.title}
                              </span>
                            </div>
                            <p className="text-sm text-red-700">
                              Cliente: {followUp.client_name}
                            </p>
                            <p className="text-xs text-red-600">
                              Atrasado há {followUp.days_overdue} dia{followUp.days_overdue > 1 ? 's' : ''}
                            </p>
                          </div>
                          <Button
                            size="sm"
                            onClick={() => markAsCompleted(followUp.id)}
                            className="bg-red-600 hover:bg-red-700 text-white"
                          >
                            <CheckCircle className="w-4 h-4 mr-1" />
                            Concluir
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Follow-ups de hoje */}
              {todayFollowUps.length > 0 && (
                <div>
                  <h4 className="font-semibold text-orange-800 mb-2 flex items-center space-x-2">
                    <Calendar className="w-4 h-4" />
                    <span>Para hoje</span>
                  </h4>
                  <div className="space-y-2">
                    {todayFollowUps.map((followUp) => (
                      <div
                        key={followUp.id}
                        className={`p-3 border rounded-lg ${
                          isOverdue(followUp.scheduled_date)
                            ? 'bg-red-50 border-red-200'
                            : 'bg-white border-orange-200'
                        }`}
                      >
                        <div className="flex items-start justify-between">
                          <div className="flex-1">
                            <div className="flex items-center space-x-2 mb-1">
                              {getTypeIcon(followUp.type)}
                              <span className="font-medium text-orange-900">
                                {followUp.title}
                              </span>
                            </div>
                            
                            <div className="flex items-center space-x-2 mb-1">
                              <Badge className={getPriorityColor(followUp.priority)}>
                                {followUp.priority === 'urgent' ? 'Urgente' :
                                 followUp.priority === 'high' ? 'Alta' :
                                 followUp.priority === 'medium' ? 'Média' : 'Baixa'}
                              </Badge>
                              {isOverdue(followUp.scheduled_date) && (
                                <Badge className="bg-red-100 text-red-800 border-red-200">
                                  Atrasado
                                </Badge>
                              )}
                            </div>

                            <p className="text-sm text-orange-700">
                              Cliente: {followUp.client?.name}
                            </p>
                            
                            <div className="flex items-center space-x-4 text-xs text-orange-600 mt-1">
                              <div className="flex items-center space-x-1">
                                <Clock className="w-3 h-3" />
                                <span>{formatTime(followUp.scheduled_date)}</span>
                              </div>
                              {followUp.description && (
                                <span className="truncate max-w-40">
                                  {followUp.description}
                                </span>
                              )}
                            </div>
                          </div>
                          
                          <Button
                            size="sm"
                            onClick={() => markAsCompleted(followUp.id)}
                            className={`${
                              isOverdue(followUp.scheduled_date)
                                ? 'bg-red-600 hover:bg-red-700'
                                : 'bg-orange-600 hover:bg-orange-700'
                            } text-white`}
                          >
                            <CheckCircle className="w-4 h-4 mr-1" />
                            Concluir
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          )}
        </CardContent>
      )}
    </Card>
  );
};
