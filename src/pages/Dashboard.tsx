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
  dailyRevenue: Array<{ date: string; revenue: number }>;
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
    dailyRevenue: [],
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
      const { data: transactionsData } = await supabase
        .from('transactions')
        .select('amount, transaction_type, account_name')
        .eq('user_id', user.id);

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
        ?.filter(t => t.account_name === 'Conta PJ')
        ?.reduce((sum, t) => {
          const amount = Number(t.amount);
          return t.transaction_type === 'income' ? sum + amount : sum - amount;
        }, 0) || 0;

      const balanceCheckout = transactionsData
        ?.filter(t => t.account_name === 'Conta Checkout')
        ?.reduce((sum, t) => {
          const amount = Number(t.amount);
          return t.transaction_type === 'income' ? sum + amount : sum - amount;
        }, 0) || 0;

      // Calculate daily revenue for current month - SIMPLIFIED
      const currentDate = new Date();
      const currentMonth = currentDate.getMonth();
      const currentYear = currentDate.getFullYear();
      
      // Get all income transactions (not just current month)
      const allIncomeTransactions = transactionsData?.filter(t => t.transaction_type === 'income') || [];
      
      // Get all income transactions for current month
      const currentMonthIncome = allIncomeTransactions.filter(t => {
        const transactionDate = new Date(t.transaction_date);
        // JavaScript months are 0-based, but database months are 1-based
        const transactionMonth = transactionDate.getMonth();
        const transactionYear = transactionDate.getFullYear();
        return transactionMonth === currentMonth && transactionYear === currentYear;
      });
      
      // Group by day
      const dailyRevenueMap = new Map();
      currentMonthIncome.forEach(t => {
        const day = new Date(t.transaction_date).getDate();
        const currentAmount = dailyRevenueMap.get(day) || 0;
        dailyRevenueMap.set(day, currentAmount + Number(t.amount));
      });
      
      // Create array for all days of month
      const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
      const dailyRevenue = [];
      for (let day = 1; day <= daysInMonth; day++) {
        dailyRevenue.push({
          date: `${day}`,
          revenue: dailyRevenueMap.get(day) || 0
        });
      }

      // Calculate monthly revenue for current year - SIMPLIFIED
      const currentYearIncome = allIncomeTransactions.filter(t => {
        const transactionDate = new Date(t.transaction_date);
        return transactionDate.getFullYear() === currentYear;
      });
      
      // Group by month
      const monthlyRevenueMap = new Map();
      currentYearIncome.forEach(t => {
        const month = new Date(t.transaction_date).getMonth();
        const currentAmount = monthlyRevenueMap.get(month) || 0;
        monthlyRevenueMap.set(month, currentAmount + Number(t.amount));
      });
      
      const monthNames = [
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];
      
      const monthlyRevenue = [];
      for (let month = 0; month < 12; month++) {
        monthlyRevenue.push({
          month: monthNames[month],
          revenue: monthlyRevenueMap.get(month) || 0
        });
      }

      // Debug logs
      console.log('=== DEBUG DASHBOARD ===');
      console.log('Total transactions loaded:', transactionsData?.length || 0);
      console.log('All income transactions:', allIncomeTransactions.length);
      console.log('Total income:', totalIncome);
      console.log('Current month/year:', currentMonth + 1, currentYear);
      console.log('Current month income transactions:', currentMonthIncome.length);
      console.log('Current year income transactions:', currentYearIncome.length);
      
      // Debug month comparison
      console.log('=== MONTH COMPARISON DEBUG ===');
      allIncomeTransactions.slice(0, 3).forEach((t, index) => {
        const transactionDate = new Date(t.transaction_date);
        const transactionMonth = transactionDate.getMonth();
        const transactionYear = transactionDate.getFullYear();
        console.log(`Transaction ${index + 1}:`, {
          originalDate: t.transaction_date,
          parsedDate: transactionDate,
          transactionMonth,
          transactionYear,
          currentMonth,
          currentYear,
          monthMatch: transactionMonth === currentMonth,
          yearMatch: transactionYear === currentYear,
          bothMatch: transactionMonth === currentMonth && transactionYear === currentYear
        });
      });
      
      console.log('Daily revenue map:', Object.fromEntries(dailyRevenueMap));
      console.log('Monthly revenue map:', Object.fromEntries(monthlyRevenueMap));
      console.log('Daily revenue data:', dailyRevenue);
      console.log('Monthly revenue data:', monthlyRevenue);
      console.log('=======================');

      setFinancialData({
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        clientsCount: clientsData?.length || 0,
        recentTransactions: recentData || [],
        dailyRevenue,
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
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-primary rounded-lg flex items-center justify-center">
              <DollarSign className="w-5 h-5 text-primary-foreground" />
            </div>
            <h1 className="text-2xl font-bold">FinanceiroLogotiq</h1>
          </div>
          <div className="flex items-center space-x-4">
            <span className="text-sm text-muted-foreground">
              Bem-vindo, {user?.email}
            </span>
            <Button variant="outline" onClick={signOut}>
              Sair
            </Button>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {/* Saldo Total Card */}
        <div className="mb-8">
          <Card className="shadow-finance-md">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-lg font-semibold">Saldo Total</CardTitle>
              <DollarSign className="h-6 w-6 text-primary" />
            </CardHeader>
            <CardContent>
              <div className={`text-4xl font-bold ${
                (financialData.balancePJ + financialData.balanceCheckout) >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balancePJ + financialData.balanceCheckout)}
              </div>
              <p className="text-sm text-muted-foreground mt-2">
                Soma dos saldos: Conta PJ + Conta Checkout
              </p>
            </CardContent>
          </Card>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Receitas</CardTitle>
              <TrendingUp className="h-4 w-4 text-success" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-success">
                {formatCurrency(financialData.totalIncome)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Despesas</CardTitle>
              <TrendingDown className="h-4 w-4 text-destructive" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-destructive">
                {formatCurrency(financialData.totalExpenses)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Saldo Conta PJ</CardTitle>
              <DollarSign className="h-4 w-4 text-primary" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${
                financialData.balancePJ >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balancePJ)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Saldo Conta Checkout</CardTitle>
              <CreditCard className="h-4 w-4 text-info" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${
                financialData.balanceCheckout >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(financialData.balanceCheckout)}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Clientes Card */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Clientes</CardTitle>
              <Users className="h-4 w-4 text-info" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-info">
                {financialData.clientsCount}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* Daily Revenue Chart */}
          <Card className="shadow-finance-md">
            <CardHeader>
              <CardTitle>Faturamento Diário - Mês Atual</CardTitle>
              <CardDescription>
                Receitas por dia do mês em vigor
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={financialData.dailyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis 
                    dataKey="date" 
                    tick={{ fontSize: 12 }}
                    interval={2}
                  />
                  <YAxis 
                    tickFormatter={(value) => `R$ ${value}`}
                    tick={{ fontSize: 12 }}
                  />
                  <Tooltip 
                    formatter={(value: any) => [`R$ ${value}`, 'Receita']}
                    labelFormatter={(label) => `Dia ${label}`}
                  />
                  <Line 
                    type="monotone" 
                    dataKey="revenue" 
                    stroke="#10b981" 
                    strokeWidth={2}
                    dot={{ fill: '#10b981', strokeWidth: 2, r: 4 }}
                    activeDot={{ r: 6, stroke: '#10b981', strokeWidth: 2 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Monthly Revenue Chart */}
          <Card className="shadow-finance-md">
            <CardHeader>
              <CardTitle>Evolução Mensal - Ano Atual</CardTitle>
              <CardDescription>
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
            <CardTitle>Transações Recentes</CardTitle>
            <CardDescription>
              Últimas movimentações financeiras
            </CardDescription>
          </CardHeader>
          <CardContent>
            {financialData.recentTransactions.length === 0 ? (
              <div className="text-center py-8">
                <CreditCard className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-muted-foreground">
                  Nenhuma transação encontrada. Comece adicionando suas primeiras movimentações.
                </p>
                <Button className="mt-4" onClick={() => navigate('/transactions')}>
                  Adicionar Transação
                </Button>
              </div>
            ) : (
              <div className="space-y-4">
                {financialData.recentTransactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className="flex items-center justify-between p-4 rounded-lg border"
                  >
                    <div className="flex items-center space-x-4">
                      <div className={`p-2 rounded-full ${
                        transaction.transaction_type === 'income' 
                          ? 'bg-success/10' 
                          : 'bg-destructive/10'
                      }`}>
                        {transaction.transaction_type === 'income' ? (
                          <ArrowUpRight className="h-4 w-4 text-success" />
                        ) : (
                          <ArrowDownRight className="h-4 w-4 text-destructive" />
                        )}
                      </div>
                      <div>
                        <p className="font-medium">{transaction.description}</p>
                        <p className="text-sm text-muted-foreground">
                          {transaction.client_name || 'Sem cliente'} • {transaction.account_name}
                        </p>
                      </div>
                    </div>
                    <div className={`font-semibold ${
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
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-4">
          <Button 
            className="h-20 text-lg"
            onClick={() => navigate('/transactions')}
          >
            Gerenciar Transações
          </Button>
          <Button 
            className="h-20 text-lg" 
            variant="outline"
            onClick={() => navigate('/clients')}
          >
            Gerenciar Clientes
          </Button>
          <Button 
            className="h-20 text-lg" 
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