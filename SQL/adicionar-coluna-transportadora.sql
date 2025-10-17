-- ════════════════════════════════════════════════════════════════════
-- ADICIONAR COLUNA TRANSPORTADORA À TABELA OCCURRENCES
-- ════════════════════════════════════════════════════════════════════
-- Data: 17/10/2025
-- ════════════════════════════════════════════════════════════════════

-- PASSO 1: Adicionar coluna transportadora
ALTER TABLE occurrences
ADD COLUMN transportadora TEXT;

-- PASSO 2: Criar índice para melhor performance
CREATE INDEX idx_occurrences_transportadora ON occurrences(transportadora);

-- PASSO 3: Verificar se coluna foi criada
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'occurrences' 
  AND column_name = 'transportadora';

-- Resultado esperado:
-- column_name     | transportadora
-- data_type       | text
-- is_nullable     | YES

-- ════════════════════════════════════════════════════════════════════
-- VALORES POSSÍVEIS (para referência)
-- ════════════════════════════════════════════════════════════════════
--
-- São Miguel
-- Leomar
-- LKW
-- Fritz
-- Vapt Vupt
-- Multi
-- Minuano
-- Garcias
-- Fortimed
-- Outros
--
-- ════════════════════════════════════════════════════════════════════
