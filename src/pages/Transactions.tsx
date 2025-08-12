import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { testDatabasePermissions, testClientIdNull } from '@/utils/testAuth';
import { insertTransactionInCorrectTable, updateTransactionInCorrectTable, deleteTransactionFromCorrectTable } from '@/utils/transactionInsertion';
import { getAllMonthlyTables } from '@/utils/monthlyTableUtils';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Textarea } from '@/components/ui/textarea';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { SubscriptionGuard } from '@/components/SubscriptionGuard';
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

interface Account {
  id: string;
  name: string;
}



export default function Transactions() {
  const { user } = useAuth();
  const { canPerformAction, incrementUsage, isMasterUser, checkPlanLimits, subscription, usage } = useSubscription();
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

  // Filter state
  const [filters, setFilters] = useState({
    month: 'all',
    day: 'all',
    type: 'all',
    account: 'all'
  });

  const [filteredTransactions, setFilteredTransactions] = useState<Transaction[]>([]);

  // Debug logs (commented out for production)
  // console.log('=== TRANSACTIONS PAGE DEBUG ===');
  // console.log('User:', user);
  // console.log('Loading:', loading);
  // console.log('Transactions count:', transactions.length);
  // console.log('Filtered transactions count:', filteredTransactions.length);

  // Contas fixas
  const accounts: Account[] = [
    { id: 'pj', name: 'Conta PJ' },
    { id: 'checkout', name: 'Conta Checkout' }
  ];

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadData();
  }, [user, navigate]);

  // Clear all filters
  const clearFilters = () => {
    setFilters({ month: 'all', day: 'all', type: 'all', account: 'all' });
    setFilteredTransactions(transactions);
  };

  // Apply filters when filters or transactions change
  useEffect(() => {
    let filtered = [...transactions];

    // Filter by month
    if (filters.month && filters.month !== 'all') {
      filtered = filtered.filter(transaction => {
        const date = new Date(transaction.transaction_date);
        const month = date.getMonth() + 1; // Convert to 1-based
        return month.toString() === filters.month;
      });
    }

    // Filter by day
    if (filters.day && filters.day !== 'all') {
      filtered = filtered.filter(transaction => {
        const date = new Date(transaction.transaction_date);
        const day = date.getDate();
        return day.toString() === filters.day;
      });
    }

    // Filter by type
    if (filters.type && filters.type !== 'all') {
      filtered = filtered.filter(transaction => transaction.transaction_type === filters.type);
    }

    // Filter by account
    if (filters.account && filters.account !== 'all') {
      filtered = filtered.filter(transaction => transaction.account_name === filters.account);
    }

    setFilteredTransactions(filtered);
  }, [transactions, filters]);

  const loadData = async () => {
    if (!user) {
      console.log('❌ No user found, skipping data load');
      return;
    }

    try {
      setLoading(true);
      console.log('🔄 Iniciando carregamento de dados...');
      console.log('👤 User ID:', user.id);
      let allTransactions: Transaction[] = [];

      // Carregar dados das tabelas mensais de 2025
      const monthlyTables = getAllMonthlyTables(2025);
      console.log('📊 Tabelas mensais a consultar:', monthlyTables.map(t => t.table));
      
      for (const tableInfo of monthlyTables) {
        try {
          console.log(`🔍 Consultando tabela: ${tableInfo.table}`);
          const { data: monthData, error: monthError } = await supabase
            .from(tableInfo.table)
            .select('*')
            .eq('user_id', user.id);

          if (monthError) {
            console.warn(`❌ Erro ao carregar ${tableInfo.month}:`, monthError);
          } else {
            const monthTransactions = monthData || [];
            allTransactions = [...allTransactions, ...monthTransactions];
            console.log(`✅ ${tableInfo.month}: ${monthTransactions.length} transações`);
          }
        } catch (error) {
          console.warn(`❌ Erro na consulta ${tableInfo.month}:`, error);
        }
      }

      // Carregar também da tabela principal (fallback e outras datas)
      try {
        console.log('🔍 Consultando tabela principal: transactions');
        const { data: mainTableData, error: mainTableError } = await supabase
          .from('transactions')
          .select('*')
          .eq('user_id', user.id);

        if (mainTableError) {
          console.warn('❌ Erro ao carregar tabela principal:', mainTableError);
        } else {
          const mainTransactions = mainTableData || [];
          allTransactions = [...allTransactions, ...mainTransactions];
          console.log(`✅ Tabela principal: ${mainTransactions.length} transações`);
        }
      } catch (error) {
        console.warn('❌ Erro na consulta tabela principal:', error);
      }

      // Remover duplicatas (caso existam) e ordenar
      const uniqueTransactions = allTransactions.filter((transaction, index, self) =>
        index === self.findIndex(t => t.id === transaction.id)
      );

      const sortedTransactions = uniqueTransactions.sort((a, b) => 
        new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime()
      );

      console.log('📈 Total transações carregadas:', sortedTransactions.length);
      console.log('📋 Primeiras 3 transações:', sortedTransactions.slice(0, 3));
      setTransactions(sortedTransactions);
      setFilteredTransactions(sortedTransactions);

    } catch (error) {
      console.error('❌ Error loading data:', error);
      toast({
        title: "Erro",
        description: "Erro inesperado ao carregar dados",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
      console.log('✅ Carregamento finalizado');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validações básicas
    if (!formData.amount || parseFloat(formData.amount) <= 0) {
      alert('Valor deve ser maior que zero');
      return;
    }

    if (!formData.account_name) {
      alert('Selecione uma conta');
      return;
    }

    if (!formData.transaction_date) {
      alert('Selecione uma data');
      return;
    }
    
    try {
      // SOLUÇÃO DEFINITIVA: Enviar data exata sem conversões
      const dataExata = formData.transaction_date;
      
      const { data, error } = await supabase.rpc('insert_transaction_safe_final', {
        p_user_id: user.id,
        p_description: formData.description || '',
        p_amount: parseFloat(formData.amount),
        p_transaction_type: formData.transaction_type,
        p_category: formData.category || '',
        p_transaction_date: dataExata,
        p_account_name: formData.account_name,
        p_client_name: formData.client_name || null
      });

      if (error) {
        throw new Error(error.message);
      }

      if (data.success) {
        alert(`✅ Transação criada! Data enviada: ${dataExata}, Data salva: ${data.transaction_date}`);
      } else {
        throw new Error(data.error || 'Erro desconhecido');
      }

      // Reset form
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
      loadData();
      
    } catch (error: any) {
      alert('❌ ERRO: ' + error.message);
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
      account_name: transaction.account_name
    });
    setDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Tem certeza que deseja excluir esta transação?')) return;

    try {
      // Encontrar a transação para obter a data
      const transactionToDelete = transactions.find(t => t.id === id);
      
      if (!transactionToDelete) {
        throw new Error('Transação não encontrada');
      }

      // Usar remoção inteligente da tabela correta
      const result = await deleteTransactionFromCorrectTable(
        id, 
        transactionToDelete.transaction_date
      );

      if (!result.success) {
        throw new Error(result.error || 'Erro ao excluir transação');
      }

      toast({
        title: "Sucesso",
        description: `Transação excluída com sucesso da tabela ${result.tableName}`
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
        <p className="ml-4 text-muted-foreground">Carregando transações...</p>
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
          <SubscriptionGuard feature="transaction">
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
                    client_name: '',
                    account_name: ''
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
                      onChange={(e) => {
                        console.log('📅 DATA ALTERADA:', e.target.value);
                        console.log('Data anterior:', formData.transaction_date);
                        setFormData({ ...formData, transaction_date: e.target.value });
                      }}
                      required
                    />
                  </div>
                </div>

                <div className="flex justify-end space-x-2">
                  <Button type="button" variant="outline" onClick={() => setDialogOpen(false)}>
                    Cancelar
                  </Button>
                  <Button 
                    type="submit"
                    onClick={() => {
                      console.log('🔘 BOTÃO SUBMIT CLICADO');
                      console.log('FormData atual:', formData);
                      console.log('Data atual:', formData.transaction_date);
                    }}
                  >
                    {editingTransaction ? 'Atualizar' : 'Criar'}
                  </Button>
                </div>
              </form>
            </DialogContent>
          </Dialog>
        </SubscriptionGuard>
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
          
          {/* Filtros */}
          <div className="px-6 pb-4 border-b">
            <div className="flex flex-wrap items-center gap-4">
              <div className="flex items-center gap-2">
                <Filter className="h-4 w-4 text-muted-foreground" />
                <span className="text-sm font-medium">Filtros:</span>
              </div>
              
              {/* Filtro por Mês */}
              <div className="flex items-center gap-2">
                <Label htmlFor="month-filter" className="text-xs">Mês:</Label>
                <Select value={filters.month} onValueChange={(value) => setFilters({ ...filters, month: value })}>
                  <SelectTrigger className="w-32 h-8">
                    <SelectValue placeholder="Todos" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos</SelectItem>
                    <SelectItem value="1">Janeiro</SelectItem>
                    <SelectItem value="2">Fevereiro</SelectItem>
                    <SelectItem value="3">Março</SelectItem>
                    <SelectItem value="4">Abril</SelectItem>
                    <SelectItem value="5">Maio</SelectItem>
                    <SelectItem value="6">Junho</SelectItem>
                    <SelectItem value="7">Julho</SelectItem>
                    <SelectItem value="8">Agosto</SelectItem>
                    <SelectItem value="9">Setembro</SelectItem>
                    <SelectItem value="10">Outubro</SelectItem>
                    <SelectItem value="11">Novembro</SelectItem>
                    <SelectItem value="12">Dezembro</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Filtro por Dia */}
              <div className="flex items-center gap-2">
                <Label htmlFor="day-filter" className="text-xs">Dia:</Label>
                <Select value={filters.day} onValueChange={(value) => setFilters({ ...filters, day: value })}>
                  <SelectTrigger className="w-20 h-8">
                    <SelectValue placeholder="Todos" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos</SelectItem>
                    {Array.from({ length: 31 }, (_, i) => i + 1).map(day => (
                      <SelectItem key={day} value={day.toString()}>{day}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Filtro por Tipo */}
              <div className="flex items-center gap-2">
                <Label htmlFor="type-filter" className="text-xs">Tipo:</Label>
                <Select value={filters.type} onValueChange={(value) => setFilters({ ...filters, type: value })}>
                  <SelectTrigger className="w-28 h-8">
                    <SelectValue placeholder="Todos" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos</SelectItem>
                    <SelectItem value="income">Receita</SelectItem>
                    <SelectItem value="expense">Despesa</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Filtro por Conta */}
              <div className="flex items-center gap-2">
                <Label htmlFor="account-filter" className="text-xs">Conta:</Label>
                <Select value={filters.account} onValueChange={(value) => setFilters({ ...filters, account: value })}>
                  <SelectTrigger className="w-32 h-8">
                    <SelectValue placeholder="Todas" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todas</SelectItem>
                    <SelectItem value="Conta PJ">Conta PJ</SelectItem>
                    <SelectItem value="Conta Checkout">Conta Checkout</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Botão Limpar Filtros */}
              {(filters.month !== 'all' || filters.day !== 'all' || filters.type !== 'all' || filters.account !== 'all') && (
                <Button 
                  variant="outline" 
                  size="sm" 
                  onClick={clearFilters}
                  className="h-8"
                >
                  <X className="h-3 w-3 mr-1" />
                  Limpar
                </Button>
              )}

              {/* Contador de resultados */}
              <div className="ml-auto text-xs text-muted-foreground">
                {filteredTransactions.length} de {transactions.length} transações
              </div>
            </div>
          </div>

          <CardContent>
            {loading ? (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto mb-4"></div>
                <p className="text-muted-foreground">Carregando transações...</p>
              </div>
            ) : filteredTransactions.length === 0 ? (
              <div className="text-center py-8">
                {transactions.length === 0 ? (
                  <>
                    <DollarSign className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                    <p className="text-muted-foreground mb-4">
                      Nenhuma transação encontrada. Adicione sua primeira transação.
                    </p>
                    <Button 
                      onClick={() => {
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
                        setDialogOpen(true);
                      }}>
                      <Plus className="w-4 h-4 mr-2" />
                      Nova Transação
                    </Button>
                  </>
                ) : (
                  <>
                    <Filter className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                    <p className="text-muted-foreground mb-4">
                      Nenhuma transação encontrada com os filtros aplicados.
                    </p>
                    <Button variant="outline" onClick={clearFilters}>
                      <X className="w-4 h-4 mr-2" />
                      Limpar Filtros
                    </Button>
                  </>
                )}
              </div>
            ) : (
              <div className="space-y-4">
                {filteredTransactions.map((transaction) => (
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