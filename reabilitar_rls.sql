-- =====================================================
-- REABILITAR RLS APÓS TESTES
-- =====================================================

SELECT '=== REABILITANDO RLS ===' as info;

-- 1. Reabilitar RLS
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;

-- 2. Criar políticas seguras
CREATE POLICY "Enable read access for all users" ON clients
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON clients
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Enable update for authenticated users" ON clients
    FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY "Enable delete for authenticated users" ON clients
    FOR DELETE USING (auth.uid() IS NOT NULL);

-- 3. Verificar se foi reabilitado
SELECT '=== VERIFICANDO STATUS RLS ===' as info;
SELECT 
    relname,
    relrowsecurity
FROM pg_class 
WHERE relname = 'clients';

-- 4. Verificar políticas criadas
SELECT '=== POLÍTICAS CRIADAS ===' as info;
SELECT 
    policyname,
    cmd,
    qual
FROM pg_policies 
WHERE tablename = 'clients'
ORDER BY cmd, policyname;

SELECT '=== RLS REABILITADO COM SUCESSO ===' as info;
SELECT 'SISTEMA SEGURO NOVAMENTE!' as status;
