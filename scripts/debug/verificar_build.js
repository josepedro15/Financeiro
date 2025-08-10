// Script para verificar problemas no build
// Execute este script para diagnosticar problemas de layout

console.log('=== DIAGNÓSTICO DE BUILD ===');

// Verificar se o Tailwind está carregado
const tailwindLoaded = document.querySelector('[class*="bg-"]') !== null;
console.log('Tailwind CSS carregado:', tailwindLoaded);

// Verificar se os componentes estão renderizando
const components = {
  buttons: document.querySelectorAll('button').length,
  cards: document.querySelectorAll('[class*="card"]').length,
  inputs: document.querySelectorAll('input').length,
  selects: document.querySelectorAll('select').length
};

console.log('Componentes encontrados:', components);

// Verificar CSS customizado
const customCSS = document.querySelectorAll('style').length;
console.log('CSS customizado carregado:', customCSS);

// Verificar se há erros de JavaScript
window.addEventListener('error', (event) => {
  console.error('Erro JavaScript detectado:', event.error);
});

// Verificar se há problemas de layout
const layoutIssues = {
  viewport: {
    width: window.innerWidth,
    height: window.innerHeight
  },
  body: {
    width: document.body.offsetWidth,
    height: document.body.offsetHeight
  }
};

console.log('Informações de layout:', layoutIssues);

// Verificar se há elementos com posicionamento absoluto problemático
const absoluteElements = document.querySelectorAll('[style*="position: absolute"]');
console.log('Elementos com posição absoluta:', absoluteElements.length);

// Verificar se há elementos com z-index alto
const highZIndex = document.querySelectorAll('[style*="z-index"]');
console.log('Elementos com z-index:', highZIndex.length);

console.log('=== FIM DO DIAGNÓSTICO ===');
