// =====================================================
// TESTE SIMPLES DOS BOTÕES
// =====================================================

console.log('🚀 ==========================================');
console.log('🚀 TESTE DOS BOTÕES DE EDITAR E DELETAR');
console.log('🚀 ==========================================');

// 1. Verificar se conseguimos encontrar os botões
console.log('🔍 Procurando botões...');

// Procurar botões de editar
const botoesEditar = document.querySelectorAll('button[title="Editar cliente"]');
console.log('✏️ Botões de editar encontrados:', botoesEditar.length);

// Procurar botões de deletar
const botoesDeletar = document.querySelectorAll('button[title="Excluir cliente"]');
console.log('🗑️ Botões de deletar encontrados:', botoesDeletar.length);

// 2. Adicionar eventos de teste aos botões
console.log('🔧 Adicionando eventos de teste...');

botoesEditar.forEach((botao, index) => {
    console.log(`✏️ Adicionando evento ao botão de editar ${index + 1}`);
    
    botao.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        console.log(`✅ Botão de editar ${index + 1} clicado!`);
        alert(`Botão de editar ${index + 1} funcionando!`);
    });
});

botoesDeletar.forEach((botao, index) => {
    console.log(`🗑️ Adicionando evento ao botão de deletar ${index + 1}`);
    
    botao.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        console.log(`✅ Botão de deletar ${index + 1} clicado!`);
        alert(`Botão de deletar ${index + 1} funcionando!`);
    });
});

// 3. Verificar se há elementos com ícones de editar/deletar
console.log('🔍 Procurando ícones...');

const iconesEditar = document.querySelectorAll('svg[data-lucide="edit"], .lucide-edit');
console.log('✏️ Ícones de editar encontrados:', iconesEditar.length);

const iconesDeletar = document.querySelectorAll('svg[data-lucide="trash-2"], .lucide-trash-2');
console.log('🗑️ Ícones de deletar encontrados:', iconesDeletar.length);

// 4. Função para testar clique manual
window.testarClique = function() {
    console.log('🔧 Testando clique manual...');
    
    // Tentar clicar no primeiro botão de editar
    if (botoesEditar.length > 0) {
        console.log('🖱️ Clicando no primeiro botão de editar...');
        botoesEditar[0].click();
    } else {
        console.log('❌ Nenhum botão de editar encontrado');
    }
    
    // Tentar clicar no primeiro botão de deletar
    if (botoesDeletar.length > 0) {
        console.log('🖱️ Clicando no primeiro botão de deletar...');
        botoesDeletar[0].click();
    } else {
        console.log('❌ Nenhum botão de deletar encontrado');
    }
};

// 5. Função para mostrar informações dos cards
window.mostrarCards = function() {
    console.log('📋 Informações dos cards de clientes:');
    
    const cards = document.querySelectorAll('[class*="card"]');
    console.log('Total de cards encontrados:', cards.length);
    
    cards.forEach((card, index) => {
        const nome = card.querySelector('h3, .font-medium')?.textContent || 'Sem nome';
        const botoes = card.querySelectorAll('button');
        console.log(`Card ${index + 1}: "${nome}" - ${botoes.length} botões`);
    });
};

console.log('📋 Comandos disponíveis:');
console.log('- testarClique() - Testa clicar nos botões');
console.log('- mostrarCards() - Mostra informações dos cards');
console.log('🚀 ==========================================');
