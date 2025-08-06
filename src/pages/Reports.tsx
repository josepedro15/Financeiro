import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { useToast } from '@/hooks/use-toast';
import { 
  BarChart3, 
  TrendingUp, 
  TrendingDown,
  Calendar,
  Download,
  Filter
} from 'lucide-react';

interface ReportData {
  monthlyIncome: Array<{ month: string; amount: number }>;
  monthlyExpenses: Array<{ month: string; amount: number }>;
  categoryBreakdown: Array<{ category: string; amount: number; count: number }>;
  clientStats: Array<{ name: string; total: number; transactions: number }>;
  summary: {
    totalIncome: number;
    totalExpenses: number;
    balance: number;
    transactionCount: number;
  };
}

export default function Reports() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [reportData, setReportData] = useState<ReportData>({
    monthlyIncome: [],
    monthlyExpenses: [],
    categoryBreakdown: [],
    clientStats: [],
    summary: {
      totalIncome: 0,
      totalExpenses: 0,
      balance: 0,
      transactionCount: 0
    }
  });
  const [loading, setLoading] = useState(true);
  const [period, setPeriod] = useState('6months');

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadReportData();
  }, [user, navigate, period]);

  const loadReportData = async () => {
    if (!user) return;

    try {
      setLoading(true);

      // Calculate date range
      const endDate = new Date();
      const startDate = new Date();
      
      switch (period) {
        case '3months':
          startDate.setMonth(endDate.getMonth() - 3);
          break;
        case '6months':
          startDate.setMonth(endDate.getMonth() - 6);
          break;
        case '1year':
          startDate.setFullYear(endDate.getFullYear() - 1);
          break;
        default:
          startDate.setMonth(endDate.getMonth() - 6);
      }

      // Load all transactions for the period
      const { data: transactions } = await supabase
        .from('transactions')
        .select('*, clients(name)')
        .eq('user_id', user.id)
        .gte('transaction_date', startDate.toISOString().split('T')[0])
        .lte('transaction_date', endDate.toISOString().split('T')[0])
        .order('transaction_date', { ascending: true });

      if (!transactions) return;

      // Process monthly data
      const monthlyData: { [key: string]: { income: number; expenses: number } } = {};
      const categoryData: { [key: string]: { amount: number; count: number } } = {};
      const clientData: { [key: string]: { total: number; transactions: number } } = {};

      let totalIncome = 0;
      let totalExpenses = 0;

      transactions.forEach(transaction => {
        const date = new Date(transaction.transaction_date);
        const monthKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
        const amount = Number(transaction.amount);

        // Monthly aggregation
        if (!monthlyData[monthKey]) {
          monthlyData[monthKey] = { income: 0, expenses: 0 };
        }

        if (transaction.transaction_type === 'income') {
          monthlyData[monthKey].income += amount;
          totalIncome += amount;
        } else if (transaction.transaction_type === 'expense') {
          monthlyData[monthKey].expenses += amount;
          totalExpenses += amount;
        }

        // Category breakdown
        const category = transaction.category || 'Sem categoria';
        if (!categoryData[category]) {
          categoryData[category] = { amount: 0, count: 0 };
        }
        categoryData[category].amount += amount;
        categoryData[category].count += 1;

        // Client stats
        const clientName = transaction.clients?.name || 'Sem cliente';
        if (!clientData[clientName]) {
          clientData[clientName] = { total: 0, transactions: 0 };
        }
        clientData[clientName].total += amount;
        clientData[clientName].transactions += 1;
      });

      // Convert to arrays for display
      const monthlyIncome = Object.entries(monthlyData).map(([month, data]) => ({
        month: new Date(month + '-01').toLocaleDateString('pt-BR', { month: 'short', year: 'numeric' }),
        amount: data.income
      }));

      const monthlyExpenses = Object.entries(monthlyData).map(([month, data]) => ({
        month: new Date(month + '-01').toLocaleDateString('pt-BR', { month: 'short', year: 'numeric' }),
        amount: data.expenses
      }));

      const categoryBreakdown = Object.entries(categoryData)
        .map(([category, data]) => ({
          category,
          amount: data.amount,
          count: data.count
        }))
        .sort((a, b) => b.amount - a.amount)
        .slice(0, 10);

      const clientStats = Object.entries(clientData)
        .map(([name, data]) => ({
          name,
          total: data.total,
          transactions: data.transactions
        }))
        .sort((a, b) => b.total - a.total)
        .slice(0, 10);

      setReportData({
        monthlyIncome,
        monthlyExpenses,
        categoryBreakdown,
        clientStats,
        summary: {
          totalIncome,
          totalExpenses,
          balance: totalIncome - totalExpenses,
          transactionCount: transactions.length
        }
      });

    } catch (error) {
      console.error('Error loading report data:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar dados do relatório",
        variant: "destructive"
      });
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
            <Button variant="ghost" onClick={() => navigate('/dashboard')}>
              ← Dashboard
            </Button>
            <h1 className="text-2xl font-bold">Relatórios</h1>
          </div>
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <Filter className="w-4 h-4" />
              <Label htmlFor="period">Período:</Label>
              <Select value={period} onValueChange={setPeriod}>
                <SelectTrigger className="w-32">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="3months">3 meses</SelectItem>
                  <SelectItem value="6months">6 meses</SelectItem>
                  <SelectItem value="1year">1 ano</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8 space-y-8">
        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total de Receitas</CardTitle>
              <TrendingUp className="h-4 w-4 text-success" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-success">
                {formatCurrency(reportData.summary.totalIncome)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total de Despesas</CardTitle>
              <TrendingDown className="h-4 w-4 text-destructive" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-destructive">
                {formatCurrency(reportData.summary.totalExpenses)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Saldo Líquido</CardTitle>
              <BarChart3 className="h-4 w-4 text-primary" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${
                reportData.summary.balance >= 0 ? 'text-success' : 'text-destructive'
              }`}>
                {formatCurrency(reportData.summary.balance)}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-sm">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Transações</CardTitle>
              <Calendar className="h-4 w-4 text-info" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-info">
                {reportData.summary.transactionCount}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Monthly Trends */}
        <Card className="shadow-finance-md">
          <CardHeader>
            <CardTitle>Tendência Mensal</CardTitle>
            <CardDescription>
              Evolução de receitas e despesas por mês
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {reportData.monthlyIncome.map((month, index) => {
                const expense = reportData.monthlyExpenses[index];
                const netBalance = month.amount - (expense?.amount || 0);
                
                return (
                  <div key={month.month} className="grid grid-cols-4 gap-4 items-center p-4 rounded-lg border">
                    <div className="font-medium">{month.month}</div>
                    <div className="text-success font-semibold">
                      {formatCurrency(month.amount)}
                    </div>
                    <div className="text-destructive font-semibold">
                      {formatCurrency(expense?.amount || 0)}
                    </div>
                    <div className={`font-semibold ${netBalance >= 0 ? 'text-success' : 'text-destructive'}`}>
                      {formatCurrency(netBalance)}
                    </div>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>

        {/* Category Breakdown */}
        <div className="grid md:grid-cols-2 gap-8">
          <Card className="shadow-finance-md">
            <CardHeader>
              <CardTitle>Por Categoria</CardTitle>
              <CardDescription>
                Top 10 categorias por valor
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {reportData.categoryBreakdown.map((category) => (
                  <div key={category.category} className="flex items-center justify-between p-3 rounded-lg border">
                    <div>
                      <p className="font-medium">{category.category}</p>
                      <p className="text-sm text-muted-foreground">
                        {category.count} transações
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="font-semibold">{formatCurrency(category.amount)}</p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card className="shadow-finance-md">
            <CardHeader>
              <CardTitle>Por Cliente</CardTitle>
              <CardDescription>
                Top 10 clientes por volume
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {reportData.clientStats.map((client) => (
                  <div key={client.name} className="flex items-center justify-between p-3 rounded-lg border">
                    <div>
                      <p className="font-medium">{client.name}</p>
                      <p className="text-sm text-muted-foreground">
                        {client.transactions} transações
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="font-semibold">{formatCurrency(client.total)}</p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  );
}