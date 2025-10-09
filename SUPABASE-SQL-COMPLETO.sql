-- ============================================================================
-- FORTIMED - SISTEMA DE CONTROLE DE OCORRÊNCIAS
-- Script SQL Completo para Supabase
-- ============================================================================
-- 
-- INSTRUÇÕES:
-- 1. Acesse seu projeto no Supabase (https://app.supabase.com)
-- 2. Vá em "SQL Editor" no menu lateral
-- 3. Clique em "+ New query"
-- 4. Copie e cole TODO este arquivo
-- 5. Clique em "RUN" ou pressione Ctrl+Enter
-- 6. Aguarde a mensagem "Success. No rows returned"
-- 
-- ============================================================================

-- ============================================================================
-- TABELA: users
-- Armazena informações dos usuários do sistema
-- ============================================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Adicionar comentários às colunas
COMMENT ON TABLE users IS 'Tabela de usuários do sistema Fortimed';
COMMENT ON COLUMN users.id IS 'Identificador único do usuário (UUID)';
COMMENT ON COLUMN users.email IS 'Email do usuário (único)';
COMMENT ON COLUMN users.password_hash IS 'Hash da senha (gerenciado pelo Supabase Auth)';
COMMENT ON COLUMN users.name IS 'Nome completo do usuário';
COMMENT ON COLUMN users.created_at IS 'Data e hora de criação do registro';

-- ============================================================================
-- TABELA: occurrences
-- Armazena as ocorrências/SAC registradas
-- ============================================================================

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

-- Adicionar comentários às colunas
COMMENT ON TABLE occurrences IS 'Tabela de ocorrências/SAC do sistema Fortimed';
COMMENT ON COLUMN occurrences.id IS 'Identificador único da ocorrência (UUID)';
COMMENT ON COLUMN occurrences.num_pedido IS 'Número do pedido (ex: NF 1535)';
COMMENT ON COLUMN occurrences.nota_fiscal IS 'Número da nota fiscal (opcional)';
COMMENT ON COLUMN occurrences.transportadora IS 'Nome da transportadora';
COMMENT ON COLUMN occurrences.nome_cliente IS 'Nome do cliente';
COMMENT ON COLUMN occurrences.ocorrencia IS 'Descrição detalhada da ocorrência';
COMMENT ON COLUMN occurrences.status IS 'Status atual (ABERTO, EM ANDAMENTO, RESOLVIDO, FECHADO)';
COMMENT ON COLUMN occurrences.situacao IS 'Informações adicionais sobre a situação (opcional)';
COMMENT ON COLUMN occurrences.responsavel_falha IS 'Responsável pela falha (opcional)';
COMMENT ON COLUMN occurrences.responsavel_resolucao IS 'Responsável pela resolução (opcional)';
COMMENT ON COLUMN occurrences.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN occurrences.updated_at IS 'Data e hora da última atualização';
COMMENT ON COLUMN occurrences.created_by IS 'UUID do usuário que criou a ocorrência';

-- ============================================================================
-- ÍNDICES
-- Melhoram a performance das consultas
-- ============================================================================

-- Índice para buscas por número de pedido
CREATE INDEX IF NOT EXISTS idx_occurrences_num_pedido 
ON occurrences(num_pedido);

-- Índice para filtros por status
CREATE INDEX IF NOT EXISTS idx_occurrences_status 
ON occurrences(status);

-- Índice para ordenação por data de criação (descendente)
CREATE INDEX IF NOT EXISTS idx_occurrences_created_at 
ON occurrences(created_at DESC);

-- Índice para buscas por cliente
CREATE INDEX IF NOT EXISTS idx_occurrences_nome_cliente 
ON occurrences(nome_cliente);

-- Índice para buscas por transportadora
CREATE INDEX IF NOT EXISTS idx_occurrences_transportadora 
ON occurrences(transportadora);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- Sistema de segurança em nível de linha
-- ============================================================================

-- Habilitar RLS na tabela occurrences
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;

-- Política: Usuários autenticados podem visualizar todas as ocorrências
CREATE POLICY "Usuários autenticados podem ver ocorrências"
    ON occurrences FOR SELECT
    USING (auth.role() = 'authenticated');

-- Política: Usuários autenticados podem criar ocorrências
CREATE POLICY "Usuários autenticados podem criar ocorrências"
    ON occurrences FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Política: Usuários autenticados podem atualizar ocorrências
CREATE POLICY "Usuários autenticados podem atualizar ocorrências"
    ON occurrences FOR UPDATE
    USING (auth.role() = 'authenticated');

-- Política: Usuários autenticados podem deletar ocorrências
CREATE POLICY "Usuários autenticados podem deletar ocorrências"
    ON occurrences FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================================================
-- FUNÇÃO: Atualizar updated_at automaticamente
-- Atualiza o campo updated_at sempre que um registro é modificado
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para atualizar updated_at automaticamente
DROP TRIGGER IF EXISTS update_occurrences_updated_at ON occurrences;
CREATE TRIGGER update_occurrences_updated_at
    BEFORE UPDATE ON occurrences
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- DADOS DE EXEMPLO (OPCIONAL)
-- Descomente as linhas abaixo se quiser inserir dados de teste
-- ============================================================================

/*
-- Criar usuário de exemplo
INSERT INTO users (email, password_hash, name) VALUES 
    ('admin@fortimed.com', 'managed_by_supabase_auth', 'Administrador Fortimed');

-- Criar ocorrências de exemplo
INSERT INTO occurrences (
    num_pedido, 
    nota_fiscal, 
    transportadora, 
    nome_cliente, 
    ocorrencia, 
    status,
    situacao
) VALUES 
    (
        'NF 1535',
        'None',
        'EXPRESSO SÃO MIGUEL',
        'HOESP',
        'DEVOLVIDOS 35 PACOTES DE MÁSCARA FORTFLEX POR QUEIXA DE MAL CHEIRO.',
        'ABERTO',
        'DESCONTO NO PRÓXIMO PEDIDO.'
    ),
    (
        'NF 1620',
        '98765',
        'TRANSPORTADORA RAPIDEX',
        'HOSPITAL SANTA MARIA',
        'ATRASO NA ENTREGA DE LUVAS CIRÚRGICAS',
        'EM ANDAMENTO',
        'CONTATO COM TRANSPORTADORA REALIZADO'
    ),
    (
        'NF 1705',
        '45678',
        'LOGÍSTICA BRASIL',
        'CLÍNICA SÃO JOSÉ',
        'PRODUTO AVARIADO NA ENTREGA',
        'RESOLVIDO',
        'REPOSIÇÃO REALIZADA'
    );
*/

-- ============================================================================
-- VIEWS ÚTEIS (OPCIONAL)
-- Views para facilitar consultas comuns
-- ============================================================================

-- View: Ocorrências abertas
CREATE OR REPLACE VIEW occurrences_open AS
SELECT * FROM occurrences
WHERE status = 'ABERTO'
ORDER BY created_at DESC;

-- View: Estatísticas por status
CREATE OR REPLACE VIEW stats_by_status AS
SELECT 
    status,
    COUNT(*) as total,
    COUNT(CASE WHEN created_at >= NOW() - INTERVAL '30 days' THEN 1 END) as last_30_days
FROM occurrences
GROUP BY status
ORDER BY total DESC;

-- View: Estatísticas por transportadora
CREATE OR REPLACE VIEW stats_by_transportadora AS
SELECT 
    transportadora,
    COUNT(*) as total_ocorrencias,
    COUNT(CASE WHEN status = 'ABERTO' THEN 1 END) as abertas,
    COUNT(CASE WHEN status = 'RESOLVIDO' THEN 1 END) as resolvidas
FROM occurrences
GROUP BY transportadora
ORDER BY total_ocorrencias DESC;

-- ============================================================================
-- VERIFICAÇÃO FINAL
-- Execute estas queries para verificar se tudo foi criado corretamente
-- ============================================================================

-- Verificar tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('users', 'occurrences');

-- Verificar índices criados
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'occurrences';

-- Verificar políticas RLS
SELECT policyname, tablename 
FROM pg_policies 
WHERE tablename = 'occurrences';

-- ============================================================================
-- SUCESSO!
-- Se você chegou até aqui sem erros, o banco de dados está pronto!
-- ============================================================================

-- Próximos passos:
-- 1. Vá em "Authentication" > "Providers" e confirme que "Email" está habilitado
-- 2. Vá em "Settings" > "API" e copie:
--    - Project URL
--    - anon public key
-- 3. Use essas informações no sistema web

-- ============================================================================
-- FIM DO SCRIPT
-- ============================================================================
