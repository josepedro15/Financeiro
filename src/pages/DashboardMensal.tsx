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
  ArrowDownRight
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

export default function DashboardMensal() {
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
    console.log('=== DASHBOARD MENSAL MOUNTED ===');
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
      console.log('=== CARREGANDO DADOS DAS TABELAS MENSAIS ===');
      console.log('User ID:', user.id);
      console.log('Timestamp:', new Date().toISOString());
      
      let debugLog = '=== DEBUG LOG TABELAS MENSAIS ===\n';
      
      // Carregar dados de TODAS as tabelas mensais
      const monthlyTables = [
        'transactions_2025_01', 'transactions_2025_02', 'transactions_2025_03',
        'transactions_2025_04', 'transactions_2025_05', 'transactions_2025_06',
        'transactions_2025_07', 'transactions_2025_08', 'transactions_2025_09',
        'transactions_2025_10', 'transactions_2025_11', 'transactions_2025_12'
      ];

      const monthNames = [
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];

      let totalIncome = 0;
      let totalExpenses = 0;
      let allTransactions: any[] = [];
      let monthlyRevenue: Array<{ month: string; revenue: number }> = [];

      // Carregar dados de cada mês
      for (let i = 0; i < monthlyTables.length; i++) {
        const tableName = monthlyTables[i];
        const monthName = monthNames[i];
        
        try {
          // Consulta para dados gerais
          const { data: monthData, error: monthError } = await supabase
            .from(tableName)
            .select('*')
            .eq('user_id', user.id);

          if (monthError) {
            debugLog += `${monthName}: ERRO - ${monthError.message}\n`;
            console.error(`Erro ${monthName}:`, monthError);
          } else {
            const monthTransactions = monthData || [];
            const monthIncome = monthTransactions
              .filter(t => t.transaction_type === 'income')
              .reduce((sum, t) => sum + Number(t.amount), 0);
            const monthExpenses = monthTransactions
              .filter(t => t.transaction_type === 'expense')
              .reduce((sum, t) => sum + Number(t.amount), 0);

            totalIncome += monthIncome;
            totalExpenses += monthExpenses;
            allTransactions = [...allTransactions, ...monthTransactions];

            monthlyRevenue.push({
              month: monthName,
              revenue: monthIncome
            });

            debugLog += `${monthName}: ${monthTransactions.length} transações, R$ ${monthIncome.toFixed(2)}\n`;
          }
        } catch (error) {
          debugLog += `${monthName}: ERRO DE CONSULTA - ${error}\n`;
          console.error(`Erro consulta ${monthName}:`, error);
          
          // Fallback: adicionar mês com valor zero
          monthlyRevenue.push({
            month: monthName,
            revenue: 0
          });
        }
      }

      // Transações recentes de todas as tabelas
      let recentTransactions: any[] = [];
      try {
        // Pegar transações recentes da tabela principal como fallback
        const { data: recentData } = await supabase
          .from('transactions')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', { ascending: false })
          .limit(50);
        
        recentTransactions = recentData || [];
      } catch (error) {
        console.error('Erro ao carregar transações recentes:', error);
      }

      // Get clients count
      const { data: clientsData } = await supabase
        .from('clients')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Calculate balance by account
      const balancePJ = totalIncome;
      const balanceCheckout = 0;

      debugLog += `\nTOTAL GERAL:\n`;
      debugLog += `Receitas: R$ ${totalIncome.toFixed(2)}\n`;
      debugLog += `Despesas: R$ ${totalExpenses.toFixed(2)}\n`;
      debugLog += `Transações totais: ${allTransactions.length}\n`;

      const newFinancialData = {
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        clientsCount: clientsData?.length || 0,
        recentTransactions,
        monthlyRevenue
      };
      
      console.log('=== RESULTADO TABELAS MENSAIS ===');
      console.log('New financial data:', newFinancialData);
      console.log('Total income:', newFinancialData.totalIncome);
      console.log('Monthly revenue:', newFinancialData.monthlyRevenue);
      
      setFinancialData(newFinancialData);
      setLastUpdate(new Date());
      setDebugInfo(debugLog);
    } catch (error) {
      console.error('Error loading financial data:', error);
      setDebugInfo(`ERRO GERAL: ${error}`);
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
            <h1 className="text-lg sm:text-2xl font-bold">FinanceiroLogotiq (Mensal)</h1>
          </div>
          <div className="flex flex-col sm:flex-row items-center space-y-2 sm:space-y-0 sm:space-x-4">
            <span className="text-xs sm:text-sm text-muted-foreground text-center">
              Bem-vindo, {user?.email}
            </span>
            <div className="flex items-center space-x-2">
              <Button variant="outline" size="sm" onClick={loadFinancialData}>
                Atualizar
              </Button>
              <Button variant="outline" size="sm" onClick={() => navigate('/dashboard')}>
                Dashboard Normal
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
            Última atualização: {lastUpdate.toLocaleTimeString('pt-BR')} (Tabelas Mensais)
          </p>
        </div>

        {/* Debug Info */}
        {debugInfo && (
          <Card className="mb-6">
            <CardHeader>
              <CardTitle>Debug Info - Tabelas Mensais</CardTitle>
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
              <CardTitle>Evolução Mensal (Tabelas Separadas)</CardTitle>
              <CardDescription>
                Receita mensal de 2025 - Dados das tabelas mensais
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
            <CardTitle>Transações Recentes</CardTitle>
            <CardDescription>
              Últimas {financialData.recentTransactions.length} transações
            </CardDescription>
          </CardHeader>
          <CardContent>
            {financialData.recentTransactions.length === 0 ? (
              <p className="text-center text-muted-foreground py-8">
                Nenhuma transação encontrada
              </p>
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
