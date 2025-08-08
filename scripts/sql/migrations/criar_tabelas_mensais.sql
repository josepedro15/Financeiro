-- Script para criar tabelas mensais separadas e migrar dados
-- Execute este script no Supabase SQL Editor

-- 1. Criar tabelas para cada mês de 2025
SELECT '=== CRIANDO TABELAS MENSAIS ===' as info;

-- Janeiro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_01 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Fevereiro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_02 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Março 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_03 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Abril 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_04 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Maio 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_05 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Junho 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_06 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Julho 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_07 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Agosto 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_08 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Setembro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_09 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Outubro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_10 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Novembro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_11 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Dezembro 2025
CREATE TABLE IF NOT EXISTS public.transactions_2025_12 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    client_id UUID,
    account_id UUID,
    description TEXT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('income', 'expense')),
    category VARCHAR(100),
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 2. Desabilitar RLS em todas as tabelas mensais
SELECT '=== DESABILITANDO RLS DAS TABELAS MENSAIS ===' as info;

ALTER TABLE public.transactions_2025_01 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_02 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_03 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_04 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_05 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_06 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_07 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_08 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_09 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_10 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_11 DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions_2025_12 DISABLE ROW LEVEL SECURITY;

-- 3. Migrar dados existentes para as tabelas mensais
SELECT '=== MIGRANDO DADOS EXISTENTES ===' as info;

-- Janeiro 2025
INSERT INTO public.transactions_2025_01 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 1;

-- Fevereiro 2025
INSERT INTO public.transactions_2025_02 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 2;

-- Março 2025
INSERT INTO public.transactions_2025_03 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 3;

-- Abril 2025
INSERT INTO public.transactions_2025_04 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 4;

-- Maio 2025
INSERT INTO public.transactions_2025_05 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 5;

-- Junho 2025
INSERT INTO public.transactions_2025_06 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 6;

-- Julho 2025
INSERT INTO public.transactions_2025_07 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 7;

-- Agosto 2025
INSERT INTO public.transactions_2025_08 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 8;

-- Setembro 2025
INSERT INTO public.transactions_2025_09 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 9;

-- Outubro 2025
INSERT INTO public.transactions_2025_10 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 10;

-- Novembro 2025
INSERT INTO public.transactions_2025_11 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 11;

-- Dezembro 2025
INSERT INTO public.transactions_2025_12 (id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at)
SELECT id, user_id, client_id, account_id, description, amount, transaction_type, category, transaction_date, created_at, updated_at
FROM public.transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2025 AND EXTRACT(MONTH FROM transaction_date) = 12;

-- 4. Criar índices para performance
SELECT '=== CRIANDO ÍNDICES OTIMIZADOS ===' as info;

CREATE INDEX IF NOT EXISTS idx_transactions_2025_01_user_type ON public.transactions_2025_01(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_02_user_type ON public.transactions_2025_02(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_03_user_type ON public.transactions_2025_03(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_04_user_type ON public.transactions_2025_04(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_05_user_type ON public.transactions_2025_05(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_06_user_type ON public.transactions_2025_06(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_07_user_type ON public.transactions_2025_07(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_08_user_type ON public.transactions_2025_08(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_09_user_type ON public.transactions_2025_09(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_10_user_type ON public.transactions_2025_10(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_11_user_type ON public.transactions_2025_11(user_id, transaction_type);
CREATE INDEX IF NOT EXISTS idx_transactions_2025_12_user_type ON public.transactions_2025_12(user_id, transaction_type);

-- 5. Verificar migração
SELECT '=== VERIFICAÇÃO DA MIGRAÇÃO ===' as info;

SELECT 
  'Janeiro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_01
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Fevereiro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_02
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Março 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_03
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Abril 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_04
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Maio 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_05
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Junho 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_06
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Julho 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_07
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Agosto 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_08
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Setembro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_09
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Outubro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_10
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Novembro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_11
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'

UNION ALL

SELECT 
  'Dezembro 2025' as mes,
  COUNT(*) as total_transacoes,
  SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento
FROM public.transactions_2025_12
WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36';

-- 6. Total geral das tabelas mensais
SELECT '=== TOTAL GERAL DAS TABELAS MENSAIS ===' as info;

SELECT 
  'TOTAL GERAL' as tipo,
  SUM(total_transacoes) as total_transacoes,
  SUM(faturamento) as faturamento_total,
  ROUND(SUM(faturamento), 2) as faturamento_arredondado
FROM (
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_01 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_02 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_03 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_04 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_05 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_06 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_07 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_08 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_09 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_10 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_11 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
  UNION ALL
  SELECT COUNT(*) as total_transacoes, SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) as faturamento FROM public.transactions_2025_12 WHERE user_id = '2dc520e3-5f19-4dfe-838b-1aca7238ae36'
) as totals;

SELECT '=== TABELAS MENSAIS CRIADAS COM SUCESSO ===' as info;
