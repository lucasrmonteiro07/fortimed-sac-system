-- ============================================================================
-- FORTIMED - CRIAÇÃO COMPLETA DE USUÁRIOS DO SISTEMA
-- Script SQL para criar usuários e configurar políticas no Supabase
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
-- CRIAR USUÁRIOS NO SUPABASE AUTH (via SQL)
-- ============================================================================
-- 
-- NOTA: O Supabase não permite criar usuários diretamente via SQL
-- Use o arquivo usuarios.csv para importar via interface ou crie manualmente
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
-- CRIAR POLÍTICA ESPECIAL PARA ADMIN (OPCIONAL)
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
-- 1. Importe o arquivo usuarios.csv no Supabase Auth
-- 2. OU crie os usuários manualmente no Supabase Auth (Authentication > Users)
-- 3. Teste o login com cada usuário
-- 4. Verifique se cada usuário vê apenas suas próprias ocorrências
-- 
-- ============================================================================
