-- Script para relançar todos os dados de abril 2025
-- Execute este script no Supabase SQL Editor APÓS apagar os dados antigos

-- 1. Inserir dados de abril 2025 (dias 1-5)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MARIA ERCINA', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'FLAVIA SOARES', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'LUIZ ZUCO', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'KAROLINE VIAL', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CONSTANCIA JORGE', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'GILBERTO SILVANO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'NEIDE', 30.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'TATIANE LOPES', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'PEDRO SOUZA', 75.91, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'FABIANE MARCIANO', 67.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'EDIANA FERREIRA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MONICA PEREIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'GILENE VIANA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CATIUCIA WAHOLTZ', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'MARIA CARVALHO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'CRISTINA MARIA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'SANDRO ALGUSTO', 65.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-01', 'TOP TELAS', 175.00, 'income', 'Conta PJ', NOW(), NOW());

-- 2. Inserir dados de abril 2025 (dias 2-5)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'APIO RODRIGUES', 50.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'MARCELLY FERNANDES', 60.72, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'FELIPE DOS SANTOS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'WLP AUTOMOVEIS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'CARINA DE QUEIROZ', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ADRIANA GONÇALVES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'CRISTINA ARARUNA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'ADRIANO MELO', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'PADARIA', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'DANIELA BENITE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'MARIA DA CONCEIÇÃO', 33.92, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'JOCASTA IVEN', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'IVONETE ALVES', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-02', 'PRISCILA RODRIGUES', 40.00, 'income', 'Conta PJ', NOW(), NOW());

-- 3. Inserir dados de abril 2025 (dias 3-5)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'SYNARA DA SILVA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'JANE PARREIRAS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'ROSILENE FRANCA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'CARLA OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'OTICAS VENEZA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'MILKA DJANE', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'MARISTELA DE SORDI', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'EDIANA FERREIRA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'MARIA IVANILDA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'ANDREINA CINTIA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'ALZENIRA MARIA', 33.96, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'SOLANGE NOGUEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'NAYARA CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'OCTAVIO TINOCO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-03', 'AMELIA LILIAN', 35.00, 'income', 'Conta PJ', NOW(), NOW());

-- 4. Inserir dados de abril 2025 (dias 4-5)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'FERNANDINHA FERREIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ITIENE SOARES', 75.91, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'FERNANDA DE LIMA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'CRISTIANA SOUZA', 60.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'LEONICE RODRIGUES', 30.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'EMERSON AIRES', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'VANUSA CRISTINA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'CRISTINA MARIA', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ELIZANGELA BRITO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'RAYSSA GAMA', 59.93, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'ROSILEIA FRANCA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'KARLA MADRUGA', 35.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'FRANCISCO CARLOS', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-04', 'PAULO ROGERIO', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 5. Inserir dados de abril 2025 (dia 5)
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, account_name, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ERINALVA CARVALHO', 40.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'GENOVEVA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'RENATO SOUZA', 64.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'PRISCILA PEREIRA', 59.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'JAQUELINE OLIVEIRA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ELIANA CAZOTTI', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'LUCIANA COELHO', 113.81, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'A.F GESTAO', 70.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'REGIANE GOMES', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'MARIA CLAUDETE', 113.81, 'income', 'Conta Checkout', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'JB SAUDE', 34.90, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ANA CLAUDIA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'JUCELI SILVA', 39.95, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'JEANE FERNANDES', 110.00, 'income', 'Conta PJ', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-04-05', 'ELCIMAR RODRIGUES', 39.95, 'income', 'Conta PJ', NOW(), NOW());

-- 6. Verificar resultado final
SELECT '=== VERIFICAÇÃO FINAL ABRIL ===' as info;

SELECT
  COUNT(*) as total_transacoes_abril,
  SUM(amount) as faturamento_total_abril,
  ROUND(SUM(amount), 2) as faturamento_arredondado_abril
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30';

-- 7. Verificar por dia
SELECT '=== VERIFICAÇÃO POR DIA ===' as info;

SELECT
  transaction_date,
  COUNT(*) as transacoes,
  SUM(amount) as total_dia,
  ROUND(SUM(amount), 2) as total_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
GROUP BY transaction_date
ORDER BY transaction_date;

-- 8. Verificar por conta
SELECT '=== VERIFICAÇÃO POR CONTA ===' as info;

SELECT
  account_name,
  COUNT(*) as total_transacoes,
  SUM(amount) as faturamento_total,
  ROUND(SUM(amount), 2) as faturamento_arredondado
FROM public.transactions
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  AND transaction_date >= '2025-04-01'
  AND transaction_date <= '2025-04-30'
GROUP BY account_name
ORDER BY account_name; 