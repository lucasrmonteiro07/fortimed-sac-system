-- ============================================================================
-- FORTIMED - CONFIGURAÇÃO SIMPLES DO BANCO DE DADOS
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- 1. Criar tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
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

-- 5. Criar políticas RLS simples
CREATE POLICY "Permitir tudo para usuários autenticados"
    ON occurrences FOR ALL
    USING (auth.role() = 'authenticated');

-- 6. Criar índices básicos
CREATE INDEX IF NOT EXISTS idx_occurrences_created_by ON occurrences(created_by);
CREATE INDEX IF NOT EXISTS idx_occurrences_status ON occurrences(status);
CREATE INDEX IF NOT EXISTS idx_occurrences_created_at ON occurrences(created_at DESC);

-- 7. Verificar se as tabelas foram criadas
SELECT 'Tabelas criadas com sucesso!' as status;
