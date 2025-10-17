-- ════════════════════════════════════════════════════════════════════
-- PERMITIR QUE ADMIN VEJA TODAS AS OCORRÊNCIAS
-- ════════════════════════════════════════════════════════════════════
-- 
-- Admin (Ana Paula) deve ter acesso completo a todas as ocorrências
-- Usuários normais veem apenas suas próprias ocorrências
-- Data: 17/10/2025
--
-- ════════════════════════════════════════════════════════════════════

-- PASSO 1: Ativar RLS (Row Level Security) na tabela
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;


-- PASSO 2: Política para ADMINS verem TODAS as ocorrências
CREATE POLICY admin_can_view_all_occurrences ON occurrences
FOR SELECT
USING (
  (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin'
);


-- PASSO 3: Política para usuários normais verem apenas suas ocorrências
CREATE POLICY users_can_view_own_occurrences ON occurrences
FOR SELECT
USING (
  (SELECT role FROM public.users WHERE id = auth.uid()) != 'admin'
  AND user_id = auth.uid()
);


-- PASSO 4: Política para ADMINS criarem ocorrências (INSERT)
CREATE POLICY admin_can_create_occurrences ON occurrences
FOR INSERT
WITH CHECK (
  (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin'
);


-- PASSO 5: Política para usuários normais criarem apenas suas ocorrências
CREATE POLICY users_can_create_own_occurrences ON occurrences
FOR INSERT
WITH CHECK (
  (SELECT role FROM public.users WHERE id = auth.uid()) != 'admin'
  AND user_id = auth.uid()
);


-- PASSO 6: Política para ADMINS atualizarem qualquer ocorrência
CREATE POLICY admin_can_update_occurrences ON occurrences
FOR UPDATE
USING (
  (SELECT role FROM public.users WHERE id = auth.uid()) = 'admin'
);


-- PASSO 7: Política para usuários normais atualizarem apenas suas ocorrências
CREATE POLICY users_can_update_own_occurrences ON occurrences
FOR UPDATE
USING (
  (SELECT role FROM public.users WHERE id = auth.uid()) != 'admin'
  AND user_id = auth.uid()
);


-- ════════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO
-- ════════════════════════════════════════════════════════════════════

-- Verificar se RLS está ativado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'occurrences';

-- Resultado esperado:
-- tablename  | rowsecurity
-- occurrences| true

-- Listar todas as políticas
SELECT policyname, tablename, qual 
FROM pg_policies 
WHERE tablename = 'occurrences';

-- Resultado esperado: 6 políticas listadas


-- ════════════════════════════════════════════════════════════════════
-- NOTAS IMPORTANTES
-- ════════════════════════════════════════════════════════════════════
--
-- 1. ADMIN (Ana Paula):
--    - Vê TODAS as ocorrências
--    - Pode criar, editar ocorrências
--    - Sem restrições
--
-- 2. USUÁRIOS NORMAIS (Vendedores):
--    - Veem apenas SUAS próprias ocorrências
--    - Não veem ocorrências de outros usuários
--    - Podem criar/editar apenas suas próprias
--
-- 3. RLS (Row Level Security):
--    - Ativado = Segurança no banco de dados
--    - Sem políticas = Sem acesso (seguro por padrão)
--    - Com políticas = Controle granular por role
--
-- 4. Verificação:
--    - role = 'admin' → acesso total
--    - role = 'user' → acesso limitado
--
-- ════════════════════════════════════════════════════════════════════
