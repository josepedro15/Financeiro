// =====================================================
// TESTE DIRETO DOS BOTÕES CLIENTS
// =====================================================

console.log('🎯 TESTE DIRETO DOS BOTÕES');

// 1. Função para encontrar botões
function encontrarBotoes() {
    console.log('🔍 Procurando botões...');
    
    // Procurar botões de editar
    const botoesEditar = document.querySelectorAll('button[onclick*="handleEdit"], button[onclick*="edit"], .edit-button, [title*="editar"], [title*="edit"]');
    console.log('✏️ Botões de editar encontrados:', botoesEditar.length);
    
    // Procurar botões de deletar
    const botoesDeletar = document.querySelectorAll('button[onclick*="handleDelete"], button[onclick*="delete"], .delete-button, [title*="deletar"], [title*="delete"], [title*="excluir"]');
    console.log('🗑️ Botões de deletar encontrados:', botoesDeletar.length);
    
    // Procurar botões por texto
    const botoesPorTexto = Array.from(document.querySelectorAll('button')).filter(btn => {
        const texto = btn.textContent?.toLowerCase() || '';
        return texto.includes('editar') || texto.includes('edit') || 
               texto.includes('deletar') || texto.includes('delete') ||
               texto.includes('excluir');
    });
    console.log('📝 Botões por texto encontrados:', botoesPorTexto.length);
    
    return { botoesEditar, botoesDeletar, botoesPorTexto };
}

// 2. Função para adicionar eventos de teste
function adicionarEventosTeste(botoes, tipo) {
    botoes.forEach((botao, index) => {
        console.log(`🎯 Adicionando evento de teste ao botão ${tipo} ${index + 1}`);
        
        // Adicionar evento de clique
        botao.addEventListener('click', function(e) {
            console.log(`✅ CLIQUE DETECTADO no botão ${tipo} ${index + 1}`);
            console.log('📍 Elemento clicado:', this);
            console.log('📍 Texto do botão:', this.textContent);
            console.log('📍 Classes:', this.className);
            console.log('📍 Evento:', e);
            
            // Mostrar alert
            alert(`Clique detectado no botão ${tipo} ${index + 1}!`);
            
            // Não prevenir o comportamento padrão para testar
            // e.preventDefault();
        }, true); // Usar capture para pegar o evento primeiro
        
        // Adicionar evento de mousedown
        botao.addEventListener('mousedown', function(e) {
            console.log(`🖱️ MOUSEDOWN no botão ${tipo} ${index + 1}`);
        }, true);
        
        // Adicionar evento de mouseup
        botao.addEventListener('mouseup', function(e) {
            console.log(`🖱️ MOUSEUP no botão ${tipo} ${index + 1}`);
        }, true);
        
        // Marcar visualmente
        botao.style.border = '2px solid red';
        botao.style.backgroundColor = '#ffebee';
    });
}

// 3. Função para forçar visibilidade dos botões
function forcarVisibilidade() {
    console.log('👁️ Forçando visibilidade dos botões...');
    
    // Encontrar elementos que podem estar escondendo botões
    const elementosOcultos = document.querySelectorAll('.opacity-0, .invisible, .hidden, [style*="display: none"], [style*="opacity: 0"]');
    console.log('👻 Elementos ocultos encontrados:', elementosOcultos.length);
    
    elementosOcultos.forEach((elemento, index) => {
        console.log(`👁️ Tornando visível elemento ${index + 1}:`, elemento);
        elemento.style.opacity = '1';
        elemento.style.visibility = 'visible';
        elemento.style.display = 'block';
        elemento.classList.remove('opacity-0', 'invisible', 'hidden');
    });
}

// 4. Função para testar cliques programáticos
function testarCliquesProgramaticos(botoes, tipo) {
    console.log(`🤖 Testando cliques programáticos nos botões ${tipo}...`);
    
    botoes.forEach((botao, index) => {
        setTimeout(() => {
            console.log(`🤖 Clicando programaticamente no botão ${tipo} ${index + 1}`);
            botao.click();
        }, index * 1000); // Delay de 1 segundo entre cada clique
    });
}

// 5. Função principal
function executarTesteCompleto() {
    console.log('🚀 EXECUTANDO TESTE COMPLETO DOS BOTÕES');
    
    // Forçar visibilidade
    forcarVisibilidade();
    
    // Encontrar botões
    const { botoesEditar, botoesDeletar, botoesPorTexto } = encontrarBotoes();
    
    // Adicionar eventos de teste
    adicionarEventosTeste(botoesEditar, 'editar');
    adicionarEventosTeste(botoesDeletar, 'deletar');
    adicionarEventosTeste(botoesPorTexto, 'texto');
    
    console.log('✅ Eventos de teste adicionados');
    console.log('💡 Agora clique nos botões para ver se os eventos são detectados');
    console.log('🤖 Para testar cliques programáticos, use: testarCliquesAutomaticos()');
    
    // Salvar referências para uso posterior
    window.botoesTeste = { botoesEditar, botoesDeletar, botoesPorTexto };
}

// 6. Função para cliques automáticos
window.testarCliquesAutomaticos = function() {
    if (window.botoesTeste) {
        console.log('🤖 Iniciando cliques automáticos...');
        testarCliquesProgramaticos(window.botoesTeste.botoesEditar, 'editar');
        setTimeout(() => {
            testarCliquesProgramaticos(window.botoesTeste.botoesDeletar, 'deletar');
        }, 5000);
    } else {
        console.log('❌ Execute primeiro: executarTesteCompleto()');
    }
};

// 7. Executar teste automaticamente
console.log('⏰ Executando teste em 1 segundo...');
setTimeout(executarTesteCompleto, 1000);

// 8. Função para executar manualmente
window.testarBotoesDireto = executarTesteCompleto;
console.log('💡 Para executar manualmente, use: testarBotoesDireto()');
