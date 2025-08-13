import React, { useState, useEffect } from 'react';
import { supabase } from '../../integrations/supabase/client';
import { useAuth } from '../../hooks/useAuth';
import { useToast } from '../../hooks/use-toast';
import { Button } from '../ui/button';
import { Badge } from '../ui/badge';
import { 
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '../ui/dropdown-menu';
import { 
  Bell, 
  Calendar, 
  Clock, 
  Phone, 
  Mail, 
  Users, 
  CheckCircle, 
  AlertCircle,
  CalendarDays,
  ChevronDown
} from 'lucide-react';
import { FollowUpWithClient } from '../../integrations/supabase/crm-types';

interface FollowUpDropdownProps {
  onFollowUpCompleted?: (followUpId: string) => void;
}

export const FollowUpDropdown: React.FC<FollowUpDropdownProps> = ({ 
  onFollowUpCompleted 
}) => {
  const { user } = useAuth();
  const { toast } = useToast();
  const [todayFollowUps, setTodayFollowUps] = useState<FollowUpWithClient[]>([]);
  const [overdueFollowUps, setOverdueFollowUps] = useState<any[]>([]);
  const [clientsWithFollowUp, setClientsWithFollowUp] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);

  // Carregar follow-ups do dia
  const loadTodayFollowUps = async () => {
    if (!user) return;

    setLoading(true);
    try {
      console.log('🔍 Carregando follow-ups do dia...');
      const realToday = new Date().toISOString().split('T')[0];
      console.log('📅 Data real de hoje:', realToday);
      
      // Usar data real de hoje para consulta
      const todayString = realToday;
      console.log('🔍 Data para consulta (hoje real):', todayString);
      
      const { data, error } = await supabase
        .from('follow_ups')
        .select(`
          *,
          client:clients(id, name, email, phone)
        `)
        .eq('user_id', user.id)
        .eq('status', 'pending')
        .gte('scheduled_date', todayString + 'T00:00:00')
        .lt('scheduled_date', todayString + 'T23:59:59')
        .order('scheduled_date', { ascending: true });

      if (error) throw error;

      console.log('📊 Follow-ups encontrados na tabela follow_ups:', data);
      console.log('🔍 Query executada para follow_ups:', `scheduled_date >= ${todayString}T00:00:00 AND scheduled_date < ${todayString}T23:59:59`);
      setTodayFollowUps(data || []);
      
      // Verificar se há clientes com next_follow_up para hoje
      const { data: clientsWithFollowUp, error: clientsError } = await supabase
        .from('clients')
        .select('id, name, email, phone, next_follow_up')
        .eq('user_id', user.id)
        .not('next_follow_up', 'is', null)
        .gte('next_follow_up', todayString + 'T00:00:00')
        .lt('next_follow_up', todayString + 'T23:59:59');

      if (clientsError) {
        console.error('Erro ao carregar clientes com follow-up:', clientsError);
      } else {
        console.log('👥 Clientes com next_follow_up para hoje:', clientsWithFollowUp);
        console.log('🔍 Query executada para clients:', `next_follow_up >= ${todayString}T00:00:00 AND next_follow_up < ${todayString}T23:59:59`);
        setClientsWithFollowUp(clientsWithFollowUp || []);
      }
      
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

  // Marcar follow-up do cliente como concluído
  const markClientFollowUpAsCompleted = async (clientId: string) => {
    try {
      // Atualizar last_contact_date para hoje e limpar next_follow_up
      const { error } = await supabase
        .from('clients')
        .update({
          last_contact_date: new Date().toISOString(),
          next_follow_up: null,
          updated_at: new Date().toISOString()
        })
        .eq('id', clientId);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Follow-up do cliente marcado como concluído"
      });

      // Recarregar dados
      await loadTodayFollowUps();
      await loadOverdueFollowUps();
      
      // Notificar componente pai para recarregar clientes
      onFollowUpCompleted?.(clientId);
    } catch (error: any) {
      console.error('Erro ao marcar follow-up do cliente como concluído:', error);
      toast({
        title: "Erro",
        description: "Erro ao marcar follow-up do cliente como concluído",
        variant: "destructive"
      });
    }
  };

  // Obter ícone do tipo
  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'call': return <Phone className="w-3 h-3" />;
      case 'email': return <Mail className="w-3 h-3" />;
      case 'meeting': return <Users className="w-3 h-3" />;
      case 'task': return <CheckCircle className="w-3 h-3" />;
      case 'note': return <AlertCircle className="w-3 h-3" />;
      default: return <CalendarDays className="w-3 h-3" />;
    }
  };

  // Obter cor da prioridade
  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'urgent': return 'bg-red-100 text-red-800';
      case 'high': return 'bg-orange-100 text-orange-800';
      case 'medium': return 'bg-yellow-100 text-yellow-800';
      case 'low': return 'bg-green-100 text-green-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  // Formatar hora
  const formatTime = (dateString: string) => {
    return new Date(dateString).toLocaleTimeString('pt-BR', {
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  // Formatar data sem compensação de fuso horário (para exibição no dropdown)
  const formatDateOriginal = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('pt-BR');
  };

  // Formatar data com +1 dia para exibição (apenas onde está "Próximo:")
  const formatDateWithPlusOne = (dateString: string) => {
    const date = new Date(dateString);
    date.setDate(date.getDate() + 1);
    return date.toLocaleDateString('pt-BR');
  };

  // Calcular se está atrasado
  const isOverdue = (scheduledDate: string) => {
    return new Date(scheduledDate) < new Date();
  };

  useEffect(() => {
    loadTodayFollowUps();
    loadOverdueFollowUps();
  }, [user]);

  const totalFollowUps = todayFollowUps.length + overdueFollowUps.length + clientsWithFollowUp.length;

  return (
    <DropdownMenu open={open} onOpenChange={setOpen}>
      <DropdownMenuTrigger asChild>
        <Button 
          variant="outline" 
          size="sm"
          className="relative flex items-center space-x-2 hover:bg-white/80 transition-colors"
        >
          <Bell className="w-4 h-4" />
          <span>Follow-ups</span>
          {totalFollowUps > 0 && (
            <Badge className="absolute -top-2 -right-2 h-5 w-5 rounded-full p-0 flex items-center justify-center text-xs bg-red-500 text-white">
              {totalFollowUps}
            </Badge>
          )}
          <ChevronDown className="w-3 h-3" />
        </Button>
      </DropdownMenuTrigger>
      
      <DropdownMenuContent align="end" className="w-80 max-h-96 overflow-y-auto">
        <DropdownMenuLabel className="flex items-center space-x-2">
          <Calendar className="w-4 h-4" />
          <span>Follow-ups de Hoje</span>
          {totalFollowUps > 0 && (
            <Badge variant="secondary" className="ml-auto">
              {totalFollowUps}
            </Badge>
          )}
        </DropdownMenuLabel>
        
        <DropdownMenuSeparator />
        
        {loading ? (
          <div className="p-4 text-center">
            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600 mx-auto mb-2"></div>
            <p className="text-xs text-muted-foreground">Carregando...</p>
          </div>
        ) : totalFollowUps === 0 ? (
          <div className="p-4 text-center">
            <Bell className="w-8 h-8 text-muted-foreground mx-auto mb-2" />
            <p className="text-sm text-muted-foreground">Nenhum follow-up para hoje</p>
          </div>
        ) : (
          <>
            {/* Follow-ups atrasados */}
            {overdueFollowUps.length > 0 && (
              <>
                <DropdownMenuLabel className="text-red-700 font-semibold flex items-center space-x-2">
                  <AlertCircle className="w-4 h-4" />
                  <span>Atrasados ({overdueFollowUps.length})</span>
                </DropdownMenuLabel>
                
                {overdueFollowUps.map((followUp) => (
                  <DropdownMenuItem key={followUp.id} className="flex flex-col items-start p-3 space-y-2">
                    <div className="flex items-center justify-between w-full">
                      <div className="flex items-center space-x-2">
                        {getTypeIcon(followUp.type)}
                        <span className="font-medium text-sm">{followUp.title}</span>
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={(e) => {
                          e.stopPropagation();
                          markAsCompleted(followUp.id);
                        }}
                        className="h-6 w-6 p-0 hover:bg-green-100 hover:text-green-600"
                      >
                        <CheckCircle className="w-3 h-3" />
                      </Button>
                    </div>
                    <div className="w-full">
                      <p className="text-xs text-muted-foreground">
                        Cliente: {followUp.client_name}
                      </p>
                      <p className="text-xs text-red-600">
                        Atrasado há {followUp.days_overdue} dia{followUp.days_overdue > 1 ? 's' : ''}
                      </p>
                    </div>
                  </DropdownMenuItem>
                ))}
                
                <DropdownMenuSeparator />
              </>
            )}

            {/* Follow-ups de hoje */}
            {todayFollowUps.length > 0 && (
              <>
                <DropdownMenuLabel className="text-orange-700 font-semibold flex items-center space-x-2">
                  <Calendar className="w-4 h-4" />
                  <span>Para hoje ({todayFollowUps.length})</span>
                </DropdownMenuLabel>
                
                {todayFollowUps.map((followUp) => (
                  <DropdownMenuItem key={followUp.id} className="flex flex-col items-start p-3 space-y-2">
                    <div className="flex items-center justify-between w-full">
                      <div className="flex items-center space-x-2">
                        {getTypeIcon(followUp.type)}
                        <span className="font-medium text-sm">{followUp.title}</span>
                        <Badge className={getPriorityColor(followUp.priority)}>
                          {followUp.priority === 'urgent' ? 'Urgente' :
                           followUp.priority === 'high' ? 'Alta' :
                           followUp.priority === 'medium' ? 'Média' : 'Baixa'}
                        </Badge>
                        {isOverdue(followUp.scheduled_date) && (
                          <Badge className="bg-red-100 text-red-800">
                            Atrasado
                          </Badge>
                        )}
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={(e) => {
                          e.stopPropagation();
                          markAsCompleted(followUp.id);
                        }}
                        className="h-6 w-6 p-0 hover:bg-green-100 hover:text-green-600"
                      >
                        <CheckCircle className="w-3 h-3" />
                      </Button>
                    </div>
                    <div className="w-full">
                      <p className="text-xs text-muted-foreground">
                        Cliente: {followUp.client?.name}
                      </p>
                      <div className="flex items-center space-x-2 text-xs text-muted-foreground">
                        <Clock className="w-3 h-3" />
                        <span>{formatTime(followUp.scheduled_date)}</span>
                        {followUp.description && (
                          <span className="truncate max-w-32">
                            {followUp.description}
                          </span>
                        )}
                      </div>
                    </div>
                  </DropdownMenuItem>
                ))}
              </>
            )}

            {/* Clientes com next_follow_up para hoje */}
            {clientsWithFollowUp.length > 0 && (
              <>
                <DropdownMenuSeparator />
                <DropdownMenuLabel className="text-blue-700 font-semibold flex items-center space-x-2">
                  <Calendar className="w-4 h-4" />
                  <span>Clientes com Follow-up ({clientsWithFollowUp.length})</span>
                </DropdownMenuLabel>
                
                {clientsWithFollowUp.map((client) => (
                  <DropdownMenuItem key={client.id} className="flex flex-col items-start p-3 space-y-2">
                    <div className="flex items-center justify-between w-full">
                      <div className="flex items-center space-x-2">
                        <CalendarDays className="w-3 h-3" />
                        <span className="font-medium text-sm">Follow-up agendado</span>
                        <Badge className="bg-blue-100 text-blue-800">
                          Cliente
                        </Badge>
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={(e) => {
                          e.stopPropagation();
                          markClientFollowUpAsCompleted(client.id);
                        }}
                        className="h-6 w-6 p-0 hover:bg-green-100 hover:text-green-600"
                        title="Marcar follow-up como concluído"
                      >
                        <CheckCircle className="w-3 h-3" />
                      </Button>
                    </div>
                    <div className="w-full">
                      <p className="text-xs text-muted-foreground">
                        Cliente: {client.name}
                      </p>
                      <div className="flex items-center space-x-2 text-xs text-muted-foreground">
                        <Clock className="w-3 h-3" />
                        <span>Próximo: {formatDateWithPlusOne(client.next_follow_up)}</span>
                      </div>
                    </div>
                  </DropdownMenuItem>
                ))}
              </>
            )}
          </>
        )}
      </DropdownMenuContent>
    </DropdownMenu>
  );
};
