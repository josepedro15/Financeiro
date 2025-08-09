import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { 
  DollarSign, 
  Plus, 
  ArrowUpRight, 
  ArrowDownRight,
  Edit,
  Trash2,
  Calendar,
  Filter,
  X
} from 'lucide-react';

interface Transaction {
  id: string;
  description?: string;
  amount: number;
  transaction_type: 'income' | 'expense' | 'transfer';
  category?: string;
  transaction_date: string;
  client_name?: string;
  account_name: string;
}

export default function Transactions() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [transactions, setTransactions] = useState<Transaction[]>([]);
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
    account_name: ''
  });

  // Contas fixas
  const accounts = [
    { id: 'pj', name: 'Conta PJ' },
    { id: 'checkout', name: 'Conta Checkout' }
  ];

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    
    loadTransactions();
  }, [user, navigate]);

  const loadTransactions = async () => {
    if (!user) return;

    try {
      setLoading(true);
      
      // Carregar transações das tabelas mensais de 2025
      let allTransactions: Transaction[] = [];
      
      const monthlyTables = [
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
      ];

      for (const table of monthlyTables) {
        try {
          const { data, error } = await supabase
            .from(table)
            .select('*')
            .eq('user_id', user.id);

          if (error) {
            console.warn(`Erro ao carregar ${table}:`, error);
          } else if (data) {
            allTransactions = [...allTransactions, ...data];
            console.log(`${table}: ${data.length} transações`);
          }
        } catch (error) {
          console.warn(`Erro na consulta ${table}:`, error);
        }
      }

      // Carregar também da tabela principal
      try {
        const { data, error } = await supabase
          .from('transactions')
          .select('*')
          .eq('user_id', user.id);

        if (error) {
          console.warn('Erro ao carregar tabela principal:', error);
        } else if (data) {
          allTransactions = [...allTransactions, ...data];
          console.log(`Tabela principal: ${data.length} transações`);
        }
      } catch (error) {
        console.warn('Erro na consulta tabela principal:', error);
      }

      // Remover duplicatas e ordenar
      const uniqueTransactions = allTransactions.filter((transaction, index, self) =>
        index === self.findIndex(t => t.id === transaction.id)
      );

      const sortedTransactions = uniqueTransactions.sort((a, b) => 
        new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime()
      );

      console.log('Total transações carregadas:', sortedTransactions.length);
      setTransactions(sortedTransactions);
    } catch (error) {
      console.error('Erro ao carregar transações:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(amount);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    try {
      const transactionData = {
        user_id: user.id,
        description: formData.description,
        amount: parseFloat(formData.amount),
        transaction_type: formData.transaction_type,
        category: formData.category,
        transaction_date: formData.transaction_date,
        account_name: formData.account_name,
        client_name: formData.client_name || null
      };

      if (editingTransaction) {
        // Atualizar transação existente
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
        // Criar nova transação
        const { error } = await supabase
          .from('transactions')
          .insert(transactionData);

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
        account_name: ''
      });
      setEditingTransaction(null);
      setDialogOpen(false);
      loadTransactions();
    } catch (error: any) {
      console.error('Transaction error:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao processar transação",
        variant: "destructive"
      });
    }
  };

  const handleEdit = (transaction: Transaction) => {
    setEditingTransaction(transaction);
    setFormData({
      description: transaction.description || '',
      amount: transaction.amount.toString(),
      transaction_type: transaction.transaction_type,
      category: transaction.category || '',
      transaction_date: transaction.transaction_date,
      client_name: transaction.client_name || '',
      account_name: transaction.account_name
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
      loadTransactions();
    } catch (error: any) {
      console.error('Delete error:', error);
      toast({
        title: "Erro",
        description: error.message || "Erro ao excluir transação",
        variant: "destructive"
      });
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-8">
          <div className="flex items-center justify-center h-64">
            <div className="text-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
              <p className="text-muted-foreground">Carregando transações...</p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b bg-card">
        <div className="container mx-auto px-4 py-4">
                      <div className="flex items-center justify-between">
              <div className="flex items-center space-x-4">
                <Button variant="outline" size="sm" onClick={() => navigate('/dashboard')}>
                  <ArrowUpRight className="w-4 h-4 mr-1" />
                  Voltar ao Dashboard
                </Button>
                <div>
                  <h1 className="text-2xl font-bold">Transações</h1>
                  <p className="text-muted-foreground">Gerencie suas transações financeiras</p>
                </div>
              </div>
              
              <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
                <DialogTrigger asChild>
                  <Button onClick={() => {
                    setEditingTransaction(null);
                    setFormData({
                      description: '',
                      amount: '',
                      transaction_type: 'income',
                      category: '',
                      transaction_date: new Date().toISOString().split('T')[0],
                      client_name: '',
                      account_name: ''
                    });
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
                      <Label htmlFor="description">Descrição (Opcional)</Label>
                      <Input
                        id="description"
                        placeholder="Descrição da transação"
                        value={formData.description}
                        onChange={(e) => setFormData({ ...formData, description: e.target.value })}
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
                      <Label htmlFor="account_name">Conta</Label>
                      <Select 
                        value={formData.account_name || undefined} 
                        onValueChange={(value) => setFormData({ ...formData, account_name: value })}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Selecione uma conta" />
                        </SelectTrigger>
                        <SelectContent>
                          {accounts.map((account) => (
                            <SelectItem key={account.id} value={account.name}>
                              {account.name}
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
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <DollarSign className="w-5 h-5" />
              <span>Transações</span>
            </CardTitle>
            <CardDescription>
              Página de transações simplificada para teste
            </CardDescription>
          </CardHeader>
                      <CardContent>
              {loading ? (
                <div className="text-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
                  <p className="text-muted-foreground">Carregando transações...</p>
                </div>
              ) : transactions.length === 0 ? (
                <div className="text-center py-8">
                  <DollarSign className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                  <p className="text-muted-foreground mb-4">
                    Nenhuma transação encontrada.
                  </p>
                  <Button onClick={() => navigate('/dashboard')}>
                    Voltar ao Dashboard
                  </Button>
                </div>
              ) : (
                <div className="space-y-4">
                  <div className="flex items-center justify-between mb-4">
                    <p className="text-sm text-muted-foreground">
                      {transactions.length} transação{transactions.length !== 1 ? 'ões' : ''} encontrada{transactions.length !== 1 ? 's' : ''}
                    </p>
                  </div>
                  
                  {transactions.map((transaction) => (
                    <div 
                      key={transaction.id} 
                      className="flex items-center justify-between p-4 rounded-lg border hover:bg-muted/50 transition-colors"
                    >
                      <div className="flex items-center space-x-4">
                        <div className={`p-2 rounded-full ${
                          transaction.transaction_type === 'income' 
                            ? 'bg-green-100' 
                            : transaction.transaction_type === 'expense'
                            ? 'bg-red-100'
                            : 'bg-blue-100'
                        }`}>
                          {transaction.transaction_type === 'income' ? (
                            <ArrowUpRight className="h-4 w-4 text-green-600" />
                          ) : transaction.transaction_type === 'expense' ? (
                            <ArrowDownRight className="h-4 w-4 text-red-600" />
                          ) : (
                            <Calendar className="h-4 w-4 text-blue-600" />
                          )}
                        </div>
                        <div>
                          <p className="font-medium">{transaction.description || 'Sem descrição'}</p>
                          <div className="flex items-center space-x-2 text-sm text-muted-foreground">
                            <span>{transaction.client_name || 'Sem cliente'}</span>
                            <span>•</span>
                            <span>{transaction.account_name}</span>
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
                            ? 'text-green-600' 
                            : transaction.transaction_type === 'expense'
                            ? 'text-red-600'
                            : 'text-blue-600'
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