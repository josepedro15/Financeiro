-- Script para inserir transações de janeiro 2025 (dias 29, 31)
-- Execute este script no Supabase SQL Editor
-- Insere diretamente na tabela mensal transactions_2025_01
-- NOTA: Lançamentos de META são ignorados conforme instrução

-- ==========================================
-- DIA 29 DE JANEIRO 2025
-- ==========================================
INSERT INTO public.transactions_2025_01 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'CAIO CESAR DE OLIVEIRA', 'Conta PJ', '2025-01-29', 'CAIO CESAR DE OLIVEIRA', 39.95, 'income', NOW(), NOW());

-- ==========================================
-- DIA 31 DE JANEIRO 2025
-- ==========================================
INSERT INTO public.transactions_2025_01 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'JONATHAN DIAS BORGES', 'Conta PJ', '2025-01-31', 'JONATHAN DIAS BORGES', 39.95, 'income', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÕES PÓS-INSERÇÃO
-- ==========================================

-- 1. Verificar inserção por dia
SELECT 
    '📊 VERIFICAÇÃO POR DIA:' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    ROUND(AVG(amount), 2) as valor_medio
FROM public.transactions_2025_01
WHERE transaction_date IN ('2025-01-29', '2025-01-31')
GROUP BY transaction_date
ORDER BY transaction_date;

-- 2. Resumo total dos dias inseridos
SELECT 
    '🎯 RESUMO TOTAL JANEIRO:' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions_2025_01
WHERE transaction_date IN ('2025-01-29', '2025-01-31');

-- 3. Comparar com valores esperados
SELECT 
    '✅ VALORES ESPERADOS VS INSERIDOS:' as status,
    'Dia 29: R$ 39,95 esperado' as dia_29,
    'Dia 31: R$ 39,95 esperado' as dia_31,
    'Total: R$ 79,90 esperado' as total_esperado;

-- 4. Estado atual de janeiro 2025
SELECT 
    '📅 ESTADO ATUAL DE JANEIRO 2025:' as status,
    COUNT(*) as total_transacoes_janeiro,
    SUM(amount) as valor_total_janeiro,
    COUNT(DISTINCT EXTRACT(DAY FROM transaction_date)) as dias_com_dados,
    31 as total_dias_janeiro,
    ROUND((COUNT(DISTINCT EXTRACT(DAY FROM transaction_date))::decimal / 31) * 100, 1) as percentual_completo
FROM public.transactions_2025_01
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 1;

-- 5. Verificar se há outros dados em janeiro
SELECT 
    '🔍 TODOS OS DIAS COM DADOS EM JANEIRO:' as status,
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_01
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 1
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 6. Resumo de clientes únicos
SELECT 
    '👥 CLIENTES DE JANEIRO:' as status,
    client_name,
    transaction_date,
    amount
FROM public.transactions_2025_01
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 1
ORDER BY transaction_date;

-- 7. Observação sobre janeiro
SELECT 
    '📝 OBSERVAÇÃO:' as status,
    'Janeiro tem apenas 2 dias com dados (29 e 31)' as observacao,
    'Possível que o sistema tenha começado no final de janeiro' as hipotese;
