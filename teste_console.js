// =====================================================
// TESTE DIRETO NO CONSOLE DO NAVEGADOR
// =====================================================

console.log('🚀 ==========================================');
console.log('🚀 TESTE DIRETO NO CONSOLE');
console.log('🚀 ==========================================');

// 1. Verificar se o Supabase está disponível
if (typeof window !== 'undefined' && window.supabase) {
    console.log('✅ Supabase disponível no window');
} else {
    console.log('❌ Supabase não encontrado no window');
}

// 2. Verificar se há uma sessão ativa
async function testarSessao() {
    try {
        console.log('🔍 Testando sessão...');
        
        // Tentar acessar o cliente Supabase
        const { data: session, error } = await window.supabase.auth.getSession();
        
        if (error) {
            console.error('❌ Erro ao obter sessão:', error);
            return;
        }
        
        if (session.session) {
            console.log('✅ Sessão ativa:', session.session.user.email);
            console.log('👤 ID do usuário:', session.session.user.id);
            
            // 3. Testar operação básica
            await testarOperacaoBasica(session.session.user.id);
        } else {
            console.log('❌ Nenhuma sessão ativa');
        }
    } catch (error) {
        console.error('❌ Erro no teste de sessão:', error);
    }
}

// 3. Testar operação básica
async function testarOperacaoBasica(userId) {
    try {
        console.log('🔍 Testando operação básica...');
        
        // Tentar fazer um SELECT simples
        const { data, error } = await window.supabase
            .from('clients')
            .select('id, name, stage')
            .limit(1);
        
        if (error) {
            console.error('❌ Erro na operação SELECT:', error);
            return;
        }
        
        console.log('✅ SELECT funcionou:', data);
        
        // 4. Testar UPDATE
        if (data && data.length > 0) {
            await testarUpdate(data[0].id);
        }
        
    } catch (error) {
        console.error('❌ Erro no teste de operação:', error);
    }
}

// 4. Testar UPDATE
async function testarUpdate(clientId) {
    try {
        console.log('🔍 Testando UPDATE...');
        
        const { data, error } = await window.supabase
            .from('clients')
            .update({ updated_at: new Date().toISOString() })
            .eq('id', clientId)
            .select('id, name, updated_at');
        
        if (error) {
            console.error('❌ Erro na operação UPDATE:', error);
            return;
        }
        
        console.log('✅ UPDATE funcionou:', data);
        
    } catch (error) {
        console.error('❌ Erro no teste de UPDATE:', error);
    }
}

// 5. Função para testar DELETE (soft delete)
async function testarDelete(clientId) {
    try {
        console.log('🔍 Testando DELETE (soft)...');
        
        const { data, error } = await window.supabase
            .from('clients')
            .update({ is_active: false })
            .eq('id', clientId)
            .select('id, name, is_active');
        
        if (error) {
            console.error('❌ Erro na operação DELETE:', error);
            return;
        }
        
        console.log('✅ DELETE funcionou:', data);
        
        // Reativar o cliente
        await window.supabase
            .from('clients')
            .update({ is_active: true })
            .eq('id', clientId);
        
        console.log('✅ Cliente reativado');
        
    } catch (error) {
        console.error('❌ Erro no teste de DELETE:', error);
    }
}

// Executar o teste
console.log('🚀 Iniciando testes...');
testarSessao();

console.log('📋 Para testar DELETE manualmente, execute:');
console.log('testarDelete("ID_DO_CLIENTE")');
console.log('🚀 ==========================================');
