-- Verificar e garantir que RLS está desabilitado na tabela occurrences

-- PASSO 1: Verificar status atual do RLS
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'occurrences';

-- PASSO 2: Se rowsecurity = true, desabilitar RLS
-- Execute apenas se o resultado do PASSO 1 mostrar rowsecurity = true
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;

-- PASSO 3: Remover TODAS as políticas RLS (se houver)
DROP POLICY IF EXISTS admin_can_view_all_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_view_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_create_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_create_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_update_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_update_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_delete_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_delete_own_occurrences ON occurrences;
DROP POLICY IF EXISTS allow_all ON occurrences;
DROP POLICY IF EXISTS occurrences_select_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_insert_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_update_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_delete_policy ON occurrences;

-- PASSO 4: Verificar resultado final
SELECT 
    tablename, 
    rowsecurity,
    (SELECT COUNT(*) FROM pg_policies WHERE tablename = 'occurrences') as num_policies
FROM pg_tables 
WHERE tablename = 'occurrences';

-- PASSO 5: Teste - Tentar listar ocorrências (deve retornar TODAS, sem restrição)
SELECT COUNT(*) as total_occurrences FROM occurrences;

-- RESULTADO ESPERADO:
-- rowsecurity = false (RLS desabilitado)
-- num_policies = 0 (nenhuma política)
-- total_occurrences = [número total de ocorrências]
