-- ============================================================================
-- FORTIMED - LIMPAR OCORRÊNCIAS DUPLICADAS
-- Execute este script no Supabase SQL Editor para remover duplicatas
-- ============================================================================

-- 1. Verificar ocorrências duplicadas por num_pedido
SELECT 
    num_pedido, 
    COUNT(*) as total,
    array_agg(id) as ids,
    array_agg(status) as statuses
FROM occurrences 
GROUP BY num_pedido 
HAVING COUNT(*) > 1
ORDER BY total DESC;

-- 2. Manter apenas a ocorrência mais recente de cada num_pedido
-- (Execute apenas se quiser remover as duplicatas)
/*
WITH duplicatas AS (
    SELECT 
        id,
        ROW_NUMBER() OVER (
            PARTITION BY num_pedido 
            ORDER BY created_at DESC
        ) as rn
    FROM occurrences
)
DELETE FROM occurrences 
WHERE id IN (
    SELECT id 
    FROM duplicatas 
    WHERE rn > 1
);
*/

-- 3. Verificar resultado após limpeza
SELECT 
    num_pedido, 
    COUNT(*) as total
FROM occurrences 
GROUP BY num_pedido 
ORDER BY total DESC;

-- 4. Mostrar total de ocorrências
SELECT COUNT(*) as total_ocorrencias FROM occurrences;

