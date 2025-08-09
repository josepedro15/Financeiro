# 📁 Estrutura de Arquivos - Financeiro-2

## 🎯 **Organização Geral**

```
Financeiro-2/
├── 📂 src/                     # Código fonte React/TypeScript
├── 📂 scripts/sql/             # Scripts SQL organizados por categoria
├── 📂 docs/                    # Documentação do projeto
├── 📂 old_scripts/             # Scripts antigos/deprecated
├── 📂 supabase/               # Configurações do Supabase
├── 📂 public/                 # Assets públicos
└── 📄 arquivos de configuração (package.json, vite.config.ts, etc.)
```

## 🗂️ **Scripts SQL - Estrutura Detalhada**

### 📊 **Inserções de Dados** (`scripts/sql/inserts/`)

#### `months/` - Scripts organizados por mês:
- **📅 abril/** - Inserções de abril 2025
- **📅 maio/** - Inserções de maio 2025  
- **📅 junho/** - Inserções de junho 2025
- **📅 julho/** - Inserções de julho 2025
- **📅 agosto/** - Inserções de agosto 2025
- **📅 setembro/** - Inserções de setembro 2025
- **📅 outubro/** - Inserções de outubro 2025

#### Scripts principais em cada mês:
- `insert_[mes]_2025_completo.sql` - Inserção completa do mês
- `insert_[mes]_2025_dia_*.sql` - Inserções por dia específico
- `insert_[mes]_2025_dias_*.sql` - Inserções de múltiplos dias

### 🧹 **Limpeza** (`scripts/sql/cleanup/`)
- Scripts para apagar dados
- Reversão de alterações
- Remoção de duplicatas
- Limpeza de dados incorretos

### 🔍 **Verificações** (`scripts/sql/verifications/`)
- Scripts de verificação de dados
- Testes de integridade
- Investigação de problemas
- Checagens estruturais

### 🐛 **Debug** (`scripts/sql/debug/`)
- Scripts de depuração
- Investigação de bugs
- Correções temporárias
- Análise de problemas

### 🔄 **Migrações** (`scripts/sql/migrations/`)
- Alterações de schema
- Migrações de dados
- Criação de tabelas
- Sincronização entre ambientes

### 📈 **Relatórios** (`scripts/sql/reports/`)
- Cálculos de faturamento
- Relatórios mensais
- Análises financeiras
- Estatísticas

### 🏦 **Contas** (`scripts/sql/accounts/`)
- Correções de contas
- Inserção de novas contas
- Ajustes de saldos
- Configurações de contas

### 🔧 **Manutenção** (`scripts/sql/maintenance/`)
- Scripts de manutenção
- Configurações de RLS
- Permissões de acesso
- Otimizações de performance

### ⚙️ **Funções** (`scripts/sql/functions/`)
- Funções PostgreSQL personalizadas
- Procedures armazenadas
- Triggers e automações

### 🚀 **Otimizações** (`scripts/sql/optimizations/`)
- Melhorias de performance
- Índices
- Otimização de queries

## 📚 **Documentação** (`docs/`)

### Arquivos principais:
- **📄 README.md** - Documentação principal do projeto
- **📄 MIGRATION_INSTRUCTIONS.md** - Instruções de migração
- **📄 abril_2025_completo.md** - Relatório completo de abril
- **📄 abril_2025_resumo.md** - Resumo de abril
- **📄 maio_2025_completo.md** - Relatório completo de maio
- **📄 calculo_manual_maio.md** - Cálculos manuais de maio
- **📄 ESTRUTURA_ARQUIVOS.md** - Este arquivo

## 🗃️ **Scripts Antigos** (`old_scripts/`)
- Scripts deprecated
- Versões antigas não utilizadas
- Backup de scripts obsoletos

## 🎯 **Convenções de Nomenclatura**

### Scripts SQL:
- **Inserções**: `insert_[mes]_[especificacao].sql`
- **Verificações**: `verificar_[assunto].sql`
- **Limpeza**: `apagar_[assunto].sql`
- **Debug**: `debug_[problema].sql`
- **Relatórios**: `calcular_[assunto].sql`

### Pastas:
- Todas em **minúsculas**
- Separadas por **underscores** ou **hífens**
- Nomes **descritivos** e **claros**

## 🔄 **Fluxo de Trabalho Recomendado**

1. **🔍 Verificação** - Sempre verifique os dados antes de modificar
2. **🧹 Backup** - Mova scripts antigos para `old_scripts/`
3. **📁 Organização** - Coloque novos scripts na pasta apropriada
4. **📝 Documentação** - Atualize a documentação quando necessário
5. **🧪 Teste** - Use scripts de verificação após mudanças

## 🚨 **Scripts Críticos**

### ⭐ **Essenciais para funcionamento:**
- `scripts/sql/inserts/months/[mes]/insert_[mes]_2025_completo.sql`
- `scripts/sql/migrations/setup_organization_system_fixed.sql`
- `scripts/sql/migrations/criar_sistema_notificacoes_completo.sql`

### 🔧 **Manutenção regular:**
- Scripts em `scripts/sql/verifications/`
- Scripts em `scripts/sql/reports/`

---

> **💡 Dica**: Sempre execute scripts de verificação após fazer alterações nos dados!
