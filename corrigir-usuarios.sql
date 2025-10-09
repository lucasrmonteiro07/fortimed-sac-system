-- ============================================================================
-- FORTIMED - CORRIGIR USUÁRIOS EXISTENTES
-- Execute este script no Supabase SQL Editor para corrigir conflitos
-- ============================================================================

-- 1. Verificar usuários existentes
SELECT id, email, name FROM users ORDER BY created_at;

-- 2. Verificar usuários do Supabase Auth
SELECT id, email FROM auth.users ORDER BY created_at;

-- 3. Atualizar IDs dos usuários para corresponder ao Supabase Auth
-- (Execute apenas se necessário)

-- Exemplo para o usuário administrativo:
-- UPDATE users 
-- SET id = 'e1b0416f-e883-42c9-8e67-30c974b5e392'
-- WHERE email = 'administrativo@fortimeddistribuidora.com.br';

-- 4. Ou deletar usuários duplicados e recriar
-- DELETE FROM users WHERE email = 'administrativo@fortimeddistribuidora.com.br';

-- 5. Verificar ocorrências existentes
SELECT id, num_pedido, created_by FROM occurrences LIMIT 5;

-- 6. Se necessário, atualizar created_by das ocorrências
-- UPDATE occurrences 
-- SET created_by = 'e1b0416f-e883-42c9-8e67-30c974b5e392'
-- WHERE created_by = 'ID_ANTIGO_AQUI';

-- 7. Verificar se tudo está correto
SELECT 'Verificação concluída!' as status;

