import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { useSubscription } from '@/hooks/useSubscription';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
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
  LogOut
} from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar, Area } from 'recharts';
import NotificationCenter from '@/components/NotificationCenter';

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


  useEffect(() => {
    if (!user) {
      navigate('/auth');
      return;
    }
    loadDataSources();
  }, [user, navigate]);

  useEffect(() => {
    if (selectedDataSource) {
      loadFinancialData();
    }
  }, [selectedDataSource]);

  // Forçar atualização a cada 30 segundos
  useEffect(() => {
    if (!user) return;
    
    const interval = setInterval(() => {
      console.log('=== ATUALIZAÇÃO AUTOMÁTICA ===');
      loadFinancialData();
    }, 30000); // 30 segundos
    
    return () => clearInterval(interval);
  }, [user]);

  // Atualizar contador de dias do trial a cada minuto
  useEffect(() => {
    if (!isMasterUser && isTrialActive()) {
      const updateTrialDays = () => {
        const daysLeft = getTrialDaysLeft();
        setTrialDaysLeft(daysLeft);
      };

      // Atualizar imediatamente
      updateTrialDays();

      // Atualizar a cada minuto
      const interval = setInterval(updateTrialDays, 60000); // 1 minuto

      return () => clearInterval(interval);
    }
  }, [isMasterUser, isTrialActive, getTrialDaysLeft]);

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
      <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-md border-b border-slate-200/50 shadow-sm">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-between">
            {/* Logo */}
            <div className="flex items-center space-x-3">
              <Button 
                variant="ghost" 
                className="p-0 h-auto hover:bg-transparent"
                onClick={() => navigate('/')}
              >
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center shadow-lg">
                    <DollarSign className="w-5 h-5 text-white" />
                  </div>
                  <h1 className="text-xl font-bold bg-gradient-to-r from-slate-800 to-slate-600 bg-clip-text text-transparent">
                    FinanceiroLogotiq
                  </h1>
                </div>
              </Button>
            </div>
            
            {/* Controles */}
            <div className="flex items-center space-x-3">
              {/* Seletor de Fonte de Dados */}
              {dataSources.length >= 1 && (
                <div className="hidden md:flex items-center space-x-2">
                  <Database className="h-4 w-4 text-slate-600" />
                  <Select value={selectedDataSource} onValueChange={setSelectedDataSource}>
                    <SelectTrigger className="w-48 bg-white/50 backdrop-blur-sm border-slate-200">
                      <SelectValue placeholder="Selecionar fonte de dados" />
                    </SelectTrigger>
                    <SelectContent>
                      {dataSources.map((source) => (
                        <SelectItem key={source.id} value={source.id}>
                          <div className="flex items-center space-x-2">
                            <span>{source.name}</span>
                            {source.isOwner && source.id !== user.id && (
                              <span className="text-xs text-blue-600">(Compartilhado)</span>
                            )}
                            {!source.isOwner && (
                              <span className="text-xs text-green-600">(Organização)</span>
                            )}
                          </div>
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              )}
              
              {/* Botões de Navegação */}
              <div className="flex items-center space-x-2">
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={() => navigate('/clients')}
                  className="hidden sm:flex items-center space-x-1 hover:bg-blue-50 hover:text-blue-600 transition-colors"
                >
                  <Users className="w-4 h-4" />
                  <span>CRM</span>
                </Button>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={() => navigate('/settings')}
                  className="hidden sm:flex items-center space-x-1 hover:bg-slate-50 hover:text-slate-600 transition-colors"
                >
                  <Settings className="w-4 h-4" />
                  <span>Config</span>
                </Button>
                {isMasterUser && (
                  <Button 
                    variant="ghost" 
                    size="sm" 
                    onClick={() => navigate('/analytics')}
                    className="hidden sm:flex items-center space-x-1 hover:bg-purple-50 hover:text-purple-600 transition-colors"
                  >
                    <Shield className="w-4 h-4" />
                    <span>Analytics</span>
                  </Button>
                )}
                <Button 
                  variant="outline" 
                  size="sm" 
                  onClick={loadFinancialData}
                  className="hover:bg-green-50 hover:text-green-600 hover:border-green-200 transition-colors"
                >
                  <RefreshCw className="w-4 h-4" />
                </Button>
                <Button 
                  variant="outline" 
                  size="sm" 
                  onClick={signOut}
                  className="hover:bg-red-50 hover:text-red-600 hover:border-red-200 transition-colors"
                >
                  <LogOut className="w-4 h-4" />
                </Button>
              </div>
            </div>
          </div>
          
          {/* Mobile: Seletor de Fonte de Dados */}
          {dataSources.length >= 1 && (
            <div className="md:hidden mt-3">
              <div className="flex items-center space-x-2">
                <Database className="h-4 w-4 text-slate-600" />
                <Select value={selectedDataSource} onValueChange={setSelectedDataSource}>
                  <SelectTrigger className="w-full bg-white/50 backdrop-blur-sm border-slate-200">
                    <SelectValue placeholder="Selecionar fonte de dados" />
                  </SelectTrigger>
                  <SelectContent>
                    {dataSources.map((source) => (
                      <SelectItem key={source.id} value={source.id}>
                        <div className="flex items-center space-x-2">
                          <span>{source.name}</span>
                          {source.isOwner && source.id !== user.id && (
                            <span className="text-xs text-blue-600">(Compartilhado)</span>
                          )}
                          {!source.isOwner && (
                            <span className="text-xs text-green-600">(Organização)</span>
                          )}
                        </div>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
          )}
        </div>
      </header>

      {/* Subscription Status Banner */}
      {!isMasterUser && !subscriptionLoading && (
        <div className="bg-gradient-to-r from-slate-50 to-blue-50/30 border-b border-slate-200/50">
          <div className="container mx-auto px-4 py-4">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
              <div className="flex items-center space-x-4">
                {isTrialActive() ? (
                  <>
                    <div className="p-2 rounded-full bg-blue-100">
                      <Clock className="w-5 h-5 text-blue-600" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <p className="text-sm font-semibold text-slate-800">
                          Trial Gratuito - {trialDaysLeft} dias restantes
                        </p>
                        {trialDaysLeft <= 3 && trialDaysLeft > 0 && (
                          <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800 animate-pulse">
                            ⚠️ Acaba em breve!
                          </span>
                        )}
                      </div>
                      <p className="text-sm text-slate-600">
                        {trialDaysLeft <= 3 && trialDaysLeft > 0 
                          ? 'Seu trial está acabando! Faça upgrade para continuar usando.'
                          : 'Aproveite o período de teste para conhecer todas as funcionalidades'
                        }
                      </p>
                    </div>
                  </>
                ) : (
                  <>
                    <div className="p-2 rounded-full bg-green-100">
                      <Crown className="w-5 h-5 text-green-600" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-slate-800">
                        Plano {getPlanName(currentPlan)} Ativo
                      </p>
                      <p className="text-sm text-slate-600">
                        {currentTransactions} / {transactionLimit} transações utilizadas
                      </p>
                    </div>
                  </>
                )}
              </div>
              <div className="flex items-center space-x-3">
                <span 
                  className={`text-xs px-3 py-1 rounded-full border ${
                    isTrialActive() 
                      ? 'border-blue-200 text-blue-700 bg-blue-50' 
                      : 'border-green-200 text-green-700 bg-green-50'
                  }`}
                >
                  {isTrialActive() ? 'Trial' : getPlanName(currentPlan)}
                </span>
                <Button 
                  variant="outline" 
                  size="sm"
                  onClick={() => navigate('/subscription')}
                  className={`hover:bg-blue-50 hover:text-blue-600 hover:border-blue-200 transition-colors ${
                    isTrialActive() && trialDaysLeft <= 3 
                      ? 'bg-red-50 text-red-600 border-red-200 hover:bg-red-100' 
                      : ''
                  }`}
                >
                  <Crown className="w-4 h-4 mr-1" />
                  Assinatura
                </Button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        
        {/* Centro de Notificações */}
        <div className="mb-6">
          <NotificationCenter />
        </div>
        {/* Status de atualização */}
        <div className="mb-6 flex items-center justify-center">
          <div className="flex items-center space-x-2 px-4 py-2 bg-slate-50 rounded-full border border-slate-200">
            <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
            <p className="text-sm text-slate-600 font-medium">
              Última atualização: {lastUpdate.toLocaleTimeString('pt-BR')}
            </p>
          </div>
        </div>



        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-4 gap-4 sm:gap-6 mb-8">
          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Receita Total
              </CardTitle>
              <div className="p-2 rounded-full bg-green-100 group-hover:bg-green-200 transition-colors">
                <DollarSign className="h-5 w-5 text-green-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-slate-900 mb-2">
                {formatCurrency(financialData.totalIncome)}
              </div>
              <div className="flex items-center text-sm text-green-600">
                <TrendingUp className="h-4 w-4 mr-1" />
                +{formatCurrency(financialData.totalIncome - financialData.totalExpenses)} vs despesas
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Saldo em Caixa
              </CardTitle>
              <div className="p-2 rounded-full bg-blue-100 group-hover:bg-blue-200 transition-colors">
                <DollarSign className="h-5 w-5 text-blue-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-slate-900 mb-2">
                {formatCurrency(financialData.balancePJ + financialData.balanceCheckout)}
              </div>
              <div className="flex items-center text-sm text-blue-600">
                <CreditCard className="h-4 w-4 mr-1" />
                Soma das duas contas
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Conta 1
              </CardTitle>
              <div className="p-2 rounded-full bg-purple-100 group-hover:bg-purple-200 transition-colors">
                <CreditCard className="h-5 w-5 text-purple-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-slate-900 mb-2">
                {formatCurrency(financialData.balancePJ)}
              </div>
              <div className="flex items-center text-sm text-purple-600">
                <Shield className="h-4 w-4 mr-1" />
                Conta Pessoa Jurídica
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Conta 2
              </CardTitle>
              <div className="p-2 rounded-full bg-orange-100 group-hover:bg-orange-200 transition-colors">
                <CreditCard className="h-5 w-5 text-orange-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-slate-900 mb-2">
                {formatCurrency(financialData.balanceCheckout)}
              </div>
              <div className="flex items-center text-sm text-orange-600">
                <CreditCard className="h-4 w-4 mr-1" />
                Conta Checkout
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Novos Indicadores */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6 mb-8">
          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Ticket Médio
              </CardTitle>
              <div className="p-2 rounded-full bg-indigo-100 group-hover:bg-indigo-200 transition-colors">
                <Calculator className="h-5 w-5 text-indigo-600" />
              </div>
            </CardHeader>
            <CardContent>
              <div className="text-3xl font-bold text-slate-900 mb-2">
                {formatCurrency(financialData.ticketMedio)}
              </div>
              <div className="flex items-center text-sm text-indigo-600">
                <BarChart3 className="h-4 w-4 mr-1" />
                Por venda ({financialData.totalTransacoes} vendas)
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Lucro Líquido
              </CardTitle>
              <div className={`p-2 rounded-full transition-colors ${
                financialData.lucroLiquido >= 0 
                  ? 'bg-green-100 group-hover:bg-green-200' 
                  : 'bg-red-100 group-hover:bg-red-200'
              }`}>
                <PiggyBank className={`h-5 w-5 ${
                  financialData.lucroLiquido >= 0 ? 'text-green-600' : 'text-red-600'
                }`} />
              </div>
            </CardHeader>
            <CardContent>
              <div className={`text-3xl font-bold mb-2 ${
                financialData.lucroLiquido >= 0 ? 'text-green-600' : 'text-red-600'
              }`}>
                {formatCurrency(financialData.lucroLiquido)}
              </div>
              <div className="flex items-center text-sm text-slate-600">
                <Calculator className="h-4 w-4 mr-1" />
                Receita - Despesas (sem prolabore)
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Margem de Lucro
              </CardTitle>
              <div className={`p-2 rounded-full transition-colors ${
                financialData.margemLucro >= 0 
                  ? 'bg-emerald-100 group-hover:bg-emerald-200' 
                  : 'bg-red-100 group-hover:bg-red-200'
              }`}>
                <Percent className={`h-5 w-5 ${
                  financialData.margemLucro >= 0 ? 'text-emerald-600' : 'text-red-600'
                }`} />
              </div>
            </CardHeader>
            <CardContent>
              <div className={`text-3xl font-bold mb-2 ${
                financialData.margemLucro >= 0 ? 'text-emerald-600' : 'text-red-600'
              }`}>
                {financialData.margemLucro.toFixed(1)}%
              </div>
              <div className="flex items-center text-sm text-slate-600">
                <TrendingUp className="h-4 w-4 mr-1" />
                Eficiência financeira
              </div>
            </CardContent>
          </Card>

          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm hover:scale-[1.02]">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3">
              <CardTitle className="text-lg font-semibold text-slate-800 group-hover:text-blue-600 transition-colors">
                Crescimento Mensal
              </CardTitle>
              <div className={`p-2 rounded-full transition-colors ${
                financialData.crescimentoMensal >= 0 
                  ? 'bg-green-100 group-hover:bg-green-200' 
                  : 'bg-red-100 group-hover:bg-red-200'
              }`}>
                <BarChart3 className={`h-5 w-5 ${
                  financialData.crescimentoMensal >= 0 ? 'text-green-600' : 'text-red-600'
                }`} />
              </div>
            </CardHeader>
            <CardContent>
              <div className={`text-3xl font-bold flex items-center mb-2 ${
                financialData.crescimentoMensal >= 0 ? 'text-green-600' : 'text-red-600'
              }`}>
                {financialData.crescimentoMensal >= 0 ? (
                  <TrendingUp className="h-5 w-5 mr-2" />
                ) : (
                  <TrendingDown className="h-5 w-5 mr-2" />
                )}
                {Math.abs(financialData.crescimentoMensal).toFixed(1)}%
              </div>
              <div className="flex items-center text-sm text-slate-600">
                <Clock className="h-4 w-4 mr-1" />
                acumulado até hoje vs mês anterior
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6 mb-8">
          {/* Gráfico Mensal */}
          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
            <CardHeader className="pb-4">
              <CardTitle className="text-lg font-semibold text-slate-800 flex items-center gap-2">
                <BarChart3 className="h-5 w-5 text-blue-600" />
                Evolução Mensal - Todas as Contas
              </CardTitle>
              <CardDescription className="text-slate-600">
                Receita mensal total em 2025 (todas as contas)
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={window.innerWidth < 768 ? 250 : 300}>
                <BarChart data={financialData.monthlyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                  <XAxis 
                    dataKey="month" 
                    tick={{ fontSize: 12, fill: '#64748b' }}
                    axisLine={{ stroke: '#cbd5e1' }}
                  />
                  <YAxis 
                    tick={{ fontSize: 12, fill: '#64748b' }}
                    axisLine={{ stroke: '#cbd5e1' }}
                  />
                  <Tooltip 
                    formatter={(value: number) => [formatCurrency(value), 'Receita']}
                    labelStyle={{ color: 'black', fontWeight: 'bold' }}
                    contentStyle={{
                      backgroundColor: 'white',
                      border: '1px solid #e2e8f0',
                      borderRadius: '8px',
                      boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)'
                    }}
                  />
                  <Bar 
                    dataKey="revenue" 
                    fill="url(#blueGradient)"
                    radius={[4, 4, 0, 0]}
                  />
                  <defs>
                    <linearGradient id="blueGradient" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#3b82f6" />
                      <stop offset="100%" stopColor="#1d4ed8" />
                    </linearGradient>
                  </defs>
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          {/* Gráfico Diário do Mês Atual */}
          <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
            <CardHeader className="pb-4">
              <CardTitle className="text-lg font-semibold text-slate-800 flex items-center gap-2">
                <TrendingUp className="h-5 w-5 text-green-600" />
                Faturamento Diário - {financialData.currentMonth}
                <span className="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">
                  Mês Atual
                </span>
              </CardTitle>
              <CardDescription className="text-slate-600">
                {financialData.currentMonth ? 
                  `Receita diária total em ${financialData.currentMonth.toLowerCase()} 2025 - Total: ${formatCurrency(financialData.currentMonthRevenue)}` 
                  : 'Carregando dados do mês atual...'
                }
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={window.innerWidth < 768 ? 250 : 300}>
                <LineChart data={financialData.dailyRevenue}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                  <XAxis 
                    dataKey="day" 
                    tick={{ fontSize: 12, fill: '#64748b' }}
                    axisLine={{ stroke: '#cbd5e1' }}
                    label={{ 
                      value: 'Dia do Mês', 
                      position: 'insideBottom', 
                      offset: -5,
                      style: { fill: '#64748b', fontSize: 12 }
                    }}
                  />
                  <YAxis 
                    tick={{ fontSize: 12, fill: '#64748b' }}
                    axisLine={{ stroke: '#cbd5e1' }}
                  />
                  <Tooltip 
                    formatter={(value: number) => [formatCurrency(value), 'Faturamento']}
                    labelFormatter={(label: string) => `Dia ${label}`}
                    labelStyle={{ color: 'black', fontWeight: 'bold' }}
                    contentStyle={{
                      backgroundColor: 'white',
                      border: '1px solid #e2e8f0',
                      borderRadius: '8px',
                      boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)'
                    }}
                  />
                  <Line 
                    type="monotone" 
                    dataKey="revenue" 
                    stroke="url(#greenGradient)"
                    strokeWidth={3}
                    dot={{ 
                      fill: '#10b981', 
                      strokeWidth: 2, 
                      r: 4,
                      stroke: 'white'
                    }}
                    activeDot={{ 
                      r: 6, 
                      stroke: '#10b981', 
                      strokeWidth: 2,
                      fill: '#10b981'
                    }}
                  />
                  <defs>
                    <linearGradient id="greenGradient" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#10b981" />
                      <stop offset="100%" stopColor="#059669" />
                    </linearGradient>
                  </defs>
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </div>

        {/* Recent Transactions */}
        <Card className="group hover:shadow-lg transition-all duration-300 bg-gradient-to-br from-white to-slate-50/50 border-0 shadow-sm">
          <CardHeader className="pb-4">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
              <div>
                <CardTitle className="text-lg font-semibold text-slate-800 flex items-center gap-2">
                  <CreditCard className="h-5 w-5 text-blue-600" />
                  Transações Recentes
                </CardTitle>
                <CardDescription className="text-slate-600">
                  Últimas {financialData.recentTransactions.length} transações
                </CardDescription>
              </div>
              <div className="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-2">
                <Button 
                  variant="outline" 
                  size="sm"
                  onClick={() => navigate('/transactions')}
                  className="hover:bg-blue-50 hover:text-blue-600 hover:border-blue-200 transition-colors"
                >
                  Ver Todas
                </Button>
                <Button 
                  size="sm"
                  onClick={() => navigate('/transactions')}
                  className="flex items-center gap-1 bg-blue-600 hover:bg-blue-700 transition-colors"
                >
                  <Plus className="h-4 w-4" />
                  Nova Transação
                </Button>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            {financialData.recentTransactions.length === 0 ? (
              <div className="text-center py-12">
                <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <CreditCard className="h-8 w-8 text-slate-400" />
                </div>
                <p className="text-slate-600 mb-4 font-medium">
                  Nenhuma transação encontrada
                </p>
                <p className="text-slate-500 text-sm mb-6">
                  Comece adicionando sua primeira transação para ver os dados aqui
                </p>
                <Button 
                  onClick={() => navigate('/transactions')}
                  className="flex items-center gap-2 mx-auto bg-blue-600 hover:bg-blue-700 transition-colors"
                >
                  <Plus className="h-4 w-4" />
                  Criar Primeira Transação
                </Button>
              </div>
            ) : (
              <div className="space-y-3">
                {financialData.recentTransactions.map((transaction) => (
                  <div 
                    key={transaction.id} 
                    className="group/item flex items-center justify-between p-4 border border-slate-200 rounded-xl hover:bg-slate-50/50 hover:border-slate-300 transition-all duration-200 cursor-pointer"
                  >
                    <div className="flex items-center space-x-4">
                      <div className={`p-3 rounded-full transition-colors ${
                        transaction.transaction_type === 'income' 
                          ? 'bg-green-100 text-green-600 group-hover/item:bg-green-200' 
                          : 'bg-red-100 text-red-600 group-hover/item:bg-red-200'
                      }`}>
                        {transaction.transaction_type === 'income' ? (
                          <ArrowUpRight className="h-5 w-5" />
                        ) : (
                          <ArrowDownRight className="h-5 w-5" />
                        )}
                      </div>
                      <div>
                        <p className="font-semibold text-slate-800 group-hover/item:text-slate-900 transition-colors">
                          {transaction.description || 'Transação sem descrição'}
                        </p>
                        <div className="flex items-center space-x-2 mt-1">
                          <p className="text-sm text-slate-500">
                            {new Date(transaction.transaction_date).toLocaleDateString('pt-BR')}
                          </p>
                          <span className="text-xs text-slate-400">•</span>
                          <p className="text-xs text-slate-500 capitalize">
                            {transaction.transaction_type === 'income' ? 'Receita' : 'Despesa'}
                          </p>
                        </div>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className={`font-bold text-lg ${
                        transaction.transaction_type === 'income' 
                          ? 'text-green-600' 
                          : 'text-red-600'
                      }`}>
                        {transaction.transaction_type === 'income' ? '+' : '-'}
                        {formatCurrency(transaction.amount)}
                      </p>
                      <p className="text-xs text-slate-500 mt-1">
                        {transaction.account_name || 'Conta não especificada'}
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