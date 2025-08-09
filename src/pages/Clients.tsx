import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { 
  Users, 
  Plus, 
  Edit, 
  Trash2, 
  Phone, 
  Mail, 
  MapPin, 
  Calendar,
  DollarSign,
  ArrowLeft,
  User,
  UserCheck,
  Crown,
  Target,
  Settings,
  Save,
  X
} from 'lucide-react';

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
  created_at: string;
}

interface Stage {
  key: string;
  name: string;
  icon: any;
  color: string;
  description: string;
}



export default function Clients() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingClient, setEditingClient] = useState<Client | null>(null);
  
  // Stage management state
  const [stagesDialogOpen, setStagesDialogOpen] = useState(false);
  const [stages, setStages] = useState<Record<string, Stage>>({
    lead: { key: 'lead', name: 'Lead', icon: Target, color: 'bg-yellow-100 text-yellow-800', description: 'Interessados' },
    prospect: { key: 'prospect', name: 'Prospect', icon: User, color: 'bg-blue-100 text-blue-800', description: 'Em negociação' },
    client: { key: 'client', name: 'Cliente', icon: UserCheck, color: 'bg-green-100 text-green-800', description: 'Compraram' },
    vip: { key: 'vip', name: 'VIP', icon: Crown, color: 'bg-purple-100 text-purple-800', description: 'Clientes premium' }
  });
  const [editingStage, setEditingStage] = useState<Stage | null>(null);
  const [stageFormData, setStageFormData] = useState({
    key: '',
    name: '',
    description: '',
    color: 'bg-gray-100 text-gray-800'
  });

  // Form state
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    document: '',
    address: '',
    stage: 'lead' as const,
    notes: ''
  });

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadClients();
  }, [user, navigate]);

  const loadClients = async () => {
    if (!user) return;

    try {
      const { data: clientsData } = await supabase
        .from('clients')
        .select('*')
        .eq('user_id', user.id)
        .eq('is_active', true)
        .order('created_at', { ascending: false });

      setClients(clientsData || []);
    } catch (error) {
      console.error('Error loading clients:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar clientes",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    try {
      const clientData = {
        user_id: user.id,
        name: formData.name,
        email: formData.email || null,
        phone: formData.phone || null,
        document: formData.document || null,
        address: formData.address || null,
        stage: formData.stage,
        notes: formData.notes || null,
        is_active: true
      };

      if (editingClient) {
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
        const { error } = await supabase
          .from('clients')
          .insert([clientData]);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Cliente criado com sucesso"
        });
      }

      // Reset form and reload data
      resetForm();
      loadClients();
    } catch (error: any) {
      toast({
        title: "Erro",
        description: error.message || "Erro ao salvar cliente",
        variant: "destructive"
      });
    }
  };

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

  const handleEdit = (client: Client) => {
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
    if (!confirm('Tem certeza que deseja excluir este cliente?')) return;

    try {
      const { error } = await supabase
        .from('clients')
        .update({ is_active: false })
        .eq('id', id);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Cliente excluído com sucesso"
      });
      loadClients();
    } catch (error: any) {
      toast({
        title: "Erro",
        description: error.message || "Erro ao excluir cliente",
        variant: "destructive"
      });
    }
  };

  const handleStageChange = async (clientId: string, newStage: string) => {
    try {
      const { error } = await supabase
        .from('clients')
        .update({ stage: newStage })
        .eq('id', clientId);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: `Cliente movido para ${stages[newStage].name}`
      });
      loadClients();
    } catch (error: any) {
      toast({
        title: "Erro",
        description: error.message || "Erro ao atualizar estágio",
        variant: "destructive"
      });
    }
  };

  const getClientsByStage = (stage: string) => {
    return clients.filter(client => client.stage === stage);
  };

  // Stage management functions
  const handleEditStage = (stageKey: string) => {
    const stage = stages[stageKey];
    setEditingStage(stage);
    setStageFormData({
      key: stage.key,
      name: stage.name,
      description: stage.description,
      color: stage.color
    });
  };

  const handleSaveStage = () => {
    if (!stageFormData.key || !stageFormData.name) {
      toast({
        title: "Erro",
        description: "Chave e nome são obrigatórios",
        variant: "destructive"
      });
      return;
    }

    const updatedStages = { ...stages };
    
    if (editingStage) {
      // Editing existing stage
      updatedStages[editingStage.key] = {
        ...editingStage,
        name: stageFormData.name,
        description: stageFormData.description,
        color: stageFormData.color
      };
    } else {
      // Creating new stage
      if (stages[stageFormData.key]) {
        toast({
          title: "Erro",
          description: "Já existe um estágio com essa chave",
          variant: "destructive"
        });
        return;
      }
      
      updatedStages[stageFormData.key] = {
        key: stageFormData.key,
        name: stageFormData.name,
        icon: Target, // Default icon
        color: stageFormData.color,
        description: stageFormData.description
      };
    }

    setStages(updatedStages);
    setEditingStage(null);
    setStageFormData({
      key: '',
      name: '',
      description: '',
      color: 'bg-gray-100 text-gray-800'
    });

    toast({
      title: "Sucesso",
      description: editingStage ? "Estágio atualizado" : "Estágio criado"
    });
  };

  const handleDeleteStage = (stageKey: string) => {
    const clientsInStage = getClientsByStage(stageKey);
    if (clientsInStage.length > 0) {
      toast({
        title: "Erro",
        description: `Não é possível excluir o estágio "${stages[stageKey].name}" pois há ${clientsInStage.length} cliente(s) nele`,
        variant: "destructive"
      });
      return;
    }

    if (!confirm(`Tem certeza que deseja excluir o estágio "${stages[stageKey].name}"?`)) return;

    const updatedStages = { ...stages };
    delete updatedStages[stageKey];
    setStages(updatedStages);

    toast({
      title: "Sucesso",
      description: "Estágio excluído com sucesso"
    });
  };

  const resetStageForm = () => {
    setEditingStage(null);
    setStageFormData({
      key: '',
      name: '',
      description: '',
      color: 'bg-gray-100 text-gray-800'
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <Button variant="ghost" onClick={() => navigate('/dashboard')}>
              <ArrowLeft className="w-4 h-4 mr-2" />
              Dashboard
            </Button>
            <div className="w-8 h-8 bg-gradient-primary rounded-lg flex items-center justify-center">
              <Users className="w-4 h-4 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold">CRM - Gestão de Clientes</h1>
          </div>
          <div className="flex space-x-2">
            <Dialog open={stagesDialogOpen} onOpenChange={setStagesDialogOpen}>
              <DialogTrigger asChild>
                <Button variant="outline" onClick={() => resetStageForm()}>
                  <Settings className="w-4 h-4 mr-2" />
                  Configurar Estágios
                </Button>
              </DialogTrigger>
            </Dialog>
            
            <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
              <DialogTrigger asChild>
                <Button onClick={() => resetForm()}>
                  <Plus className="w-4 h-4 mr-2" />
                  Novo Cliente
                </Button>
              </DialogTrigger>
            <DialogContent className="sm:max-w-[600px]">
              <DialogHeader>
                <DialogTitle>
                  {editingClient ? 'Editar Cliente' : 'Novo Cliente'}
                </DialogTitle>
                <DialogDescription>
                  {editingClient ? 'Edite os dados do cliente' : 'Adicione um novo cliente ao seu CRM'}
                </DialogDescription>
              </DialogHeader>
              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="name">Nome *</Label>
                    <Input
                      id="name"
                      placeholder="Nome do cliente"
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="stage">Estágio *</Label>
                    <Select value={formData.stage} onValueChange={(value: string) => setFormData({ ...formData, stage: value })}>
                      <SelectTrigger>
                        <SelectValue placeholder="Selecione o estágio" />
                      </SelectTrigger>
                      <SelectContent>
                        {Object.entries(stages).map(([key, stage]) => (
                          <SelectItem key={key} value={key}>
                            <div className="flex items-center space-x-2">
                              <stage.icon className="w-4 h-4" />
                              <span>{stage.name}</span>
                            </div>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="email">Email</Label>
                    <Input
                      id="email"
                      type="email"
                      placeholder="cliente@email.com"
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
                  <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>
                    Cancelar
                  </Button>
                  <Button type="submit">
                    {editingClient ? 'Atualizar' : 'Criar Cliente'}
                  </Button>
                </div>
              </form>
            </DialogContent>
          </Dialog>
          </div>
          
          {/* Stage Management Dialog */}
          <Dialog open={stagesDialogOpen} onOpenChange={setStagesDialogOpen}>
            <DialogContent className="sm:max-w-[800px] max-h-[80vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Configurar Estágios do Kanban</DialogTitle>
                <DialogDescription>
                  Gerencie os estágios do seu pipeline de vendas
                </DialogDescription>
              </DialogHeader>
              
              <div className="space-y-6">
                {/* Current Stages */}
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
                              <Button size="sm" variant="ghost" onClick={() => handleEditStage(key)}>
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

                {/* Stage Form */}
                <div className="border-t pt-6">
                  <h3 className="text-lg font-medium mb-4">
                    {editingStage ? 'Editar Estágio' : 'Novo Estágio'}
                  </h3>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="stage-key">Chave do Estágio *</Label>
                      <Input
                        id="stage-key"
                        placeholder="ex: negociacao"
                        value={stageFormData.key}
                        onChange={(e) => setStageFormData({ ...stageFormData, key: e.target.value.toLowerCase().replace(/\s+/g, '_') })}
                        disabled={!!editingStage}
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="stage-name">Nome do Estágio *</Label>
                      <Input
                        id="stage-name"
                        placeholder="ex: Negociação"
                        value={stageFormData.name}
                        onChange={(e) => setStageFormData({ ...stageFormData, name: e.target.value })}
                      />
                    </div>
                  </div>

                  <div className="space-y-2 mt-4">
                    <Label htmlFor="stage-description">Descrição</Label>
                    <Input
                      id="stage-description"
                      placeholder="ex: Clientes em processo de negociação"
                      value={stageFormData.description}
                      onChange={(e) => setStageFormData({ ...stageFormData, description: e.target.value })}
                    />
                  </div>

                  <div className="space-y-2 mt-4">
                    <Label htmlFor="stage-color">Cor do Badge</Label>
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

                  <div className="flex justify-end space-x-2 mt-6">
                    <Button variant="outline" onClick={resetStageForm}>
                      <X className="w-4 h-4 mr-2" />
                      Cancelar
                    </Button>
                    <Button onClick={handleSaveStage}>
                      <Save className="w-4 h-4 mr-2" />
                      {editingStage ? 'Atualizar' : 'Criar'} Estágio
                    </Button>
                  </div>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </header>

      {/* Kanban Board */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {Object.entries(stages).map(([stageKey, stage]) => {
            const stageClients = getClientsByStage(stageKey);
            const StageIcon = stage.icon;
            
            return (
              <div key={stageKey} className="space-y-4">
                {/* Stage Header */}
                <Card className="bg-gradient-to-r from-background to-muted/30">
                  <CardHeader className="pb-3">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <StageIcon className="w-5 h-5" />
                        <CardTitle className="text-lg">{stage.name}</CardTitle>
                      </div>
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${stage.color}`}>
                        {stageClients.length}
                      </span>
                    </div>
                    <CardDescription>{stage.description}</CardDescription>
                  </CardHeader>
                </Card>

                {/* Clients in this stage */}
                <div className="space-y-3 min-h-[200px]">
                  {stageClients.map((client) => (
                    <Card key={client.id} className="hover:shadow-lg transition-all duration-200 cursor-pointer group">
                      <CardHeader className="pb-2">
                        <div className="flex items-center justify-between">
                          <CardTitle className="text-base group-hover:text-primary transition-colors">
                            {client.name}
                          </CardTitle>
                          <div className="flex space-x-1">
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => handleEdit(client)}
                              className="opacity-0 group-hover:opacity-100 transition-opacity"
                            >
                              <Edit className="w-3 h-3" />
                            </Button>
                            <Button
                              size="sm"
                              variant="ghost"
                              onClick={() => handleDelete(client.id)}
                              className="opacity-0 group-hover:opacity-100 transition-opacity"
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
                        
                        {/* Stage Movement */}
                        <div className="pt-2 space-y-2">
                          <div className="flex items-center space-x-2 text-xs text-muted-foreground">
                            <Calendar className="w-3 h-3" />
                            <span>{new Date(client.created_at).toLocaleDateString('pt-BR')}</span>
                          </div>
                          
                          <Select value={client.stage} onValueChange={(newStage: string) => handleStageChange(client.id, newStage)}>
                            <SelectTrigger className="h-7 text-xs">
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              {Object.entries(stages).map(([key, stageOption]) => (
                                <SelectItem key={key} value={key}>
                                  <div className="flex items-center space-x-2">
                                    <stageOption.icon className="w-3 h-3" />
                                    <span>{stageOption.name}</span>
                                  </div>
                                </SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                      </CardContent>
                    </Card>
                  ))}

                  {stageClients.length === 0 && (
                    <div className="border-2 border-dashed border-muted rounded-lg p-6 text-center">
                      <StageIcon className="w-8 h-8 text-muted-foreground mx-auto mb-2" />
                      <p className="text-sm text-muted-foreground">
                        Nenhum cliente em {stage.name.toLowerCase()}
                      </p>
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Empty State */}
        {clients.length === 0 && (
          <div className="text-center py-12">
            <Users className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-xl font-semibold mb-2">Nenhum cliente cadastrado</h3>
            <p className="text-muted-foreground mb-6">
              Comece adicionando seu primeiro cliente ao CRM
            </p>
            <Button onClick={() => setDialogOpen(true)}>
              <Plus className="w-4 h-4 mr-2" />
              Adicionar Primeiro Cliente
            </Button>
          </div>
        )}
      </main>
    </div>
  );
}