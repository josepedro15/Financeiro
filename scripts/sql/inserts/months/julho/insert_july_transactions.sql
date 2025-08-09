-- Script para inserir transações de julho de 2025
-- Execute este SQL no Supabase Dashboard > SQL Editor

-- Script com user_id real: 2dc520e3-5f19-4dfe-838b-1aca7238ae36

-- Primeiro, vamos verificar se já existem transações para evitar duplicatas
-- DELETE FROM public.transactions WHERE EXTRACT(MONTH FROM transaction_date) = 7 AND EXTRACT(YEAR FROM transaction_date) = 2025;

-- Inserir transações de 1/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ELAINE GONÇALVES', 75.91, 'income', '2025-07-01', 'Conta Checkout', 'ELAINE GONÇALVES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento JAQUELINE DIAS', 40.00, 'income', '2025-07-01', 'Conta PJ', 'JAQUELINE DIAS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento TATIANE SANTOS', 75.91, 'income', '2025-07-01', 'Conta Checkout', 'TATIANE SANTOS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento PONTO CERTO', 50.00, 'income', '2025-07-01', 'Conta PJ', 'PONTO CERTO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ADRIANA ZELESKI', 75.91, 'income', '2025-07-01', 'Conta Checkout', 'ADRIANA ZELESKI', 'Receita');

-- Inserir transações de 2/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento FERNANDA PEREIRA', 35.95, 'income', '2025-07-02', 'Conta PJ', 'FERNANDA PEREIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento JOSE HARLEY', 39.95, 'income', '2025-07-02', 'Conta PJ', 'JOSE HARLEY', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MAGDA COSTA', 39.95, 'income', '2025-07-02', 'Conta PJ', 'MAGDA COSTA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento THALITA RIBEIRO', 39.95, 'income', '2025-07-02', 'Conta PJ', 'THALITA RIBEIRO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento CIBELE APARECIDA', 20.00, 'income', '2025-07-02', 'Conta PJ', 'CIBELE APARECIDA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento EDIANE FERNANDES', 99.90, 'income', '2025-07-02', 'Conta PJ', 'EDIANE FERNANDES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento GLAUCIA RODRIGUES', 100.00, 'income', '2025-07-02', 'Conta PJ', 'GLAUCIA RODRIGUES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ELIANA CRISTINA', 39.95, 'income', '2025-07-02', 'Conta PJ', 'ELIANA CRISTINA', 'Receita');

-- Inserir transações de 3/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento CARLA', 39.95, 'income', '2025-07-03', 'Conta PJ', 'CARLA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MARCELO DEL', 39.95, 'income', '2025-07-03', 'Conta PJ', 'MARCELO DEL', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ALINE FRANCIELI', 75.91, 'income', '2025-07-03', 'Conta Checkout', 'ALINE FRANCIELI', 'Receita');

-- Inserir transações de 4/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento RANIELE CRUVINEL', 75.91, 'income', '2025-07-04', 'Conta PJ', 'RANIELE CRUVINEL', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento GIOVANI PEIXOTO', 40.00, 'income', '2025-07-04', 'Conta PJ', 'GIOVANI PEIXOTO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento PONTO CERTO', 50.00, 'income', '2025-07-04', 'Conta PJ', 'PONTO CERTO', 'Receita');

-- Inserir transações de 5/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento SILVANA SACCHIERO', 75.91, 'income', '2025-07-05', 'Conta PJ', 'SILVANA SACCHIERO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MARINA KRAUSE', 75.91, 'income', '2025-07-05', 'Conta PJ', 'MARINA KRAUSE', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento RENATA DA SILVA', 75.91, 'income', '2025-07-05', 'Conta Checkout', 'RENATA DA SILVA', 'Receita');

-- Inserir transações de 7/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento LILIANE WRASSE', 39.95, 'income', '2025-07-07', 'Conta PJ', 'LILIANE WRASSE', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento LUCIANA DE OLIVEIRA', 39.95, 'income', '2025-07-07', 'Conta PJ', 'LUCIANA DE OLIVEIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento NEILTA LIRA', 39.95, 'income', '2025-07-07', 'Conta PJ', 'NEILTA LIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento THAIS SANTOS', 67.92, 'income', '2025-07-07', 'Conta Checkout', 'THAIS SANTOS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento REGIANE GADELHA', 39.90, 'income', '2025-07-07', 'Conta PJ', 'REGIANE GADELHA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MAURO SERGIO', 75.91, 'income', '2025-07-07', 'Conta Checkout', 'MAURO SERGIO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento REGIANE GOMES', 35.00, 'income', '2025-07-07', 'Conta PJ', 'REGIANE GOMES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento JULIANA SANTOS', 28.00, 'income', '2025-07-07', 'Conta PJ', 'JULIANA SANTOS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento EMILLY VASCONCELOS', 75.91, 'income', '2025-07-07', 'Conta Checkout', 'EMILLY VASCONCELOS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento KELVIN M CORREIA', 75.91, 'income', '2025-07-07', 'Conta Checkout', 'KELVIN M CORREIA', 'Receita');

