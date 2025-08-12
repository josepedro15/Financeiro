import React, { useState, useEffect } from 'react';
import { useAuth } from '../hooks/useAuth';
import { supabase } from '../integrations/supabase/client';
import { useToast } from '../hooks/use-toast';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from '../components/ui/dialog';
import { Input } from '../components/ui/input';
import { Label } from '../components/ui/label';
import { Textarea } from '../components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../components/ui/select';
import { 
  Users, 
  Plus, 
  Settings, 
  Edit, 
  Trash2, 
  Mail, 
  Phone, 
  Target,
  UserCheck,
  UserX,
  DollarSign,
  CheckCircle,
  Clock,
  AlertCircle
} from 'lucide-react';

// Tipos
interface Client {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  document?: string;
  address?: string;
  stage: string;
  notes?: string;
  is_active: boolean;
  user_id: string;
  created_at: string;
  updated_at: string;
}

interface Stage {
  key: string;
  name: string;
  description?: string;
  icon: any;
  color: string;
  order_index: number;
  is_default: boolean;
}

// Ícones dos estágios
const iconMap = {
  target: Target,
  userCheck: UserCheck,
  userX: UserX,
  dollarSign: DollarSign,
  checkCircle: CheckCircle,
  clock: Clock,
  alertCircle: AlertCircle
};

// Estágios padrão
const defaultStages: Stage[] = [
  {
    key: 'lead',
    name: 'Lead',
    description: 'Contatos iniciais',
    icon: Target,
    color: 'bg-yellow-100 text-yellow-800',
    order_index: 1,
    is_default: true
  },
  {
    key: 'prospect',
    name: 'Prospecto',
    description: 'Interessados',
    icon: UserCheck,
    color: 'bg-blue-100 text-blue-800',
    order_index: 2,
    is_default: false
  },
  {
    key: 'negotiation',
    name: 'Negociação',
    description: 'Em negociação',
    icon: DollarSign,
    color: 'bg-purple-100 text-purple-800',
    order_index: 3,
    is_default: false
  },
  {
    key: 'closed',
    name: 'Fechado',
    description: 'Venda realizada',
    icon: CheckCircle,
    color: 'bg-green-100 text-green-800',
    order_index: 4,
    is_default: false
  }
];

