-- ============================================================================
-- FORTIMED - CONFIGURAÇÃO SIMPLIFICADA DO BANCO DE DADOS
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- 1. Criar tabela de usuários para controle de roles
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Criar tabela de ocorrências
CREATE TABLE IF NOT EXISTS occurrences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    num_pedido VARCHAR(100) NOT NULL,
    nota_fiscal VARCHAR(100),
    transportadora VARCHAR(255) NOT NULL,
    nome_cliente VARCHAR(255) NOT NULL,
    ocorrencia TEXT NOT NULL,
    status VARCHAR(50) NOT NULL,
    situacao TEXT,
    responsavel_falha VARCHAR(255),
    responsavel_resolucao VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES users(id)
);

-- 3. Habilitar RLS na tabela occurrences
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;

-- 4. Remover todas as políticas existentes
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

-- 5. Criar políticas RLS com controle de admin
-- Admin pode ver todas as ocorrências
CREATE POLICY "Admin vê todas as ocorrências"
    ON occurrences FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = auth.uid() 
            AND users.role = 'admin'
        )
    );

-- Usuários normais veem apenas suas próprias ocorrências
CREATE POLICY "Usuários veem suas próprias ocorrências"
    ON occurrences FOR SELECT
    USING (auth.uid() = created_by);

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

-- 6. Criar índices básicos
CREATE INDEX IF NOT EXISTS idx_occurrences_created_by ON occurrences(created_by);
CREATE INDEX IF NOT EXISTS idx_occurrences_status ON occurrences(status);
CREATE INDEX IF NOT EXISTS idx_occurrences_created_at ON occurrences(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);

-- 7. Inserir usuário administrativo
INSERT INTO users (id, email, name, role) 
VALUES (
    'e1b0416f-e883-42c9-8e67-30c974b5e392', 
    'administrativo@fortimeddistribuidora.com.br', 
    'Administrador', 
    'admin'
) ON CONFLICT (id) DO UPDATE SET role = 'admin';

-- 8. Verificar se as tabelas foram criadas
SELECT 'Tabelas criadas com sucesso!' as status;
