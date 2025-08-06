# Instruções para Migração do Campo Cliente

## O que foi alterado

O campo "Cliente (Opcional)" na página de transações foi alterado de um dropdown (que puxava dados do cadastro de clientes) para um campo de texto livre, onde você pode digitar qualquer nome de cliente.

## Alterações no Código

✅ **Concluído**: O código foi atualizado para usar um campo de texto livre ao invés do dropdown.

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
- Confirme que a coluna `client_name` foi criada e `client_id` foi removida

## Resultado

Após aplicar a migração:
- O campo "Cliente (Opcional)" será um campo de texto livre
- Você poderá digitar qualquer nome de cliente
- O campo não será mais vinculado ao cadastro de clientes
- As transações existentes manterão seus dados (se houver)

## Observações

- Esta alteração não afeta o cadastro de clientes em outras partes do sistema
- O campo continua sendo opcional
- Você pode deixar em branco se não quiser especificar um cliente 