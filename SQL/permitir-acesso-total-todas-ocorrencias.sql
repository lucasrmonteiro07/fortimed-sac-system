-- ════════════════════════════════════════════════════════════════════
-- PERMITIR ACESSO TOTAL - TODOS VEEM TODAS AS OCORRÊNCIAS
-- ════════════════════════════════════════════════════════════════════
-- 
-- Objetivo: Remover restrições - TODOS têm acesso a TODAS as ocorrências
-- Data: 17/10/2025
--
-- ════════════════════════════════════════════════════════════════════

-- OPÇÃO 1: DESABILITAR RLS (MAIS RÁPIDO - RECOMENDADO)
-- Isto remove todas as restrições de acesso
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;


-- RESULTADO:
-- ✅ Todos os usuários podem ver TODAS as ocorrências
-- ✅ Todos podem criar ocorrências
-- ✅ Todos podem editar qualquer ocorrência
-- ✅ Sem restrições de acesso


-- ════════════════════════════════════════════════════════════════════
-- ALTERNATIVA: Se preferir manter RLS mas permitir acesso total
-- (Execute SOMENTE se a opção acima não funcionar)
-- ════════════════════════════════════════════════════════════════════

-- Remover todas as políticas antigas
-- DROP POLICY IF EXISTS admin_can_view_all_occurrences ON occurrences;
-- DROP POLICY IF EXISTS users_can_view_own_occurrences ON occurrences;
-- DROP POLICY IF EXISTS admin_can_create_occurrences ON occurrences;
-- DROP POLICY IF EXISTS users_can_create_own_occurrences ON occurrences;
-- DROP POLICY IF EXISTS admin_can_update_occurrences ON occurrences;
-- DROP POLICY IF EXISTS users_can_update_own_occurrences ON occurrences;

-- Criar política permissiva que permite tudo
-- CREATE POLICY allow_all ON occurrences
-- FOR ALL
-- USING (true)
-- WITH CHECK (true);


-- ════════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO
-- ════════════════════════════════════════════════════════════════════

-- Verificar se RLS está desabilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'occurrences';

-- Resultado esperado:
-- tablename  | rowsecurity
-- occurrences| false  (RLS desabilitado)


-- ════════════════════════════════════════════════════════════════════
-- NOTAS IMPORTANTES
-- ════════════════════════════════════════════════════════════════════
--
-- 1. Com RLS DESABILITADO:
--    ✅ Todos veem TODAS as ocorrências
--    ✅ Todos podem criar ocorrências
--    ✅ Todos podem editar qualquer ocorrência
--    ✅ Sem restrições
--
-- 2. Tabela afetada:
--    • occurrences (dados de ocorrências)
--
-- 3. Outros dados (auth, configurações) continuam protegidos
--
-- 4. Se precisar voltar com restrições depois:
--    ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;
--
-- ════════════════════════════════════════════════════════════════════
