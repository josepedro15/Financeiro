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
  Plus,
  Calculator,
  PiggyBank,
  Percent,
  BarChart3
} from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar, Area } from 'recharts';

interface FinancialData {
  totalIncome: number;
  totalExpenses: number;
  balancePJ: number;
  balanceCheckout: number;
  recentTransactions: any[];
  monthlyRevenue: Array<{ month: string; revenue: number }>;
  dailyRevenue: Array<{ day: string; revenue: number }>;
  currentMonth: string;
  currentMonthRevenue: number;
  // Novos indicadores
  ticketMedio: number;
  lucroLiquido: number;
  margemLucro: number;
  crescimentoMensal: number;
  totalTransacoes: number;
}

export default function Dashboard() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const [financialData, setFinancialData] = useState<FinancialData>({
    totalIncome: 0,
    totalExpenses: 0,
    balancePJ: 0,
    balanceCheckout: 0,
    recentTransactions: [],
    monthlyRevenue: [],
    dailyRevenue: [],
    currentMonth: '',
    currentMonthRevenue: 0,
    // Novos indicadores
    ticketMedio: 0,
    lucroLiquido: 0,
    margemLucro: 0,
    crescimentoMensal: 0,
    totalTransacoes: 0
  });
  const [loading, setLoading] = useState(true);
  const [lastUpdate, setLastUpdate] = useState<Date>(new Date());


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
      let totalExpensesSemProlabore = 0; // Para cálculo da margem de lucro
      let balancePJTotal = 0;
      let balanceCheckoutTotal = 0;
      let totalIncomeTransactions = 0; // Para calcular ticket médio

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
          const monthExpensesSemProlabore = monthExpenses.filter(t => t.category !== 'Prolabore');
          
          // Separar por conta
          const monthIncomePJ = monthIncome.filter(t => t.account_name === 'Conta PJ');
          const monthIncomeCheckout = monthIncome.filter(t => t.account_name === 'Conta Checkout');
          const monthExpensesPJ = monthExpenses.filter(t => t.account_name === 'Conta PJ');
          const monthExpensesCheckout = monthExpenses.filter(t => t.account_name === 'Conta Checkout');
          
          // Calcular totais do mês
          const monthIncomeTotal = monthIncome.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthExpensesTotal = monthExpenses.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthExpensesSemProlaboreTotal = monthExpensesSemProlabore.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthIncomePJTotal = monthIncomePJ.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthIncomeCheckoutTotal = monthIncomeCheckout.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthExpensesPJTotal = monthExpensesPJ.reduce((sum, t) => sum + Number(t.amount), 0);
          const monthExpensesCheckoutTotal = monthExpensesCheckout.reduce((sum, t) => sum + Number(t.amount), 0);
          
          // Debug: Log dos valores calculados
          console.log(`=== ${monthInfo.month} ===`);
          console.log(`Receitas PJ: ${monthIncomePJTotal}`);
          console.log(`Despesas PJ: ${monthExpensesPJTotal}`);
          console.log(`Receitas Checkout: ${monthIncomeCheckoutTotal}`);
          console.log(`Despesas Checkout: ${monthExpensesCheckoutTotal}`);
          
          // Acumular totais gerais
          totalIncome += monthIncomeTotal;
          totalExpenses += monthExpensesTotal;
          totalExpensesSemProlabore += monthExpensesSemProlaboreTotal;
          totalIncomeTransactions += monthIncome.length; // Contar transações de receita
          // Saldo = Receitas - Despesas
          balancePJTotal += (monthIncomePJTotal - monthExpensesPJTotal);
          balanceCheckoutTotal += (monthIncomeCheckoutTotal - monthExpensesCheckoutTotal);
          
          console.log(`Saldo PJ acumulado: ${balancePJTotal}`);
          console.log(`Saldo Checkout acumulado: ${balanceCheckoutTotal}`);
          
          // Adicionar transações aos arrays gerais
          allTransactionsData = [...allTransactionsData, ...monthTransactions];
          incomeOnlyData = [...incomeOnlyData, ...monthIncome];
          
          // Adicionar dados mensais para gráfico (apenas Conta PJ)
          monthlyRevenue.push({
            month: monthInfo.month,
            revenue: monthIncomePJTotal
          });
          

          
        } catch (error) {
          console.error(`Erro ao carregar ${monthInfo.month}:`, error);

          
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

      // Clients count não é mais necessário (substituído por saldo checkout)

      // Usar totais já calculados das tabelas mensais
      console.log('=== TOTAIS DAS TABELAS MENSAIS ===');
      console.log('Income transactions count:', incomeOnlyData.length);
      console.log('All transactions count:', allTransactionsData.length);
      console.log('Total income calculated:', totalIncome);
      console.log('Total expenses calculated:', totalExpenses);

      // Calculate balance by account
      const balancePJ = balancePJTotal;
      const balanceCheckout = balanceCheckoutTotal;

      // Usar dados mensais já calculados das tabelas específicas
      console.log('=== DADOS MENSAIS FINAIS ===');
      console.log('Monthly revenue final:', monthlyRevenue);
      
      // CALCULAR DADOS DIÁRIOS DO MÊS ATUAL
      const now = new Date();
      const currentMonth = now.getMonth() + 1; // 1-based
      const currentYear = now.getFullYear();
      const currentMonthName = monthlyTables.find(table => table.monthNum === currentMonth)?.month || '';
      
      // Obter dados diários do mês atual
      const currentMonthTable = `transactions_${currentYear}_${String(currentMonth).padStart(2, '0')}`;
      console.log('=== CARREGANDO DADOS DIÁRIOS DO MÊS ATUAL ===');
      console.log('Current month table:', currentMonthTable);
      
      let dailyRevenue: Array<{ day: string; revenue: number }> = [];
      let currentMonthRevenue = 0;
      
      try {
        const { data: dailyData, error: dailyError } = await supabase
          .from(currentMonthTable)
          .select('transaction_date, amount, account_name')
          .eq('user_id', user.id)
          .eq('transaction_type', 'income')
          .eq('account_name', 'Conta PJ');

        if (dailyError) {
          console.warn('Erro ao carregar dados diários:', dailyError);
        } else if (dailyData) {
          // Agrupar por dia
          const dailyMap = new Map<string, number>();
          
          dailyData.forEach(transaction => {
            const day = new Date(transaction.transaction_date).getDate().toString();
            const current = dailyMap.get(day) || 0;
            dailyMap.set(day, current + Number(transaction.amount));
          });

          // Converter para array e ordenar
          dailyRevenue = Array.from(dailyMap.entries())
            .map(([day, revenue]) => ({ day, revenue }))
            .sort((a, b) => parseInt(a.day) - parseInt(b.day));

          currentMonthRevenue = dailyData.reduce((sum, t) => sum + Number(t.amount), 0);
          
          console.log('Daily revenue data:', dailyRevenue);
          console.log('Current month revenue:', currentMonthRevenue);
        }
      } catch (error) {
        console.error('Erro ao carregar dados diários:', error);
      }

      // CALCULAR NOVOS INDICADORES
      console.log('=== CALCULANDO INDICADORES ===');
      
      // 1. Ticket Médio = receita ÷ número de vendas
      const ticketMedio = totalIncomeTransactions > 0 ? totalIncome / totalIncomeTransactions : 0;
      
      // 2. Lucro Líquido = receita - despesas sem prolabore (para o card)
      const lucroLiquido = totalIncome - totalExpensesSemProlabore;
      
      // 3. Margem de Lucro (%) = (receita - despesas sem prolabore) ÷ receita × 100
      const lucroLiquidoSemProlabore = lucroLiquido; // Mesmo valor agora
      const margemLucro = totalIncome > 0 ? (lucroLiquidoSemProlabore / totalIncome) * 100 : 0;
      
      // 4. Crescimento Mensal (%) = acumulado até hoje vs mesmo dia mês anterior
      let crescimentoMensal = 0;
      
      // Obter data atual
      const today = new Date();
      const currentDay = today.getDate();
      const todayMonth = today.getMonth() + 1; // 1-based
      const todayYear = today.getFullYear();
      
      console.log('=== CALCULANDO CRESCIMENTO MENSAL ===');
      console.log('Data atual:', today.toLocaleDateString('pt-BR'));
      console.log('Dia atual:', currentDay);
      console.log('Mês atual:', todayMonth);
      
      // Determinar mês anterior
      let previousMonth = todayMonth - 1;
      let previousYear = todayYear;
      if (previousMonth === 0) {
        previousMonth = 12;
        previousYear = todayYear - 1;
      }
      
      console.log('Mês anterior para comparação:', previousMonth, '/', previousYear);
      
      try {
        // Buscar dados acumulados até hoje no mês atual
        const currentMonthTableGrowth = `transactions_${todayYear}_${String(todayMonth).padStart(2, '0')}`;
        const { data: currentMonthData, error: currentError } = await supabase
          .from(currentMonthTableGrowth)
          .select('transaction_date, amount')
          .eq('user_id', user.id)
          .eq('transaction_type', 'income')
          .eq('account_name', 'Conta PJ')
          .lte('transaction_date', `${todayYear}-${String(todayMonth).padStart(2, '0')}-${String(currentDay).padStart(2, '0')}`);

        // Buscar dados acumulados até o mesmo dia no mês anterior
        const previousMonthTable = `transactions_${previousYear}_${String(previousMonth).padStart(2, '0')}`;
        const { data: previousMonthData, error: previousError } = await supabase
          .from(previousMonthTable)
          .select('transaction_date, amount')
          .eq('user_id', user.id)
          .eq('transaction_type', 'income')
          .eq('account_name', 'Conta PJ')
          .lte('transaction_date', `${previousYear}-${String(previousMonth).padStart(2, '0')}-${String(currentDay).padStart(2, '0')}`);

        if (!currentError && !previousError && currentMonthData && previousMonthData) {
          const currentAccumulated = currentMonthData.reduce((sum, t) => sum + Number(t.amount), 0);
          const previousAccumulated = previousMonthData.reduce((sum, t) => sum + Number(t.amount), 0);
          
          console.log(`Acumulado até ${currentDay}/${todayMonth}:`, currentAccumulated);
          console.log(`Acumulado até ${currentDay}/${previousMonth}:`, previousAccumulated);
          
          if (previousAccumulated > 0) {
            crescimentoMensal = ((currentAccumulated - previousAccumulated) / previousAccumulated) * 100;
          }
          
          console.log('Crescimento calculado:', crescimentoMensal + '%');
        } else {
          console.warn('Erro ao buscar dados para crescimento mensal:', currentError || previousError);
        }
      } catch (error) {
        console.error('Erro no cálculo de crescimento mensal:', error);
      }
      
      console.log('Ticket Médio:', ticketMedio);
      console.log('Lucro Líquido (sem prolabore):', lucroLiquido);
      console.log('Total Receitas:', totalIncome);
      console.log('Total Despesas (com prolabore):', totalExpenses);
      console.log('Total Despesas (sem prolabore):', totalExpensesSemProlabore);
      console.log('Margem de Lucro (sem prolabore):', margemLucro);
      console.log('Crescimento Mensal:', crescimentoMensal);
      console.log('Total de transações de receita:', totalIncomeTransactions);

      const newFinancialData = {
        totalIncome,
        totalExpenses,
        balancePJ,
        balanceCheckout,
        recentTransactions: recentData || [],
        monthlyRevenue,
        dailyRevenue,
        currentMonth: currentMonthName,
        currentMonthRevenue,
        // Novos indicadores
        ticketMedio,
        lucroLiquido,
        margemLucro,
        crescimentoMensal,
        totalTransacoes: totalIncomeTransactions
      };
      
      console.log('=== ATUALIZANDO ESTADO AGRESSIVO ===');
      console.log('New financial data:', newFinancialData);
      console.log('Total income in state:', newFinancialData.totalIncome);
      console.log('Recent transactions count:', newFinancialData.recentTransactions.length);
      
      setFinancialData(newFinancialData);
      setLastUpdate(new Date());

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



        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-4 gap-6 mb-8">
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
              <CardTitle className="text-sm font-medium">Saldo em Caixa</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.balancePJ + financialData.balanceCheckout)}</div>
              <p className="text-xs text-muted-foreground">
                Soma das duas contas
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
              <CardTitle className="text-sm font-medium">Saldo Checkout</CardTitle>
              <CreditCard className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.balanceCheckout)}</div>
              <p className="text-xs text-muted-foreground">
                Conta Checkout
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Novos Indicadores */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Ticket Médio</CardTitle>
              <Calculator className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{formatCurrency(financialData.ticketMedio)}</div>
              <p className="text-xs text-muted-foreground">
                Por venda ({financialData.totalTransacoes} vendas)
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Lucro Líquido</CardTitle>
              <PiggyBank className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${financialData.lucroLiquido >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                {formatCurrency(financialData.lucroLiquido)}
              </div>
              <p className="text-xs text-muted-foreground">
                Receita - Despesas (sem prolabore)
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Margem de Lucro</CardTitle>
              <Percent className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold ${financialData.margemLucro >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                {financialData.margemLucro.toFixed(1)}%
              </div>
              <p className="text-xs text-muted-foreground">
                Eficiência financeira
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Crescimento Mensal</CardTitle>
              <BarChart3 className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className={`text-2xl font-bold flex items-center ${
                financialData.crescimentoMensal >= 0 ? 'text-green-600' : 'text-red-600'
              }`}>
                {financialData.crescimentoMensal >= 0 ? (
                  <TrendingUp className="h-4 w-4 mr-1" />
                ) : (
                  <TrendingDown className="h-4 w-4 mr-1" />
                )}
                {Math.abs(financialData.crescimentoMensal).toFixed(1)}%
              </div>
              <p className="text-xs text-muted-foreground">
                acumulado até hoje vs mês anterior
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* Gráfico Mensal */}
          <Card>
            <CardHeader>
              <CardTitle>Evolução Mensal - Conta PJ</CardTitle>
              <CardDescription>
                Receita mensal da Conta PJ em 2025
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

          {/* Gráfico Diário do Mês Atual */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                Faturamento Diário Conta PJ - {financialData.currentMonth}
                <span className="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                  Mês Atual
                </span>
              </CardTitle>
              <CardDescription>
                {financialData.currentMonth ? 
                  `Receita diária da Conta PJ em ${financialData.currentMonth.toLowerCase()} 2025 - Total: ${formatCurrency(financialData.currentMonthRevenue)}` 
                  : 'Carregando dados do mês atual...'
                }
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={financialData.dailyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis 
                    dataKey="day" 
                    label={{ value: 'Dia do Mês', position: 'insideBottom', offset: -5 }}
                  />
                  <YAxis />
                  <Tooltip 
                    formatter={(value: number) => [formatCurrency(value), 'Faturamento']}
                    labelFormatter={(label: string) => `Dia ${label}`}
                    labelStyle={{ color: 'black' }}
                  />
                  <Line 
                    type="monotone" 
                    dataKey="revenue" 
                    stroke="#10b981" 
                    strokeWidth={3}
                    dot={{ fill: '#10b981', strokeWidth: 2, r: 4 }}
                    activeDot={{ r: 6, stroke: '#10b981', strokeWidth: 2 }}
                  />
                </LineChart>
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