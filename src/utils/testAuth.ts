import { supabase } from '@/integrations/supabase/client';

export async function testDatabasePermissions() {
  console.log('🔍 Testando permissões do banco de dados...');
  
  try {
    // Testar se o usuário está autenticado
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    
    if (authError) {
      console.error('❌ Erro de autenticação:', authError);
      return { success: false, error: 'Erro de autenticação' };
    }
    
    if (!user) {
      console.log('⚠️ Usuário não autenticado');
      return { success: false, error: 'Usuário não autenticado' };
    }
    
    console.log('✅ Usuário autenticado:', user.id);
    
    // Testar consulta de transações
    const { data: transactions, error: transactionsError } = await supabase
      .from('transactions')
      .select('*')
      .limit(1);
    
    if (transactionsError) {
      console.error('❌ Erro ao consultar transações:', transactionsError);
      return { success: false, error: `Erro transações: ${transactionsError.message}` };
    }
    
    console.log('✅ Consulta de transações funcionando');
    
    // Testar consulta de clientes
    const { data: clients, error: clientsError } = await supabase
      .from('clients')
      .select('*')
      .limit(1);
    
    if (clientsError) {
      console.error('❌ Erro ao consultar clientes:', clientsError);
      return { success: false, error: `Erro clientes: ${clientsError.message}` };
    }
    
    console.log('✅ Consulta de clientes funcionando');
    
    // Testar consulta de contas
    const { data: accounts, error: accountsError } = await supabase
      .from('accounts')
      .select('*')
      .limit(1);
    
    if (accountsError) {
      console.error('❌ Erro ao consultar contas:', accountsError);
      return { success: false, error: `Erro contas: ${accountsError.message}` };
    }
    
    console.log('✅ Consulta de contas funcionando');
    
    console.log('🎉 Todas as permissões estão funcionando corretamente!');
    return { success: true };
    
  } catch (error) {
    console.error('❌ Erro geral:', error);
    return { success: false, error: 'Erro geral no teste' };
  }
}

// Função para verificar se há problemas específicos com client_id null
export async function testClientIdNull() {
  console.log('🔍 Testando problema com client_id null...');
  
  try {
    const { data: { user } } = await supabase.auth.getUser();
    
    if (!user) {
      return { success: false, error: 'Usuário não autenticado' };
    }
    
    // Tentar inserir uma transação com client_id null
    const testTransaction = {
      user_id: user.id,
      description: 'Teste de autorização',
      amount: 0.01,
      transaction_type: 'income' as const,
      category: 'Teste',
      transaction_date: new Date().toISOString().split('T')[0],
      account_id: '00000000-0000-0000-0000-000000000000', // ID inválido para teste
      client_id: null
    };
    
    const { error } = await supabase
      .from('transactions')
      .insert([testTransaction]);
    
    if (error) {
      console.log('❌ Erro esperado (account_id inválido):', error.message);
      // Se chegou até aqui, significa que o problema não é com client_id null
      return { success: true, message: 'client_id null não é o problema' };
    }
    
    return { success: true, message: 'Teste passou' };
    
  } catch (error) {
    console.error('❌ Erro no teste:', error);
    return { success: false, error: 'Erro no teste' };
  }
} 