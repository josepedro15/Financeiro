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
      
      // FORÇAR CARREGAMENTO COMPLETO - MÚLTIPLAS CONSULTAS
      console.log('=== FORÇANDO CARREGAMENTO COMPLETO ===');
      
      // 1. Consulta AGGRESSIVA - TODAS as transações sem filtros
      const { data: allTransactionsData, error: allTransactionsError } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id);

      debugLog += `Consulta 1 - Todas as transações: ${allTransactionsData?.length || 0} registros\n`;
      debugLog += `Erro consulta 1: ${allTransactionsError?.message || 'Nenhum'}\n`;

      // 2. Consulta AGGRESSIVA - Apenas receitas sem filtros
      const { data: incomeOnlyData, error: incomeError } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id)
        .eq('transaction_type', 'income');

      debugLog += `Consulta 2 - Apenas receitas: ${incomeOnlyData?.length || 0} registros\n`;
      debugLog += `Erro consulta 2: ${incomeError?.message || 'Nenhum'}\n`;

      // 3. Consulta AGGRESSIVA - Transações recentes (aumentado para 200)
      const { data: recentData, error: recentError } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(200); // Aumentado para 200

      debugLog += `Consulta 3 - Transações recentes: ${recentData?.length || 0} registros\n`;
      debugLog += `Erro consulta 3: ${recentError?.message || 'Nenhum'}\n`;

      // 4. Consulta AGGRESSIVA - Para cálculos mensais (sem filtro de ano)
      const { data: monthlyData, error: monthlyError } = await supabase
        .from('transactions')
        .select('*')
        .eq('user_id', user.id)
        .eq('transaction_type', 'income')
        .order('transaction_date', { ascending: false });

      debugLog += `Consulta 4 - Para cálculos mensais: ${monthlyData?.length || 0} registros\n`;
      debugLog += `Erro consulta 4: ${monthlyError?.message || 'Nenhum'}\n`;

      // 5. Consulta AGGRESSIVA - Verificar se há problemas de RLS
      const { data: testData, error: testError } = await supabase
        .from('transactions')
        .select('count')
        .eq('user_id', user.id);

      debugLog += `Consulta 5 - Teste de acesso: ${testData?.length || 0} registros\n`;
      debugLog += `Erro consulta 5: ${testError?.message || 'Nenhum'}\n`;

      // DEBUG: Verificar dados carregados
      console.log('=== SUPABASE DEBUG AGRESSIVO ===');
      console.log('All transactions error:', allTransactionsError);
      console.log('Income error:', incomeError);
      console.log('Recent error:', recentError);
      console.log('Monthly error:', monthlyError);
      console.log('Test error:', testError);
      console.log('Total all transactions loaded:', allTransactionsData?.length || 0);
      console.log('Total income transactions loaded:', incomeOnlyData?.length || 0);
      console.log('Total recent transactions loaded:', recentData?.length || 0);
      console.log('Total monthly transactions loaded:', monthlyData?.length || 0);
      console.log('Sample transactions:', allTransactionsData?.slice(0, 5));
      
      // Verificar transações de abril especificamente
      const abrilTransactions = allTransactionsData?.filter(t => 
        t.transaction_date?.startsWith('2025-04')
      ) || [];
      console.log('Abril transactions found:', abrilTransactions.length);
      console.log('Abril transactions sample:', abrilTransactions.slice(0, 3));

      // Get clients count (otimizado)
      const { data: clientsData } = await supabase
        .from('clients')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Calculate totals with detailed logging
      console.log('=== CALCULANDO TOTAIS AGRESSIVO ===');
      
      // USAR TODOS OS DADOS POSSÍVEIS
      const incomeTransactions = incomeOnlyData || allTransactionsData?.filter(t => t.transaction_type === 'income') || [];
      const expenseTransactions = allTransactionsData?.filter(t => t.transaction_type === 'expense') || [];
      
      console.log('Income transactions count:', incomeTransactions.length);
      console.log('Expense transactions count:', expenseTransactions.length);
      
      const totalIncome = incomeTransactions.reduce((sum, t) => sum + Number(t.amount), 0);
      const totalExpenses = expenseTransactions.reduce((sum, t) => sum + Number(t.amount), 0);
      
      console.log('Total income calculated:', totalIncome);
      console.log('Total expenses calculated:', totalExpenses);

      // Calculate balance by account
      const balancePJ = incomeTransactions.reduce((sum, t) => sum + Number(t.amount), 0);
      const balanceCheckout = 0; // Simplified since we don't have account separation

      // NOVA LÓGICA COMPLETAMENTE REESCRITA PARA GRÁFICO MENSAL
      console.log('=== NOVA LÓGICA MENSAL AGRESSIVA ===');
      
      // 1. Usar TODAS as transações de receita (sem filtro de ano)
      const allIncomeTransactions = monthlyData || incomeOnlyData || [];
      
      console.log('Todas as transações de receita encontradas:', allIncomeTransactions.length);
      
      // 2. Criar mapa simples por mês
      const monthlyDataMap = {
        0: 0, // Janeiro
        1: 0, // Fevereiro  
        2: 0, // Março
        3: 0, // Abril
        4: 0, // Maio
        5: 0, // Junho
        6: 0, // Julho
        7: 0, // Agosto
        8: 0, // Setembro
        9: 0, // Outubro
        10: 0, // Novembro
        11: 0  // Dezembro
      };
      
      // 3. Processar cada transação (sem filtro de ano)
      allIncomeTransactions.forEach(t => {
        const [year, month, day] = t.transaction_date.split('-').map(Number);
        const monthIndex = month - 1; // Converter para 0-based
        const amount = Number(t.amount);
        
        monthlyDataMap[monthIndex] += amount;
        
        // Debug para abril
        if (monthIndex === 3) {
          console.log('Abril transaction:', {
            date: t.transaction_date,
            amount: amount,
            monthIndex: monthIndex,
            runningTotal: monthlyDataMap[monthIndex]
          });
        }
      });
      
      // 4. Criar array para o gráfico
      const monthNames = [
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];
      
      const monthlyRevenue = monthNames.map((name, index) => ({
        month: name,
        revenue: monthlyDataMap[index]
      }));
      
      // 5. Debug final
      console.log('=== RESULTADO FINAL AGRESSIVO ===');
      console.log('Abril total:', monthlyDataMap[3]);
      console.log('Maio total:', monthlyDataMap[4]);
      console.log('Todos os meses:', monthlyDataMap);
      console.log('Array para gráfico:', monthlyRevenue);

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