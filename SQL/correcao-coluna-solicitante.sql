-- ════════════════════════════════════════════════════════════════════
-- CORRIGIR ERRO: COLUNA 'SOLICITANTE' FALTANDO
-- ════════════════════════════════════════════════════════════════════
-- Data: 17/10/2025
-- Erro: "Could not find the 'solicitante' column of 'occurrences'"
-- ════════════════════════════════════════════════════════════════════

-- PASSO 1: Adicionar coluna solicitante
ALTER TABLE occurrences
ADD COLUMN solicitante TEXT;

-- PASSO 2: Criar índice para melhor performance
CREATE INDEX idx_occurrences_solicitante ON occurrences(solicitante);

-- PASSO 3: Verificar coluna foi criada
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'occurrences' 
  AND column_name = 'solicitante';

-- Resultado esperado:
-- column_name | solicitante
-- data_type   | text
-- is_nullable | YES (true)

-- ════════════════════════════════════════════════════════════════════
-- INFORMAÇÕES DA COLUNA
-- ════════════════════════════════════════════════════════════════════
-- Nome:        solicitante
-- Tipo:        TEXT
-- Nullable:    SIM (NULL permitido)
-- Índice:      SIM (para performance)
-- Descrição:   Nome do usuário que solicitou/criou a ocorrência
-- Preenchimento: Automático via JavaScript (authManager.getCurrentUser().name)
-- ════════════════════════════════════════════════════════════════════
