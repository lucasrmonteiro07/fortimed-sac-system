-- ============================================================================
-- FORTIMED - CONFIGURAÇÃO DO BANCO DE DADOS
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- Criar tabela de usuários se não existir
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Criar tabela de ocorrências se não existir
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

-- Habilitar RLS
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;

-- Remover políticas antigas
DROP POLICY IF EXISTS "Usuários veem apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários atualizam apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários deletam apenas suas ocorrências" ON occurrences;

-- Criar políticas RLS
CREATE POLICY "Usuários veem apenas suas ocorrências"
    ON occurrences FOR SELECT
    USING (auth.uid() = created_by);

CREATE POLICY "Usuários podem criar ocorrências"
    ON occurrences FOR INSERT
    WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Usuários atualizam apenas suas ocorrências"
    ON occurrences FOR UPDATE
    USING (auth.uid() = created_by)
    WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Usuários deletam apenas suas ocorrências"
    ON occurrences FOR DELETE
    USING (auth.uid() = created_by);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_occurrences_created_by ON occurrences(created_by);
CREATE INDEX IF NOT EXISTS idx_occurrences_status ON occurrences(status);
CREATE INDEX IF NOT EXISTS idx_occurrences_created_at ON occurrences(created_at DESC);
