// Script para forçar atualização do Dashboard
// Execute este script no console do navegador (F12)

console.log('=== FORÇANDO ATUALIZAÇÃO DO DASHBOARD ===');

// 1. Limpar cache do localStorage
localStorage.clear();
console.log('✅ Cache do localStorage limpo');

// 2. Limpar cache do sessionStorage
sessionStorage.clear();
console.log('✅ Cache do sessionStorage limpo');

// 3. Forçar reload da página
console.log('🔄 Recarregando página...');
window.location.reload(true);

// 4. Se não recarregar automaticamente, execute manualmente:
// window.location.reload(true);

console.log('=== ATUALIZAÇÃO CONCLUÍDA ===');
console.log('Se a página não recarregou automaticamente, execute: window.location.reload(true)'); 