-- ════════════════════════════════════════════════════════════════════
-- ADICIONAR ANA PAULA COMO ADMIN NA TABELA public.users
-- ════════════════════════════════════════════════════════════════════
-- 
-- Email: anapaula@fortimeddistribuidora.com.br
-- ID: 2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f (do auth.users)
-- Função: Admin (acesso total ao sistema)
-- Data: 17/10/2025
--
-- ════════════════════════════════════════════════════════════════════

-- INSERIR NA TABELA public.users COM ROLE DE ADMIN
INSERT INTO public.users (
    id,
    email,
    name,
    role,
    created_at,
    updated_at
) VALUES (
    '2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f',
    'anapaula@fortimeddistribuidora.com.br',
    'Ana Paula',
    'admin',
    NOW(),
    NOW()
) 
ON CONFLICT (email) DO UPDATE SET
    id = '2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f',
    name = 'Ana Paula',
    role = 'admin',
    updated_at = NOW()
RETURNING id, email, name, role, created_at, updated_at;


-- ════════════════════════════════════════════════════════════════════
-- VERIFICAR SE FOI INSERIDO CORRETAMENTE
-- ════════════════════════════════════════════════════════════════════

SELECT 
    id,
    email,
    name,
    role,
    created_at,
    updated_at
FROM public.users
WHERE email = 'anapaula@fortimeddistribuidora.com.br';

-- Resultado esperado:
-- id                    | 2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f
-- email                 | anapaula@fortimeddistribuidora.com.br
-- name                  | Ana Paula
-- role                  | admin  ← IMPORTANTE: deve ser 'admin'
-- created_at            | 2025-10-17 ...
-- updated_at            | 2025-10-17 ...

-- ════════════════════════════════════════════════════════════════════
-- TAMBÉM PODE EXECUTAR APENAS A LINHA ABAIXO SE PREFERIR:
-- ════════════════════════════════════════════════════════════════════

-- INSERT INTO public.users (id, email, name, role) VALUES 
-- ('2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f', 'anapaula@fortimeddistribuidora.com.br', 'Ana Paula', 'admin');
