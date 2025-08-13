import React, { useState, useEffect } from 'react';
import { supabase } from '../../integrations/supabase/client';
import { useAuth } from '../../hooks/useAuth';
import { FollowUp, FollowUpFormData, FollowUpWithClient } from '../../integrations/supabase/crm-types';
import { Button } from '../ui/button';
import { Input } from '../ui/input';
import { Label } from '../ui/label';
import { Textarea } from '../ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '../ui/dialog';
import { Card, CardContent, CardHeader, CardTitle } from '../ui/card';
import { Badge } from '../ui/badge';
import { useToast } from '../../hooks/use-toast';
import { Calendar, Clock, Phone, Mail, Users, CheckCircle, XCircle, AlertCircle, CalendarDays } from 'lucide-react';

interface FollowUpManagerProps {
  clientId?: string;
  onFollowUpCreated?: () => void;
}

export const FollowUpManager: React.FC<FollowUpManagerProps> = ({ clientId, onFollowUpCreated }) => {
  const { user } = useAuth();
  const { toast } = useToast();
  const [followUps, setFollowUps] = useState<FollowUpWithClient[]>([]);
  const [loading, setLoading] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingFollowUp, setEditingFollowUp] = useState<FollowUp | null>(null);
  const [formData, setFormData] = useState<FollowUpFormData>({
    title: '',
    description: '',
    scheduled_date: '',
    priority: 'medium',
    type: 'call',
    reminder_days: 1
  });

  // Carregar follow-ups
  const loadFollowUps = async () => {
    if (!user) return;

    setLoading(true);
    try {
      let query = supabase
        .from('follow_ups')
        .select(`
          *,
          client:clients(id, name, email, phone)
        `)
        .eq('user_id', user.id)
        .order('scheduled_date', { ascending: true });

      if (clientId) {
        query = query.eq('client_id', clientId);
      }

      const { data, error } = await query;

      if (error) throw error;

      setFollowUps(data || []);
    } catch (error: any) {
      console.error('Erro ao carregar follow-ups:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar follow-ups",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  // Carregar follow-ups do dia
  const loadTodayFollowUps = async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .rpc('get_today_follow_ups', { user_uuid: user.id });

      if (error) throw error;

      return data || [];
    } catch (error: any) {
      console.error('Erro ao carregar follow-ups do dia:', error);
      return [];
    }
  };

  // Carregar follow-ups atrasados
  const loadOverdueFollowUps = async () => {
    if (!user) return;

    try {
      const { data, error } = await supabase
        .rpc('get_overdue_follow_ups', { user_uuid: user.id });

      if (error) throw error;

      return data || [];
    } catch (error: any) {
      console.error('Erro ao carregar follow-ups atrasados:', error);
      return [];
    }
  };

  // Criar/editar follow-up
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    try {
      const followUpData = {
        ...formData,
        user_id: user.id,
        client_id: clientId || '',
        scheduled_date: new Date(formData.scheduled_date).toISOString()
      };

      if (editingFollowUp) {
        const { error } = await supabase
          .from('follow_ups')
          .update(followUpData)
          .eq('id', editingFollowUp.id);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Follow-up atualizado com sucesso"
        });
      } else {
        const { error } = await supabase
          .from('follow_ups')
          .insert([followUpData]);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Follow-up criado com sucesso"
        });
      }

      resetForm();
      await loadFollowUps();
      onFollowUpCreated?.();
    } catch (error: any) {
      console.error('Erro ao salvar follow-up:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao salvar follow-up",
        variant: "destructive"
      });
    }
  };

  // Marcar como concluído
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

      await loadFollowUps();
    } catch (error: any) {
      console.error('Erro ao marcar follow-up como concluído:', error);
      toast({
        title: "Erro",
        description: "Erro ao marcar follow-up como concluído",
        variant: "destructive"
      });
    }
  };

  // Excluir follow-up
  const deleteFollowUp = async (followUpId: string) => {
    if (!confirm('Tem certeza que deseja excluir este follow-up?')) return;

    try {
      const { error } = await supabase
        .from('follow_ups')
        .delete()
        .eq('id', followUpId);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Follow-up excluído com sucesso"
      });

      await loadFollowUps();
    } catch (error: any) {
      console.error('Erro ao excluir follow-up:', error);
      toast({
        title: "Erro",
        description: "Erro ao excluir follow-up",
        variant: "destructive"
      });
    }
  };

  // Resetar formulário
  const resetForm = () => {
    setFormData({
      title: '',
      description: '',
      scheduled_date: '',
      priority: 'medium',
      type: 'call',
      reminder_days: 1
    });
    setEditingFollowUp(null);
    setDialogOpen(false);
  };

  // Editar follow-up
  const handleEdit = (followUp: FollowUp) => {
    setEditingFollowUp(followUp);
    setFormData({
      title: followUp.title,
      description: followUp.description || '',
      scheduled_date: followUp.scheduled_date.split('T')[0],
      priority: followUp.priority,
      type: followUp.type,
      reminder_days: followUp.reminder_days
    });
    setDialogOpen(true);
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

  // Obter cor do status
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'completed': return 'bg-green-100 text-green-800';
      case 'overdue': return 'bg-red-100 text-red-800';
      case 'pending': return 'bg-yellow-100 text-yellow-800';
      case 'rescheduled': return 'bg-blue-100 text-blue-800';
      case 'cancelled': return 'bg-gray-100 text-gray-800';
      default: return 'bg-gray-100 text-gray-800';
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

  useEffect(() => {
    loadFollowUps();
  }, [user, clientId]);

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold">Follow-ups</h3>
          <p className="text-sm text-muted-foreground">
            Gerencie o acompanhamento de clientes
          </p>
        </div>
        <Button onClick={() => setDialogOpen(true)}>
          <Calendar className="w-4 h-4 mr-2" />
          Novo Follow-up
        </Button>
      </div>

      {/* Lista de follow-ups */}
      <div className="space-y-3">
        {loading ? (
          <div className="text-center py-8">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
            <p>Carregando follow-ups...</p>
          </div>
        ) : followUps.length === 0 ? (
          <div className="text-center py-8 text-muted-foreground">
            <Calendar className="w-12 h-12 mx-auto mb-4 opacity-50" />
            <p>Nenhum follow-up encontrado</p>
            <p className="text-sm">Crie seu primeiro follow-up para começar</p>
          </div>
        ) : (
          followUps.map((followUp) => (
            <Card key={followUp.id} className="hover:shadow-md transition-shadow">
              <CardHeader className="pb-3">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center space-x-2 mb-2">
                      {getTypeIcon(followUp.type)}
                      <CardTitle className="text-base">{followUp.title}</CardTitle>
                    </div>
                    
                    <div className="flex flex-wrap gap-2 mb-2">
                      <Badge className={getStatusColor(followUp.status)}>
                        {followUp.status === 'pending' ? 'Pendente' :
                         followUp.status === 'completed' ? 'Concluído' :
                         followUp.status === 'overdue' ? 'Atrasado' :
                         followUp.status === 'rescheduled' ? 'Reagendado' : 'Cancelado'}
                      </Badge>
                      <Badge className={getPriorityColor(followUp.priority)}>
                        {followUp.priority === 'urgent' ? 'Urgente' :
                         followUp.priority === 'high' ? 'Alta' :
                         followUp.priority === 'medium' ? 'Média' : 'Baixa'}
                      </Badge>
                    </div>

                    {followUp.client && (
                      <p className="text-sm text-muted-foreground">
                        Cliente: <span className="font-medium">{followUp.client.name}</span>
                      </p>
                    )}
                  </div>

                  <div className="flex space-x-1">
                    {followUp.status === 'pending' && (
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => markAsCompleted(followUp.id)}
                        className="h-8 w-8 p-0 hover:bg-green-100 hover:text-green-600"
                        title="Marcar como concluído"
                      >
                        <CheckCircle className="w-4 h-4" />
                      </Button>
                    )}
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => handleEdit(followUp)}
                      className="h-8 w-8 p-0 hover:bg-blue-100 hover:text-blue-600"
                      title="Editar"
                    >
                      <AlertCircle className="w-4 h-4" />
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => deleteFollowUp(followUp.id)}
                      className="h-8 w-8 p-0 hover:bg-red-100 hover:text-red-600"
                      title="Excluir"
                    >
                      <XCircle className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              </CardHeader>
              
              <CardContent className="pt-0">
                {followUp.description && (
                  <p className="text-sm text-muted-foreground mb-3">
                    {followUp.description}
                  </p>
                )}
                
                <div className="flex items-center space-x-4 text-sm text-muted-foreground">
                  <div className="flex items-center space-x-1">
                    <Calendar className="w-4 h-4" />
                    <span>
                      {new Date(followUp.scheduled_date).toLocaleDateString('pt-BR')}
                    </span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Clock className="w-4 h-4" />
                    <span>
                      {new Date(followUp.scheduled_date).toLocaleTimeString('pt-BR', {
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </span>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))
        )}
      </div>

      {/* Modal de follow-up */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle>
              {editingFollowUp ? 'Editar Follow-up' : 'Novo Follow-up'}
            </DialogTitle>
            <DialogDescription>
              {editingFollowUp ? 'Atualize as informações do follow-up' : 'Crie um novo follow-up para acompanhar o cliente'}
            </DialogDescription>
          </DialogHeader>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="title">Título *</Label>
              <Input
                id="title"
                placeholder="Ex: Ligar para cliente"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="description">Descrição</Label>
              <Textarea
                id="description"
                placeholder="Detalhes do follow-up..."
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                rows={3}
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="scheduled_date">Data e hora *</Label>
                <Input
                  id="scheduled_date"
                  type="datetime-local"
                  value={formData.scheduled_date}
                  onChange={(e) => setFormData({ ...formData, scheduled_date: e.target.value })}
                  required
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="type">Tipo</Label>
                <Select value={formData.type} onValueChange={(value) => setFormData({ ...formData, type: value as any })}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="call">Ligação</SelectItem>
                    <SelectItem value="email">Email</SelectItem>
                    <SelectItem value="meeting">Reunião</SelectItem>
                    <SelectItem value="task">Tarefa</SelectItem>
                    <SelectItem value="note">Nota</SelectItem>
                    <SelectItem value="follow_up">Follow-up</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="priority">Prioridade</Label>
                <Select value={formData.priority} onValueChange={(value) => setFormData({ ...formData, priority: value as any })}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="low">Baixa</SelectItem>
                    <SelectItem value="medium">Média</SelectItem>
                    <SelectItem value="high">Alta</SelectItem>
                    <SelectItem value="urgent">Urgente</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="reminder_days">Lembrete (dias antes)</Label>
                <Input
                  id="reminder_days"
                  type="number"
                  min="0"
                  max="30"
                  value={formData.reminder_days}
                  onChange={(e) => setFormData({ ...formData, reminder_days: parseInt(e.target.value) || 1 })}
                />
              </div>
            </div>

            <div className="flex justify-end space-x-2 pt-4">
              <Button type="button" variant="outline" onClick={resetForm}>
                Cancelar
              </Button>
              <Button type="submit">
                {editingFollowUp ? 'Atualizar' : 'Criar'} Follow-up
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
};
