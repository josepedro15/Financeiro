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

interface FinancialData {
  totalIncome: number;
  totalExpenses: number;
  balancePJ: number;
  balanceCheckout: number;
  clientsCount: number;
  recentTransactions: any[];
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
    recentTransactions: []
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

      setFinancialData({
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        clientsCount: clientsData?.length || 0,
        recentTransactions: recentData || []
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