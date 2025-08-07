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
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar } from 'recharts';

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

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadFinancialData();
  }, [user, navigate]);

  const loadFinancialData = async () => {
    if (!user) return;

    try {
      // Get all transactions
      const { data: transactionsData, error } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id);

      // DEBUG: Verificar dados carregados
      console.log('=== SUPABASE DEBUG ===');
      console.log('Error:', error);
      console.log('Total transactions loaded:', transactionsData?.length || 0);
      console.log('Sample transactions:', transactionsData?.slice(0, 5));
      
      // Verificar transações de abril especificamente
      const abrilTransactions = transactionsData?.filter(t => 
        t.transaction_date?.startsWith('2025-04')
      ) || [];
      console.log('Abril transactions found:', abrilTransactions.length);
      console.log('Abril transactions sample:', abrilTransactions.slice(0, 3));

      // Get clients count
      const { data: clientsData } = await supabase
        .from('clients')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Get recent transactions
      const { data: recentData } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(5);

      // Calculate totals
      const totalIncome = transactionsData
        ?.filter(t => t.transaction_type === 'income')
        ?.reduce((sum, t) => sum + Number(t.amount), 0) || 0;

      const totalExpenses = transactionsData
        ?.filter(t => t.transaction_type === 'expense')
        ?.reduce((sum, t) => sum + Number(t.amount), 0) || 0;

      // Calculate balance by account
      const balancePJ = transactionsData
        ?.filter(t => t.transaction_type === 'income')
        ?.reduce((sum, t) => sum + Number(t.amount), 0) || 0;

      const balanceCheckout = 0; // Simplified since we don't have account separation

      // NOVA LÓGICA SIMPLIFICADA PARA GRÁFICO MENSAL
      console.log('=== NOVA LÓGICA MENSAL ===');
      
      // Filtrar apenas transações de receita
      const allIncomeTransactions = transactionsData?.filter(t => t.transaction_type === 'income') || [];
      console.log('Total income transactions:', allIncomeTransactions.length);
      
      // Agrupar por mês de 2025
      const monthlyRevenueMap = new Map();
      
      allIncomeTransactions.forEach(t => {
        const [year, month, day] = t.transaction_date.split('-').map(Number);
        const transactionDate = new Date(year, month - 1, day);
        const transactionYear = transactionDate.getFullYear();
        const monthIndex = transactionDate.getMonth();
        
        // Apenas transações de 2025
        if (transactionYear === 2025) {
          const currentAmount = monthlyRevenueMap.get(monthIndex) || 0;
          const newAmount = currentAmount + Number(t.amount);
          monthlyRevenueMap.set(monthIndex, newAmount);
          
          // Debug para abril e maio
          if (monthIndex === 3) {
            console.log('Abril transaction:', {
              date: t.transaction_date,
              amount: t.amount,
              currentAmount,
              newAmount
            });
          }
          if (monthIndex === 4) {
            console.log('Maio transaction:', {
              date: t.transaction_date,
              amount: t.amount,
              currentAmount,
              newAmount
            });
          }
        }
      });
      
      // Criar array para o gráfico
      const monthNames = [
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];
      
      const monthlyRevenue = [];
      for (let month = 0; month < 12; month++) {
        const revenue = monthlyRevenueMap.get(month) || 0;
        monthlyRevenue.push({
          month: monthNames[month],
          revenue: revenue
        });
        
        // Debug dos totais
        if (month === 3) {
          console.log('=== ABRIL FINAL ===');
          console.log('Abril total:', revenue);
          console.log('Abril expected:', 7624.88);
          console.log('Difference:', revenue - 7624.88);
        }
        if (month === 4) {
          console.log('=== MAIO FINAL ===');
          console.log('Maio total:', revenue);
        }
      }
      
      console.log('Monthly revenue map:', Object.fromEntries(monthlyRevenueMap));
      console.log('Monthly revenue data:', monthlyRevenue);

      setFinancialData({
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        clientsCount: clientsData?.length || 0,
        recentTransactions: recentData || [],
        monthlyRevenue
      });
    } catch (error) {
      console.error('Error loading financial data:', error);
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
            <Button variant="outline" size="sm" onClick={signOut}>
              Sair
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-3 sm:px-4 py-4 sm:py-8">
        {/* Saldo Total Card */}
        <div className="mb-6 sm:mb-8">
          <Card className="shadow-finance-md">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm sm:text-lg font-semibold">Saldo Total</CardTitle>
              <DollarSign className="h-4 w-4 sm:h-6 sm:w-6 text-primary" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl sm:text-4xl font-bold ${
                (financialData.balancePJ + financialData.balanceCheckout) >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balancePJ + financialData.balanceCheckout)}
              </div>
              <p className="text-xs sm:text-sm text-muted-foreground mt-2">
                Soma dos saldos: Conta PJ + Conta Checkout
              </p>
            </CardContent>
          </Card>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6 mb-8">
          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-xs sm:text-sm font-medium">Receitas</CardTitle>
              <TrendingUp className="h-3 w-3 sm:h-4 sm:w-4 text-success" />
            </CardHeader>
            <CardContent>
              <div className="text-lg sm:text-2xl font-bold text-success">
                {formatCurrency(financialData.totalIncome)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-xs sm:text-sm font-medium">Despesas</CardTitle>
              <TrendingDown className="h-3 w-3 sm:h-4 sm:w-4 text-destructive" />
            </CardHeader>
            <CardContent>
              <div className="text-lg sm:text-2xl font-bold text-destructive">
                {formatCurrency(financialData.totalExpenses)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-xs sm:text-sm font-medium">Saldo PJ</CardTitle>
              <DollarSign className="h-3 w-3 sm:h-4 sm:w-4 text-primary" />
            </CardHeader>
            <CardContent>
              <div className={`text-lg sm:text-2xl font-bold ${
                financialData.balancePJ >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balancePJ)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-xs sm:text-sm font-medium">Saldo Checkout</CardTitle>
              <CreditCard className="h-3 w-3 sm:h-4 sm:w-4 text-info" />
            </CardHeader>
            <CardContent>
              <div className={`text-lg sm:text-2xl font-bold ${
                financialData.balanceCheckout >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balanceCheckout)}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 gap-4 sm:gap-6 mb-8">
          {/* Monthly Revenue Chart - REESCRITO */}
          <Card className="shadow-finance-md">
            <CardHeader>
              <CardTitle className="text-sm sm:text-base">Evolução Mensal - Ano Atual</CardTitle>
              <CardDescription className="text-xs sm:text-sm">
                Receitas por mês desde o início do ano
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={financialData.monthlyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis 
                    dataKey="month" 
                    tick={{ fontSize: 12 }}
                  />
                  <YAxis 
                    tickFormatter={(value) => `R$ ${value}`}
                    tick={{ fontSize: 12 }}
                  />
                  <Tooltip 
                    formatter={(value: any) => [`R$ ${value}`, 'Receita']}
                    labelFormatter={(label) => `${label}`}
                  />
                  <Bar 
                    dataKey="revenue" 
                    fill="#10b981" 
                    radius={[4, 4, 0, 0]}
                  />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </div>

        {/* Recent Transactions */}
        <Card className="shadow-finance-md">
          <CardHeader>
            <CardTitle className="text-sm sm:text-base">Transações Recentes</CardTitle>
            <CardDescription className="text-xs sm:text-sm">
              Últimas movimentações financeiras
            </CardDescription>
          </CardHeader>
          <CardContent>
            {financialData.recentTransactions.length === 0 ? (
              <div className="text-center py-8">
                <CreditCard className="h-8 w-8 sm:h-12 sm:w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-xs sm:text-sm text-muted-foreground">
                  Nenhuma transação encontrada. Comece adicionando suas primeiras movimentações.
                </p>
                <Button className="mt-4" size="sm" onClick={() => navigate('/transactions')}>
                  Adicionar Transação
                </Button>
              </div>
            ) : (
              <div className="space-y-3 sm:space-y-4">
                {financialData.recentTransactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className="flex flex-col sm:flex-row sm:items-center justify-between p-3 sm:p-4 rounded-lg border gap-2 sm:gap-0"
                  >
                    <div className="flex items-center space-x-3 sm:space-x-4">
                      <div className={`p-1.5 sm:p-2 rounded-full ${
                        transaction.transaction_type === 'income' 
                          ? 'bg-success/10' 
                          : 'bg-destructive/10'
                      }`}>
                        {transaction.transaction_type === 'income' ? (
                          <ArrowUpRight className="h-3 w-3 sm:h-4 sm:w-4 text-success" />
                        ) : (
                          <ArrowDownRight className="h-3 w-3 sm:h-4 sm:w-4 text-destructive" />
                        )}
                      </div>
                      <div className="min-w-0 flex-1">
                        <p className="font-medium text-sm sm:text-base truncate">{transaction.description}</p>
                        <p className="text-xs sm:text-sm text-muted-foreground truncate">
                          {transaction.client_name || 'Sem cliente'} • {transaction.transaction_date}
                        </p>
                      </div>
                    </div>
                    <div className={`font-semibold text-sm sm:text-base ${
                      transaction.transaction_type === 'income' ? 'text-success' : 'text-destructive'
                    }`}>
                      {transaction.transaction_type === 'income' ? '+' : '-'}
                      {formatCurrency(Number(transaction.amount))}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <div className="mt-6 sm:mt-8 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-4">
          <Button 
            className="h-16 sm:h-20 text-sm sm:text-lg"
            onClick={() => navigate('/transactions')}
          >
            Gerenciar Transações
          </Button>
          <Button 
            className="h-16 sm:h-20 text-sm sm:text-lg" 
            variant="outline"
            onClick={() => navigate('/clients')}
          >
            Gerenciar Clientes
          </Button>
          <Button 
            className="h-16 sm:h-20 text-sm sm:text-lg col-span-1 sm:col-span-2 lg:col-span-1" 
            variant="secondary"
            onClick={() => navigate('/reports')}
          >
            Ver Relatórios
          </Button>
        </div>
      </main>
    </div>
  );
}