-- ============================================================================
-- FORTIMED - CONFIGURAÇÃO SIMPLIFICADA DO BANCO DE DADOS
-- Execute este script no Supabase SQL Editor
-- ============================================================================

-- 1. Criar tabela de ocorrências (sem dependência da tabela users)
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
    created_by UUID -- Referência direta ao auth.uid() do Supabase
);

-- 2. Habilitar RLS na tabela occurrences
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;

-- 3. Remover todas as políticas existentes
DROP POLICY IF EXISTS "Usuários veem apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários atualizam apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários deletam apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem ver ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem deletar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Permitir tudo para usuários autenticados" ON occurrences;

-- 4. Criar políticas RLS simples
CREATE POLICY "Permitir tudo para usuários autenticados"
    ON occurrences FOR ALL
    USING (auth.role() = 'authenticated');

-- 5. Criar índices básicos
CREATE INDEX IF NOT EXISTS idx_occurrences_created_by ON occurrences(created_by);
CREATE INDEX IF NOT EXISTS idx_occurrences_status ON occurrences(status);
CREATE INDEX IF NOT EXISTS idx_occurrences_created_at ON occurrences(created_at DESC);

-- 6. Verificar se a tabela foi criada
SELECT 'Tabela de ocorrências criada com sucesso!' as status;
