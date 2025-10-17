-- ════════════════════════════════════════════════════════════════════
-- CRIAR NOVO ADMIN: ANA PAULA (COM PASSWORD_HASH)
-- ════════════════════════════════════════════════════════════════════
-- 
-- Email: anapaula@fortimeddistribuidora.com.br
-- Senha: Compras@01
-- ID: 2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f
-- Função: Admin
-- Data: 17/10/2025
--
-- ════════════════════════════════════════════════════════════════════

-- INSERIR NA TABELA public.users COM TODOS OS CAMPOS OBRIGATÓRIOS
INSERT INTO public.users (
    id,
    email,
    password_hash,
    name,
    role,
    created_at,
    updated_at
) VALUES (
    '2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f',
    'anapaula@fortimeddistribuidora.com.br',
    crypt('Compras@01', gen_salt('bf')),
    'Ana Paula',
    'admin',
    NOW(),
    NOW()
)
ON CONFLICT (email) DO UPDATE SET
    password_hash = crypt('Compras@01', gen_salt('bf')),
    name = 'Ana Paula',
    role = 'admin',
    updated_at = NOW()
RETURNING id, email, name, role, created_at, updated_at;


-- ════════════════════════════════════════════════════════════════════
-- VERIFICAR SE FOI CRIADO CORRETAMENTE
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
-- id     | 2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f
-- email  | anapaula@fortimeddistribuidora.com.br
-- name   | Ana Paula
-- role   | admin ← IMPORTANTE!
-- created_at | 2025-10-17 ...
-- updated_at | 2025-10-17 ...
