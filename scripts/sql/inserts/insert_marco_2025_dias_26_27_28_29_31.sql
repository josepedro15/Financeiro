-- Script para inserir transações de março 2025 (dias 26, 27, 28, 29, 31)
-- Execute este script no Supabase SQL Editor
-- Insere diretamente na tabela mensal transactions_2025_03
-- NOTA: Lançamentos de META são ignorados conforme instrução

-- ==========================================
-- DIA 26 DE MARÇO 2025
-- ==========================================
INSERT INTO public.transactions_2025_03 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ILMAR GOMES', 'Conta PJ', '2025-03-26', 'ILMAR GOMES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'DANILO DANTAS', 'Conta PJ', '2025-03-26', 'DANILO DANTAS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'JEANDERSON DOS REIS', 'Conta PJ', '2025-03-26', 'JEANDERSON DOS REIS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'DEBORA MOURA', 'Conta Checkout', '2025-03-26', 'DEBORA MOURA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ANA MARIA', 'Conta PJ', '2025-03-26', 'ANA MARIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'FABIO RODRIGO', 'Conta PJ', '2025-03-26', 'FABIO RODRIGO', 39.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'CARLA CAMILA', 'Conta PJ', '2025-03-26', 'CARLA CAMILA', 39.95, 'income', NOW(), NOW());

-- ==========================================
-- DIA 27 DE MARÇO 2025
-- ==========================================
INSERT INTO public.transactions_2025_03 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ANA MARIA', 'Conta PJ', '2025-03-27', 'ANA MARIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ELLISON ALLAN', 'Conta Checkout', '2025-03-27', 'ELLISON ALLAN', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LUCAS CRUZ', 'Conta Checkout', '2025-03-27', 'LUCAS CRUZ', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'DOUGLAS OLIVEIRA', 'Conta PJ', '2025-03-27', 'DOUGLAS OLIVEIRA', 39.02, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LUCAS FERREIRA', 'Conta Checkout', '2025-03-27', 'LUCAS FERREIRA', 113.81, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'PADRE GIOVANI', 'Conta Checkout', '2025-03-27', 'PADRE GIOVANI', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'GIAN CARLOS', 'Conta Checkout', '2025-03-27', 'GIAN CARLOS', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'VANDERLEA APARECIDA', 'Conta PJ', '2025-03-27', 'VANDERLEA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'MICHELE PAUST', 'Conta PJ', '2025-03-27', 'MICHELE PAUST', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'TERESINHA', 'Conta Checkout', '2025-03-27', 'TERESINHA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ANDERSON PARIZOTTO', 'Conta PJ', '2025-03-27', 'ANDERSON PARIZOTTO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ELIEZER BEZERRA', 'Conta PJ', '2025-03-27', 'ELIEZER BEZERRA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'DANIEL CAMARA', 'Conta PJ', '2025-03-27', 'DANIEL CAMARA', 30.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LEIDE MARIA', 'Conta PJ', '2025-03-27', 'LEIDE MARIA', 39.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'MICHELE CABRAL', 'Conta PJ', '2025-03-27', 'MICHELE CABRAL', 30.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'KELEN PLÁCIDO', 'Conta PJ', '2025-03-27', 'KELEN PLÁCIDO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'B NELSON PET', 'Conta PJ', '2025-03-27', 'B NELSON PET', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LIDIANE DE LA VEIGA', 'Conta PJ', '2025-03-27', 'LIDIANE DE LA VEIGA', 39.50, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'OZIEL ALVES', 'Conta PJ', '2025-03-27', 'OZIEL ALVES', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'SILVANA SANTOS', 'Conta PJ', '2025-03-27', 'SILVANA SANTOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'J NOGUEIRA', 'Conta PJ', '2025-03-27', 'J NOGUEIRA', 39.95, 'income', NOW(), NOW());