-- Inserir transações de 8/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MIRELLA TESSAROLLO', 67.92, 'income', '2025-07-08', 'Conta PJ', 'MIRELLA TESSAROLLO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MARCELO DEL', 39.95, 'income', '2025-07-08', 'Conta PJ', 'MARCELO DEL', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento THALITA RIBEIRO', 39.95, 'income', '2025-07-08', 'Conta PJ', 'THALITA RIBEIRO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento GIOVANI PEIXOTO', 40.00, 'income', '2025-07-08', 'Conta PJ', 'GIOVANI PEIXOTO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MARIA APARECIDA', 40.00, 'income', '2025-07-08', 'Conta PJ', 'MARIA APARECIDA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento RONALDO VARAO', 39.95, 'income', '2025-07-08', 'Conta PJ', 'RONALDO VARAO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento LUCIANA DE OLIVEIRA', 39.95, 'income', '2025-07-08', 'Conta PJ', 'LUCIANA DE OLIVEIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ALECSANDRA OLIVEIRA', 75.91, 'income', '2025-07-08', 'Conta Checkout', 'ALECSANDRA OLIVEIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ANGELICA BRAUN', 75.00, 'income', '2025-07-08', 'Conta PJ', 'ANGELICA BRAUN', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ISAAC DA SILVA', 39.95, 'income', '2025-07-08', 'Conta PJ', 'ISAAC DA SILVA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento DALVA HELENA', 39.95, 'income', '2025-07-08', 'Conta PJ', 'DALVA HELENA', 'Receita');

-- Inserir transações de 9/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento NATALLI DA SILVA', 75.91, 'income', '2025-07-09', 'Conta Checkout', 'NATALLI DA SILVA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento FERNANDA VALLERIO', 39.95, 'income', '2025-07-09', 'Conta PJ', 'FERNANDA VALLERIO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento FRANCISCA RODRIGUES', 39.95, 'income', '2025-07-09', 'Conta PJ', 'FRANCISCA RODRIGUES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento NEILTA LIRA', 39.95, 'income', '2025-07-09', 'Conta PJ', 'NEILTA LIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento JAIRO EUSTAQUIO', 39.95, 'income', '2025-07-09', 'Conta PJ', 'JAIRO EUSTAQUIO', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento ANA LUCIA', 20.00, 'income', '2025-07-09', 'Conta PJ', 'ANA LUCIA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento JULIANA SANTOS', 52.00, 'income', '2025-07-09', 'Conta PJ', 'JULIANA SANTOS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento RENATA CARDOSO', 70.00, 'income', '2025-07-09', 'Conta PJ', 'RENATA CARDOSO', 'Receita');

-- Inserir transações de 10/7/2025
INSERT INTO public.transactions (user_id, description, amount, transaction_type, transaction_date, account_name, client_name, category) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento VALDIR JOSE', 67.92, 'income', '2025-07-10', 'Conta PJ', 'VALDIR JOSE', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento TATIELLE MARQUES', 39.95, 'income', '2025-07-10', 'Conta PJ', 'TATIELLE MARQUES', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MARIANA DIAS', 40.00, 'income', '2025-07-10', 'Conta PJ', 'MARIANA DIAS', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento DALVA HELENA', 39.95, 'income', '2025-07-10', 'Conta PJ', 'DALVA HELENA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento MAGDA COSTA', 39.95, 'income', '2025-07-10', 'Conta PJ', 'MAGDA COSTA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento SULAMITA MOREIRA', 35.00, 'income', '2025-07-10', 'Conta PJ', 'SULAMITA MOREIRA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento LEILLIANE SILVA', 75.91, 'income', '2025-07-10', 'Conta PJ', 'LEILLIANE SILVA', 'Receita'),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', 'Pagamento I. C. DE BRITO', 39.95, 'income', '2025-07-10', 'Conta PJ', 'I. C. DE BRITO', 'Receita');

-- Verificar se os dados foram inseridos corretamente
SELECT 
    transaction_date,
    client_name,
    amount,
    account_name,
    COUNT(*) as total_transactions
FROM public.transactions 
WHERE EXTRACT(MONTH FROM transaction_date) = 7 
AND EXTRACT(YEAR FROM transaction_date) = 2025
GROUP BY transaction_date, client_name, amount, account_name
ORDER BY transaction_date, client_name; 