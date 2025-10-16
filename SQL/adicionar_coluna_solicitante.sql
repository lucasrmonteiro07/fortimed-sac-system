-- ============================================================================
-- ADICIONAR COLUNA 'SOLICITANTE' À TABELA 'OCCURRENCES'
-- ============================================================================
-- Esta coluna armazenará o nome do usuário que solicitou a ocorrência
-- O preenchimento é automático com o nome do usuário logado na plataforma

ALTER TABLE occurrences
ADD COLUMN solicitante TEXT NULL;

-- Criar índice para melhor performance em filtros
CREATE INDEX idx_occurrences_solicitante ON occurrences(solicitante);

-- ============================================================================
-- VERIFICAÇÃO
-- ============================================================================
-- Executar esta query para confirmar se a coluna foi adicionada com sucesso

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'occurrences' AND column_name = 'solicitante';

-- ============================================================================
-- NOTAS IMPORTANTES
-- ============================================================================
-- 1. A coluna 'solicitante' será preenchida automaticamente no formulário
-- 2. O valor padrão será o nome do usuário logado (authManager.getCurrentUser().name)
-- 3. Tipo de dados: TEXT (permite nomes de qualquer tamanho)
-- 4. Nullable: SIM (NULL para ocorrências criadas antes desta alteração)
-- 5. Índice criado para otimizar filtros e buscas por solicitante

-- ============================================================================
-- EXEMPLO DE DADOS
-- ============================================================================
-- solicitante | Significado
-- ------------|------------------------------------------
-- João Silva  | Ocorrência criada por João Silva
-- NULL        | Ocorrências criadas antes desta atualização
-- Vendedor01  | Email do usuário se nome não disponível