-- ==========================================
-- DIA 28 DE MARÇO 2025
-- ==========================================
INSERT INTO public.transactions_2025_03 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'CAROLINA DIAS', 'Conta PJ', '2025-03-28', 'CAROLINA DIAS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'RENATA CRISTINA', 'Conta PJ', '2025-03-28', 'RENATA CRISTINA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'EMERSON RIBEIRO', 'Conta PJ', '2025-03-28', 'EMERSON RIBEIRO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'JULIA NUNES', 'Conta PJ', '2025-03-28', 'JULIA NUNES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LAUDIANE SILVA', 'Conta PJ', '2025-03-28', 'LAUDIANE SILVA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LIDIANE ALVES', 'Conta PJ', '2025-03-28', 'LIDIANE ALVES', 99.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'APARECIDA PEREIRA', 'Conta PJ', '2025-03-28', 'APARECIDA PEREIRA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'GIAN CARLOS', 'Conta PJ', '2025-03-28', 'GIAN CARLOS', 79.90, 'income', NOW(), NOW());

-- ==========================================
-- DIA 29 DE MARÇO 2025
-- ==========================================
INSERT INTO public.transactions_2025_03 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'JOSE PEDRO', 'Conta PJ', '2025-03-29', 'JOSE PEDRO', 39.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'DANIELLY DE FATIMA', 'Conta Checkout', '2025-03-29', 'DANIELLY DE FATIMA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LUIZ ALBERTO', 'Conta Checkout', '2025-03-29', 'LUIZ ALBERTO', 75.91, 'income', NOW(), NOW());

-- ==========================================
-- DIA 31 DE MARÇO 2025
-- ==========================================
INSERT INTO public.transactions_2025_03 (user_id, client_name, account_name, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ADRIANA BERTONI', 'Conta PJ', '2025-03-31', 'ADRIANA BERTONI', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'CARLA CAMILA', 'Conta PJ', '2025-03-31', 'CARLA CAMILA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'CARLOS AUGUSTO', 'Conta PJ', '2025-03-31', 'CARLOS AUGUSTO', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LUCAS FERREIRA', 'Conta PJ', '2025-03-31', 'LUCAS FERREIRA', 20.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'SIMONE RIBEIRO', 'Conta Checkout', '2025-03-31', 'SIMONE RIBEIRO', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'YGOR DO NASCIMENTO', 'Conta PJ', '2025-03-31', 'YGOR DO NASCIMENTO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'B NELSON PET', 'Conta PJ', '2025-03-31', 'B NELSON PET', 35.96, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LAUDIANE SILVA', 'Conta PJ', '2025-03-31', 'LAUDIANE SILVA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'KESSYA FERNANDES', 'Conta PJ', '2025-03-31', 'KESSYA FERNANDES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'MATIAS F ROCHA', 'Conta PJ', '2025-03-31', 'MATIAS F ROCHA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'ANTONIO FH L SANTANA', 'Conta PJ', '2025-03-31', 'ANTONIO FH L SANTANA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'LINDINALVA PEREIRA', 'Conta PJ', '2025-03-31', 'LINDINALVA PEREIRA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'TIAGO LEITE', 'Conta PJ', '2025-03-31', 'TIAGO LEITE', 54.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'FERNANDO VIRGILIO', 'Conta Checkout', '2025-03-31', 'FERNANDO VIRGILIO', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'RODRIGO ANDRELINO', 'Conta PJ', '2025-03-31', 'RODRIGO ANDRELINO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'MAYK BRENDO', 'Conta PJ', '2025-03-31', 'MAYK BRENDO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'JOILSON DOS SANTOS', 'Conta PJ', '2025-03-31', 'JOILSON DOS SANTOS', 39.95, 'income', NOW(), NOW());

-- ==========================================
-- VERIFICAÇÕES PÓS-INSERÇÃO
-- ==========================================

-- 1. Verificar inserção por dia
SELECT 
    '📊 VERIFICAÇÃO POR DIA (26-31):' as status,
    transaction_date,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    ROUND(AVG(amount), 2) as valor_medio
FROM public.transactions_2025_03
WHERE transaction_date IN ('2025-03-26', '2025-03-27', '2025-03-28', '2025-03-29', '2025-03-31')
GROUP BY transaction_date
ORDER BY transaction_date;

