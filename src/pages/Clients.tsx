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
  DndContext,
  DragEndEvent,
  DragOverlay,
  DragStartEvent,
  PointerSensor,
  useSensor,
  useSensors,
  closestCorners,
  DragOverEvent,
  useDroppable,
} from '@dnd-kit/core';
import {
  SortableContext,
  verticalListSortingStrategy,
  horizontalListSortingStrategy,
} from '@dnd-kit/sortable';
import {
  useSortable,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
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
  AlertCircle,
  Move,
  Sparkles,
  ArrowRight,
  ArrowLeft,
  History
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
  
  // Estados para Smart Stage Navigator
  const [moveModalOpen, setMoveModalOpen] = useState(false);
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);
  const [isMoving, setIsMoving] = useState(false);
  const [moveHistory, setMoveHistory] = useState<Array<{clientId: string, fromStage: string, toStage: string, timestamp: string}>>([]);
  
  // Estados para Drag and Drop
  const [activeClient, setActiveClient] = useState<Client | null>(null);
  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 8,
      },
    })
  );
  
  // Formulários
  const [formData, setFormData] = useState({
    // Informações principais (identidade)
    name: '',
    email: '',
    phone: '',
    document: '',
    address: '',
    
    // Perfil e classificação
    contact_type: 'lead' as 'lead' | 'client' | 'partner',
    lead_source: '',
    
    // Dados complementares estratégicos
    job_title: '',
    company: '',
    industry: '',
    estimated_ticket: 0,
    clv: 0,
    
    // Histórico de interações
    last_contact_date: '',
    next_follow_up: '',
    
    // Customizações para negócio
    payment_method: '',
    delivery_deadline: '',
    technical_contact: '',
    contract_type: '',
    
    // Campos existentes
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
      console.log('📝 Dados do formulário:', formData);
      
      const clientData = {
        user_id: user.id,
        name: formData.name.trim(),
        email: formData.email.trim() || null,
        phone: formData.phone.trim() || null,
        document: formData.document.trim() || null,
        address: formData.address.trim() || null,
        stage: formData.stage,
        notes: formData.notes.trim() || null,
        is_active: true,
        // Campos CRM - Perfil e classificação
        contact_type: formData.contact_type,
        lead_source: formData.lead_source || null,
        // Campos CRM - Dados complementares estratégicos
        job_title: formData.job_title || null,
        company: formData.company || null,
        industry: formData.industry || null,
        estimated_ticket: formData.estimated_ticket || null,
        clv: formData.clv || null,
        purchase_history: formData.purchase_history || null,
        // Campos CRM - Histórico de interações
        last_contact_date: formData.last_contact_date || null,
        next_follow_up: formData.next_follow_up || null,
        days_since_last_contact: formData.days_since_last_contact || null,
        // Campos CRM - Customizações para negócio
        payment_method: formData.payment_method || null,
        delivery_deadline: formData.delivery_deadline || null,
        technical_contact: formData.technical_contact || null,
        contract_type: formData.contract_type || null
      };

      console.log('💾 Dados para salvar:', clientData);

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
      notes: client.notes || '',
      // Campos CRM - Perfil e classificação
      contact_type: client.contact_type || 'lead',
      lead_source: client.lead_source || '',
      // Campos CRM - Dados complementares estratégicos
      job_title: client.job_title || '',
      company: client.company || '',
      industry: client.industry || '',
      estimated_ticket: client.estimated_ticket || 0,
      clv: client.clv || 0,
      purchase_history: client.purchase_history || null,
      // Campos CRM - Histórico de interações
      last_contact_date: client.last_contact_date ? client.last_contact_date.split('T')[0] : '',
      next_follow_up: client.next_follow_up ? client.next_follow_up.split('T')[0] : '',
      days_since_last_contact: client.days_since_last_contact || 0,
      // Campos CRM - Customizações para negócio
      payment_method: client.payment_method || '',
      delivery_deadline: client.delivery_deadline || '',
      technical_contact: client.technical_contact || '',
      contract_type: client.contract_type || ''
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



  const handleMoveClient = async (clientId: string, newStageKey: string) => {
    const client = clients.find(c => c.id === clientId);
    if (!client) return;
    
    try {
      setIsMoving(true);
      console.log(`🚀 Movendo cliente ${client.name} para ${stages[newStageKey].name}`);
      
      // Atualizar no banco de dados
      const { error } = await supabase
        .from('clients')
        .update({ 
          stage: newStageKey,
          updated_at: new Date().toISOString()
        })
        .eq('id', clientId);
      
      if (error) throw error;
      
      // Atualizar estado local
      setClients(prevClients => 
        prevClients.map(c => 
          c.id === clientId 
            ? { ...c, stage: newStageKey, updated_at: new Date().toISOString() }
            : c
        )
      );
      
      // Adicionar ao histórico
      setMoveHistory(prev => [...prev, {
        clientId,
        fromStage: client.stage,
        toStage: newStageKey,
        timestamp: new Date().toISOString()
      }]);
      
      toast({
        title: "🎉 Cliente Movido!",
        description: `${client.name} foi movido para ${stages[newStageKey].name}`,
      });
      
      setMoveModalOpen(false);
      setSelectedClient(null);
      
    } catch (error: any) {
      console.error('❌ Erro ao mover cliente:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao mover cliente",
        variant: "destructive"
      });
    } finally {
      setIsMoving(false);
    }
  };

  const openMoveModal = (client: Client) => {
    setSelectedClient(client);
    setMoveModalOpen(true);
  };

  // Funções para Drag and Drop
  const handleDragStart = (event: DragStartEvent) => {
    const { active } = event;
    const activeId = active.id as string;
    
    // Verificar se é um drag de cliente
    const client = clients.find(c => c.id === activeId);
    setActiveClient(client || null);
  };

  const handleReorderStages = async (fromStageKey: string, direction: 'left' | 'right') => {
    try {
      const fromStage = stages[fromStageKey];
      if (!fromStage) return;

      // Obter todos os estágios ordenados
      const stageEntries = Object.entries(stages).sort((a, b) => a[1].order_index - b[1].order_index);
      const fromIndex = stageEntries.findIndex(([key]) => key === fromStageKey);
      
      if (fromIndex === -1) return;

      let toIndex = fromIndex;
      
      if (direction === 'left' && fromIndex > 0) {
        toIndex = fromIndex - 1;
      } else if (direction === 'right' && fromIndex < stageEntries.length - 1) {
        toIndex = fromIndex + 1;
      } else {
        return; // Não pode mover mais
      }

      const toStageKey = stageEntries[toIndex][0];
      const toStage = stages[toStageKey];

      // Reordenar os estágios
      const reorderedStages = [...stageEntries];
      const [movedStage] = reorderedStages.splice(fromIndex, 1);
      reorderedStages.splice(toIndex, 0, movedStage);

      // Atualizar order_index para todos os estágios
      const updates = reorderedStages.map(([key], index) => ({
        key,
        order_index: index + 1
      }));

      // Fazer as atualizações no banco
      for (const update of updates) {
        const { error } = await supabase
          .from('stages')
          .update({ order_index: update.order_index })
          .eq('key', update.key)
          .eq('user_id', user?.id);

        if (error) throw error;
      }

      toast({
        title: "🎉 Estágio Movido!",
        description: `${fromStage.name} foi movido ${direction === 'left' ? 'para a esquerda' : 'para a direita'}`,
      });

      await loadStages();
      
    } catch (error: any) {
      console.error('❌ Erro ao reordenar estágios:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao reordenar estágios",
        variant: "destructive"
      });
    }
  };

  const handleDragEnd = async (event: DragEndEvent) => {
    const { active, over } = event;
    
    if (!over) {
      setActiveClient(null);
      return;
    }

    const activeId = active.id as string;
    const overId = over.id as string;

    // Verificar se é um drag de cliente
    const client = clients.find(c => c.id === activeId);
    if (!client) {
      setActiveClient(null);
      return;
    }

    // Extrair o stageKey do overId
    let targetStageKey = '';
    
    if (overId.startsWith('stage-')) {
      targetStageKey = overId.replace('stage-', '');
    } else if (overId.startsWith('client-area-')) {
      targetStageKey = overId.replace('client-area-', '');
    } else if (overId.startsWith('drop-zone-')) {
      // Para drop-zone-{stageKey}-{position}, extrair apenas o stageKey
      const parts = overId.split('-');
      if (parts.length >= 3) {
        targetStageKey = parts[2]; // stageKey está na posição 2
      }
    } else {
      // Fallback: procurar por data-stage no elemento ou seus pais
      const element = over as any;
      const stageElement = element.closest?.('[data-stage]') || element.querySelector?.('[data-stage]');
      if (stageElement) {
        targetStageKey = stageElement.getAttribute('data-stage');
      }
    }

    console.log('🔍 Debug drag end:', { activeId, overId, targetStageKey, clientStage: client.stage });

    // Verificar se o estágio de destino é válido
    if (!targetStageKey || !stages[targetStageKey] || client.stage === targetStageKey) {
      console.log('❌ Estágio inválido ou mesmo estágio');
      setActiveClient(null);
      return;
    }

    console.log('✅ Movendo cliente para:', targetStageKey);
    
    // Mover o cliente
    await handleMoveClient(activeId, targetStageKey);
    setActiveClient(null);
  };

  // Componente Droppable para Estágios
  const DroppableStage = ({ stageKey, stage, children }: { stageKey: string; stage: Stage; children: React.ReactNode }) => {
    const { setNodeRef, isOver } = useDroppable({
      id: `stage-${stageKey}`,
    });

    return (
      <div 
        ref={setNodeRef}
        className={`transition-colors duration-200 ${
          isOver ? 'bg-blue-50 border-blue-200' : ''
        }`}
        style={{ minHeight: '100%' }}
      >
        {children}
      </div>
    );
  };

  // Componente Droppable para Área de Clientes
  const DroppableClientArea = ({ stageKey, children }: { stageKey: string; children: React.ReactNode }) => {
    const { setNodeRef, isOver } = useDroppable({
      id: `client-area-${stageKey}`,
    });

    return (
      <div 
        ref={setNodeRef}
        className={`transition-all duration-200 ${
          isOver ? 'bg-green-50 border-green-200 scale-[1.02]' : ''
        }`}
      >
        {children}
      </div>
    );
  };

  // Componente Droppable para Zonas de Drop
  const DroppableDropZone = ({ stageKey, position }: { stageKey: string; position: string }) => {
    const { setNodeRef, isOver } = useDroppable({
      id: `drop-zone-${stageKey}-${position}`,
    });

    const getHeight = () => {
      if (position === 'top') return 'h-8';
      if (position === 'bottom') return 'h-10';
      return 'h-6';
    };

    const getText = () => {
      if (position === 'top') return 'Soltar cliente aqui';
      if (position === 'bottom') return 'Soltar cliente aqui';
      return 'Soltar aqui';
    };

    return (
      <div 
        ref={setNodeRef}
        className={`${getHeight()} border-2 border-dashed border-slate-200 rounded-lg flex items-center justify-center bg-slate-50/50 hover:bg-slate-100/50 transition-colors ${
          isOver ? 'bg-blue-100 border-blue-300' : ''
        }`}
      >
        <span className="text-xs text-slate-500 font-medium">{getText()}</span>
      </div>
    );
  };





  // Componente de Estágio com Setas de Reordenação
  const StageColumnWithArrows = ({ stageKey, stage }: { stageKey: string; stage: Stage }) => {
    const stageEntries = Object.entries(stages).sort((a, b) => a[1].order_index - b[1].order_index);
    const currentIndex = stageEntries.findIndex(([key]) => key === stageKey);
    const canMoveLeft = currentIndex > 0;
    const canMoveRight = currentIndex < stageEntries.length - 1;

    return (
      <div className="flex items-center">
        {/* Seta esquerda */}
        {canMoveLeft && (
          <Button
            size="sm"
            variant="ghost"
            onClick={() => handleReorderStages(stageKey, 'left')}
            className="h-10 w-10 p-0 mr-2 hover:bg-blue-50 hover:text-blue-600 transition-all duration-200 rounded-full"
            title="Mover para esquerda"
          >
            <ArrowLeft className="w-5 h-5" />
          </Button>
        )}
        
        {/* Estágio */}
        <DroppableStage stageKey={stageKey} stage={stage}>
          <StageColumn stageKey={stageKey} stage={stage} />
        </DroppableStage>
        
        {/* Seta direita */}
        {canMoveRight && (
          <Button
            size="sm"
            variant="ghost"
            onClick={() => handleReorderStages(stageKey, 'right')}
            className="h-10 w-10 p-0 ml-2 hover:bg-blue-50 hover:text-blue-600 transition-all duration-200 rounded-full"
            title="Mover para direita"
          >
            <ArrowRight className="w-5 h-5" />
          </Button>
        )}
      </div>
    );
  };



  // Componente Sortable para Drag and Drop
  const SortableClientCard = ({ client }: { client: Client }) => {
    const {
      attributes,
      listeners,
      setNodeRef,
      transform,
      transition,
      isDragging,
    } = useSortable({ id: client.id });

    const style = {
      transform: CSS.Transform.toString(transform),
      transition,
      opacity: isDragging ? 0.5 : 1,
    };

    return (
      <div ref={setNodeRef} style={style} {...attributes} {...listeners}>
        <ClientCard client={client} />
      </div>
    );
  };

  // Componente do Card do Cliente
  const ClientCard = ({ client }: { client: Client }) => {
    
    return (
      <Card className="mb-3 hover:shadow-lg hover:scale-[1.02] transition-all duration-200 group relative overflow-hidden cursor-grab active:cursor-grabbing border-slate-200/50">
        {/* Efeito de brilho no hover */}
        <div className="absolute inset-0 bg-gradient-to-r from-blue-50/50 via-purple-50/50 to-blue-50/50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none" />
        
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-2 h-2 bg-blue-400 rounded-full opacity-0 group-hover:opacity-100 transition-opacity" />
              <CardTitle className="text-base font-semibold text-slate-900">
                {client.name}
              </CardTitle>
            </div>
            <div className="flex space-x-1 opacity-0 group-hover:opacity-100 transition-opacity">
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  e.preventDefault();
                  openMoveModal(client);
                }}
                className="h-8 w-8 p-0 hover:bg-purple-100 hover:text-purple-600 transition-colors"
                title="Mover cliente"
              >
                <Move className="w-4 h-4" />
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  e.preventDefault();
                  console.log('✏️ Botão editar clicado para cliente:', client.id);
                  handleEdit(client);
                }}
                className="h-8 w-8 p-0 hover:bg-blue-100 hover:text-blue-600 transition-colors"
                title="Editar cliente"
              >
                <Edit className="w-4 h-4" />
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  e.preventDefault();
                  console.log('🗑️ Botão delete clicado para cliente:', client.id);
                  handleDelete(client.id);
                }}
                className="h-8 w-8 p-0 hover:bg-red-100 hover:text-red-600 transition-colors"
                title="Excluir cliente"
              >
                <Trash2 className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent className="space-y-3">
          {/* Informações de contato */}
          {client.email && (
            <div className="flex items-center space-x-2 text-sm text-slate-600">
              <div className="w-4 h-4 bg-blue-100 rounded-full flex items-center justify-center">
                <Mail className="w-2.5 h-2.5 text-blue-600" />
              </div>
              <span className="truncate font-medium">{client.email}</span>
            </div>
          )}
          {client.phone && (
            <div className="flex items-center space-x-2 text-sm text-slate-600">
              <div className="w-4 h-4 bg-green-100 rounded-full flex items-center justify-center">
                <Phone className="w-2.5 h-2.5 text-green-600" />
              </div>
              <span className="font-medium">{client.phone}</span>
            </div>
          )}

          {/* Perfil e classificação */}
          <div className="flex flex-wrap gap-1">
            {client.contact_type && (
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                {client.contact_type === 'lead' ? 'Lead' : client.contact_type === 'client' ? 'Cliente' : 'Parceiro'}
              </span>
            )}
            {client.lead_source && (
              <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                {client.lead_source}
              </span>
            )}
          </div>

          {/* Dados complementares */}
          {(client.company || client.job_title || client.industry) && (
            <div className="space-y-1">
              {client.company && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Empresa:</span> {client.company}
                </div>
              )}
              {client.job_title && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Cargo:</span> {client.job_title}
                </div>
              )}
              {client.industry && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Setor:</span> {client.industry}
                </div>
              )}
            </div>
          )}

          {/* Valores financeiros */}
          {(client.estimated_ticket || client.clv) && (
            <div className="space-y-1">
              {client.estimated_ticket && client.estimated_ticket > 0 && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Ticket:</span> R$ {client.estimated_ticket.toLocaleString('pt-BR')}
                </div>
              )}
              {client.clv && client.clv > 0 && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">CLV:</span> R$ {client.clv.toLocaleString('pt-BR')}
                </div>
              )}
            </div>
          )}

          {/* Histórico de interações */}
          {(client.last_contact_date || client.next_follow_up) && (
            <div className="space-y-1">
              {client.last_contact_date && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Último contato:</span> {new Date(client.last_contact_date).toLocaleDateString('pt-BR')}
                </div>
              )}
              {client.next_follow_up && (
                <div className="text-sm text-slate-600">
                  <span className="font-medium">Próximo follow-up:</span> {new Date(client.next_follow_up).toLocaleDateString('pt-BR')}
                </div>
              )}
            </div>
          )}

          {/* Observações */}
          {client.notes && (
            <div className="text-sm text-slate-600 bg-slate-50 rounded-lg p-2">
              <p className="line-clamp-2">{client.notes}</p>
            </div>
          )}

          {/* Data de criação */}
          <div className="pt-2 text-xs text-slate-400 border-t border-slate-100">
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
      <div className="flex-shrink-0 w-80" style={{ height: 'calc(100vh - 200px)' }}>
        <div className="bg-white/80 backdrop-blur-sm rounded-xl p-5 shadow-sm border border-slate-200/50 hover:shadow-md transition-all duration-200 h-full flex flex-col">
          <div className="flex items-center justify-between mb-5 flex-shrink-0">
            <div className="flex items-center space-x-3">
              <div className="p-2 bg-slate-100 rounded-lg">
                <StageIcon className="w-5 h-5 text-slate-600" />
              </div>
              <div>
                <h3 className="font-semibold text-slate-900">{stage.name}</h3>
                <span className="bg-blue-100 text-blue-700 px-2 py-1 rounded-full text-xs font-medium">
                  {stageClients.length} {stageClients.length === 1 ? 'cliente' : 'clientes'}
                </span>
              </div>
            </div>
            <div className="flex space-x-1">
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  handleEditStage(stage);
                }}
                className="h-8 w-8 p-0 hover:bg-slate-100"
                title="Editar estágio"
              >
                <Edit className="w-4 h-4" />
              </Button>
              <Button
                size="sm"
                variant="ghost"
                onClick={(e) => {
                  e.stopPropagation();
                  handleDeleteStage(stageKey);
                }}
                className="h-8 w-8 p-0 hover:bg-red-50 hover:text-red-600"
                title="Excluir estágio"
                disabled={stageClients.length > 0}
              >
                <Trash2 className="w-4 h-4" />
              </Button>
            </div>
          </div>
          
          <DroppableClientArea stageKey={stageKey}>
            <div 
              className="flex-1 border-2 border-dashed border-slate-200 rounded-xl p-3 hover:border-blue-300 hover:bg-blue-50/30 transition-all duration-200 overflow-y-auto"
              style={{ maxHeight: 'calc(100vh - 300px)' }}
              data-stage={stageKey}
            >
              <div className="space-y-3">
                {/* Área de drop no topo */}
                <DroppableDropZone stageKey={stageKey} position="top" />
                
                <SortableContext items={stageClients.map(c => c.id)} strategy={verticalListSortingStrategy}>
                  {stageClients.map((client, index) => (
                    <div key={client.id}>
                      <SortableClientCard client={client} />
                      {/* Área de drop entre cards */}
                      {index < stageClients.length - 1 && (
                        <DroppableDropZone stageKey={stageKey} position={`between-${index}`} />
                      )}
                    </div>
                  ))}
                </SortableContext>
                
                {stageClients.length === 0 && (
                  <div className="text-center py-12 text-muted-foreground">
                    <div className="w-12 h-12 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-3">
                      <Users className="w-6 h-6 text-slate-400" />
                    </div>
                    <p className="text-sm font-medium">Nenhum cliente</p>
                    <p className="text-xs text-slate-400 mt-1">Arraste clientes para cá</p>
                  </div>
                )}
                
                {/* Área de drop no final do estágio */}
                <DroppableDropZone stageKey={stageKey} position="bottom" />
              </div>
            </div>
          </DroppableClientArea>
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
    <div className="h-screen bg-gradient-to-br from-slate-50 via-blue-50/30 to-purple-50/30 flex flex-col">
      {/* Header */}
      <header className="border-b bg-gradient-to-r from-slate-50 to-blue-50/50 backdrop-blur supports-[backdrop-filter]:bg-background/60 flex-shrink-0">
        <div className="container mx-auto px-6 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-6">
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => window.history.back()}
                className="hover:bg-white/80 transition-colors"
              >
                ← Dashboard
              </Button>
              <div className="flex items-center space-x-3">
                <div className="p-2 bg-blue-100 rounded-lg">
                  <Users className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <h1 className="text-2xl font-bold bg-gradient-to-r from-slate-900 to-blue-900 bg-clip-text text-transparent">
                    CRM - Gestão de Clientes
                  </h1>
                  <p className="text-sm text-muted-foreground mt-1">
                    Arraste clientes entre estágios • Use as setas para reordenar estágios
                  </p>
                </div>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <Button
                variant="outline"
                onClick={() => setStagesDialogOpen(true)}
                className="flex items-center space-x-2 hover:bg-white/80 transition-colors"
              >
                <Settings className="w-4 h-4" />
                Configurar Estágios
              </Button>
              <Button
                onClick={() => setDialogOpen(true)}
                className="flex items-center space-x-2 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white shadow-lg hover:shadow-xl transition-all duration-200"
              >
                <Plus className="w-4 h-4" />
                Novo Cliente
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Conteúdo Principal */}
      <main className="flex-1 container mx-auto px-6 py-8 min-h-0 flex flex-col">
        <DndContext
          sensors={sensors}
          collisionDetection={closestCorners}
          onDragStart={handleDragStart}
          onDragEnd={handleDragEnd}
        >
          <div className="flex gap-6 overflow-x-auto flex-1" style={{ height: 'calc(100vh - 200px)' }}>
            {Object.entries(stages).map(([stageKey, stage]) => (
              <StageColumnWithArrows key={stageKey} stageKey={stageKey} stage={stage} />
            ))}
            
            {/* Botão para adicionar estágios */}
            <div className="flex-shrink-0 w-80 flex items-center justify-center">
              <Button 
                variant="outline" 
                className="h-16 w-16 rounded-full border-2 border-dashed border-slate-300 hover:border-blue-400 hover:bg-blue-50 transition-all duration-200"
                onClick={() => setStagesDialogOpen(true)}
              >
                <Plus className="w-8 h-8 text-slate-400" />
              </Button>
            </div>
          </div>
          
          {/* Drag Overlay */}
          <DragOverlay>
            {activeClient ? (
              <div className="w-80">
                <ClientCard client={activeClient} />
              </div>
            ) : null}
          </DragOverlay>
        </DndContext>

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
        <DialogContent className="sm:max-w-[800px] max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>
              {editingClient ? 'Editar Cliente' : 'Novo Cliente'}
            </DialogTitle>
            <DialogDescription>
              {editingClient ? 'Atualize as informações do cliente' : 'Adicione um novo cliente ao seu CRM'}
            </DialogDescription>
          </DialogHeader>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Informações principais (identidade) */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Informações Principais</h3>
              
              <div className="space-y-2">
                <Label htmlFor="name">Nome completo *</Label>
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

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
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
                  <Label htmlFor="address">Endereço completo</Label>
                  <Input
                    id="address"
                    placeholder="Endereço completo"
                    value={formData.address}
                    onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  />
                </div>
              </div>
            </div>

            {/* Perfil e classificação */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Perfil e Classificação</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="contact_type">Tipo de contato</Label>
                  <Select value={formData.contact_type} onValueChange={(value) => setFormData({ ...formData, contact_type: value as 'lead' | 'client' | 'partner' })}>
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione o tipo" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="lead">Lead</SelectItem>
                      <SelectItem value="client">Cliente</SelectItem>
                      <SelectItem value="partner">Parceiro</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="lead_source">Fonte do lead</Label>
                  <Select value={formData.lead_source} onValueChange={(value) => setFormData({ ...formData, lead_source: value })}>
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione a fonte" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="campaign">Campanha</SelectItem>
                      <SelectItem value="referral">Indicação</SelectItem>
                      <SelectItem value="organic">Orgânico</SelectItem>
                      <SelectItem value="social">Redes Sociais</SelectItem>
                      <SelectItem value="website">Website</SelectItem>
                      <SelectItem value="event">Evento</SelectItem>
                      <SelectItem value="other">Outro</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="stage">Estágio atual</Label>
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
            </div>

            {/* Dados complementares estratégicos */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Dados Complementares</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="job_title">Cargo</Label>
                  <Input
                    id="job_title"
                    placeholder="Cargo do contato"
                    value={formData.job_title}
                    onChange={(e) => setFormData({ ...formData, job_title: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="company">Empresa</Label>
                  <Input
                    id="company"
                    placeholder="Nome da empresa"
                    value={formData.company}
                    onChange={(e) => setFormData({ ...formData, company: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="industry">Indústria</Label>
                  <Input
                    id="industry"
                    placeholder="Setor/Indústria"
                    value={formData.industry}
                    onChange={(e) => setFormData({ ...formData, industry: e.target.value })}
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="estimated_ticket">Ticket médio estimado (R$)</Label>
                  <Input
                    id="estimated_ticket"
                    type="number"
                    placeholder="0,00"
                    value={formData.estimated_ticket}
                    onChange={(e) => setFormData({ ...formData, estimated_ticket: parseFloat(e.target.value) || 0 })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="clv">CLV - Valor do cliente (R$)</Label>
                  <Input
                    id="clv"
                    type="number"
                    placeholder="0,00"
                    value={formData.clv}
                    onChange={(e) => setFormData({ ...formData, clv: parseFloat(e.target.value) || 0 })}
                  />
                </div>
              </div>
            </div>

            {/* Histórico de interações */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Histórico de Interações</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="last_contact_date">Data do último contato</Label>
                  <Input
                    id="last_contact_date"
                    type="date"
                    value={formData.last_contact_date}
                    onChange={(e) => setFormData({ ...formData, last_contact_date: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="next_follow_up">Próximo follow-up</Label>
                  <Input
                    id="next_follow_up"
                    type="date"
                    value={formData.next_follow_up}
                    onChange={(e) => setFormData({ ...formData, next_follow_up: e.target.value })}
                  />
                </div>
              </div>
            </div>

            {/* Customizações para negócio */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Customizações</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="payment_method">Forma de pagamento</Label>
                  <Select value={formData.payment_method} onValueChange={(value) => setFormData({ ...formData, payment_method: value })}>
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="pix">PIX</SelectItem>
                      <SelectItem value="credit_card">Cartão de Crédito</SelectItem>
                      <SelectItem value="debit_card">Cartão de Débito</SelectItem>
                      <SelectItem value="bank_transfer">Transferência</SelectItem>
                      <SelectItem value="cash">Dinheiro</SelectItem>
                      <SelectItem value="boleto">Boleto</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="contract_type">Tipo de contrato</Label>
                  <Select value={formData.contract_type} onValueChange={(value) => setFormData({ ...formData, contract_type: value })}>
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="monthly">Mensal</SelectItem>
                      <SelectItem value="quarterly">Trimestral</SelectItem>
                      <SelectItem value="annual">Anual</SelectItem>
                      <SelectItem value="one_time">Única vez</SelectItem>
                      <SelectItem value="custom">Personalizado</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="delivery_deadline">Prazo de entrega</Label>
                  <Input
                    id="delivery_deadline"
                    placeholder="Ex: 15 dias úteis"
                    value={formData.delivery_deadline}
                    onChange={(e) => setFormData({ ...formData, delivery_deadline: e.target.value })}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="technical_contact">Responsável técnico</Label>
                  <Input
                    id="technical_contact"
                    placeholder="Nome do responsável"
                    value={formData.technical_contact}
                    onChange={(e) => setFormData({ ...formData, technical_contact: e.target.value })}
                  />
                </div>
              </div>
            </div>

            {/* Observações */}
            <div className="space-y-4">
              <h3 className="text-lg font-semibold text-slate-900 border-b pb-2">Observações</h3>
              
              <div className="space-y-2">
                <Label htmlFor="notes">Observações e notas</Label>
                <Textarea
                  id="notes"
                  placeholder="Anotações sobre o cliente, preferências, objeções, resultados de reuniões, próximos passos..."
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  rows={4}
                />
              </div>
            </div>

            <div className="flex justify-end space-x-2 pt-4 border-t">
              <Button type="button" variant="outline" onClick={resetForm}>
                Cancelar
              </Button>
              <Button type="submit">
                {editingClient ? 'Atualizar Cliente' : 'Criar Cliente'}
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

      {/* Modal Smart Stage Navigator */}
      <Dialog open={moveModalOpen} onOpenChange={setMoveModalOpen}>
        <DialogContent className="sm:max-w-[600px]">
          <DialogHeader>
            <DialogTitle className="flex items-center space-x-2">
              <Sparkles className="w-5 h-5 text-purple-600" />
              <span>Smart Stage Navigator</span>
            </DialogTitle>
            <DialogDescription>
              Mova {selectedClient?.name} para o estágio desejado com sugestões inteligentes
            </DialogDescription>
          </DialogHeader>
          
          {selectedClient && (
            <div className="space-y-6">
              {/* Cliente selecionado */}
              <div className="p-4 bg-gradient-to-r from-purple-50 to-blue-50 rounded-lg border border-purple-200">
                <div className="flex items-center space-x-3">
                  <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                    <Users className="w-6 h-6 text-purple-600" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-lg">{selectedClient.name}</h3>
                    <p className="text-sm text-muted-foreground">
                      Estágio atual: <span className="font-medium">{stages[selectedClient.stage]?.name}</span>
                    </p>
                  </div>
                </div>
              </div>



              {/* Todos os estágios */}
              <div>
                <h4 className="font-semibold mb-3 flex items-center space-x-2">
                  <Move className="w-4 h-4" />
                  <span>Escolher Estágio</span>
                </h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {Object.entries(stages).map(([stageKey, stage]) => {
                    const StageIcon = stage.icon;
                    const isCurrentStage = stageKey === selectedClient.stage;
                    const isSuggestedStage = false;
                    
                    return (
                      <Button
                        key={stageKey}
                        variant={isCurrentStage ? "outline" : "default"}
                        disabled={isCurrentStage || isMoving}
                        onClick={() => handleMoveClient(selectedClient.id, stageKey)}
                        className={`h-auto p-4 flex flex-col items-center space-y-2 ${
                          isCurrentStage ? 'opacity-50 cursor-not-allowed' : ''
                        } ${
                          isSuggestedStage ? 'ring-2 ring-green-500' : ''
                        }`}
                      >
                        <StageIcon className="w-6 h-6" />
                        <div className="text-center">
                          <div className="font-medium">{stage.name}</div>
                          <div className="text-xs text-muted-foreground">
                            {getClientsByStage(stageKey).length} clientes
                          </div>
                        </div>
                        {isCurrentStage && (
                          <div className="text-xs text-muted-foreground">Atual</div>
                        )}

                      </Button>
                    );
                  })}
                </div>
              </div>

              {/* Histórico de movimentações */}
              {moveHistory.length > 0 && (
                <div>
                  <h4 className="font-semibold mb-3 flex items-center space-x-2">
                    <History className="w-4 h-4" />
                    <span>Histórico de Movimentações</span>
                  </h4>
                  <div className="max-h-32 overflow-y-auto space-y-2">
                    {moveHistory.slice(-5).reverse().map((move, index) => (
                      <div key={index} className="flex items-center space-x-2 text-sm p-2 bg-muted/50 rounded">
                        <ArrowRight className="w-3 h-3 text-muted-foreground" />
                        <span className="text-muted-foreground">
                          {clients.find(c => c.id === move.clientId)?.name}
                        </span>
                        <span className="text-muted-foreground">→</span>
                        <span className="font-medium">{stages[move.toStage]?.name}</span>
                        <span className="text-xs text-muted-foreground">
                          {new Date(move.timestamp).toLocaleTimeString('pt-BR')}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}