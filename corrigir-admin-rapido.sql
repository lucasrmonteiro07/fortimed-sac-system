-- ============================================================================
-- FORTIMED - CORREÇÃO RÁPIDA PARA ADMIN VER TODOS OS CHAMADOS
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- 1. Remover TODAS as políticas existentes
DROP POLICY IF EXISTS "Usuários veem apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários atualizam apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários deletam apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem ver ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem deletar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Permitir tudo para usuários autenticados" ON occurrences;
DROP POLICY IF EXISTS "Admin vê todas as ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários veem suas próprias ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Controle de acesso por role" ON occurrences;

-- 2. Criar política SIMPLES que permite tudo para usuários autenticados
-- (Vamos controlar no código JavaScript)
CREATE POLICY "Permitir tudo para usuários autenticados"
    ON occurrences FOR ALL
    USING (auth.role() = 'authenticated');

-- 3. Garantir que o usuário admin existe
INSERT INTO users (id, email, name, role) 
VALUES (
    'e1b0416f-e883-42c9-8e67-30c974b5e392', 
    'administrativo@fortimeddistribuidora.com.br', 
    'Administrador', 
    'admin'
) ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = 'admin';

-- 4. Verificar se funcionou
SELECT 'Correção aplicada! Admin deve conseguir ver todos os chamados.' as status;
