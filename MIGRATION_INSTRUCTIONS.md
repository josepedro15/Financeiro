# Instruções para Migração dos Campos Cliente e Conta

## O que foi alterado

1. **Campo "Cliente (Opcional)"**: Alterado de dropdown (que puxava dados do cadastro de clientes) para um campo de texto livre, onde você pode digitar qualquer nome de cliente.

2. **Campo "Conta"**: Simplificado para ter apenas 2 opções fixas:
   - **Conta PJ**
   - **Conta Checkout**

## Alterações no Código

✅ **Concluído**: O código foi atualizado para usar:
- Campo de texto livre para cliente
- Dropdown fixo com apenas 2 opções de conta

## Migração do Banco de Dados

Para aplicar as alterações no banco de dados, siga estes passos:

### 1. Acesse o Supabase Dashboard
- Vá para [supabase.com](https://supabase.com)
- Faça login na sua conta
- Acesse o projeto do seu sistema financeiro

### 2. Execute a Migração
- No menu lateral, clique em "SQL Editor"
- Clique em "New query"
- Copie e cole o conteúdo do arquivo `database_migration.sql`
- Clique em "Run" para executar

### 3. Verifique a Migração
- A consulta final do arquivo SQL mostrará as colunas da tabela `transactions`
- Confirme que as colunas `client_name` e `account_name` foram criadas
- Confirme que as colunas `client_id` e `account_id` foram removidas

## Resultado

Após aplicar a migração:
- O campo "Cliente (Opcional)" será um campo de texto livre
- O campo "Conta" terá apenas 2 opções: "Conta PJ" e "Conta Checkout"
- Você poderá digitar qualquer nome de cliente
- As transações existentes manterão seus dados (se houver)

## Observações

- Esta alteração não afeta o cadastro de clientes em outras partes do sistema
- O campo cliente continua sendo opcional
- O campo conta agora é obrigatório e tem apenas 2 opções fixas
- Você pode deixar o campo cliente em branco se não quiser especificar 