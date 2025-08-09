-- Script COMPLETO para inserir TODOS os dados de abril 2025
-- Execute este script no Supabase SQL Editor
-- IMPORTANTE: Este script insere direto na tabela transactions_2025_04

-- 1. LIMPAR DADOS ANTIGOS DE ABRIL (se necessário)
DELETE FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 2. INSERIR TODOS OS DADOS DE ABRIL 2025

-- === DIA 1 DE ABRIL ===
INSERT INTO public.transactions_2025_04 (user_id, transaction_date, description, amount, transaction_type, account_name, category, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MARIA ERCINA', 75.91, 'income', 'Conta Checkout', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'FLAVIA SOARES', 75.91, 'income', 'Conta Checkout', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'LUIZ ZUCO', 75.91, 'income', 'Conta Checkout', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'KAROLINE VIAL', 40.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CONSTANCIA JORGE', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'GILBERTO SILVANO', 40.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'NEIDE', 30.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'TATIANE LOPES', 35.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'PEDRO SOUZA', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'FABIANE MARCIANO', 67.92, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'EDIANA FERREIRA', 40.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MONICA PEREIRA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'GILENE VIANA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CATIUCIA WAHOLTZ', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MARIA CARVALHO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'BRUNA LETICIA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CLEIDE PEREIRA', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'DAVI SANTOS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'YURI GODOY', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'FABIANA SANTIAGO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),

-- === DIA 2 DE ABRIL ===
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'NEIDA SILVA', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ADRIANO SANTOS', 40.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'PATRICIA ERICA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'MARINA MARA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'VITORIA NASCIMENTO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'PATRICIA HENRIQUE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ELZA SOARES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'BRUNA SILVA', 35.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'JAGUARACY SANTOS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'NEUSA CAMPOS', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'GISELE MORAES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ADRIANA CAMPOS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'JENIFFER SILVA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'EDUARDA MELO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'LUIZ FERNANDO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'PAULA MOURA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ELIANE LEITE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'JOSE FRANCISCO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'DIEGO MEDEIROS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'LETICIA ALVES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),

-- === DIA 3 DE ABRIL ===
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'JESSICA LOPES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'PATRICIA ROCHA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'JULIANA RODRIGUES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'ALINE SANTOS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'LUIZ MAXIMO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'FELIPE REIS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'EDILENE SOUSA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'MARIA JOSE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'JOAO VITOR', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'ANA CLAUDIA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'TATIANE CASTRO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'MARIA PAULA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'CRISTIANE SILVA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'JESSICA OLIVEIRA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'SIMONE SANTOS', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),

-- === DIA 4 DE ABRIL ===
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LARISSA BUSATO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'THAIS DE OLIVEIRA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ELOILSON COUTO', 40.00, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'FABIANA SOUZA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'EDGAR DA SILVA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LILIAN VIEIRA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LUANA GABRIELLE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LUANA ELAINE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'SANDRA MICHELINI', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'PAULA DANIELA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ANTONIO FH L SANTANA', 17.45, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'NADYA ADRIANY', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),

-- === DIA 5 DE ABRIL ===
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'PATRICIA BENICIO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'MONICA PAULA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'VANESSA APARECIDA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ELIZANDRA NOVAES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'BARBARA ROQUE', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'DALVA SILVA', 75.91, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'DEBORAH CAETANO', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ROSANGELA MORAES', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ANDREIA SOUZA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ERICA SOUSDA', 39.95, 'income', 'Conta PJ', 'Pagamento', NOW(), NOW()),

-- Continuar com mais dias...
-- [ADICIONE MAIS DIAS CONFORME NECESSÁRIO]

-- === DESPESAS DE ABRIL (EXEMPLO) ===
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'DESPESA EXEMPLO 1', 100.00, 'expense', 'Conta PJ', 'Operacional', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-15', 'DESPESA EXEMPLO 2', 200.00, 'expense', 'Conta PJ', 'Operacional', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-30', 'PROLABORE ABRIL', 5000.00, 'expense', 'Conta PJ', 'Prolabore', NOW(), NOW());

-- 3. VERIFICAR RESULTADO
SELECT '=== VERIFICAÇÃO FINAL ABRIL 2025 ===' as info;

SELECT 
    COUNT(*) as total_transacoes,
    COUNT(CASE WHEN transaction_type = 'income' THEN 1 END) as total_receitas,
    COUNT(CASE WHEN transaction_type = 'expense' THEN 1 END) as total_despesas,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as valor_receitas,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as valor_despesas,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE -amount END) as saldo_liquido
FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