-- 2. Verificar por conta
SELECT 
    '💳 VERIFICAÇÃO POR CONTA (DIAS 26-31):' as status,
    account_name,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total
FROM public.transactions_2025_03
WHERE transaction_date IN ('2025-03-26', '2025-03-27', '2025-03-28', '2025-03-29', '2025-03-31')
GROUP BY account_name
ORDER BY account_name;

-- 3. Resumo total dos dias finais
SELECT 
    '🎯 RESUMO TOTAL DOS DIAS FINAIS (26-31, exceto 30):' as status,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    MIN(transaction_date) as primeira_data,
    MAX(transaction_date) as ultima_data
FROM public.transactions_2025_03
WHERE transaction_date IN ('2025-03-26', '2025-03-27', '2025-03-28', '2025-03-29', '2025-03-31');

-- 4. Comparar com valores esperados
SELECT 
    '✅ VALORES ESPERADOS VS INSERIDOS:' as status,
    'Dia 26: R$ 307,57 esperado' as dia_26,
    'Dia 27: R$ 1.099,30 esperado' as dia_27,
    'Dia 28: R$ 419,55 esperado' as dia_28,
    'Dia 29: R$ 191,72 esperado' as dia_29,
    'Dia 31: R$ 742,13 esperado' as dia_31;

-- 5. Top transações dos dias finais
SELECT 
    '🏆 MAIORES TRANSAÇÕES (DIAS 26-31):' as status,
    transaction_date,
    client_name,
    amount,
    account_name,
    ROW_NUMBER() OVER (ORDER BY amount DESC) as ranking
FROM public.transactions_2025_03
WHERE transaction_date IN ('2025-03-26', '2025-03-27', '2025-03-28', '2025-03-29', '2025-03-31')
ORDER BY amount DESC
LIMIT 10;

-- 6. Destaques especiais dos dias finais
SELECT 
    '⭐ DESTAQUES DOS DIAS FINAIS:' as status,
    'LUCAS FERREIRA (Dia 27): R$ 113,81 - MAIOR DO PERÍODO' as destaque_1,
    'LIDIANE ALVES (Dia 28): R$ 99,90 - SEGUNDA MAIOR' as destaque_2,
    'GIAN CARLOS (Dia 28): R$ 79,90 - TERCEIRA MAIOR' as destaque_3,
    'Dia 27: 21 transações = R$ 1.099,30 - MELHOR DIA' as destaque_4;

-- 7. Observação sobre o dia 30
SELECT 
    '❓ OBSERVAÇÃO:' as status,
    'Dia 30 não incluído - verificar se há dados pendentes' as observacao;

-- 8. RESUMO COMPLETO DE MARÇO 2025
SELECT 
    '🎊 ESTADO FINAL DE MARÇO 2025:' as status,
    EXTRACT(DAY FROM transaction_date) as dia,
    COUNT(*) as total_transacoes,
    SUM(amount) as valor_total,
    CASE 
        WHEN EXTRACT(DAY FROM transaction_date) IN (23, 30) THEN '❌ AUSENTE'
        ELSE '✅ COMPLETO'
    END as status_dia
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
GROUP BY EXTRACT(DAY FROM transaction_date)
ORDER BY dia;

-- 9. Totais gerais de março
SELECT 
    '🏁 TOTAIS FINAIS DE MARÇO 2025:' as status,
    COUNT(*) as total_transacoes_marco,
    SUM(amount) as valor_total_marco,
    COUNT(DISTINCT EXTRACT(DAY FROM transaction_date)) as dias_com_transacoes,
    ROUND(AVG(amount), 2) as ticket_medio,
    MAX(amount) as maior_transacao,
    MIN(amount) as menor_transacao
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3;

-- 10. Dias faltantes em março
SELECT 
    generate_series(1, 31) as dia_faltante
EXCEPT
SELECT 
    EXTRACT(DAY FROM transaction_date)::int
FROM public.transactions_2025_03
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 3
ORDER BY dia_faltante;
