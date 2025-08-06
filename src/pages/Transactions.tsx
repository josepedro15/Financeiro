import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { testDatabasePermissions, testClientIdNull } from '@/utils/testAuth';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Textarea } from '@/components/ui/textarea';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { 
  DollarSign, 
  Plus, 
  ArrowUpRight, 
  ArrowDownRight,
  Edit,
  Trash2,
  Calendar
} from 'lucide-react';

interface Transaction {
  id: string;
  description: string;
  amount: number;
  transaction_type: 'income' | 'expense' | 'transfer';
  category: string;
  transaction_date: string;
  client_name?: string;
  account_id: string;
  accounts?: { name: string };
}

interface Account {
  id: string;
  name: string;
  code: string;
}



export default function Transactions() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [accounts, setAccounts] = useState<Account[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingTransaction, setEditingTransaction] = useState<Transaction | null>(null);

  // Form state
  const [formData, setFormData] = useState({
    description: '',
    amount: '',
    transaction_type: 'income' as 'income' | 'expense' | 'transfer',
    category: '',
    transaction_date: new Date().toISOString().split('T')[0],
    client_name: '',
    account_id: ''
  });

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadData();
  }, [user, navigate]);

  const loadData = async () => {
    if (!user) {
      console.log('No user found, skipping data load');
      return;
    }

    console.log('Loading data for user:', user.id);

    try {
      // Load transactions
      const { data: transactionsData, error: transactionsError } = await supabase
        .from('transactions')
        .select('*, accounts(name)')
        .eq('user_id', user.id)
        .order('transaction_date', { ascending: false });

      if (transactionsError) {
        console.error('Error loading transactions:', transactionsError);
        toast({
          title: "Erro",
          description: `Erro ao carregar transações: ${transactionsError.message}`,
          variant: "destructive"
        });
      }

      // Load accounts
      const { data: accountsData, error: accountsError } = await supabase
        .from('accounts')
        .select('id, name, code')
        .eq('is_active', true);

      if (accountsError) {
        console.error('Error loading accounts:', accountsError);
        toast({
          title: "Erro",
          description: `Erro ao carregar contas: ${accountsError.message}`,
          variant: "destructive"
        });
      }



      console.log('Loaded data:', {
        transactions: transactionsData?.length || 0,
        accounts: accountsData?.length || 0
      });

      setTransactions((transactionsData as Transaction[]) || []);
      setAccounts(accountsData || []);

      // If no accounts exist, show a warning
      if (!accountsData || accountsData.length === 0) {
        toast({
          title: "Aviso",
          description: "Nenhuma conta encontrada. Você precisa criar contas antes de adicionar transações.",
          variant: "destructive"
        });
      }
    } catch (error) {
      console.error('Error loading data:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar dados",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    // Validação adicional
    if (!formData.account_id) {
      toast({
        title: "Erro",
        description: "Selecione uma conta para a transação",
        variant: "destructive"
      });
      return;
    }

    try {
      const transactionData = {
        user_id: user.id,
        description: formData.description,
        amount: parseFloat(formData.amount),
        transaction_type: formData.transaction_type,
        category: formData.category,
        transaction_date: formData.transaction_date,
        account_id: formData.account_id,
        client_name: formData.client_name || null
      };

      if (editingTransaction) {
        const { error } = await supabase
          .from('transactions')
          .update(transactionData)
          .eq('id', editingTransaction.id);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Transação atualizada com sucesso"
        });
      } else {
        const { error } = await supabase
          .from('transactions')
          .insert([transactionData]);

        if (error) throw error;

        toast({
          title: "Sucesso",
          description: "Transação criada com sucesso"
        });
      }

      // Reset form and reload data
      setFormData({
        description: '',
        amount: '',
        transaction_type: 'income',
        category: '',
        transaction_date: new Date().toISOString().split('T')[0],
        client_name: '',
        account_id: ''
      });
      setEditingTransaction(null);
      setDialogOpen(false);
      loadData();
    } catch (error: any) {
      console.error('Transaction error:', error);
      
      // Verificar se é um erro de autorização
      if (error.code === 'PGRST116' || error.message?.includes('permission')) {
        toast({
          title: "Erro de Autorização",
          description: "Você não tem permissão para realizar esta ação. Verifique se está logado corretamente.",
          variant: "destructive"
        });
      } else {
        toast({
          title: "Erro",
          description: error.message || "Erro desconhecido ao processar transação",
          variant: "destructive"
        });
      }
    }
  };

  const handleEdit = (transaction: Transaction) => {
    setEditingTransaction(transaction);
    setFormData({
      description: transaction.description,
      amount: transaction.amount.toString(),
      transaction_type: transaction.transaction_type,
      category: transaction.category || '',
      transaction_date: transaction.transaction_date,
      client_name: transaction.client_name || '',
      account_id: transaction.account_id
    });
    setDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Tem certeza que deseja excluir esta transação?')) return;

    try {
      const { error } = await supabase
        .from('transactions')
        .delete()
        .eq('id', id);

      if (error) throw error;

      toast({
        title: "Sucesso",
        description: "Transação excluída com sucesso"
      });
      loadData();
    } catch (error: any) {
      console.error('Delete error:', error);
      
      // Verificar se é um erro de autorização
      if (error.code === 'PGRST116' || error.message?.includes('permission')) {
        toast({
          title: "Erro de Autorização",
          description: "Você não tem permissão para excluir esta transação. Verifique se está logado corretamente.",
          variant: "destructive"
        });
      } else {
        toast({
          title: "Erro",
          description: error.message || "Erro desconhecido ao excluir transação",
          variant: "destructive"
        });
      }
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(amount);
  };

  const runAuthTests = async () => {
    console.log('🧪 Executando testes de autorização...');
    
    // Teste geral de permissões
    const permissionsResult = await testDatabasePermissions();
    console.log('Resultado do teste de permissões:', permissionsResult);
    
    // Teste específico de client_id null
    const clientIdResult = await testClientIdNull();
    console.log('Resultado do teste de client_id:', clientIdResult);
    
    if (permissionsResult.success && clientIdResult.success) {
      toast({
        title: "Testes Concluídos",
        description: "Todos os testes de autorização passaram!",
      });
    } else {
      toast({
        title: "Testes Falharam",
        description: `Problemas encontrados: ${permissionsResult.error || clientIdResult.error}`,
        variant: "destructive"
      });
    }
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
              ← Dashboard
            </Button>
            <h1 className="text-2xl font-bold">Transações</h1>
            <Button 
              variant="outline" 
              size="sm" 
              onClick={runAuthTests}
              className="ml-4"
            >
              🧪 Testar Auth
            </Button>
          </div>
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => {
                console.log('Button clicked - opening dialog');
                console.log('Current accounts:', accounts);
            
                setEditingTransaction(null);
                setFormData({
                  description: '',
                  amount: '',
                  transaction_type: 'income',
                  category: '',
                  transaction_date: new Date().toISOString().split('T')[0],
                  client_id: '',
                  account_id: ''
                });
                console.log('Form data reset, opening dialog');
              }}>
                <Plus className="w-4 h-4 mr-2" />
                Nova Transação
              </Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[500px]">
              <DialogHeader>
                <DialogTitle>
                  {editingTransaction ? 'Editar Transação' : 'Nova Transação'}
                </DialogTitle>
                <DialogDescription>
                  {editingTransaction ? 'Edite os dados da transação' : 'Adicione uma nova transação financeira'}
                </DialogDescription>
              </DialogHeader>
              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="description">Descrição</Label>
                  <Input
                    id="description"
                    placeholder="Descrição da transação"
                    value={formData.description}
                    onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                    required
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="amount">Valor</Label>
                    <Input
                      id="amount"
                      type="number"
                      step="0.01"
                      placeholder="0,00"
                      value={formData.amount}
                      onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
                      required
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="transaction_type">Tipo</Label>
                    <Select value={formData.transaction_type} onValueChange={(value: any) => setFormData({ ...formData, transaction_type: value })}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="income">Receita</SelectItem>
                        <SelectItem value="expense">Despesa</SelectItem>
                        <SelectItem value="transfer">Transferência</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="account_id">Conta</Label>
                  <Select 
                    value={formData.account_id || ""} 
                    onValueChange={(value) => setFormData({ ...formData, account_id: value })}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione uma conta" />
                    </SelectTrigger>
                    <SelectContent>
                      {accounts.map((account) => (
                        <SelectItem key={account.id} value={account.id}>
                          {account.code} - {account.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="client_name">Cliente (Opcional)</Label>
                  <Input
                    id="client_name"
                    placeholder="Digite o nome do cliente"
                    value={formData.client_name}
                    onChange={(e) => setFormData({ ...formData, client_name: e.target.value })}
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="category">Categoria</Label>
                    <Input
                      id="category"
                      placeholder="Ex: Vendas, Marketing"
                      value={formData.category}
                      onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="transaction_date">Data</Label>
                    <Input
                      id="transaction_date"
                      type="date"
                      value={formData.transaction_date}
                      onChange={(e) => setFormData({ ...formData, transaction_date: e.target.value })}
                      required
                    />
                  </div>
                </div>

                <div className="flex justify-end space-x-2">
                  <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>
                    Cancelar
                  </Button>
                  <Button type="submit">
                    {editingTransaction ? 'Atualizar' : 'Criar'}
                  </Button>
                </div>
              </form>
            </DialogContent>
          </Dialog>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <Card className="shadow-finance-md">
          <CardHeader>
            <CardTitle>Lista de Transações</CardTitle>
            <CardDescription>
              Gerencie todas as suas movimentações financeiras
            </CardDescription>
          </CardHeader>
          <CardContent>
            {transactions.length === 0 ? (
              <div className="text-center py-8">
                <DollarSign className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-muted-foreground mb-4">
                  Nenhuma transação encontrada. Adicione sua primeira transação.
                </p>
              </div>
            ) : (
              <div className="space-y-4">
                {transactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className="flex items-center justify-between p-4 rounded-lg border hover:bg-muted/50 transition-colors"
                  >
                    <div className="flex items-center space-x-4">
                      <div className={`p-2 rounded-full ${
                        transaction.transaction_type === 'income' 
                          ? 'bg-success/10' 
                          : transaction.transaction_type === 'expense'
                          ? 'bg-destructive/10'
                          : 'bg-info/10'
                      }`}>
                        {transaction.transaction_type === 'income' ? (
                          <ArrowUpRight className="h-4 w-4 text-success" />
                        ) : transaction.transaction_type === 'expense' ? (
                          <ArrowDownRight className="h-4 w-4 text-destructive" />
                        ) : (
                          <Calendar className="h-4 w-4 text-info" />
                        )}
                      </div>
                      <div>
                        <p className="font-medium">{transaction.description}</p>
                        <div className="flex items-center space-x-2 text-sm text-muted-foreground">
                          <span>{transaction.client_name || 'Sem cliente'}</span>
                          <span>•</span>
                          <span>{transaction.accounts?.name}</span>
                          <span>•</span>
                          <span>{new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}</span>
                          {transaction.category && (
                            <>
                              <span>•</span>
                              <span>{transaction.category}</span>
                            </>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center space-x-4">
                      <div className={`font-semibold ${
                        transaction.transaction_type === 'income' 
                          ? 'text-success' 
                          : transaction.transaction_type === 'expense'
                          ? 'text-destructive'
                          : 'text-info'
                      }`}>
                        {transaction.transaction_type === 'income' ? '+' : 
                         transaction.transaction_type === 'expense' ? '-' : ''}
                        {formatCurrency(Number(transaction.amount))}
                      </div>
                      <div className="flex space-x-2">
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => handleEdit(transaction)}
                        >
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button
                          size="sm"
                          variant="ghost"
                          onClick={() => handleDelete(transaction.id)}
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      </main>
    </div>
  );
}