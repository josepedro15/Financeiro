import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate, useLocation } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { useDeviceInfo } from '@/hooks/use-mobile';
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
  BarChart3,
  Settings,
  Database,
  ChevronDown,
  Crown,
  Clock,
  AlertTriangle,
  Shield,
  RefreshCw,
  LogOut,
  Home,
  BarChart
} from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart as RechartsBarChart, Bar, Area } from 'recharts';
import NotificationCenter from '@/components/NotificationCenter';
import { Breadcrumbs } from '@/components/ui/breadcrumbs';
import { EnhancedCard, MetricCard, StatsCard } from '@/components/ui/enhanced-card';
import { EnhancedButton, GradientButton } from '@/components/ui/enhanced-button';
import { LoadingSpinner, SkeletonCard } from '@/components/ui/loading-spinner';
import { useToast } from '@/hooks/use-toast';

interface DataSource {
  id: string;
  email: string;
  name: string;
  isOwner: boolean;
}

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
  const { 
    isMasterUser, 
    isTrialActive, 
    getTrialDaysLeft, 
    getPlanName, 
    currentPlan,
    currentTransactions,
    transactionLimit,
    loading: subscriptionLoading 
  } = useSubscription();
  const navigate = useNavigate();
  const location = useLocation();
  const { isMobile, isTablet } = useDeviceInfo();
  const { toast } = useToast();
  
  const [dataSources, setDataSources] = useState<DataSource[]>([]);
  const [selectedDataSource, setSelectedDataSource] = useState<string>('');
  const [loadingDataSources, setLoadingDataSources] = useState(true);
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
  const [trialDaysLeft, setTrialDaysLeft] = useState<number>(0);

  // Breadcrumbs
  const breadcrumbItems = [
    { label: 'Dashboard', href: '/dashboard' }
  ];

  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadData();
  }, [user, navigate]);

  useEffect(() => {
    if (isTrialActive()) {
      setTrialDaysLeft(getTrialDaysLeft());
    }
  }, [isTrialActive, getTrialDaysLeft]);

  const loadData = async () => {
    if (!user) return;

    try {
      setLoading(true);
      
      // Carregar fontes de dados
      await loadDataSources();
      
      // Carregar dados financeiros
      await loadFinancialData();
      
      setLastUpdate(new Date());
    } catch (error) {
      console.error('Erro ao carregar dados:', error);
      toast({
        title: "Erro",
        description: "Erro ao carregar dados do dashboard",
        variant: "destructive"
      });
    } finally {
      setLoading(false);
    }
  };

  const loadDataSources = async () => {
    if (!user) return;
    
    setLoadingDataSources(true);
    
    try {
      const sources: DataSource[] = [];
      
      // Adicionar fonte própria
      sources.push({
        id: user.id,
        email: user.email || '',
        name: 'Meus dados',
        isOwner: true
      });
      
      // Buscar organizações onde sou membro (posso ver dados de outros)
      const { data: memberOf, error: memberError } = await supabase
        .rpc('get_organization_members', { 
          user_member_id: user.id 
        });
      
      if (!memberError && memberOf && Array.isArray(memberOf)) {
        for (const org of memberOf) {
          // Buscar email do owner separadamente usando RPC também
          const { data: ownerProfile, error: ownerError } = await supabase
            .rpc('get_profile_email', { user_profile_id: org.owner_id });
          
          if (!ownerError && ownerProfile) {
            sources.push({
              id: org.owner_id,
              email: ownerProfile,
              name: `Dados de ${ownerProfile}`,
              isOwner: false
            });
          }
        }
      }
      
      // Buscar organizações onde sou owner (outros podem ver meus dados)
      const { data: ownerOf, error: ownerError } = await supabase
        .from('organization_members')
        .select(`
          member_id,
          profiles!organization_members_member_id_fkey(email)
        `)
        .eq('owner_id', user.id)
        .eq('status', 'active');
      
      if (!ownerError && ownerOf) {
        for (const member of ownerOf) {
          if (member.profiles && member.profiles.email) {
            sources.push({
              id: member.member_id,
              email: member.profiles.email,
              name: `Dados compartilhados com ${member.profiles.email}`,
              isOwner: true
            });
          }
        }
      }
      
      setDataSources(sources);
      
      // Selecionar a primeira fonte (próprios dados) por padrão
      if (sources.length > 0 && !selectedDataSource) {
        setSelectedDataSource(sources[0].id);
      }
      
    } catch (error) {
      console.error('Erro ao carregar fontes de dados:', error);
    } finally {
      setLoadingDataSources(false);
    }
  };

  const loadFinancialData = async () => {
    if (!user) return;
    
    const dataSourceToUse = selectedDataSource || user.id;

    try {
      console.log('=== CARREGANDO DADOS FINANCEIROS (VERSÃO AGRESSIVA) ===');
      console.log('User ID:', user.id);
      console.log('Selected Data Source:', selectedDataSource);
      console.log('Data Source to Use:', dataSourceToUse);
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
            .eq('user_id', dataSourceToUse);

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
          
          // Adicionar dados mensais para gráfico (todas as contas)
          monthlyRevenue.push({
            month: monthInfo.month,
            revenue: monthIncomeTotal
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

      // Buscar transações recentes de todas as tabelas (principal + mensais)
      let recentTransactions: any[] = [];
      
      try {
        // Buscar da tabela principal
        const { data: mainRecentData, error: mainRecentError } = await supabase
          .from('transactions')
          .select('*')
          .eq('user_id', dataSourceToUse)
          .order('created_at', { ascending: false })
          .limit(10);

        if (mainRecentError) {
          console.warn('Erro ao carregar transações recentes da tabela principal:', mainRecentError);
        } else if (mainRecentData) {
          recentTransactions = [...recentTransactions, ...mainRecentData];
        }

        // Buscar das tabelas mensais (últimos 3 meses)
        const currentDate = new Date();
        const currentMonth = currentDate.getMonth() + 1;
        const currentYear = currentDate.getFullYear();
        
        // Buscar dos últimos 3 meses
        for (let i = 0; i < 3; i++) {
          const targetMonth = currentMonth - i;
          const targetYear = targetMonth <= 0 ? currentYear - 1 : currentYear;
          const actualMonth = targetMonth <= 0 ? targetMonth + 12 : targetMonth;
          
          const monthTable = `transactions_${targetYear}_${String(actualMonth).padStart(2, '0')}`;
          
          try {
            const { data: monthRecentData, error: monthRecentError } = await supabase
              .from(monthTable)
              .select('*')
              .eq('user_id', dataSourceToUse)
              .order('created_at', { ascending: false })
              .limit(5);

            if (monthRecentError) {
              console.warn(`Erro ao carregar transações recentes de ${monthTable}:`, monthRecentError);
            } else if (monthRecentData) {
              recentTransactions = [...recentTransactions, ...monthRecentData];
            }
          } catch (error) {
            console.warn(`Erro ao consultar tabela ${monthTable}:`, error);
          }
        }

        // Ordenar por data de criação (mais recentes primeiro) e pegar apenas as 5 mais recentes
        recentTransactions.sort((a, b) => 
          new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
        );
        
        recentTransactions = recentTransactions.slice(0, 5);
        
        console.log('Total recent transactions loaded:', recentTransactions.length);
        console.log('Recent transactions ordered by created_at:');
        recentTransactions.forEach((transaction, index) => {
          console.log(`${index + 1}. ${transaction.description || 'Sem descrição'} - Criado em: ${transaction.created_at} - Data transação: ${transaction.transaction_date}`);
        });
        
      } catch (error) {
        console.error('Erro ao carregar transações recentes:', error);
      }


      // DEBUG: Verificar dados carregados das tabelas mensais
      console.log('=== DEBUG TABELAS MENSAIS ===');
      console.log('Total all transactions loaded:', allTransactionsData.length);
      console.log('Total income transactions loaded:', incomeOnlyData.length);
      console.log('Total recent transactions loaded:', recentTransactions.length);
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
          .eq('user_id', dataSourceToUse)
          .eq('transaction_type', 'income');

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
          .eq('user_id', dataSourceToUse)
          .eq('transaction_type', 'income')
          .lte('transaction_date', `${todayYear}-${String(todayMonth).padStart(2, '0')}-${String(currentDay).padStart(2, '0')}`);

        // Buscar dados acumulados até o mesmo dia no mês anterior
        const previousMonthTable = `transactions_${previousYear}_${String(previousMonth).padStart(2, '0')}`;
        const { data: previousMonthData, error: previousError } = await supabase
          .from(previousMonthTable)
          .select('transaction_date, amount')
          .eq('user_id', dataSourceToUse)
          .eq('transaction_type', 'income')
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
        recentTransactions: recentTransactions,
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

  const formatPercentage = (value: number) => {
    return `${value.toFixed(1)}%`;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-6">
          <Breadcrumbs items={breadcrumbItems} />
          
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">
            {[...Array(8)].map((_, i) => (
              <SkeletonCard key={i} lines={3} className="h-32" />
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6 space-y-6">
        {/* Header com Breadcrumbs */}
        <div className="space-y-4">
          <Breadcrumbs items={breadcrumbItems} />
          
          {/* Header do Dashboard */}
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-2xl sm:text-3xl font-bold tracking-tight">
                Dashboard Financeiro
              </h1>
              <p className="text-muted-foreground">
                Última atualização: {lastUpdate.toLocaleTimeString('pt-BR')}
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
              
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<Plus className="w-4 h-4" />}
                onClick={() => navigate('/transactions')}
              >
                Nova Transação
              </EnhancedButton>
            </div>
          </div>
        </div>

        {/* Sistema de Notificações */}
        <NotificationCenter />

        {/* Trial Banner */}
        {isTrialActive() && (
          <EnhancedCard
            variant="gradient"
            className="border-yellow-200 bg-gradient-to-r from-yellow-50 to-orange-50 dark:from-yellow-900/20 dark:to-orange-900/20"
          >
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Clock className="w-5 h-5 text-yellow-600" />
                <div>
                  <h3 className="font-medium text-yellow-800 dark:text-yellow-200">
                    Período de Teste Ativo
                  </h3>
                  <p className="text-sm text-yellow-700 dark:text-yellow-300">
                    {trialDaysLeft} dias restantes no seu teste gratuito
                  </p>
                </div>
              </div>
              <GradientButton
                gradient="warning"
                size="sm"
                onClick={() => navigate('/plans')}
              >
                Escolher Plano
              </GradientButton>
            </div>
          </EnhancedCard>
        )}

        {/* Cards de Métricas Principais */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">
          <MetricCard
            title="Receita Total"
            value={formatCurrency(financialData.totalIncome)}
            icon={<DollarSign className="w-5 h-5 text-green-600" />}
            trend="up"
            change={{ value: 12.5, type: 'increase' }}
          />
          
          <MetricCard
            title="Despesas Totais"
            value={formatCurrency(financialData.totalExpenses)}
            icon={<TrendingDown className="w-5 h-5 text-red-600" />}
            trend="down"
            change={{ value: 8.3, type: 'decrease' }}
          />
          
          <MetricCard
            title="Saldo PJ"
            value={formatCurrency(financialData.balancePJ)}
            icon={<CreditCard className="w-5 h-5 text-blue-600" />}
            trend="up"
            change={{ value: 5.7, type: 'increase' }}
          />
          
          <MetricCard
            title="Saldo Checkout"
            value={formatCurrency(financialData.balanceCheckout)}
            icon={<PiggyBank className="w-5 h-5 text-purple-600" />}
            trend="neutral"
          />
        </div>

        {/* Cards de Indicadores Avançados */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 lg:gap-6">
          <StatsCard
            title="Indicadores de Performance"
            stats={[
              { label: 'Ticket Médio', value: formatCurrency(financialData.ticketMedio) },
              { label: 'Lucro Líquido', value: formatCurrency(financialData.lucroLiquido) },
              { label: 'Margem de Lucro', value: formatPercentage(financialData.margemLucro) },
              { label: 'Crescimento Mensal', value: formatPercentage(financialData.crescimentoMensal) },
            ]}
            icon={<Calculator className="w-5 h-5" />}
          />
        </div>

        {/* Gráficos */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Gráfico de Receita Mensal */}
          <EnhancedCard
            title="Receita Mensal"
            description="Evolução da receita nos últimos 6 meses"
            icon={<BarChart3 className="w-5 h-5" />}
            variant="elevated"
          >
            <div className="h-64 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={financialData.monthlyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" className="opacity-30" />
                  <XAxis 
                    dataKey="month" 
                    className="text-xs sm:text-sm"
                    tick={{ fontSize: 12 }}
                  />
                  <YAxis 
                    className="text-xs sm:text-sm"
                    tick={{ fontSize: 12 }}
                    tickFormatter={(value) => `R$ ${value / 1000}k`}
                  />
                  <Tooltip 
                    contentStyle={{
                      backgroundColor: 'hsl(var(--background))',
                      border: '1px solid hsl(var(--border))',
                      borderRadius: '8px'
                    }}
                    formatter={(value: any) => [formatCurrency(value), 'Receita']}
                  />
                  <Line 
                    type="monotone" 
                    dataKey="revenue" 
                    stroke="hsl(var(--primary))" 
                    strokeWidth={2}
                    dot={{ fill: 'hsl(var(--primary))', strokeWidth: 2, r: 4 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </EnhancedCard>

          {/* Gráfico de Receita Diária */}
          <EnhancedCard
            title="Receita Diária"
            description="Receita por dia da semana"
            icon={<BarChart className="w-5 h-5" />}
            variant="elevated"
          >
            <div className="h-64 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <RechartsBarChart data={financialData.dailyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" className="opacity-30" />
                  <XAxis 
                    dataKey="day" 
                    className="text-xs sm:text-sm"
                    tick={{ fontSize: 12 }}
                  />
                  <YAxis 
                    className="text-xs sm:text-sm"
                    tick={{ fontSize: 12 }}
                    tickFormatter={(value) => `R$ ${value / 1000}k`}
                  />
                  <Tooltip 
                    contentStyle={{
                      backgroundColor: 'hsl(var(--background))',
                      border: '1px solid hsl(var(--border))',
                      borderRadius: '8px'
                    }}
                    formatter={(value: any) => [formatCurrency(value), 'Receita']}
                  />
                  <Bar 
                    dataKey="revenue" 
                    fill="hsl(var(--primary))" 
                    radius={[4, 4, 0, 0]}
                  />
                </RechartsBarChart>
              </ResponsiveContainer>
            </div>
          </EnhancedCard>
        </div>

        {/* Transações Recentes */}
        <EnhancedCard
          title="Transações Recentes"
          description="Últimas transações registradas"
          icon={<Database className="w-5 h-5" />}
          action={{
            label: 'Ver Todas',
            onClick: () => navigate('/transactions'),
            variant: 'outline'
          }}
        >
          <div className="space-y-3">
            {financialData.recentTransactions.map((transaction) => (
              <div
                key={transaction.id}
                className="flex items-center justify-between p-3 rounded-lg border hover:bg-muted/50 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <div className={`
                    p-2 rounded-full
                    ${transaction.transaction_type === 'income' 
                      ? 'bg-green-100 text-green-600 dark:bg-green-900/20 dark:text-green-400'
                      : 'bg-red-100 text-red-600 dark:bg-red-900/20 dark:text-red-400'
                    }
                  `}>
                    {transaction.transaction_type === 'income' ? (
                      <ArrowUpRight className="w-4 h-4" />
                    ) : (
                      <ArrowDownRight className="w-4 h-4" />
                    )}
                  </div>
                  <div>
                    <p className="font-medium">{transaction.description}</p>
                    <p className="text-sm text-muted-foreground">
                      {new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}
                    </p>
                  </div>
                </div>
                <div className={`
                  font-medium
                  ${transaction.transaction_type === 'income' ? 'text-green-600' : 'text-red-600'}
                `}>
                  {formatCurrency(Math.abs(transaction.amount))}
                </div>
              </div>
            ))}
          </div>
        </EnhancedCard>

        {/* Informações da Assinatura */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <EnhancedCard
            title="Plano Atual"
            description={`Você está no plano ${getPlanName(currentPlan)}`}
            icon={<Crown className="w-5 h-5" />}
            variant="outlined"
          >
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Transações este mês</span>
                <span className="font-medium">
                  {currentTransactions} / {transactionLimit || '∞'}
                </span>
              </div>
              
              {transactionLimit && (
                <div className="w-full bg-muted rounded-full h-2">
                  <div 
                    className="bg-primary h-2 rounded-full transition-all duration-300"
                    style={{ 
                      width: `${Math.min((currentTransactions / transactionLimit) * 100, 100)}%` 
                    }}
                  />
                </div>
              )}
              
              <EnhancedButton
                variant="outline"
                size="sm"
                onClick={() => navigate('/subscription')}
                fullWidth
              >
                Gerenciar Assinatura
              </EnhancedButton>
            </div>
          </EnhancedCard>

          <EnhancedCard
            title="Ações Rápidas"
            description="Acesse rapidamente as principais funcionalidades"
            icon={<Settings className="w-5 h-5" />}
            variant="outlined"
          >
            <div className="grid grid-cols-2 gap-3">
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<Plus className="w-4 h-4" />}
                onClick={() => navigate('/transactions')}
                fullWidth
              >
                Nova Transação
              </EnhancedButton>
              
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<Users className="w-4 h-4" />}
                onClick={() => navigate('/clients')}
                fullWidth
              >
                Gerenciar Clientes
              </EnhancedButton>
              
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<BarChart3 className="w-4 h-4" />}
                onClick={() => navigate('/reports')}
                fullWidth
              >
                Relatórios
              </EnhancedButton>
              
              <EnhancedButton
                variant="outline"
                size="sm"
                icon={<LogOut className="w-4 h-4" />}
                onClick={signOut}
                fullWidth
              >
                Sair
              </EnhancedButton>
            </div>
          </EnhancedCard>
        </div>
      </div>
    </div>
  );
}