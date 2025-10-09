-- ============================================================================
-- FORTIMED - CRIAÇÃO DE USUÁRIOS DO SISTEMA
-- Script SQL para criar usuários no Supabase
-- ============================================================================
-- 
-- INSTRUÇÕES:
-- 1. Acesse seu projeto no Supabase (https://app.supabase.com)
-- 2. Vá em "SQL Editor" no menu lateral
-- 3. Clique em "+ New query"
-- 4. Copie e cole este arquivo
-- 5. Clique em "RUN" ou pressione Ctrl+Enter
-- 6. Aguarde a mensagem "Success. No rows returned"
-- 
-- ============================================================================

-- ============================================================================
-- CRIAR USUÁRIOS NO SUPABASE AUTH
-- ============================================================================
-- 
-- IMPORTANTE: Estes usuários precisam ser criados manualmente no Supabase Auth
-- Vá em Authentication > Users > Add User e crie cada usuário com email e senha
-- 
-- Lista de usuários para criar:
-- 
-- 1. Admin
--    Email: administrativo@fortimeddistribuidora.com.br
--    Senha: Compras@01
-- 
-- 2. Vendas 01
--    Email: vendas01@fortimeddistribuidora.com.br
--    Senha: vendas01
-- 
-- 3. Vendas 02
--    Email: vendas02@fortimeddistribuidora.com.br
--    Senha: vendas02
-- 
-- 4. Vendas 03
--    Email: vendas03@fortimeddistribuidora.com.br
--    Senha: vendas03
-- 
-- 5. Vendas 04
--    Email: vendas04@fortimeddistribuidora.com.br
--    Senha: vendas04
-- 
-- 6. Vendas 05
--    Email: vendas05@fortimeddistribuidora.com.br
--    Senha: vendas05
-- 
-- 7. Vendas 06
--    Email: vendas06@fortimeddistribuidora.com.br
--    Senha: vendas06
-- 
-- ============================================================================

-- ============================================================================
-- ATUALIZAR POLÍTICAS RLS PARA FILTRAR POR USUÁRIO
-- ============================================================================

-- Remover políticas antigas
DROP POLICY IF EXISTS "Usuários autenticados podem ver ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem deletar ocorrências" ON occurrences;

-- Criar novas políticas que filtram por usuário
-- Política: Usuários só podem ver suas próprias ocorrências
CREATE POLICY "Usuários veem apenas suas ocorrências"
    ON occurrences FOR SELECT
    USING (auth.uid() = created_by);

-- Política: Usuários podem criar ocorrências (sempre associadas ao usuário logado)
CREATE POLICY "Usuários podem criar ocorrências"
    ON occurrences FOR INSERT
    WITH CHECK (auth.uid() = created_by);

-- Política: Usuários podem atualizar apenas suas próprias ocorrências
CREATE POLICY "Usuários atualizam apenas suas ocorrências"
    ON occurrences FOR UPDATE
    USING (auth.uid() = created_by)
    WITH CHECK (auth.uid() = created_by);

-- Política: Usuários podem deletar apenas suas próprias ocorrências
CREATE POLICY "Usuários deletam apenas suas ocorrências"
    ON occurrences FOR DELETE
    USING (auth.uid() = created_by);

-- ============================================================================
-- ADICIONAR CAMPO DE ROLE PARA DIFERENCIAR ADMIN DE USUÁRIOS
-- ============================================================================

-- Adicionar coluna role na tabela users se não existir
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS role VARCHAR(50) DEFAULT 'user';

-- Adicionar comentário
COMMENT ON COLUMN users.role IS 'Role do usuário: admin ou user';

-- ============================================================================
-- CRIAR POLÍTICA ESPECIAL PARA ADMIN (se necessário)
-- ============================================================================

-- Política adicional: Admin pode ver todas as ocorrências
-- (Descomente se quiser que o admin veja todas as ocorrências)
/*
CREATE POLICY "Admin pode ver todas as ocorrências"
    ON occurrences FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );
*/

-- ============================================================================
-- VERIFICAÇÃO FINAL
-- ============================================================================

-- Verificar políticas criadas
SELECT policyname, tablename, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'occurrences'
ORDER BY policyname;

-- ============================================================================
-- SUCESSO!
-- ============================================================================
-- 
-- Próximos passos:
-- 1. Crie os usuários manualmente no Supabase Auth (Authentication > Users)
-- 2. Teste o login com cada usuário
-- 3. Verifique se cada usuário vê apenas suas próprias ocorrências
-- 
-- ============================================================================
