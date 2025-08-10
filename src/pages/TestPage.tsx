import React from 'react';

const TestPage = () => {
  return (
    <div className="min-h-screen bg-blue-500 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-lg">
        <h1 className="text-2xl font-bold text-gray-800 mb-4">
          Teste de Layout
        </h1>
        <p className="text-gray-600 mb-4">
          Se você consegue ver este texto com formatação, o CSS está funcionando.
        </p>
        <div className="space-y-2">
          <div className="bg-red-100 p-2 rounded">Fundo vermelho claro</div>
          <div className="bg-green-100 p-2 rounded">Fundo verde claro</div>
          <div className="bg-blue-100 p-2 rounded">Fundo azul claro</div>
        </div>
        <button className="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
          Botão de Teste
        </button>
      </div>
    </div>
  );
};

export default TestPage;
