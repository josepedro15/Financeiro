import { useState, useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { 
  Settings as SettingsIcon, 
  Users, 
  Mail, 
  Shield, 
  Trash2,
  Plus,
  ArrowLeft,
  Check,
  X
} from 'lucide-react';
import { toast } from 'sonner';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';

interface SharedUser {
  id: string;
  email: string;
  created_at: string;
  status: 'pending' | 'active';
}

export default function Settings() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [sharedUsers, setSharedUsers] = useState<SharedUser[]>([]);
  const [newUserEmail, setNewUserEmail] = useState('');
  const [addingUser, setAddingUser] = useState(false);

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadSharedUsers();
  }, [user, navigate]);

  const loadSharedUsers = async () => {
    if (!user) return;
    
    try {
      const { data, error } = await supabase
        .from('organization_members')
        .select('*')
        .eq('owner_id', user.id)
        .order('created_at', { ascending: false });

      if (error) {
        console.error('Erro ao carregar usuários compartilhados:', error);
        return;
      }

      setSharedUsers(data || []);
    } catch (error) {
      console.error('Erro ao carregar usuários:', error);
    }
  };

  const addUserToOrganization = async () => {
    if (!user || !newUserEmail.trim()) {
      toast.error('Email é obrigatório');
      return;
    }

    // Validar formato do email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(newUserEmail.trim())) {
      toast.error('Formato de email inválido');
      return;
    }

    setAddingUser(true);

    try {
      // Verificar se o email já foi adicionado
      const { data: existingUser, error: checkError } = await supabase
        .from('organization_members')
        .select('email')
        .eq('owner_id', user.id)
        .eq('email', newUserEmail.trim().toLowerCase())
        .single();

      if (existingUser) {
        toast.error('Este email já foi adicionado à organização');
        setAddingUser(false);
        return;
      }

      // Verificar se o usuário existe no sistema
      const { data: userExists, error: userError } = await supabase
        .from('profiles')
        .select('id, email')
        .eq('email', newUserEmail.trim().toLowerCase())
        .single();

      let status: 'pending' | 'active' = 'pending';
      let member_id: string | null = null;

      if (userExists && !userError) {
        status = 'active';
        member_id = userExists.id;
      }

      // Adicionar à tabela de membros da organização
      const { data, error } = await supabase
        .from('organization_members')
        .insert({
          owner_id: user.id,
          member_id: member_id,
          email: newUserEmail.trim().toLowerCase(),
          status: status
        })
        .select()
        .single();

      if (error) {
        console.error('Erro ao adicionar usuário:', error);
        toast.error('Erro ao adicionar usuário');
        return;
      }

      toast.success(`Usuário ${status === 'active' ? 'adicionado' : 'convidado'} com sucesso!`);
      setNewUserEmail('');
      loadSharedUsers();

    } catch (error) {
      console.error('Erro ao adicionar usuário:', error);
      toast.error('Erro ao adicionar usuário');
    } finally {
      setAddingUser(false);
    }
  };

  const removeUserFromOrganization = async (userId: string, email: string) => {
    if (!user) return;

    try {
      const { error } = await supabase
        .from('organization_members')
        .delete()
        .eq('owner_id', user.id)
        .eq('id', userId);

      if (error) {
        console.error('Erro ao remover usuário:', error);
        toast.error('Erro ao remover usuário');
        return;
      }

      toast.success(`${email} removido da organização`);
      loadSharedUsers();

    } catch (error) {
      console.error('Erro ao remover usuário:', error);
      toast.error('Erro ao remover usuário');
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (!user) {
    return null;
  }

  return (
    <div className="container mx-auto p-6 max-w-4xl">
      {/* Header */}
      <div className="flex items-center gap-4 mb-8">
        <Button 
          variant="ghost" 
          size="sm" 
          onClick={() => navigate('/dashboard')}
          className="flex items-center gap-2"
        >
          <ArrowLeft className="h-4 w-4" />
          Voltar
        </Button>
        <div className="flex items-center gap-3">
          <SettingsIcon className="h-8 w-8 text-blue-600" />
          <div>
            <h1 className="text-3xl font-bold">Configurações</h1>
            <p className="text-muted-foreground">Gerencie sua conta e organização</p>
          </div>
        </div>
      </div>

      <div className="grid gap-6">
        {/* Informações da Conta */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-5 w-5" />
              Informações da Conta
            </CardTitle>
            <CardDescription>
              Suas informações de usuário
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <Label htmlFor="email">Email</Label>
                <Input 
                  id="email" 
                  value={user.email || ''} 
                  disabled 
                  className="bg-muted"
                />
              </div>
              <div>
                <Label htmlFor="user-id">ID do Usuário</Label>
                <Input 
                  id="user-id" 
                  value={user.id} 
                  disabled 
                  className="bg-muted text-xs"
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Compartilhamento de Dados */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Users className="h-5 w-5" />
              Compartilhamento de Dados
            </CardTitle>
            <CardDescription>
              Adicione usuários à sua organização para que eles visualizem os mesmos dados
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Adicionar Usuário */}
            <div className="flex gap-3">
              <div className="flex-1">
                <Label htmlFor="new-user-email">Email do usuário</Label>
                <Input
                  id="new-user-email"
                  type="email"
                  placeholder="usuario@exemplo.com"
                  value={newUserEmail}
                  onChange={(e) => setNewUserEmail(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && addUserToOrganization()}
                />
              </div>
              <div className="flex items-end">
                <Button 
                  onClick={addUserToOrganization}
                  disabled={addingUser || !newUserEmail.trim()}
                  className="flex items-center gap-2"
                >
                  {addingUser ? (
                    'Adicionando...'
                  ) : (
                    <>
                      <Plus className="h-4 w-4" />
                      Adicionar
                    </>
                  )}
                </Button>
              </div>
            </div>

            {/* Lista de Usuários Compartilhados */}
            <div>
              <h4 className="font-medium mb-3">
                Usuários com Acesso ({sharedUsers.length})
              </h4>
              
              {sharedUsers.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">
                  <Users className="h-12 w-12 mx-auto mb-3 opacity-50" />
                  <p>Nenhum usuário adicionado ainda</p>
                  <p className="text-sm">Adicione o email de um usuário acima</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {sharedUsers.map((sharedUser) => (
                    <div 
                      key={sharedUser.id}
                      className="flex items-center justify-between p-3 border rounded-lg"
                    >
                      <div className="flex items-center gap-3">
                        <Mail className="h-4 w-4 text-muted-foreground" />
                        <div>
                          <p className="font-medium">{sharedUser.email}</p>
                          <p className="text-sm text-muted-foreground">
                            Adicionado em {formatDate(sharedUser.created_at)}
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <div className="flex items-center gap-2">
                          {sharedUser.status === 'active' ? (
                            <>
                              <Check className="h-4 w-4 text-green-600" />
                              <span className="text-sm text-green-600">Ativo</span>
                            </>
                          ) : (
                            <>
                              <X className="h-4 w-4 text-yellow-600" />
                              <span className="text-sm text-yellow-600">Pendente</span>
                            </>
                          )}
                        </div>
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button 
                              variant="outline" 
                              size="sm"
                              className="text-red-600 hover:text-red-700 hover:bg-red-50"
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          </DialogTrigger>
                          <DialogContent>
                            <DialogHeader>
                              <DialogTitle>Remover usuário</DialogTitle>
                              <DialogDescription>
                                Tem certeza que deseja remover <strong>{sharedUser.email}</strong> da sua organização?
                                Esta ação não pode ser desfeita.
                              </DialogDescription>
                            </DialogHeader>
                            <div className="flex justify-end gap-3">
                              <DialogTrigger asChild>
                                <Button variant="outline">Cancelar</Button>
                              </DialogTrigger>
                              <Button 
                                variant="destructive"
                                onClick={() => removeUserFromOrganization(sharedUser.id, sharedUser.email)}
                              >
                                Remover
                              </Button>
                            </div>
                          </DialogContent>
                        </Dialog>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Informações Adicionais */}
            <div className="bg-blue-50 p-4 rounded-lg">
              <h5 className="font-medium text-blue-900 mb-2">Como funciona:</h5>
              <ul className="text-sm text-blue-800 space-y-1">
                <li>• Usuários adicionados terão acesso a todos os seus dados financeiros</li>
                <li>• Se o usuário já tiver conta, o acesso será imediato (status "Ativo")</li>
                <li>• Se não tiver conta, aparecerá como "Pendente" até criar uma conta</li>
                <li>• Você pode remover o acesso a qualquer momento</li>
              </ul>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
