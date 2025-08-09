import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { 
  DollarSign, 
  TrendingUp, 
  TrendingDown, 
  Users, 
  CreditCard,
  ArrowUpRight,
  ArrowDownRight,
  Plus
} from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar, Area } from 'recharts';

interface FinancialData {
  totalIncome: number;
  totalExpenses: number;
  balancePJ: number;
  balanceCheckout: number;
  clientsCount: number;
  recentTransactions: any[];
  monthlyRevenue: Array<{ month: string; revenue: number }>;
}

export default function Dashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const [financialData, setFinancialData] = useState<FinancialData>({
    totalIncome: 0,
    totalExpenses: 0,
    balancePJ: 0,
    balanceCheckout: 0,
    clientsCount: 0,
    recentTransactions: [],
    monthlyRevenue: []
  });
  const [loading, setLoading] = useState(true);
  const [lastUpdate, setLastUpdate] = useState<Date>(new Date());
  const [debugInfo, setDebugInfo] = useState<string>('');

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    console.log('=== DASHBOARD MOUNTED ===');
    console.log('User:', user.email);
    loadFinancialData();
  }, [user, navigate]);

  // Forçar atualização a cada 30 segundos
  useEffect(() => {
    if (!user) return;
    
    const interval = setInterval(() => {
      console.log('=== ATUALIZAÇÃO AUTOMÁTICA ===');
      loadFinancialData();
    }, 30000); // 30 segundos
    
    return () => clearInterval(interval);
  }, [user]);

  const loadFinancialData = async () => {
    if (!user) return;

    try {
      console.log('=== CARREGANDO DADOS FINANCEIROS (VERSÃO AGRESSIVA) ===');
      console.log('User ID:', user.id);
      console.log('Timestamp:', new Date().toISOString());
      
      let debugLog = '=== DEBUG LOG ===\n';
      
      // CARREGAR DADOS DAS TABELAS MENSAIS ESPECÍFICAS
      console.log('=== CARREGANDO DAS TABELAS MENSAIS ===');
      
      // Definir tabelas mensais e seus nomes
      const monthlyTables = [
        { table: 'transactions_2025_01', month: 'Jan', monthNum: 1 },
        { table: 'transactions_2025_02', month: 'Fev', monthNum: 2 },
        { table: 'transactions_2025_03', month: 'Mar', monthNum: 3 },
        { table: 'transactions_2025_04', month: 'Abr', monthNum: 4 },
        { table: 'transactions_2025_05', month: 'Mai', monthNum: 5 },
        { table: 'transactions_2025_06', month: 'Jun', monthNum: 6 },
        { table: 'transactions_2025_07', month: 'Jul', monthNum: 7 },
        { table: 'transactions_2025_08', month: 'Ago', monthNum: 8 },
        { table: 'transactions_2025_09', month: 'Set', monthNum: 9 },
        { table: 'transactions_2025_10', month: 'Out', monthNum: 10 },
        { table: 'transactions_2025_11', month: 'Nov', monthNum: 11 },
        { table: 'transactions_2025_12', month: 'Dez', monthNum: 12 }
      ];

      let allTransactionsData: any[] = [];
      let incomeOnlyData: any[] = [];
      let monthlyRevenue: Array<{ month: string; revenue: number }> = [];
      let totalIncome = 0;
      let totalExpenses = 0;

      // Carregar dados de cada tabela mensal
      for (const monthInfo of monthlyTables) {
        try {
          console.log(`Carregando dados de ${monthInfo.month} (${monthInfo.table})...`);
          
          // Buscar todos os dados do mês
          const { data: monthData, error: monthError } = await supabase
            .from(monthInfo.table)
            .select('*')
            .eq('user_id', user.id);

          if (monthError) {
            console.warn(`Erro ao carregar ${monthInfo.month}:`, monthError);
            debugLog += `${monthInfo.month}: ERRO - ${monthError.message}\n`;
            
            // Adicionar mês com valor zero se houve erro
            monthlyRevenue.push({
              month: monthInfo.month,
              revenue: 0
            });
            continue;
          }

          const monthTransactions = monthData || [];
          
          // Separar receitas e despesas
          const monthIncome = monthTransactions.filter(t => t.transaction_type === 'income');
          const monthExpenses = monthTransactions.filter(t => t.transaction_type === 'expense');
          
          // Calcular totais do mês
          const monthIncomeTotal = monthIncome.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthExpensesTotal = monthExpenses.reduce((sum, t) => sum + Number(t.amount), 0);
          
          // Acumular totais gerais
          totalIncome += monthIncomeTotal;
          totalExpenses += monthExpensesTotal;
          
          // Adicionar transações aos arrays gerais
          allTransactionsData = [...allTransactionsData, ...monthTransactions];
          incomeOnlyData = [...incomeOnlyData, ...monthIncome];
          
          // Adicionar dados mensais para gráfico
          monthlyRevenue.push({
            month: monthInfo.month,
            revenue: monthIncomeTotal
          });
          
          debugLog += `${monthInfo.month}: ${monthTransactions.length} transações, R$ ${monthIncomeTotal.toFixed(2)}\n`;
          
        } catch (error) {
          console.error(`Erro ao carregar ${monthInfo.month}:`, error);
          debugLog += `${monthInfo.month}: ERRO DE CONSULTA - ${error}\n`;
          
          // Adicionar mês com valor zero em caso de erro
          monthlyRevenue.push({
            month: monthInfo.month,
            revenue: 0
          });
        }
      }

      // Buscar transações recentes da tabela principal (fallback para novas transações)
      const { data: recentData, error: recentError } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(5);

      debugLog += `Transações recentes (tabela principal): ${recentData?.length || 0} registros\n`;
      debugLog += `Erro transações recentes: ${recentError?.message || 'Nenhum'}\n`;

      // DEBUG: Verificar dados carregados das tabelas mensais
      console.log('=== DEBUG TABELAS MENSAIS ===');
      console.log('Recent error:', recentError);
      console.log('Total all transactions loaded:', allTransactionsData.length);
      console.log('Total income transactions loaded:', incomeOnlyData.length);
      console.log('Total recent transactions loaded:', recentData?.length || 0);
      console.log('Monthly revenue data:', monthlyRevenue);
      console.log('Sample transactions:', allTransactionsData.slice(0, 5));
      
      // Verificar transações de abril especificamente
      const abrilTransactions = allTransactionsData.filter(t => 
        t.transaction_date?.startsWith('2025-04')
      );
      console.log('Abril transactions found:', abrilTransactions.length);
      console.log('Abril transactions sample:', abrilTransactions.slice(0, 3));

      // Get clients count (otimizado)
      const { data: clientsData } = await supabase
        .from('clients')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Usar totais já calculados das tabelas mensais
      console.log('=== TOTAIS DAS TABELAS MENSAIS ===');
      console.log('Income transactions count:', incomeOnlyData.length);
      console.log('All transactions count:', allTransactionsData.length);
      console.log('Total income calculated:', totalIncome);
      console.log('Total expenses calculated:', totalExpenses);

      // Calculate balance by account
      const balancePJ = totalIncome;
      const balanceCheckout = 0; // Simplified since we don't have account separation

      // Usar dados mensais já calculados das tabelas específicas
      console.log('=== DADOS MENSAIS FINAIS ===');
      console.log('Monthly revenue final:', monthlyRevenue);
      
      // Adicionar log dos totais finais
      debugLog += `\nTOTAIS FINAIS:\n`;
      debugLog += `Receitas: R$ ${totalIncome.toFixed(2)}\n`;
      debugLog += `Despesas: R$ ${totalExpenses.toFixed(2)}\n`;
      debugLog += `Transações totais: ${allTransactionsData.length}\n`;
      debugLog += `Receitas por mês:\n`;
      monthlyRevenue.forEach(month => {
        debugLog += `  ${month.month}: R$ ${month.revenue.toFixed(2)}\n`;
      });

      const newFinancialData = {
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        clientsCount: clientsData?.length || 0,
        recentTransactions: recentData || [],
        monthlyRevenue
      };
      
      console.log('=== ATUALIZANDO ESTADO AGRESSIVO ===');
      console.log('New financial data:', newFinancialData);
      console.log('Total income in state:', newFinancialData.totalIncome);
      console.log('Recent transactions count:', newFinancialData.recentTransactions.length);
      
      setFinancialData(newFinancialData);
      setLastUpdate(new Date());
      setDebugInfo(debugLog);
    } catch (error) {
      console.error('Error loading financial data:', error);
      setDebugInfo(`ERRO: ${error}`);
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
        <div className="container mx-auto px-4 py-4 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center space-x-3">
            <div className="w-8 h-8 sm:w-10 sm:h-10 bg-gradient-primary rounded-lg flex items-center justify-center">
              <DollarSign className="w-4 h-4 sm:w-5 sm:h-5 text-primary-foreground" />
            </div>
            <h1 className="text-lg sm:text-2xl font-bold">FinanceiroLogotiq</h1>
          </div>
          <div className="flex flex-col sm:flex-row items-center space-y-2 sm:space-y-0 sm:space-x-4">
            <span className="text-xs sm:text-sm text-muted-foreground text-center">
              Bem-vindo, {user?.email}
            </span>
            <div className="flex items-center space-x-2">
              <Button variant="outline" size="sm" onClick={loadFinancialData}>
                Atualizar
              </Button>
              <Button variant="outline" size="sm" onClick={signOut}>
                Sair
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {/* Status de atualização */}
        <div className="mb-6 text-center">
          <p className="text-sm text-muted-foreground">
            Última atualização: {lastUpdate.toLocaleTimeString('pt-BR')}
          </p>
        </div>

        {/* Debug Info (temporário) */}
        {debugInfo && (
          <Card className="mb-6">
            <CardHeader>
              <CardTitle>Debug Info</CardTitle>
            </CardHeader>
            <CardContent>
              <pre className="text-xs bg-gray-100 p-2 rounded overflow-auto max-h-40">
                {debugInfo}
              </pre>
            </CardContent>
          </Card>
        )}

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Receita Total</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.totalIncome)}</div>
              <p className="text-xs text-muted-foreground">
                +{formatCurrency(financialData.totalIncome - financialData.totalExpenses)} vs despesas
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Despesas</CardTitle>
              <TrendingDown className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.totalExpenses)}</div>
              <p className="text-xs text-muted-foreground">
                Total de despesas registradas
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Saldo PJ</CardTitle>
              <CreditCard className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.balancePJ)}</div>
              <p className="text-xs text-muted-foreground">
                Conta Pessoa Jurídica
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Clientes Ativos</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{financialData.clientsCount}</div>
              <p className="text-xs text-muted-foreground">
                Clientes cadastrados
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 gap-6 mb-8">
          <Card>
            <CardHeader>
              <CardTitle>Evolução Mensal</CardTitle>
              <CardDescription>
                Receita mensal de 2025
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={financialData.monthlyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="month" />
                  <YAxis />
                  <Tooltip 
                    formatter={(value: number) => formatCurrency(value)}
                    labelStyle={{ color: 'black' }}
                  />
                  <Bar dataKey="revenue" fill="#3b82f6" />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </div>

        {/* Recent Transactions */}
        <Card>
          <CardHeader>
            <div className="flex flex-row items-center justify-between">
              <div>
                <CardTitle>Transações Recentes</CardTitle>
                <CardDescription>
                  Últimas {financialData.recentTransactions.length} transações
                </CardDescription>
              </div>
              <div className="flex space-x-2">
                <Button 
                  variant="outline" 
                  size="sm"
                  onClick={() => navigate('/transactions')}
                >
                  Ver Todas
                </Button>
                <Button 
                  size="sm"
                  onClick={() => navigate('/transactions')}
                  className="flex items-center gap-1"
                >
                  <Plus className="h-4 w-4" />
                  Nova Transação
                </Button>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            {financialData.recentTransactions.length === 0 ? (
              <div className="text-center py-8">
                <p className="text-muted-foreground mb-4">
                  Nenhuma transação encontrada
                </p>
                <Button 
                  onClick={() => navigate('/transactions')}
                  className="flex items-center gap-2 mx-auto"
                >
                  <Plus className="h-4 w-4" />
                  Criar Primeira Transação
                </Button>
              </div>
            ) : (
              <div className="space-y-4">
                {financialData.recentTransactions.map((transaction) => (
                  <div key={transaction.id} className="flex items-center justify-between p-4 border rounded-lg">
                    <div className="flex items-center space-x-4">
                      <div className={`p-2 rounded-full ${
                        transaction.transaction_type === 'income' 
                          ? 'bg-green-100 text-green-600' 
                          : 'bg-red-100 text-red-600'
                      }`}>
                        {transaction.transaction_type === 'income' ? (
                          <ArrowUpRight className="h-4 w-4" />
                        ) : (
                          <ArrowDownRight className="h-4 w-4" />
                        )}
                      </div>
                      <div>
                        <p className="font-medium">{transaction.description}</p>
                        <p className="text-sm text-muted-foreground">
                          {new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}
                        </p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className={`font-medium ${
                        transaction.transaction_type === 'income' 
                          ? 'text-green-600' 
                          : 'text-red-600'
                      }`}>
                        {transaction.transaction_type === 'income' ? '+' : '-'}
                        {formatCurrency(transaction.amount)}
                      </p>
                      <p className="text-xs text-muted-foreground capitalize">
                        {transaction.transaction_type}
                      </p>
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