export default function Clients() {
  const { user } = useAuth();
  const { toast } = useToast();
  
  // Estados
  const [clients, setClients] = useState<Client[]>([]);
  const [stages, setStages] = useState<Record<string, Stage>>({});
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [stagesDialogOpen, setStagesDialogOpen] = useState(false);
  const [editingClient, setEditingClient] = useState<Client | null>(null);
  const [editingStage, setEditingStage] = useState<Stage | null>(null);
  
  // Formulários
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    document: '',
    address: '',
    stage: 'lead',
    notes: ''
  });
  
  const [stageFormData, setStageFormData] = useState({
    key: '',
    name: '',
    description: '',
    icon: 'target',
    color: 'bg-yellow-100 text-yellow-800',
    order_index: 1
  });

  // Carregar dados iniciais
  useEffect(() => {
    if (user) {
      loadStages();
      loadClients();
    }
  }, [user]);

  // Carregar estágios
  const loadStages = async () => {
    try {
      console.log('🔄 Carregando estágios...');
      
      // Primeiro, verificar se existem estágios no banco
      const { data: existingStages, error } = await supabase
        .from('stages')
        .select('*')
        .eq('user_id', user?.id)
        .order('order_index');

      if (error) {
        console.error('❌ Erro ao carregar estágios:', error);
        // Se não existem estágios, criar os padrões
        await createDefaultStages();
      } else if (!existingStages || existingStages.length === 0) {
        console.log('📝 Nenhum estágio encontrado, criando padrões...');
        await createDefaultStages();
      } else {
        console.log('✅ Estágios carregados:', existingStages.length);
        const stagesObject = existingStages.reduce((acc, stage) => {
          acc[stage.key] = {
            ...stage,
            icon: iconMap[stage.icon as keyof typeof iconMap] || Target
          };
          return acc;
        }, {} as Record<string, Stage>);
        setStages(stagesObject);
      }
    } catch (error) {
      console.error('❌ Erro ao carregar estágios:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar estágios",
        variant: "destructive"
      });
    }
  };

  // Criar estágios padrão
  const createDefaultStages = async () => {
    try {
      console.log('📝 Criando estágios padrão...');
      
      const stagesToCreate = defaultStages.map(stage => ({
        ...stage,
        user_id: user?.id,
        icon: stage.icon.name.toLowerCase()
      }));

      const { error } = await supabase
        .from('stages')
        .insert(stagesToCreate);

      if (error) {
        console.error('❌ Erro ao criar estágios padrão:', error);
        throw error;
      }

      console.log('✅ Estágios padrão criados');
      
      // Recarregar estágios
      await loadStages();
    } catch (error) {
      console.error('❌ Erro ao criar estágios padrão:', error);
      // Usar estágios padrão em memória
      const stagesObject = defaultStages.reduce((acc, stage) => {
        acc[stage.key] = stage;
        return acc;
      }, {} as Record<string, Stage>);
      setStages(stagesObject);
    }
  };

  // Carregar clientes
  const loadClients = async () => {
    if (!user) return;

    setLoading(true);
    try {
      console.log('🔄 Carregando clientes...');
      
      const { data: clientsData, error } = await supabase
        .from('clients')
        .select('*')
        .eq('user_id', user.id)
        .eq('is_active', true)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('❌ Erro ao carregar clientes:', error);
        toast({
          title: "Erro",
          description: `Erro ao carregar clientes: ${error.message}`,
          variant: "destructive"
        });
        return;
      }

      console.log('✅ Clientes carregados:', clientsData?.length || 0);
      setClients(clientsData || []);
    } catch (error) {
      console.error('❌ Erro ao carregar clientes:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar clientes",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  // Obter clientes por estágio
  const getClientsByStage = (stageKey: string) => {
    return clients.filter(client => client.stage === stageKey);
  };

  // Handlers
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    try {
      console.log('🔄 Salvando cliente...');
      
      const clientData = {
        user_id: user.id,
        name: formData.name.trim(),
        email: formData.email.trim() || null,
        phone: formData.phone.trim() || null,
        document: formData.document.trim() || null,
        address: formData.address.trim() || null,
        stage: formData.stage,
        notes: formData.notes.trim() || null,
        is_active: true
      };

      if (editingClient) {
        console.log('✏️ Atualizando cliente:', editingClient.id);
        const { error } = await supabase
          .from('clients')
          .update(clientData)
          .eq('id', editingClient.id);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Cliente atualizado com sucesso"
        });
      } else {
        console.log('➕ Criando novo cliente');
        const { error } = await supabase
          .from('clients')
          .insert([clientData]);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Cliente criado com sucesso"
        });
      }

      // Limpar formulário e recarregar
      resetForm();
      await loadClients();
      
    } catch (error: any) {
      console.error('❌ Erro ao salvar cliente:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao salvar cliente",
        variant: "destructive"
      });
    }
  };

  const handleEdit = (client: Client) => {
    console.log('✏️ Editando cliente:', client);
    setEditingClient(client);
    setFormData({
      name: client.name,
      email: client.email || '',
      phone: client.phone || '',
      document: client.document || '',
      address: client.address || '',
      stage: client.stage,
      notes: client.notes || ''
    });
    setDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    console.log('🗑️ Deletando cliente:', id);
    
    if (!confirm('Tem certeza que deseja excluir este cliente?')) {
      return;
    }

    try {
      const { error } = await supabase
        .from('clients')
        .update({
          is_active: false,
          updated_at: new Date().toISOString()
        })
        .eq('id', id);

      if (error) throw error;

      console.log('✅ Cliente deletado com sucesso');
      toast({
        title: "Sucesso",
        description: "Cliente excluído com sucesso"
      });
      
      await loadClients();
      
    } catch (error: any) {
      console.error('❌ Erro ao deletar cliente:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao excluir cliente",
        variant: "destructive"
      });
    }
  };

  const handleStageSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    try {
      const stageData = {
        user_id: user.id,
        key: stageFormData.key.toLowerCase().replace(/\s+/g, '_'),
        name: stageFormData.name,
        description: stageFormData.description,
        icon: stageFormData.icon,
        color: stageFormData.color,
        order_index: stageFormData.order_index
      };

      if (editingStage) {
        const { error } = await supabase
          .from('stages')
          .update(stageData)
          .eq('key', editingStage.key);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Estágio atualizado com sucesso"
        });
      } else {
        const { error } = await supabase
          .from('stages')
          .insert([stageData]);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Estágio criado com sucesso"
        });
      }

      resetStageForm();
      await loadStages();
      
    } catch (error: any) {
      console.error('❌ Erro ao salvar estágio:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao salvar estágio",
        variant: "destructive"
      });
    }
  };

  const handleEditStage = (stage: Stage) => {
    setEditingStage(stage);
    setStageFormData({
      key: stage.key,
      name: stage.name,
      description: stage.description || '',
      icon: stage.icon.name.toLowerCase(),
      color: stage.color,
      order_index: stage.order_index
    });
    setStagesDialogOpen(true);
  };

  const handleDeleteStage = async (stageKey: string) => {
    const stageClients = getClientsByStage(stageKey);
    
    if (stageClients.length > 0) {
      toast({
        title: "Erro",
        description: "Não é possível excluir um estágio que contém clientes",
        variant: "destructive"
      });
      return;
    }

    if (!confirm('Tem certeza que deseja excluir este estágio?')) {
      return;
    }

    try {
      const { error } = await supabase
        .from('stages')
        .delete()
        .eq('key', stageKey)
        .eq('user_id', user?.id);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Estágio excluído com sucesso"
      });
      
      await loadStages();
      
    } catch (error: any) {
      console.error('❌ Erro ao deletar estágio:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao excluir estágio",
        variant: "destructive"
      });
    }
  };

  // Resetar formulários
  const resetForm = () => {
    setFormData({
      name: '',
      email: '',
      phone: '',
      document: '',
      address: '',
      stage: 'lead',
      notes: ''
    });
    setEditingClient(null);
    setDialogOpen(false);
  };

  const resetStageForm = () => {
    setStageFormData({
      key: '',
      name: '',
      description: '',
      icon: 'target',
      color: 'bg-yellow-100 text-yellow-800',
      order_index: 1
    });
    setEditingStage(null);
    setStagesDialogOpen(false);
  };

  // Componente do Card do Cliente
  const ClientCard = ({ client }: { client: Client }) => {
    const StageIcon = stages[client.stage]?.icon || Target;
    
    return (
      <Card className="mb-3 hover:shadow-md transition-shadow group">
        <CardHeader className="pb-2">
          <div className="flex items-center justify-between">
            <CardTitle className="text-base font-medium">
              {client.name}
            </CardTitle>
            <div className="flex space-x-1 opacity-100">
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  handleEdit(client);
                }}
                className="h-8 w-8 p-0 hover:bg-blue-100"
                title="Editar cliente"
              >
                <Edit className="w-3 h-3" />
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  handleDelete(client.id);
                }}
                className="h-8 w-8 p-0 hover:bg-red-100 hover:text-red-600"
                title="Excluir cliente"
              >
                <Trash2 className="w-3 h-3" />
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent className="space-y-2">
          {client.email && (
            <div className="flex items-center space-x-2 text-sm text-muted-foreground">
              <Mail className="w-3 h-3" />
              <span className="truncate">{client.email}</span>
            </div>
          )}
          {client.phone && (
            <div className="flex items-center space-x-2 text-sm text-muted-foreground">
              <Phone className="w-3 h-3" />
              <span>{client.phone}</span>
            </div>
          )}
          {client.notes && (
            <div className="text-sm text-muted-foreground">
              <p className="line-clamp-2">{client.notes}</p>
            </div>
          )}
          <div className="pt-2 text-xs text-muted-foreground">
            Criado em {new Date(client.created_at).toLocaleDateString('pt-BR')}
          </div>
        </CardContent>
      </Card>
    );
  };

  // Componente da Coluna de Estágio
  const StageColumn = ({ stageKey, stage }: { stageKey: string; stage: Stage }) => {
    const stageClients = getClientsByStage(stageKey);
    const StageIcon = stage.icon;
    
    return (
      <div className="flex-shrink-0 w-80">
        <div className="bg-muted/50 rounded-lg p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center space-x-2">
              <StageIcon className="w-5 h-5" />
              <h3 className="font-semibold">{stage.name}</h3>
              <span className="bg-background px-2 py-1 rounded-full text-xs font-medium">
                {stageClients.length}
              </span>
            </div>
            <div className="flex space-x-1">
              <Button
                size="sm"
                variant="ghost"
                onClick={() => handleEditStage(stage)}
                className="h-6 w-6 p-0"
                title="Editar estágio"
              >
                <Edit className="w-3 h-3" />
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={() => handleDeleteStage(stageKey)}
                className="h-6 w-6 p-0 hover:text-red-600"
                title="Excluir estágio"
                disabled={stageClients.length > 0}
              >
                <Trash2 className="w-3 h-3" />
              </Button>
            </div>
          </div>
          
          <div className="space-y-2">
            {stageClients.map((client) => (
              <ClientCard key={client.id} client={client} />
            ))}
            
            {stageClients.length === 0 && (
              <div className="text-center py-8 text-muted-foreground">
                <Users className="w-8 h-8 mx-auto mb-2 opacity-50" />
                <p className="text-sm">Nenhum cliente</p>
              </div>
            )}
          </div>
        </div>
      </div>
    );
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
          <p>Carregando...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button variant="ghost" size="sm" onClick={() => window.history.back()}>
                ← Dashboard
              </Button>
              <div className="flex items-center space-x-2">
                <Users className="w-6 h-6" />
                <h1 className="text-2xl font-bold">CRM - Gestão de Clientes</h1>
              </div>
            </div>
            
            <div className="flex items-center space-x-2">
              <Button
                variant="outline"
                onClick={() => setStagesDialogOpen(true)}
                className="flex items-center space-x-2"
              >
                <Settings className="w-4 h-4" />
                Configurar Estágios
              </Button>
              <Button
                onClick={() => setDialogOpen(true)}
                className="flex items-center space-x-2"
              >
                <Plus className="w-4 h-4" />
                Novo Cliente
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Conteúdo Principal */}
      <main className="container mx-auto px-4 py-8">
        <div className="flex gap-6 overflow-x-auto pb-4">
          {Object.entries(stages).map(([stageKey, stage]) => (
            <StageColumn key={stageKey} stageKey={stageKey} stage={stage} />
          ))}
          
          {/* Botão para adicionar estágios */}
          <div className="flex-shrink-0 w-80 flex items-center justify-center">
            <Button 
              variant="outline" 
              className="h-12 w-12 rounded-full border-dashed border-2 hover:border-solid"
              onClick={() => setStagesDialogOpen(true)}
            >
              <Plus className="w-6 h-6" />
            </Button>
          </div>
        </div>

        {/* Estado vazio */}
        {Object.keys(stages).length === 0 && (
          <div className="text-center py-12">
            <Users className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-xl font-semibold mb-2">Nenhum estágio criado</h3>
            <p className="text-muted-foreground mb-6">
              Comece criando seu primeiro estágio para organizar os clientes
            </p>
            <Button onClick={() => setStagesDialogOpen(true)}>
              <Settings className="w-4 h-4 mr-2" />
              Criar Primeiro Estágio
            </Button>
          </div>
        )}
      </main>

      {/* Modal de Cliente */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-[600px]">
          <DialogHeader>
            <DialogTitle>
              {editingClient ? 'Editar Cliente' : 'Novo Cliente'}
            </DialogTitle>
            <DialogDescription>
              {editingClient ? 'Atualize as informações do cliente' : 'Adicione um novo cliente ao seu CRM'}
            </DialogDescription>
          </DialogHeader>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Nome *</Label>
              <Input
                id="name"
                placeholder="Nome completo"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                required
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="email@exemplo.com"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="phone">Telefone</Label>
                <Input
                  id="phone"
                  type="tel"
                  placeholder="(11) 99999-9999"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="document">CPF/CNPJ</Label>
              <Input
                id="document"
                placeholder="000.000.000-00 ou 00.000.000/0001-00"
                value={formData.document}
                onChange={(e) => setFormData({ ...formData, document: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="address">Endereço</Label>
              <Input
                id="address"
                placeholder="Endereço completo"
                value={formData.address}
                onChange={(e) => setFormData({ ...formData, address: e.target.value })}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="stage">Estágio</Label>
              <Select value={formData.stage} onValueChange={(value) => setFormData({ ...formData, stage: value })}>
                <SelectTrigger>
                  <SelectValue placeholder="Selecione um estágio" />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(stages).map(([key, stage]) => (
                    <SelectItem key={key} value={key}>
                      {stage.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="notes">Observações</Label>
              <Textarea
                id="notes"
                placeholder="Anotações sobre o cliente..."
                value={formData.notes}
                onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                rows={3}
              />
            </div>

            <div className="flex justify-end space-x-2">
              <Button type="button" variant="outline" onClick={resetForm}>
                Cancelar
              </Button>
              <Button type="submit">
                {editingClient ? 'Atualizar' : 'Criar Cliente'}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>

      {/* Modal de Estágios */}
      <Dialog open={stagesDialogOpen} onOpenChange={setStagesDialogOpen}>
        <DialogContent className="sm:max-w-[800px] max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Configurar Estágios do Kanban</DialogTitle>
            <DialogDescription>
              Gerencie os estágios do seu pipeline de vendas
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-6">
            {/* Estágios Atuais */}
            <div>
              <h3 className="text-lg font-medium mb-4">Estágios Atuais</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {Object.entries(stages).map(([key, stage]) => {
                  const StageIcon = stage.icon;
                  return (
                    <Card key={key} className="p-4">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-3">
                          <StageIcon className="w-5 h-5" />
                          <div>
                            <h4 className="font-medium">{stage.name}</h4>
                            <p className="text-sm text-muted-foreground">{stage.description}</p>
                            <span className={`inline-block px-2 py-1 rounded text-xs ${stage.color} mt-1`}>
                              {getClientsByStage(key).length} clientes
                            </span>
                          </div>
                        </div>
                        <div className="flex space-x-1">
                          <Button size="sm" variant="ghost" onClick={() => handleEditStage(stage)}>
                            <Edit className="w-3 h-3" />
                          </Button>
                          <Button 
                            size="sm" 
                            variant="ghost" 
                            onClick={() => handleDeleteStage(key)}
                            disabled={getClientsByStage(key).length > 0}
                          >
                            <Trash2 className="w-3 h-3" />
                          </Button>
                        </div>
                      </div>
                    </Card>
                  );
                })}
              </div>
            </div>

            {/* Formulário de Estágio */}
            <div className="border-t pt-6">
              <h3 className="text-lg font-medium mb-4">
                {editingStage ? 'Editar Estágio' : 'Novo Estágio'}
              </h3>
              
              <form onSubmit={handleStageSubmit} className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="stage-key">Chave</Label>
                    <Input
                      id="stage-key"
                      placeholder="lead, prospect, etc."
                      value={stageFormData.key}
                      onChange={(e) => setStageFormData({ ...stageFormData, key: e.target.value })}
                      disabled={!!editingStage}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="stage-name">Nome</Label>
                    <Input
                      id="stage-name"
                      placeholder="Nome do estágio"
                      value={stageFormData.name}
                      onChange={(e) => setStageFormData({ ...stageFormData, name: e.target.value })}
                      required
                    />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="stage-description">Descrição</Label>
                  <Input
                    id="stage-description"
                    placeholder="Descrição do estágio"
                    value={stageFormData.description}
                    onChange={(e) => setStageFormData({ ...stageFormData, description: e.target.value })}
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="stage-icon">Ícone</Label>
                    <Select value={stageFormData.icon} onValueChange={(value) => setStageFormData({ ...stageFormData, icon: value })}>
                      <SelectTrigger>
                        <SelectValue placeholder="Selecione um ícone" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="target">🎯 Target</SelectItem>
                        <SelectItem value="userCheck">✅ User Check</SelectItem>
                        <SelectItem value="userX">❌ User X</SelectItem>
                        <SelectItem value="dollarSign">💰 Dollar Sign</SelectItem>
                        <SelectItem value="checkCircle">✅ Check Circle</SelectItem>
                        <SelectItem value="clock">⏰ Clock</SelectItem>
                        <SelectItem value="alertCircle">⚠️ Alert Circle</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="stage-color">Cor</Label>
                    <Select value={stageFormData.color} onValueChange={(value) => setStageFormData({ ...stageFormData, color: value })}>
                      <SelectTrigger>
                        <SelectValue placeholder="Selecione uma cor" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="bg-yellow-100 text-yellow-800">🟡 Amarelo</SelectItem>
                        <SelectItem value="bg-blue-100 text-blue-800">🔵 Azul</SelectItem>
                        <SelectItem value="bg-green-100 text-green-800">🟢 Verde</SelectItem>
                        <SelectItem value="bg-purple-100 text-purple-800">🟣 Roxo</SelectItem>
                        <SelectItem value="bg-red-100 text-red-800">🔴 Vermelho</SelectItem>
                        <SelectItem value="bg-orange-100 text-orange-800">🟠 Laranja</SelectItem>
                        <SelectItem value="bg-gray-100 text-gray-800">⚫ Cinza</SelectItem>
                        <SelectItem value="bg-pink-100 text-pink-800">🩷 Rosa</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="flex justify-end space-x-2">
                  <Button type="button" variant="outline" onClick={resetStageForm}>
                    Cancelar
                  </Button>
                  <Button type="submit">
                    {editingStage ? 'Atualizar' : 'Criar'} Estágio
                  </Button>
                </div>
              </form>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}