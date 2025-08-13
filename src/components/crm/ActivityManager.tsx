import { useState } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '@/components/ui/dialog';
import { 
  Plus, 
  Calendar, 
  Clock, 
  Phone, 
  Mail, 
  Users, 
  CheckCircle, 
  XCircle,
  AlertTriangle,
  Edit,
  Trash2,
  Target
} from 'lucide-react';
import { Activity, ActivityFormData } from '@/integrations/supabase/crm-types';

interface ActivityManagerProps {
  activities: Activity[];
  clients: Array<{ id: string; name: string }>;
  onCreateActivity: (data: ActivityFormData) => Promise<void>;
  onUpdateActivity: (id: string, updates: Partial<Activity>) => Promise<void>;
  onDeleteActivity: (id: string) => Promise<void>;
  loading?: boolean;
}

export const ActivityManager = ({
  activities,
  clients,
  onCreateActivity,
  onUpdateActivity,
  onDeleteActivity,
  loading = false
}: ActivityManagerProps) => {
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingActivity, setEditingActivity] = useState<Activity | null>(null);
  const [formData, setFormData] = useState<ActivityFormData>({
    client_id: '',
    type: 'task',
    title: '',
    description: '',
    scheduled_at: '',
    priority: 'medium',
    duration_minutes: 30,
    location: '',
    attendees: []
  });

  const activityTypes = [
    { value: 'call', label: 'Ligação', icon: Phone },
    { value: 'email', label: 'Email', icon: Mail },
    { value: 'meeting', label: 'Reunião', icon: Users },
    { value: 'task', label: 'Tarefa', icon: Target },
    { value: 'note', label: 'Nota', icon: Edit },
    { value: 'follow_up', label: 'Follow-up', icon: Clock }
  ];

  const priorities = [
    { value: 'low', label: 'Baixa', color: 'text-green-600' },
    { value: 'medium', label: 'Média', color: 'text-yellow-600' },
    { value: 'high', label: 'Alta', color: 'text-orange-600' },
    { value: 'urgent', label: 'Urgente', color: 'text-red-600' }
  ];

  const getActivityIcon = (type: string) => {
    const activityType = activityTypes.find(t => t.value === type);
    return activityType ? activityType.icon : Target;
  };

  const getPriorityColor = (priority: string) => {
    const priorityItem = priorities.find(p => p.value === priority);
    return priorityItem ? priorityItem.color : 'text-gray-600';
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed':
        return <CheckCircle className="h-4 w-4 text-green-600" />;
      case 'cancelled':
        return <XCircle className="h-4 w-4 text-red-600" />;
      case 'overdue':
        return <AlertTriangle className="h-4 w-4 text-orange-600" />;
      default:
        return <Clock className="h-4 w-4 text-blue-600" />;
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      if (editingActivity) {
        await onUpdateActivity(editingActivity.id, formData);
      } else {
        await onCreateActivity(formData);
      }
      
      resetForm();
      setDialogOpen(false);
    } catch (error) {
      console.error('Erro ao salvar atividade:', error);
    }
  };

  const handleEdit = (activity: Activity) => {
    setEditingActivity(activity);
    setFormData({
      client_id: activity.client_id,
      type: activity.type,
      title: activity.title,
      description: activity.description || '',
      scheduled_at: activity.scheduled_at ? new Date(activity.scheduled_at).toISOString().slice(0, 16) : '',
      priority: activity.priority,
      duration_minutes: activity.duration_minutes || 30,
      location: activity.location || '',
      attendees: activity.attendees || []
    });
    setDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (confirm('Tem certeza que deseja excluir esta atividade?')) {
      await onDeleteActivity(id);
    }
  };

  const resetForm = () => {
    setFormData({
      client_id: '',
      type: 'task',
      title: '',
      description: '',
      scheduled_at: '',
      priority: 'medium',
      duration_minutes: 30,
      location: '',
      attendees: []
    });
    setEditingActivity(null);
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  const getClientName = (clientId: string) => {
    const client = clients.find(c => c.id === clientId);
    return client ? client.name : 'Cliente não encontrado';
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Atividades</h2>
          <p className="text-muted-foreground">
            Gerencie suas atividades e compromissos
          </p>
        </div>
        <Button onClick={() => setDialogOpen(true)}>
          <Plus className="w-4 h-4 mr-2" />
          Nova Atividade
        </Button>
      </div>

      {/* Lista de Atividades */}
      <div className="grid gap-4">
        {activities.map((activity) => {
          const ActivityIcon = getActivityIcon(activity.type);
          const activityType = activityTypes.find(t => t.value === activity.type);
          
          return (
            <Card key={activity.id} className="hover:shadow-md transition-shadow">
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-start space-x-3 flex-1">
                    <div className="p-2 bg-blue-100 rounded-lg">
                      <ActivityIcon className="h-5 w-5 text-blue-600" />
                    </div>
                    
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center space-x-2 mb-1">
                        <h3 className="font-semibold text-lg truncate">
                          {activity.title}
                        </h3>
                        {getStatusIcon(activity.status)}
                      </div>
                      
                      <p className="text-sm text-muted-foreground mb-2">
                        {activity.description}
                      </p>
                      
                      <div className="flex items-center space-x-4 text-sm text-muted-foreground">
                        <span className="flex items-center">
                          <Target className="w-3 h-3 mr-1" />
                          {getClientName(activity.client_id)}
                        </span>
                        
                        {activity.scheduled_at && (
                          <span className="flex items-center">
                            <Calendar className="w-3 h-3 mr-1" />
                            {formatDate(activity.scheduled_at)}
                          </span>
                        )}
                        
                        <span className={`flex items-center ${getPriorityColor(activity.priority)}`}>
                          <AlertTriangle className="w-3 h-3 mr-1" />
                          {priorities.find(p => p.value === activity.priority)?.label}
                        </span>
                        
                        {activity.duration_minutes && (
                          <span className="flex items-center">
                            <Clock className="w-3 h-3 mr-1" />
                            {activity.duration_minutes} min
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center space-x-2">
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => handleEdit(activity)}
                    >
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => handleDelete(activity.id)}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
        
        {activities.length === 0 && !loading && (
          <Card>
            <CardContent className="p-8 text-center">
              <Calendar className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-medium mb-2">Nenhuma atividade</h3>
              <p className="text-muted-foreground mb-4">
                Comece criando sua primeira atividade
              </p>
              <Button onClick={() => setDialogOpen(true)}>
                <Plus className="w-4 h-4 mr-2" />
                Criar Atividade
              </Button>
            </CardContent>
          </Card>
        )}
      </div>

      {/* Modal de Atividade */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-[600px]">
          <DialogHeader>
            <DialogTitle>
              {editingActivity ? 'Editar Atividade' : 'Nova Atividade'}
            </DialogTitle>
            <DialogDescription>
              {editingActivity ? 'Atualize os detalhes da atividade' : 'Crie uma nova atividade'}
            </DialogDescription>
          </DialogHeader>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="client">Cliente *</Label>
                <Select 
                  value={formData.client_id} 
                  onValueChange={(value) => setFormData({ ...formData, client_id: value })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione um cliente" />
                  </SelectTrigger>
                  <SelectContent>
                    {clients.map((client) => (
                      <SelectItem key={client.id} value={client.id}>
                        {client.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="type">Tipo *</Label>
                <Select 
                  value={formData.type} 
                  onValueChange={(value: any) => setFormData({ ...formData, type: value })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione o tipo" />
                  </SelectTrigger>
                  <SelectContent>
                    {activityTypes.map((type) => (
                      <SelectItem key={type.value} value={type.value}>
                        {type.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="title">Título *</Label>
              <Input
                id="title"
                placeholder="Título da atividade"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                required
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="description">Descrição</Label>
              <Textarea
                id="description"
                placeholder="Detalhes da atividade..."
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                rows={3}
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="space-y-2">
                <Label htmlFor="scheduled_at">Data/Hora</Label>
                <Input
                  id="scheduled_at"
                  type="datetime-local"
                  value={formData.scheduled_at}
                  onChange={(e) => setFormData({ ...formData, scheduled_at: e.target.value })}
                />
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="priority">Prioridade</Label>
                <Select 
                  value={formData.priority} 
                  onValueChange={(value: any) => setFormData({ ...formData, priority: value })}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Selecione a prioridade" />
                  </SelectTrigger>
                  <SelectContent>
                    {priorities.map((priority) => (
                      <SelectItem key={priority.value} value={priority.value}>
                        {priority.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="duration">Duração (min)</Label>
                <Input
                  id="duration"
                  type="number"
                  placeholder="30"
                  value={formData.duration_minutes}
                  onChange={(e) => setFormData({ ...formData, duration_minutes: parseInt(e.target.value) || 30 })}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="location">Local</Label>
              <Input
                id="location"
                placeholder="Local da atividade"
                value={formData.location}
                onChange={(e) => setFormData({ ...formData, location: e.target.value })}
              />
            </div>

            <div className="flex justify-end space-x-2">
              <Button type="button" variant="outline" onClick={() => {
                setDialogOpen(false);
                resetForm();
              }}>
                Cancelar
              </Button>
              <Button type="submit">
                {editingActivity ? 'Atualizar' : 'Criar'} Atividade
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
};
