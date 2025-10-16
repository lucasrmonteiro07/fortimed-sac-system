-- Adicionar coluna 'motivo' à tabela 'occurrences'
-- Esta coluna armazenará o motivo da ocorrência

ALTER TABLE occurrences
ADD COLUMN motivo TEXT NULL;

-- Criar índice para melhor performance em filtros
CREATE INDEX idx_occurrences_motivo ON occurrences(motivo);

-- Verificar se a coluna foi adicionada com sucesso
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'occurrences' AND column_name = 'motivo';
