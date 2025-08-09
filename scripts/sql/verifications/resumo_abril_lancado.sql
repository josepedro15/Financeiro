-- RESUMO: Dias de abril 2025 já lançados no sistema
-- Baseado nos arquivos de inserção criados

/*
DIAS JÁ LANÇADOS EM ABRIL 2025:
=================================

✅ DIA 01 - LANÇADO (insert_abril_2025_completo.sql)
✅ DIA 02 - LANÇADO (insert_abril_2025_completo.sql) 
✅ DIA 03 - LANÇADO (insert_abril_2025_completo.sql)
✅ DIA 04 - LANÇADO (insert_abril_2025_completo.sql)
✅ DIA 05 - LANÇADO (insert_abril_2025_ultimos_dias.sql)
❌ DIA 06 - NÃO LANÇADO
✅ DIA 07 - LANÇADO (insert_abril_2025_ultimos_dias.sql)
✅ DIA 08 - LANÇADO (insert_abril_2025_ultimos_dias.sql)
✅ DIA 09 - LANÇADO (insert_abril_2025_ultimos_dias.sql)
✅ DIA 10 - LANÇADO (insert_abril_2025_dias_10_11_12_13_14.sql)
✅ DIA 11 - LANÇADO (insert_abril_2025_dias_10_11_12_13_14.sql)
✅ DIA 12 - LANÇADO (insert_abril_2025_dias_10_11_12_13_14.sql)
✅ DIA 13 - LANÇADO (insert_abril_2025_dias_10_11_12_13_14.sql)
✅ DIA 14 - LANÇADO (insert_abril_2025_dias_10_11_12_13_14.sql)
✅ DIA 15 - LANÇADO (insert_abril_2025_dias_15_16_17.sql)
✅ DIA 16 - LANÇADO (insert_abril_2025_dias_15_16_17.sql)
✅ DIA 17 - LANÇADO (insert_abril_2025_dias_15_16_17.sql)
❌ DIA 18 - NÃO LANÇADO
❌ DIA 19 - NÃO LANÇADO
❌ DIA 20 - NÃO LANÇADO
❌ DIA 21 - NÃO LANÇADO
❌ DIA 22 - NÃO LANÇADO
❌ DIA 23 - NÃO LANÇADO
❌ DIA 24 - NÃO LANÇADO
❌ DIA 25 - NÃO LANÇADO
❌ DIA 26 - NÃO LANÇADO
❌ DIA 27 - NÃO LANÇADO
❌ DIA 28 - NÃO LANÇADO
❌ DIA 29 - NÃO LANÇADO
❌ DIA 30 - NÃO LANÇADO

ÚLTIMO DIA LANÇADO: 17 DE ABRIL
DIAS RESTANTES: 18 a 30 (13 dias faltando)

ARQUIVOS DE INSERÇÃO EXECUTADOS:
- insert_abril_2025_completo.sql (dias 1-5, 7-9)
- insert_abril_2025_ultimos_dias.sql (dias 5, 7, 8, 9) 
- insert_abril_2025_dias_10_11_12_13_14.sql (dias 10-14)
- insert_abril_2025_dias_15_16_17.sql (dias 15-17)
*/

-- Query para confirmar no banco:
SELECT 
    'Abril foi lançado até o dia:' as info,
    MAX(EXTRACT(DAY FROM transaction_date)) as ultimo_dia_lancado
FROM public.transactions_2025_04
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 
  AND EXTRACT(MONTH FROM transaction_date) = 4;
