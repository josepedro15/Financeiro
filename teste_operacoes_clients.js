// =====================================================
// TESTE DAS OPERAÇÕES CLIENTS NO FRONTEND
// =====================================================

console.log('🚀 INICIANDO TESTE DAS OPERAÇÕES CLIENTS');

// 1. Verificar se o Supabase está disponível
console.log('📡 Verificando Supabase...');
if (typeof window.supabase === 'undefined') {
    console.error('❌ Supabase não encontrado no window');
    console.log('🔍 Tentando encontrar em outras variáveis...');
    
    // Tentar encontrar o cliente Supabase
    const possibleSupabase = window.supabase || 
                           window.Supabase || 
                           document.querySelector('[data-supabase]') ||
                           null;
    
    if (possibleSupabase) {
        console.log('✅ Supabase encontrado:', possibleSupabase);
    } else {
        console.error('❌ Supabase não encontrado em nenhum lugar');
        console.log('💡 Verifique se a página está carregada completamente');
        return;
    }
}

// 2. Verificar autenticação
console.log('🔐 Verificando autenticação...');
async function verificarAuth() {
    try {
        const { data: { session }, error } = await supabase.auth.getSession();
        
        if (error) {
            console.error('❌ Erro ao verificar sessão:', error);
            return null;
        }
        
        if (!session) {
            console.error('❌ Nenhuma sessão ativa');
            return null;
        }
        
        console.log('✅ Usuário autenticado:', session.user.email);
        console.log('🆔 User ID:', session.user.id);
        return session.user;
    } catch (error) {
        console.error('❌ Erro ao verificar autenticação:', error);
        return null;
    }
}

// 3. Testar carregamento de clientes
async function testarCarregamentoClientes(user) {
    console.log('📋 Testando carregamento de clientes...');
    
    try {
        const { data: clients, error } = await supabase
            .from('clients')
            .select('*')
            .eq('user_id', user.id)
            .eq('is_active', true)
            .order('created_at', { ascending: false });
        
        if (error) {
            console.error('❌ Erro ao carregar clientes:', error);
            return null;
        }
        
        console.log('✅ Clientes carregados:', clients?.length || 0);
        console.log('📊 Primeiros 3 clientes:', clients?.slice(0, 3));
        
        return clients;
    } catch (error) {
        console.error('❌ Erro ao carregar clientes:', error);
        return null;
    }
}

// 4. Testar operação de delete
async function testarDelete(clientId, user) {
    console.log('🗑️ Testando delete do cliente:', clientId);
    
    try {
        // Primeiro, verificar o cliente
        const { data: client, error: fetchError } = await supabase
            .from('clients')
            .select('*')
            .eq('id', clientId)
            .single();
        
        if (fetchError) {
            console.error('❌ Erro ao buscar cliente:', fetchError);
            return false;
        }
        
        console.log('📋 Cliente antes do delete:', client);
        
        // Fazer soft delete
        const { error: updateError } = await supabase
            .from('clients')
            .update({
                is_active: false,
                updated_at: new Date().toISOString()
            })
            .eq('id', clientId);
        
        if (updateError) {
            console.error('❌ Erro no delete:', updateError);
            return false;
        }
        
        console.log('✅ Cliente deletado com sucesso');
        
        // Verificar se foi deletado
        const { data: clientAfter, error: checkError } = await supabase
            .from('clients')
            .select('*')
            .eq('id', clientId)
            .single();
        
        if (checkError) {
            console.error('❌ Erro ao verificar cliente após delete:', checkError);
            return false;
        }
        
        console.log('📋 Cliente após delete:', clientAfter);
        return true;
        
    } catch (error) {
        console.error('❌ Erro no teste de delete:', error);
        return false;
    }
}

// 5. Testar operação de update
async function testarUpdate(clientId, user) {
    console.log('✏️ Testando update do cliente:', clientId);
    
    try {
        const updateData = {
            name: 'TESTE UPDATE ' + new Date().toISOString(),
            updated_at: new Date().toISOString()
        };
        
        const { error } = await supabase
            .from('clients')
            .update(updateData)
            .eq('id', clientId);
        
        if (error) {
            console.error('❌ Erro no update:', error);
            return false;
        }
        
        console.log('✅ Cliente atualizado com sucesso');
        return true;
        
    } catch (error) {
        console.error('❌ Erro no teste de update:', error);
        return false;
    }
}

// 6. Função principal de teste
async function executarTestes() {
    console.log('🧪 EXECUTANDO TESTES COMPLETOS...');
    
    // Verificar autenticação
    const user = await verificarAuth();
    if (!user) {
        console.error('❌ Teste cancelado: usuário não autenticado');
        return;
    }
    
    // Carregar clientes
    const clients = await testarCarregamentoClientes(user);
    if (!clients || clients.length === 0) {
        console.error('❌ Teste cancelado: nenhum cliente encontrado');
        return;
    }
    
    // Testar delete no primeiro cliente
    const primeiroCliente = clients[0];
    console.log('🎯 Testando com cliente:', primeiroCliente.name);
    
    const deleteSucesso = await testarDelete(primeiroCliente.id, user);
    console.log('🗑️ Resultado do delete:', deleteSucesso ? '✅ SUCESSO' : '❌ FALHOU');
    
    // Testar update no segundo cliente (se existir)
    if (clients.length > 1) {
        const segundoCliente = clients[1];
        console.log('🎯 Testando update com cliente:', segundoCliente.name);
        
        const updateSucesso = await testarUpdate(segundoCliente.id, user);
        console.log('✏️ Resultado do update:', updateSucesso ? '✅ SUCESSO' : '❌ FALHOU');
    }
    
    console.log('🏁 TESTES CONCLUÍDOS');
}

// 7. Executar testes automaticamente
console.log('⏰ Executando testes em 2 segundos...');
setTimeout(executarTestes, 2000);

// 8. Função para executar manualmente
window.testarOperacoesClients = executarTestes;
console.log('💡 Para executar manualmente, use: testarOperacoesClients()');
