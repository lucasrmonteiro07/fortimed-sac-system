-- Script para REMOVER COMPLETAMENTE todas as políticas RLS na tabela occurrences
-- Objetivo: Fazer com que TODOS vejam TODAS as ocorrências

-- PASSO 1: Listar todas as políticas existentes (para diagnóstico)
SELECT schemaname, tablename, policyname, permissive, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'occurrences'
ORDER BY tablename, policyname;

-- PASSO 2: REMOVER TODAS AS POLÍTICAS ANTIGAS
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

-- PASSO 3: DESABILITAR RLS COMPLETAMENTE
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;

-- PASSO 4: VERIFICAR que RLS foi desabilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'occurrences';

-- Resultado esperado: rowsecurity = false (ou 'f')

-- PASSO 5: CONFIRMAR que não há mais políticas
SELECT schemaname, tablename, policyname
FROM pg_policies
WHERE tablename = 'occurrences';

-- Resultado esperado: SEM LINHAS (nenhuma política)
