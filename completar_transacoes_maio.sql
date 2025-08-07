-- Script para completar as transações faltantes de maio de 2025
-- Usuário: 2dc520e3-5f19-4dfe-838b-1aca7238ae36
-- Objetivo: Inserir apenas as transações que estão faltando

-- Primeiro, vamos verificar o que já existe no banco
SELECT '=== VERIFICAÇÃO ATUAL ===' as info;
SELECT 
    COUNT(*) as total_atual,
    SUM(amount) as faturamento_atual
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31';

-- Inserir transações que podem estar faltando (dias 22-31)
-- Estas são as transações finais que podem não ter sido inseridas

-- 5/22/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ANGELA MARIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'RANDSON ARAUJO', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'JOSÉ COPAT', 34.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'JOCEAN S SANTOS', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ADRIANO MACHADO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ADRIANO SANTOS', 80.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ERISLENE FERNANDES', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ANIELLE PEREIRA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'A.F GESTAO', 29.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ARYANA PEREIRA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'CRISTINA ARARUNA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'PAULO ROGERIO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'YUNEISIS ESPINOSA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'JOYCE MELRIN', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'ELAINE APARECIDA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-22', 'PRISCILA REGINA', 113.81, 'income', NOW(), NOW());

-- 5/23/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'JESSICA CORREIA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'CINTIA PEREIRA', 35.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'LUCINEIA CRISTINA', 25.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'GEOVANA DA MOTA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'DANIELA ALVES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'DIEGO RODRIGUES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'SANDRA MICHELINI', 20.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'CLAUDIA CRUZ', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'GABRIELE BORGES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'REBECA RODRIGUES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'PAMELA DE SOUZA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'LUCIANE DOS SANTOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-23', 'ELOIZA APARECIDA', 79.90, 'income', NOW(), NOW());

-- 5/24/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'MARIA DAS GRAÇAS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'GEOVANA CRISTINA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'LAIANE DOS SANTOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'EDWIN CLAURE', 37.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'JAQUILENE GOMES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-24', 'NISIA SILVA', 40.00, 'income', NOW(), NOW());

-- 5/26/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'LUMA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'LORENE RODRIGUES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'MATEUS MELO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'VANESSA DOS SANTOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'LUCIENE DE SOUSA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'JUSSARA LOPES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'ROSANGELA OLIVEIRA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'MAYRA GIL', 113.81, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'GENEROSA DE OLIVEIRA', 50.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'RODRIGO LINS', 38.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'MARCELO LINDOSO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'SIMONE PEREIRA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'DIANA DOS SANTOS', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'CLAUDIONOR TRINDADE', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'ELISVANE APARECIDA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'MAYNARA SEVERINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'JESSICA CORREIA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'FABIANA DA SILVA', 33.96, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'PETERSON MIRANDA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'PEDRO MIRANDA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-26', 'ALEXANDRE MOUSQUER', 93.85, 'income', NOW(), NOW());

-- 5/27/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'SANDRA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'DARLENE GONÇALVES', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'VIVIANE BARBOSA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'ADRIANA VIANA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'ADJANE DE SOUZA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'JESSICA VASCONCELOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'HELIO RIBEIRO', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'PADARIA E CONFEITARIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'EUNICE COSTA', 39.53, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'MARIA DAS DORES', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'SERGIO ROSA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'MONICA NOBRE', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'CLEUDE BARBOSA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'MARCIA CRISTINA', 27.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'ROSANE NASCIMENTO', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'JOSE WILKER', 33.96, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'FMG REPRESENTAÇOES', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'ALINE APARECIDA', 34.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'ROMILDA CASSIA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-27', 'NEIDE SANTANA', 40.00, 'income', NOW(), NOW());

-- 5/28/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'MARIA ROZIANE', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'ERICA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'STEFANIA PIRES', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'ANA CALINA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'FL MONTAGENS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'RODRIGO LINS', 37.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'ORLANEI CORREIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'EDUARDO PEDROSO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'SILVIA ADRIANA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'SUZENANDO GOMES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'MONICA MARIA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'LUCIA LOPES', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-28', 'ISABEL FERREIRA', 67.92, 'income', NOW(), NOW());

-- 5/29/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'EDWIN CLAURE', 37.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'SOLANGE LUCIANO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'JOSEMARA AZEREDO', 42.54, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'FRANCISCO ALEXANDRE', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'ROSANGELA SOTTO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'SANDRA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'PETERSON MIRANDA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'JUSSARA LOPES', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'MAYNARA SEVERINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'DANIELE COSTA', 64.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'GEOVANA CRISTINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'NISIA SILVA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'JUANA BEATRIZ', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'SANDERSON ALBINO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'CLAUDIO EUGENIO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'JOAO BOSCO', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'ALINE SA CAVALCANTI', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'IZABELLA THAIS', 67.90, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'PRISCILLA MOREIRA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'LEIDIANE PENICHE', 68.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'LUIZ CARLOS', 35.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'MARIA LINDAVA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-29', 'GUIPSON FLAVIO', 101.83, 'income', NOW(), NOW());

-- 5/30/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'KAYANNE GEOVANA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'ANGELICA CIRQUEIRA', 67.92, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'ALLAN LAUREANO', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'ADJANE DE SOUZA', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'MARIA ROZIANE', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'ERICA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'PRISCILA RODRIGUES', 84.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'GAMA FASHION', 33.96, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'JOSELI SILVA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'CINTIA PEREIRA', 43.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'JESSICA VASCONCELOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'AMELIA LILIAN', 40.00, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'DIVINA APARECIDA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'ROSANGELA SOTTO', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-30', 'GEANE TAVARES', 101.83, 'income', NOW(), NOW());

-- 5/31/2025
INSERT INTO public.transactions (user_id, transaction_date, description, amount, transaction_type, created_at, updated_at) VALUES
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'ESTEFANY REGINA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'GILENE VIANA', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'RAI PASSOS', 39.95, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'ROSANGELA APARECIDA', 75.91, 'income', NOW(), NOW()),
('2dc520e3-5f19-4dfe-838b-1aca7238ae36', '2025-05-31', 'DOUGLAS RIBEIRO', 75.91, 'income', NOW(), NOW());

-- Verificar resultado final
SELECT '=== RESULTADO FINAL ===' as info;
SELECT 
    COUNT(*) as total_transacoes_final,
    SUM(amount) as faturamento_total_final,
    ROUND(SUM(amount), 2) as faturamento_arredondado_final
FROM public.transactions 
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
AND transaction_date >= '2025-05-01' 
AND transaction_date <= '2025-05-31'; 