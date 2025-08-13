import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { testDatabasePermissions, testClientIdNull } from '@/utils/testAuth';
import { insertTransactionInCorrectTable, insertTransactionInSelectedMonthTable, updateTransactionInCorrectTable, deleteTransactionFromCorrectTable } from '@/utils/transactionInsertion';
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
  const [selectedTransactions, setSelectedTransactions] = useState<Set<string>>(new Set());
  const [selectAll, setSelectAll] = useState(false);

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
      // SOLUÇÃO DEFINITIVA: COMPENSAÇÃO CORRETA DE TIMEZONE
      
      // 1. Data original do modal
      const dataOriginal = formData.transaction_date;
      console.log('🔍 DEBUG TIMEZONE:');
      console.log('📅 Data original do modal:', dataOriginal);
      
      // 2. LÓGICA CORRETA: Compensação de 1 dia
      const [ano, mes, dia] = dataOriginal.split('-');
      console.log('📊 Componentes:', { ano, mes, dia });
      
      // Criar data no meio-dia para evitar problemas de timezone
      const dataOriginalObj = new Date(parseInt(ano), parseInt(mes) - 1, parseInt(dia), 12, 0, 0);
      console.log('📅 Data original (Date):', dataOriginalObj);
      console.log('📅 Data original (ISO):', dataOriginalObj.toISOString());
      
      // COMPENSAÇÃO CORRETA: Adicionar 1 dia
      const dataCompensada = new Date(dataOriginalObj);
      dataCompensada.setDate(dataCompensada.getDate() + 1);
      console.log('📅 Data compensada +1 dia (Date):', dataCompensada);
      console.log('📅 Data compensada +1 dia (ISO):', dataCompensada.toISOString());
      
      // Formatar como YYYY-MM-DD
      const dataCorrigida = dataCompensada.toISOString().split('T')[0];
      console.log('📅 Data corrigida (YYYY-MM-DD):', dataCorrigida);
      
      // 3. Dados da transação
      const transactionData = {
        user_id: user.id,
        description: formData.description || '',
        amount: parseFloat(formData.amount),
        transaction_type: formData.transaction_type,
        category: formData.category || '',
        transaction_date: dataCorrigida, // DATA COMPENSADA +1 DIA
        account_name: formData.account_name,
        client_name: formData.client_name || null
      };
      
      console.log('📤 Dados sendo enviados:', transactionData);
      
      // 4. Verificar se é edição ou criação
      if (editingTransaction) {
        console.log('🔄 MODE: EDITANDO TRANSAÇÃO');
        console.log('📝 ID da transação sendo editada:', editingTransaction.id);
        console.log('📅 Data original:', editingTransaction.transaction_date);
        console.log('📅 Nova data:', dataCorrigida);
        
        // LÓGICA SIMPLES: Excluir anterior e criar nova
        try {
          // 1. Primeiro, excluir transação anterior
          console.log('🗑️ Excluindo transação anterior...');
          console.log('📝 ID da transação a ser excluída:', editingTransaction.id);
          
          const { data: deleteResult, error: deleteError } = await supabase
            .from('transactions_2025_08')
            .delete()
            .eq('id', editingTransaction.id)
            .select();
          
          if (deleteError) {
            console.error('❌ Erro ao excluir transação anterior:', deleteError);
            throw new Error(`Erro ao excluir transação anterior: ${deleteError.message}`);
          }
          
          console.log('🗑️ Resultado da exclusão:', deleteResult);
          
          // Verificar se realmente foi excluída
          if (!deleteResult || deleteResult.length === 0) {
            console.error('❌ Transação não foi excluída - nenhuma linha afetada');
            throw new Error('Transação não foi excluída - verifique se o ID está correto');
          }
          
          console.log('✅ Transação anterior excluída com sucesso');
          
          // 2. Depois, criar nova transação
          console.log('📤 Criando nova transação...');
          const { data: newTransaction, error: insertError } = await supabase
            .from('transactions_2025_08') // Por enquanto fixo em agosto
            .insert([transactionData])
            .select()
            .single();
          
          if (insertError) {
            console.error('❌ Erro ao criar nova transação:', insertError);
            throw new Error(`Erro ao criar nova transação: ${insertError.message}`);
          }
          
          console.log('✅ Nova transação criada:', newTransaction);
          
          // 3. Verificar se não há duplicatas
          console.log('🔍 Verificando se não há duplicatas...');
          const { data: checkResult, error: checkError } = await supabase
            .from('transactions_2025_08')
            .select('id, description, transaction_date, amount')
            .eq('user_id', user.id)
            .eq('description', transactionData.description)
            .eq('amount', transactionData.amount);
          
          if (checkError) {
            console.error('❌ Erro ao verificar duplicatas:', checkError);
          } else {
            console.log('🔍 Transações encontradas com mesmo descrição/valor:', checkResult);
            if (checkResult && checkResult.length > 1) {
              console.warn('⚠️ ATENÇÃO: Possível duplicação detectada!');
            }
          }
          
          console.log('✅ Edição concluída com sucesso!');
          
          const date = new Date(formData.transaction_date);
          const monthNames = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
          const monthName = monthNames[date.getMonth()];
          
          toast({
            title: "✅ Transação atualizada!",
            description: `${monthName} ${date.getFullYear()} | Nova data: ${formData.transaction_date}`,
            duration: 3000,
          });
          
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
          return;
          
        } catch (error: any) {
          console.error('❌ Erro na edição:', error);
          throw new Error(error.message || 'Erro ao editar transação');
        }
      } else {
        console.log('🆕 MODE: CRIANDO NOVA TRANSAÇÃO');
        
        // 4. Inserir na tabela correta usando a data da transação
        const result = await insertTransactionInCorrectTable(transactionData);

        if (!result.success) {
          console.error('❌ Erro na inserção inteligente:', result.error);
          throw new Error(result.error || 'Erro ao inserir transação');
        }

        console.log('✅ Transação inserida com sucesso na tabela:', result.tableName);
        console.log('✅ Dados inseridos:', result.data);
        
        // 5. Verificar o que foi salvo
        if (result.data && result.data[0]) {
          const transacaoSalva = result.data[0];
          console.log('💾 Transação salva:', transacaoSalva);
          console.log('📅 Data salva no banco:', transacaoSalva.transaction_date);
          console.log('📊 Tabela utilizada:', result.tableName);
          
          // Verificar se a data salva é a correta
          const dataSalva = new Date(transacaoSalva.transaction_date);
          const dataEsperada = new Date(dataOriginal);
          
          console.log('📅 Data esperada:', dataEsperada.toISOString().split('T')[0]);
          console.log('📅 Data realmente salva:', dataSalva.toISOString().split('T')[0]);
          console.log('✅ Datas coincidem?', dataEsperada.toISOString().split('T')[0] === dataSalva.toISOString().split('T')[0]);
        }

        const date = new Date(formData.transaction_date);
        const monthNames = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
        const monthName = monthNames[date.getMonth()];
        
        toast({
          title: "✅ Transação criada!",
          description: `${monthName} ${date.getFullYear()} | Tabela: ${result.tableName}`,
          duration: 3000,
        });

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
      }
      
    } catch (error: any) {
      console.error('❌ Erro completo:', error);
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

  // Funções para seleção múltipla
  const handleSelectTransaction = (id: string) => {
    const newSelected = new Set(selectedTransactions);
    if (newSelected.has(id)) {
      newSelected.delete(id);
    } else {
      newSelected.add(id);
    }
    setSelectedTransactions(newSelected);
    setSelectAll(newSelected.size === filteredTransactions.length);
  };

  const handleSelectAll = () => {
    if (selectAll) {
      setSelectedTransactions(new Set());
      setSelectAll(false);
    } else {
      const allIds = filteredTransactions.map(t => t.id);
      setSelectedTransactions(new Set(allIds));
      setSelectAll(true);
    }
  };

  const handleDeleteSelected = async () => {
    if (selectedTransactions.size === 0) {
      toast({
        title: "Aviso",
        description: "Nenhuma transação selecionada para excluir",
        variant: "destructive"
      });
      return;
    }

    const count = selectedTransactions.size;
    const confirmMessage = count === 1 
      ? 'Tem certeza que deseja excluir esta transação?' 
      : `Tem certeza que deseja excluir ${count} transações?`;

    if (!confirm(confirmMessage)) return;

    try {
      let successCount = 0;
      let errorCount = 0;

      for (const id of selectedTransactions) {
        try {
          // Encontrar a transação para obter a data
          const transactionToDelete = transactions.find(t => t.id === id);
          
          if (!transactionToDelete) {
            console.error(`Transação ${id} não encontrada`);
            errorCount++;
            continue;
          }

          // Usar remoção inteligente da tabela correta
          const result = await deleteTransactionFromCorrectTable(
            id, 
            transactionToDelete.transaction_date
          );

          if (result.success) {
            successCount++;
          } else {
            console.error(`Erro ao excluir transação ${id}:`, result.error);
            errorCount++;
          }
        } catch (error: any) {
          console.error(`Erro ao excluir transação ${id}:`, error);
          errorCount++;
        }
      }

      // Limpar seleção
      setSelectedTransactions(new Set());
      setSelectAll(false);

      // Mostrar resultado
      if (successCount > 0) {
        toast({
          title: "Sucesso",
          description: `${successCount} transação(ões) excluída(s) com sucesso${errorCount > 0 ? `, ${errorCount} erro(s)` : ''}`
        });
      } else {
        toast({
          title: "Erro",
          description: `Nenhuma transação foi excluída. ${errorCount} erro(s) encontrado(s).`,
          variant: "destructive"
        });
      }

      loadData();
    } catch (error: any) {
      console.error('Erro na exclusão em lote:', error);
      toast({
        title: "Erro",
        description: "Erro inesperado ao excluir transações",
        variant: "destructive"
      });
    }
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
      <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/50 shadow-sm">
        <div className="container mx-auto px-4 py-4">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
            <div className="flex items-center space-x-4">
              <Button 
                variant="ghost" 
                onClick={() => navigate('/dashboard')}
                className="hover:bg-slate-100 transition-colors"
              >
                ← Dashboard
              </Button>
              <div>
                <h1 className="text-2xl font-bold text-slate-800">Transações</h1>
                <p className="text-sm text-slate-600">{transactions.length} transações encontradas</p>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <div className="hidden md:flex items-center space-x-4 text-sm">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  <span className="text-green-600 font-medium">
                    {transactions.filter(t => t.transaction_type === 'income').length} Receitas
                  </span>
                </div>
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  <span className="text-red-600 font-medium">
                    {transactions.filter(t => t.transaction_type === 'expense').length} Despesas
                  </span>
                </div>
              </div>
              
              <Button 
                variant="outline" 
                size="sm" 
                onClick={runAuthTests}
                className="hidden sm:flex"
              >
                🧪 Testar Auth
              </Button>
              
              <SubscriptionGuard feature="transaction">
                <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
                  <DialogTrigger asChild>
                    <Button 
                      onClick={() => {
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
                      }}
                      className="bg-blue-600 hover:bg-blue-700 text-white transition-colors"
                    >
                      <Plus className="w-4 h-4 mr-2" />
                      Nova Transação
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="sm:max-w-[600px] max-h-[90vh] overflow-y-auto">
              <DialogHeader className="pb-4">
                <DialogTitle className="text-xl font-semibold text-slate-800">
                  {editingTransaction ? 'Editar Transação' : 'Nova Transação'}
                </DialogTitle>
                <DialogDescription className="text-slate-600">
                  {editingTransaction ? 'Atualize os dados da transação' : 'Adicione uma nova movimentação financeira'}
                </DialogDescription>
              </DialogHeader>
              
              <form onSubmit={handleSubmit} className="space-y-6">
                {/* Seção: Informações Básicas */}
                <div className="space-y-4">
                  <h3 className="text-lg font-medium text-slate-800 border-b pb-2">Informações Básicas</h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="description" className="text-sm font-medium">Descrição</Label>
                      <Input
                        id="description"
                        placeholder="Ex: Venda de produto X"
                        value={formData.description}
                        onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                        className="focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="amount" className="text-sm font-medium">Valor</Label>
                      <Input
                        id="amount"
                        type="number"
                        step="0.01"
                        placeholder="0,00"
                        value={formData.amount}
                        onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
                        className="focus:ring-2 focus:ring-blue-500"
                        required
                      />
                    </div>
                  </div>
                </div>
                
                {/* Seção: Classificação */}
                <div className="space-y-4">
                  <h3 className="text-lg font-medium text-slate-800 border-b pb-2">Classificação</h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="transaction_type" className="text-sm font-medium">Tipo</Label>
                      <Select value={formData.transaction_type} onValueChange={(value: any) => setFormData({ ...formData, transaction_type: value })}>
                        <SelectTrigger className="focus:ring-2 focus:ring-blue-500">
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
                      <Label htmlFor="category" className="text-sm font-medium">Categoria</Label>
                      <Input
                        id="category"
                        placeholder="Ex: Vendas, Marketing"
                        value={formData.category}
                        onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                        className="focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="account_name" className="text-sm font-medium">Conta</Label>
                      <Select 
                        value={formData.account_name || undefined} 
                        onValueChange={(value) => setFormData({ ...formData, account_name: value })}
                      >
                        <SelectTrigger className="focus:ring-2 focus:ring-blue-500">
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
                  </div>
                </div>
                
                {/* Seção: Detalhes */}
                <div className="space-y-4">
                  <h3 className="text-lg font-medium text-slate-800 border-b pb-2">Detalhes</h3>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="client_name" className="text-sm font-medium">Cliente (Opcional)</Label>
                      <Input
                        id="client_name"
                        placeholder="Nome do cliente"
                        value={formData.client_name}
                        onChange={(e) => setFormData({ ...formData, client_name: e.target.value })}
                        className="focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="transaction_date" className="text-sm font-medium">Data</Label>
                      <Input
                        id="transaction_date"
                        type="date"
                        value={formData.transaction_date}
                        onChange={(e) => {
                          console.log('📅 DATA ALTERADA:', e.target.value);
                          console.log('Data anterior:', formData.transaction_date);
                          setFormData({ ...formData, transaction_date: e.target.value });
                        }}
                        className="focus:ring-2 focus:ring-blue-500"
                        required
                      />
                    </div>
                  </div>
                  
                  {/* Informação da tabela */}
                  <div className="space-y-2">
                    <Label className="text-sm font-medium">Mês da Transação</Label>
                    <div className="text-sm text-slate-600 bg-slate-50 p-3 rounded-lg border border-slate-200">
                      {(() => {
                        const date = new Date(formData.transaction_date);
                        const monthNames = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
                        const monthName = monthNames[date.getMonth()];
                        const year = date.getFullYear();
                        return `Tabela: transactions_${year}_${String(date.getMonth() + 1).padStart(2, '0')} (${monthName} ${year})`;
                      })()}
                    </div>
                  </div>
                </div>
                
                {/* Botões de Ação */}
                <div className="flex justify-end space-x-3 pt-4 border-t">
                  <Button 
                    type="button" 
                    variant="outline" 
                    onClick={() => setDialogOpen(false)}
                    className="hover:bg-slate-50"
                  >
                    Cancelar
                  </Button>
                  <Button 
                    type="submit"
                    className="bg-blue-600 hover:bg-blue-700 transition-colors"
                    onClick={() => {
                      console.log('🔘 BOTÃO SUBMIT CLICADO');
                      console.log('FormData atual:', formData);
                      console.log('Data atual:', formData.transaction_date);
                    }}
                  >
                    {editingTransaction ? 'Atualizar Transação' : 'Criar Transação'}
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
        <Card className="shadow-sm border-0 bg-gradient-to-br from-white to-slate-50/50">
          <CardHeader className="pb-4">
            <CardTitle className="text-xl font-semibold text-slate-800 flex items-center gap-2">
              <DollarSign className="h-5 w-5 text-blue-600" />
              Lista de Transações
            </CardTitle>
            <CardDescription className="text-slate-600">
              Gerencie todas as suas movimentações financeiras
            </CardDescription>
          </CardHeader>
          
          {/* Filtros e Seleção Múltipla */}
          <div className="px-6 pb-6">
            {/* Filtros em Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
              <Card className="p-4 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
                <Label className="text-sm font-medium mb-2 text-slate-700">Mês</Label>
                <Select value={filters.month} onValueChange={(value) => setFilters({ ...filters, month: value })}>
                  <SelectTrigger className="w-full focus:ring-2 focus:ring-blue-500">
                    <SelectValue placeholder="Todos os meses" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os meses</SelectItem>
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
              </Card>

              <Card className="p-4 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
                <Label className="text-sm font-medium mb-2 text-slate-700">Tipo</Label>
                <Select value={filters.type} onValueChange={(value) => setFilters({ ...filters, type: value })}>
                  <SelectTrigger className="w-full focus:ring-2 focus:ring-blue-500">
                    <SelectValue placeholder="Todos os tipos" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os tipos</SelectItem>
                    <SelectItem value="income">Receitas</SelectItem>
                    <SelectItem value="expense">Despesas</SelectItem>
                  </SelectContent>
                </Select>
              </Card>

              <Card className="p-4 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
                <Label className="text-sm font-medium mb-2 text-slate-700">Conta</Label>
                <Select value={filters.account} onValueChange={(value) => setFilters({ ...filters, account: value })}>
                  <SelectTrigger className="w-full focus:ring-2 focus:ring-blue-500">
                    <SelectValue placeholder="Todas as contas" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todas as contas</SelectItem>
                    <SelectItem value="Conta PJ">Conta PJ</SelectItem>
                    <SelectItem value="Conta Checkout">Conta Checkout</SelectItem>
                  </SelectContent>
                </Select>
              </Card>

              <Card className="p-4 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
                <Label className="text-sm font-medium mb-2 text-slate-700">Dia</Label>
                <Select value={filters.day} onValueChange={(value) => setFilters({ ...filters, day: value })}>
                  <SelectTrigger className="w-full focus:ring-2 focus:ring-blue-500">
                    <SelectValue placeholder="Todos os dias" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Todos os dias</SelectItem>
                    {Array.from({ length: 31 }, (_, i) => i + 1).map(day => (
                      <SelectItem key={day} value={day.toString()}>{day}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </Card>
            </div>

            {/* Controles de Filtro */}
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-4">
                <div className="flex items-center gap-2">
                  <Filter className="h-4 w-4 text-slate-600" />
                  <span className="text-sm font-medium text-slate-700">Filtros Ativos:</span>
                </div>
                
                {/* Botão Limpar Filtros */}
                {(filters.month !== 'all' || filters.day !== 'all' || filters.type !== 'all' || filters.account !== 'all') && (
                  <Button 
                    variant="outline" 
                    size="sm" 
                    onClick={clearFilters}
                    className="hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition-colors"
                  >
                    <X className="h-3 w-3 mr-1" />
                    Limpar Filtros
                  </Button>
                )}
              </div>

              {/* Contador de resultados */}
              <div className="text-sm text-slate-600 font-medium">
                {filteredTransactions.length} de {transactions.length} transações
              </div>
            </div>
            
            {/* Controles de Seleção Múltipla */}
            {selectedTransactions.size > 0 && (
              <div className="flex items-center gap-2 mt-4 p-4 bg-blue-50 rounded-xl border border-blue-200 shadow-sm">
                <div className="flex items-center gap-3">
                  <input
                    type="checkbox"
                    checked={selectAll}
                    onChange={handleSelectAll}
                    className="w-5 h-5 text-blue-600 bg-white border-blue-300 rounded focus:ring-blue-500 focus:ring-2"
                  />
                  <span className="text-sm font-semibold text-blue-800">
                    {selectedTransactions.size} transação(ões) selecionada(s)
                  </span>
                </div>
                <Button
                  variant="destructive"
                  size="sm"
                  onClick={handleDeleteSelected}
                  className="ml-auto bg-red-600 hover:bg-red-700 transition-colors"
                >
                  <Trash2 className="w-4 h-4 mr-2" />
                  Excluir Selecionadas
                </Button>
              </div>
            )}
          </div>

          <CardContent>
            {/* Cabeçalho com Seleção Múltipla */}
            {filteredTransactions.length > 0 && (
              <div className="flex items-center gap-3 mb-4 p-4 bg-slate-50 rounded-xl border border-slate-200">
                <input
                  type="checkbox"
                  checked={selectAll}
                  onChange={handleSelectAll}
                  className="w-5 h-5 text-blue-600 bg-white border-slate-300 rounded focus:ring-blue-500 focus:ring-2"
                />
                <span className="text-sm font-medium text-slate-700">
                  {selectAll ? 'Desmarcar Todas' : 'Selecionar Todas'}
                </span>
                {selectedTransactions.size > 0 && (
                  <span className="text-sm text-blue-600 font-medium ml-auto">
                    {selectedTransactions.size} selecionada(s)
                  </span>
                )}
              </div>
            )}
            
            {loading ? (
              <div className="space-y-4">
                {Array.from({ length: 5 }).map((_, i) => (
                  <div key={i} className="animate-pulse">
                    <div className="flex items-center space-x-4 p-4 bg-slate-100 rounded-lg">
                      <div className="w-5 h-5 bg-slate-200 rounded"></div>
                      <div className="w-12 h-12 bg-slate-200 rounded-full"></div>
                      <div className="flex-1 space-y-2">
                        <div className="h-4 bg-slate-200 rounded w-3/4"></div>
                        <div className="h-3 bg-slate-200 rounded w-1/2"></div>
                      </div>
                      <div className="w-24 h-6 bg-slate-200 rounded"></div>
                    </div>
                  </div>
                ))}
              </div>
            ) : filteredTransactions.length === 0 ? (
              <div className="text-center py-12">
                {transactions.length === 0 ? (
                  <>
                    <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <DollarSign className="h-8 w-8 text-slate-400" />
                    </div>
                    <h3 className="text-lg font-semibold text-slate-800 mb-2">
                      Nenhuma transação encontrada
                    </h3>
                    <p className="text-slate-600 mb-6 max-w-md mx-auto">
                      Comece adicionando sua primeira transação para gerenciar suas movimentações financeiras
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
                      }}
                      className="bg-blue-600 hover:bg-blue-700 transition-colors"
                    >
                      <Plus className="w-4 h-4 mr-2" />
                      Nova Transação
                    </Button>
                  </>
                ) : (
                  <>
                    <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <Filter className="h-8 w-8 text-slate-400" />
                    </div>
                    <h3 className="text-lg font-semibold text-slate-800 mb-2">
                      Nenhuma transação encontrada
                    </h3>
                    <p className="text-slate-600 mb-6 max-w-md mx-auto">
                      Nenhuma transação corresponde aos filtros aplicados. Tente ajustar os critérios de busca.
                    </p>
                    <Button 
                      variant="outline" 
                      onClick={clearFilters}
                      className="hover:bg-slate-50"
                    >
                      <X className="w-4 h-4 mr-2" />
                      Limpar Filtros
                    </Button>
                  </>
                )}
              </div>
            ) : (
              <div className="space-y-3">
                {filteredTransactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className={`group hover:shadow-lg transition-all duration-300 bg-gradient-to-r from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.01] rounded-xl p-4 ${
                      selectedTransactions.has(transaction.id) 
                        ? 'bg-blue-50 border-blue-200 ring-2 ring-blue-200' 
                        : 'border-slate-200 hover:border-slate-300'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-4">
                        {/* Checkbox de seleção */}
                        <input
                          type="checkbox"
                          checked={selectedTransactions.has(transaction.id)}
                          onChange={() => handleSelectTransaction(transaction.id)}
                          className="w-5 h-5 text-blue-600 bg-white border-slate-300 rounded focus:ring-blue-500 focus:ring-2"
                        />
                        
                        {/* Ícone da transação */}
                        <div className={`p-3 rounded-full transition-colors ${
                          transaction.transaction_type === 'income' 
                            ? 'bg-green-100 group-hover:bg-green-200' 
                            : transaction.transaction_type === 'expense'
                            ? 'bg-red-100 group-hover:bg-red-200'
                            : 'bg-blue-100 group-hover:bg-blue-200'
                        }`}>
                          {transaction.transaction_type === 'income' ? (
                            <ArrowUpRight className="h-5 w-5 text-green-600" />
                          ) : transaction.transaction_type === 'expense' ? (
                            <ArrowDownRight className="h-5 w-5 text-red-600" />
                          ) : (
                            <Calendar className="h-5 w-5 text-blue-600" />
                          )}
                        </div>
                        
                        {/* Informações da transação */}
                        <div>
                          <h3 className="font-semibold text-slate-800 group-hover:text-slate-900 transition-colors">
                            {transaction.description || 'Sem descrição'}
                          </h3>
                          <div className="flex items-center space-x-2 mt-1">
                            <span className="text-sm text-slate-500">{transaction.client_name || 'Sem cliente'}</span>
                            <span className="text-xs text-slate-400">•</span>
                            <span className="text-sm text-slate-500">{transaction.account_name}</span>
                            <span className="text-xs text-slate-400">•</span>
                            <span className="text-sm text-slate-500">
                              {new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}
                            </span>
                            {transaction.category && (
                              <>
                                <span className="text-xs text-slate-400">•</span>
                                <span className="text-sm text-slate-500">{transaction.category}</span>
                              </>
                            )}
                          </div>
                        </div>
                      </div>
                      
                      {/* Valor e ações */}
                      <div className="flex items-center space-x-4">
                        <div className={`text-xl font-bold ${
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
                            className="hover:bg-blue-50 hover:text-blue-600 transition-colors"
                          >
                            <Edit className="w-4 h-4" />
                          </Button>
                          <Button
                            size="sm"
                            variant="ghost"
                            onClick={() => handleDelete(transaction.id)}
                            className="hover:bg-red-50 hover:text-red-600 transition-colors"
                          >
                            <Trash2 className="w-4 h-4" />
                          </Button>
                        </div>
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