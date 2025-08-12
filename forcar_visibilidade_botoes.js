// =====================================================
// FORÇAR VISIBILIDADE DOS BOTÕES CLIENTS
// =====================================================

console.log('👁️ FORÇANDO VISIBILIDADE DOS BOTÕES');

// 1. Função para forçar visibilidade
function forcarVisibilidadeBotoes() {
    console.log('🔍 Procurando botões com opacity-0...');
    
    // Encontrar botões com opacity-0
    const botoesOcultos = document.querySelectorAll('.opacity-0, [style*="opacity: 0"]');
    console.log('👻 Botões ocultos encontrados:', botoesOcultos.length);
    
    // Forçar visibilidade
    botoesOcultos.forEach((botao, index) => {
        console.log(`👁️ Tornando visível botão ${index + 1}:`, botao);
        
        // Remover classes que ocultam
        botao.classList.remove('opacity-0');
        
        // Forçar estilo inline
        botao.style.opacity = '1';
        botao.style.visibility = 'visible';
        botao.style.display = 'block';
        
        // Adicionar borda para identificar
        botao.style.border = '1px solid blue';
        botao.style.backgroundColor = '#e3f2fd';
    });
    
    // Encontrar botões por ícones específicos
    const botoesEdit = document.querySelectorAll('button svg[class*="w-3 h-3"]');
    console.log('✏️ Botões com ícones pequenos encontrados:', botoesEdit.length);
    
    botoesEdit.forEach((svg, index) => {
        const botao = svg.closest('button');
        if (botao) {
            console.log(`🎯 Botão com ícone ${index + 1}:`, botao);
            botao.style.opacity = '1';
            botao.style.visibility = 'visible';
            botao.style.border = '2px solid green';
            botao.style.backgroundColor = '#e8f5e8';
        }
    });
}

// 2. Função para adicionar eventos de teste
function adicionarEventosTeste() {
    console.log('🎯 Adicionando eventos de teste...');
    
    // Encontrar todos os botões
    const todosBotoes = document.querySelectorAll('button');
    console.log('🔘 Total de botões encontrados:', todosBotoes.length);
    
    todosBotoes.forEach((botao, index) => {
        // Verificar se é botão de editar ou deletar
        const texto = botao.textContent?.toLowerCase() || '';
        const title = botao.title?.toLowerCase() || '';
        const temIcone = botao.querySelector('svg');
        
        if (title.includes('editar') || title.includes('edit') || 
            title.includes('deletar') || title.includes('delete') ||
            title.includes('excluir') || temIcone) {
            
            console.log(`🎯 Botão especial ${index + 1}:`, botao);
            console.log('  - Texto:', botao.textContent);
            console.log('  - Title:', botao.title);
            console.log('  - Classes:', botao.className);
            
            // Adicionar evento de clique
            botao.addEventListener('click', function(e) {
                console.log(`✅ CLIQUE DETECTADO no botão ${index + 1}`);
                console.log('📍 Elemento:', this);
                console.log('📍 Evento:', e);
                alert(`Clique detectado no botão ${index + 1}!`);
            }, true);
            
            // Marcar visualmente
            botao.style.border = '3px solid red';
            botao.style.backgroundColor = '#ffebee';
            botao.style.opacity = '1';
            botao.style.visibility = 'visible';
        }
    });
}

// 3. Função para monitorar mudanças no DOM
function monitorarMudancas() {
    console.log('👀 Monitorando mudanças no DOM...');
    
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.type === 'childList') {
                console.log('🔄 DOM mudou, verificando botões...');
                setTimeout(() => {
                    forcarVisibilidadeBotoes();
                    adicionarEventosTeste();
                }, 100);
            }
        });
    });
    
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    console.log('✅ Monitoramento ativo');
}

// 4. Função principal
function executarCorrecao() {
    console.log('🚀 EXECUTANDO CORREÇÃO COMPLETA');
    
    // Forçar visibilidade
    forcarVisibilidadeBotoes();
    
    // Adicionar eventos
    adicionarEventosTeste();
    
    // Monitorar mudanças
    monitorarMudancas();
    
    console.log('✅ Correção aplicada');
    console.log('💡 Agora os botões devem estar sempre visíveis');
    console.log('🎯 Clique nos botões para testar');
}

// 5. Executar automaticamente
console.log('⏰ Executando correção em 1 segundo...');
setTimeout(executarCorrecao, 1000);

// 6. Função para executar manualmente
window.forcarVisibilidadeBotoes = executarCorrecao;
console.log('💡 Para executar manualmente, use: forcarVisibilidadeBotoes()');
