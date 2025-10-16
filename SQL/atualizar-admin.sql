-- ============================================================================
-- FORTIMED - ATUALIZAR SISTEMA PARA SUPORTE DE ADMIN
-- Execute este script no Supabase SQL Editor para adicionar funcionalidade de admin
-- ============================================================================

-- 1. Criar tabela de usuários se não existir
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Atualizar tabela occurrences para ter foreign key
ALTER TABLE occurrences 
ADD COLUMN IF NOT EXISTS created_by_name VARCHAR(255);

-- Adicionar foreign key constraint se não existir
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'occurrences_created_by_fkey'
    ) THEN
        ALTER TABLE occurrences 
        ADD CONSTRAINT occurrences_created_by_fkey 
        FOREIGN KEY (created_by) REFERENCES users(id);
    END IF;
END $$;

-- 3. Remover políticas antigas
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

-- 4. Criar novas políticas com controle de admin
-- Política única que permite admin ver tudo e usuários verem apenas suas próprias
CREATE POLICY "Controle de acesso por role"
    ON occurrences FOR SELECT
    USING (
        -- Admin pode ver tudo
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
        OR
        -- Usuários normais veem apenas suas próprias
        auth.uid() = created_by
    );

-- Todos podem criar ocorrências
CREATE POLICY "Usuários podem criar ocorrências"
    ON occurrences FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Todos podem atualizar suas próprias ocorrências
CREATE POLICY "Usuários atualizam suas próprias ocorrências"
    ON occurrences FOR UPDATE
    USING (auth.uid() = created_by)
    WITH CHECK (auth.uid() = created_by);

-- Todos podem deletar suas próprias ocorrências
CREATE POLICY "Usuários deletam suas próprias ocorrências"
    ON occurrences FOR DELETE
    USING (auth.uid() = created_by);

-- 5. Inserir usuário administrativo
INSERT INTO users (id, email, name, role) 
VALUES (
    'e1b0416f-e883-42c9-8e67-30c974b5e392', 
    'administrativo@fortimeddistribuidora.com.br', 
    'Administrador', 
    'admin'
) ON CONFLICT (id) DO UPDATE SET role = 'admin';

-- 6. Criar índices
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_occurrences_created_by ON occurrences(created_by);

-- 7. Verificar resultado
SELECT 'Sistema atualizado com sucesso! Admin pode ver todos os chamados.' as status;
