import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate, useLocation } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { useDeviceInfo } from '@/hooks/use-mobile';

import { insertTransactionInCorrectTable, insertTransactionInSelectedMonthTable, updateTransactionInCorrectTable, deleteTransactionFromCorrectTable } from '@/utils/transactionInsertion';
import { getAllMonthlyTables } from '@/utils/monthlyTableUtils';
import { EnhancedCard, ActionCard } from '@/components/ui/enhanced-card';
import { EnhancedButton, GradientButton, FloatingButton } from '@/components/ui/enhanced-button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Textarea } from '@/components/ui/textarea';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { useToast } from '@/hooks/use-toast';
import { SubscriptionGuard } from '@/components/SubscriptionGuard';
import { Breadcrumbs } from '@/components/ui/breadcrumbs';
import { LoadingSpinner, SkeletonList } from '@/components/ui/loading-spinner';
import { 
  DollarSign, 
  Plus, 
  ArrowUpRight, 
  ArrowDownRight,
  Edit,
  Trash2,
  Calendar,
  Filter,
  X,
  Search,
  Download,
  Upload,
  RefreshCw,
  BarChart3,
  Users,
  CreditCard
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
  const location = useLocation();
  const { isMobile, isTablet } = useDeviceInfo();
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
    account: 'all',
    search: ''
  });

  const [filteredTransactions, setFilteredTransactions] = useState<Transaction[]>([]);
  const [selectedTransactions, setSelectedTransactions] = useState<Set<string>>(new Set());
  const [selectAll, setSelectAll] = useState(false);

  // Breadcrumbs
  const breadcrumbItems = [
    { label: 'Dashboard', href: '/dashboard' },
    { label: 'Transações', href: '/transactions' }
  ];

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

  const loadData = async () => {
    try {
      setLoading(true);
      
      // Simular carregamento de transações
      const mockTransactions: Transaction[] = [
        {
          id: '1',
          description: 'Venda #1234',
          amount: 2500,
          transaction_type: 'income',
          category: 'Vendas',
          transaction_date: '2025-01-15',
          client_name: 'Cliente A',
          account_name: 'Conta PJ'
        },
        {
          id: '2',
          description: 'Fornecedor ABC',
          amount: -1200,
          transaction_type: 'expense',
          category: 'Fornecedores',
          transaction_date: '2025-01-14',
          client_name: '',
          account_name: 'Conta Checkout'
        },
        {
          id: '3',
          description: 'Venda #1235',
          amount: 1800,
          transaction_type: 'income',
          category: 'Vendas',
          transaction_date: '2025-01-13',
          client_name: 'Cliente B',
          account_name: 'Conta PJ'
        }
      ];
      
      setTransactions(mockTransactions);
      setFilteredTransactions(mockTransactions);
    } catch (error) {
      console.error('Erro ao carregar transações:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar transações",
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
      const canAdd = await canPerformAction('transaction');
      if (!canAdd) {
        toast({
          title: "Limite Atingido",
          description: "Você atingiu o limite de transações do seu plano",
          variant: "destructive"
        });
        return;
      }

      const transactionData = {
        user_id: user.id,
        description: formData.description,
        amount: parseFloat(formData.amount),
        transaction_type: formData.transaction_type,
        category: formData.category,
        transaction_date: formData.transaction_date,
        client_name: formData.client_name || null,
        account_name: formData.account_name
      };

      const result = await insertTransactionInCorrectTable(transactionData);

      if (result.success) {
        toast({
          title: "Sucesso",
          description: "Transação criada com sucesso"
        });
        
        setDialogOpen(false);
        resetForm();
        loadData();
        
        // Incrementar uso
        await incrementUsage('transaction');
      } else {
        toast({
          title: "Erro",
          description: result.error || "Erro ao criar transação",
          variant: "destructive"
        });
      }
    } catch (error) {
      console.error('Erro ao criar transação:', error);
      toast({
        title: "Erro",
        description: "Erro ao criar transação",
        variant: "destructive"
      });
    }
  };

  const handleEdit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!editingTransaction) return;

    try {
      const updatedData = {
        user_id: user!.id,
        description: formData.description,
        amount: parseFloat(formData.amount),
        transaction_type: formData.transaction_type,
        category: formData.category,
        transaction_date: formData.transaction_date,
        client_name: formData.client_name || null,
        account_name: formData.account_name
      };

      const result = await updateTransactionInCorrectTable(
        editingTransaction.id,
        editingTransaction,
        updatedData
      );

      if (result.success) {
        toast({
          title: "Sucesso",
          description: "Transação atualizada com sucesso"
        });
        
        setDialogOpen(false);
        setEditingTransaction(null);
        resetForm();
        loadData();
      } else {
        toast({
          title: "Erro",
          description: result.error || "Erro ao atualizar transação",
          variant: "destructive"
        });
      }
    } catch (error) {
      console.error('Erro ao atualizar transação:', error);
      toast({
        title: "Erro",
        description: "Erro ao atualizar transação",
        variant: "destructive"
      });
    }
  };

  const handleDelete = async (transactionId: string, transactionDate: string) => {
    try {
      const result = await deleteTransactionFromCorrectTable(transactionId, transactionDate);

      if (result.success) {
        toast({
          title: "Sucesso",
          description: "Transação excluída com sucesso"
        });
        loadData();
      } else {
        toast({
          title: "Erro",
          description: result.error || "Erro ao excluir transação",
          variant: "destructive"
        });
      }
    } catch (error) {
      console.error('Erro ao excluir transação:', error);
      toast({
        title: "Erro",
        description: "Erro ao excluir transação",
        variant: "destructive"
      });
    }
  };

  const resetForm = () => {
    setFormData({
      description: '',
      amount: '',
      transaction_type: 'income',
      category: '',
      transaction_date: new Date().toISOString().split('T')[0],
      client_name: '',
      account_name: ''
    });
  };

  const openEditDialog = (transaction: Transaction) => {
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

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(amount);
  };

  const getTransactionIcon = (type: string) => {
    switch (type) {
      case 'income':
        return <ArrowUpRight className="w-4 h-4 text-green-600" />;
      case 'expense':
        return <ArrowDownRight className="w-4 h-4 text-red-600" />;
      case 'transfer':
        return <ArrowUpRight className="w-4 h-4 text-blue-600" />;
      default:
        return <DollarSign className="w-4 h-4" />;
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-6">
          <Breadcrumbs items={breadcrumbItems} />
          <SkeletonList items={8} />
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6 space-y-6">
        {/* Header */}
        <div className="space-y-4">
          <Breadcrumbs items={breadcrumbItems} />
          
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-2xl sm:text-3xl font-bold tracking-tight">
                Transações
              </h1>
              <p className="text-muted-foreground">
                Gerencie suas transações financeiras
              </p>
            </div>
            
            <div className="flex items-center gap-3">
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<RefreshCw className="w-4 h-4" />}
                onClick={loadData}
                loading={loading}
              >
                Atualizar
              </EnhancedButton>
              
              <SubscriptionGuard feature="transaction">
                <EnhancedButton
                  icon={<Plus className="w-4 h-4" />}
                  onClick={() => setDialogOpen(true)}
                >
                  Nova Transação
                </EnhancedButton>
              </SubscriptionGuard>
            </div>
          </div>
        </div>

        {/* Filtros */}
        <EnhancedCard
          title="Filtros"
          icon={<Filter className="w-5 h-5" />}
          variant="outlined"
        >
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="space-y-2">
              <Label htmlFor="search">Buscar</Label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                <Input
                  id="search"
                  placeholder="Buscar transações..."
                  value={filters.search}
                  onChange={(e) => setFilters({ ...filters, search: e.target.value })}
                  className="pl-10"
                />
              </div>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="type">Tipo</Label>
              <Select value={filters.type} onValueChange={(value) => setFilters({ ...filters, type: value })}>
                <SelectTrigger>
                  <SelectValue placeholder="Todos os tipos" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos</SelectItem>
                  <SelectItem value="income">Receitas</SelectItem>
                  <SelectItem value="expense">Despesas</SelectItem>
                  <SelectItem value="transfer">Transferências</SelectItem>
                </SelectContent>
              </Select>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="account">Conta</Label>
              <Select value={filters.account} onValueChange={(value) => setFilters({ ...filters, account: value })}>
                <SelectTrigger>
                  <SelectValue placeholder="Todas as contas" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas</SelectItem>
                  {accounts.map((account) => (
                    <SelectItem key={account.id} value={account.id}>
                      {account.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="month">Mês</Label>
              <Select value={filters.month} onValueChange={(value) => setFilters({ ...filters, month: value })}>
                <SelectTrigger>
                  <SelectValue placeholder="Todos os meses" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos</SelectItem>
                  <SelectItem value="01">Janeiro</SelectItem>
                  <SelectItem value="02">Fevereiro</SelectItem>
                  <SelectItem value="03">Março</SelectItem>
                  <SelectItem value="04">Abril</SelectItem>
                  <SelectItem value="05">Maio</SelectItem>
                  <SelectItem value="06">Junho</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </EnhancedCard>

        {/* Lista de Transações */}
        <EnhancedCard
          title={`Transações (${filteredTransactions.length})`}
          description="Lista de todas as transações"
          icon={<BarChart3 className="w-5 h-5" />}
        >
          {filteredTransactions.length === 0 ? (
            <div className="text-center py-12">
              <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                <DollarSign className="w-8 h-8 text-muted-foreground" />
              </div>
              <h3 className="text-lg font-medium mb-2">Nenhuma transação encontrada</h3>
              <p className="text-muted-foreground mb-6">
                Comece adicionando sua primeira transação
              </p>
              <EnhancedButton
                icon={<Plus className="w-4 h-4" />}
                onClick={() => setDialogOpen(true)}
              >
                Criar Primeira Transação
              </EnhancedButton>
            </div>
          ) : (
            <div className="space-y-3">
              {filteredTransactions.map((transaction) => (
                <div
                  key={transaction.id}
                  className="flex items-center justify-between p-4 rounded-lg border hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className="p-2 rounded-full bg-muted">
                      {getTransactionIcon(transaction.transaction_type)}
                    </div>
                    
                    <div>
                      <p className="font-medium">{transaction.description}</p>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <span>{new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}</span>
                        <span>•</span>
                        <span className="capitalize">{transaction.transaction_type}</span>
                        {transaction.category && (
                          <>
                            <span>•</span>
                            <span>{transaction.category}</span>
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center gap-2">
                    <div className="text-right">
                      <p className={`font-bold ${
                        transaction.transaction_type === 'income' 
                          ? 'text-green-600' 
                          : 'text-red-600'
                      }`}>
                        {transaction.transaction_type === 'income' ? '+' : '-'}
                        {formatCurrency(Math.abs(transaction.amount))}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {transaction.account_name}
                      </p>
                    </div>
                    
                    <div className="flex items-center gap-1">
                      <EnhancedButton
                        variant="ghost"
                        size="sm"
                        icon={<Edit className="w-4 h-4" />}
                        onClick={() => openEditDialog(transaction)}
                      />
                      <EnhancedButton
                        variant="ghost"
                        size="sm"
                        icon={<Trash2 className="w-4 h-4" />}
                        onClick={() => handleDelete(transaction.id, transaction.transaction_date)}
                      />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </EnhancedCard>

        {/* Botão Flutuante */}
        <FloatingButton
          icon={<Plus className="w-6 h-6" />}
          onClick={() => setDialogOpen(true)}
          variant="primary"
          size="lg"
        />

        {/* Dialog para Criar/Editar Transação */}
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle>
                {editingTransaction ? 'Editar Transação' : 'Nova Transação'}
              </DialogTitle>
              <DialogDescription>
                {editingTransaction 
                  ? 'Edite os dados da transação abaixo'
                  : 'Preencha os dados da nova transação'
                }
              </DialogDescription>
            </DialogHeader>
            
            <form onSubmit={editingTransaction ? handleEdit : handleSubmit} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="description">Descrição</Label>
                <Input
                  id="description"
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  placeholder="Descrição da transação"
                  required
                />
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="amount">Valor</Label>
                <Input
                  id="amount"
                  type="number"
                  step="0.01"
                  value={formData.amount}
                  onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
                  placeholder="0,00"
                  required
                />
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="type">Tipo</Label>
                  <Select 
                    value={formData.transaction_type} 
                    onValueChange={(value: 'income' | 'expense' | 'transfer') => 
                      setFormData({ ...formData, transaction_type: value })
                    }
                  >
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
                
                <div className="space-y-2">
                  <Label htmlFor="account">Conta</Label>
                  <Select 
                    value={formData.account_name} 
                    onValueChange={(value) => setFormData({ ...formData, account_name: value })}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Selecione a conta" />
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
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="date">Data</Label>
                  <Input
                    id="date"
                    type="date"
                    value={formData.transaction_date}
                    onChange={(e) => setFormData({ ...formData, transaction_date: e.target.value })}
                    required
                  />
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="category">Categoria</Label>
                  <Input
                    id="category"
                    value={formData.category}
                    onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                    placeholder="Categoria"
                  />
                </div>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="client">Cliente (opcional)</Label>
                <Input
                  id="client"
                  value={formData.client_name}
                  onChange={(e) => setFormData({ ...formData, client_name: e.target.value })}
                  placeholder="Nome do cliente"
                />
              </div>
              
              <div className="flex justify-end gap-3 pt-4">
                <EnhancedButton
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setDialogOpen(false);
                    setEditingTransaction(null);
                    resetForm();
                  }}
                >
                  Cancelar
                </EnhancedButton>
                <EnhancedButton type="submit">
                  {editingTransaction ? 'Atualizar' : 'Criar'} Transação
                </EnhancedButton>
              </div>
            </form>
          </DialogContent>
        </Dialog>
      </div>
    </div>
  );
}