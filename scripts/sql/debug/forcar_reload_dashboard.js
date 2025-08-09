// Script para forçar reload do Dashboard e limpar cache
// Execute este script no console do navegador

console.log('=== FORÇANDO RELOAD DO DASHBOARD ===');

// 1. Limpar cache do localStorage
localStorage.clear();
console.log('Cache do localStorage limpo');

// 2. Limpar cache do sessionStorage
sessionStorage.clear();
console.log('Cache do sessionStorage limpo');

// 3. Forçar reload da página
window.location.reload(true);
console.log('Página recarregada forçadamente');

// 4. Verificar se o Supabase está conectado
if (window.supabase) {
  console.log('Supabase está disponível');
} else {
  console.log('Supabase não está disponível');
}

// 5. Verificar dados do usuário
const user = JSON.parse(localStorage.getItem('supabase.auth.token') || '{}');
console.log('Dados do usuário:', user);

// 6. Testar conexão com Supabase
async function testSupabaseConnection() {
  try {
    const { data, error } = await supabase
      .from('transactions')
      .select('count')
      .eq('user_id', '2dc520e3-5f19-4dfe-838b-1aca7238ae36')
      .limit(1);
    
    if (error) {
      console.error('Erro na conexão com Supabase:', error);
    } else {
      console.log('Conexão com Supabase OK');
    }
  } catch (err) {
    console.error('Erro ao testar conexão:', err);
  }
}

// Executar teste de conexão
testSupabaseConnection(); 