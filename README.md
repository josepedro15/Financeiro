# Projeto Financeiro

Sistema de gestão financeira desenvolvido com React, TypeScript e Supabase.

## 📁 Estrutura do Projeto

### 📂 `src/`
- **Componentes React**: Interface do usuário
- **Páginas**: Telas principais do sistema
- **Hooks**: Lógica reutilizável
- **Integrações**: Configurações do Supabase

### 📂 `scripts/`
Scripts organizados por categoria:

#### `scripts/sql/`
- **`inserts/`**: Scripts para inserção de dados
  - Transações por mês (abril, maio, junho, julho, agosto)
  - Dados de contas e clientes
  
- **`verifications/`**: Scripts de verificação
  - Verificação de dados no dashboard
  - Verificação de estrutura de tabelas
  - Verificação de transações por período
  
- **`debug/`**: Scripts de debug e investigação
  - Testes de conexão
  - Investigação de discrepâncias
  - Debug de carregamento
  
- **`migrations/`**: Scripts de migração
  - Migração de dados existentes
  - Criação de triggers
  - Alterações de estrutura
  
- **`cleanup/`**: Scripts de limpeza
  - Remoção de dados duplicados
  - Limpeza de transações antigas
  - Apagar dados específicos

#### `scripts/js/`
- Scripts JavaScript para automação
- Debug de dashboard
- Forçar atualizações

### 📂 `docs/`
- Documentação do projeto
- Relatórios de dados
- Instruções de migração

### 📂 `supabase/`
- Configurações do Supabase
- Migrações do banco de dados

## 🚀 Como Usar

### Desenvolvimento
```bash
npm install
npm run dev
```

### Scripts SQL
Os scripts estão organizados por função. Para usar:

1. **Inserir dados**: Use scripts da pasta `inserts/`
2. **Verificar dados**: Use scripts da pasta `verifications/`
3. **Debug**: Use scripts da pasta `debug/`
4. **Migração**: Use scripts da pasta `migrations/`
5. **Limpeza**: Use scripts da pasta `cleanup/`

### Exemplo de uso:
```bash
# Executar script de inserção
psql -d your_database -f scripts/sql/inserts/insert_abril_2025_dias_1_2_3.sql

# Verificar dados
psql -d your_database -f scripts/sql/verifications/verificar_abril_completo.sql
```

## 📊 Funcionalidades

- Dashboard financeiro
- Gestão de transações
- Relatórios por período
- Autenticação de usuários
- Integração com Supabase

## 🛠️ Tecnologias

- React + TypeScript
- Supabase (PostgreSQL)
- Tailwind CSS
- Vite
