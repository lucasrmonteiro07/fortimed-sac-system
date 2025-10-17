-- ════════════════════════════════════════════════════════════════════
-- CRIAR NOVO USUÁRIO ADMIN: ANA PAULA
-- ════════════════════════════════════════════════════════════════════
-- 
-- Email: anapaula@fortimeddistribuidora.com.br
-- Senha: Compras@01
-- Função: Admin (acesso total ao sistema)
-- Data: 17/10/2025
--
-- ════════════════════════════════════════════════════════════════════

-- 1. INSERIR NA TABELA auth.users (SUPABASE)
-- (Executar via interface web do Supabase ou API)
-- 
-- MÉTODO 1: Via SQL no Supabase
-- INSERT INTO auth.users (
--     instance_id,
--     id,
--     aud,
--     role,
--     email,
--     encrypted_password,
--     email_confirmed_at,
--     invited_at,
--     confirmation_token,
--     confirmation_sent_at,
--     recovery_token,
--     recovery_sent_at,
--     email_change_token,
--     email_change,
--     email_change_sent_at,
--     last_sign_in_at,
--     raw_app_meta_data,
--     raw_user_meta_data,
--     is_super_admin,
--     created_at,
--     updated_at,
--     phone,
--     phone_confirmed_at,
--     phone_change,
--     phone_change_token,
--     phone_change_sent_at,
--     email_change_token_new,
--     email_change_confirm_token,
--     banned_until,
--     reauthentication_token,
--     reauthentication_sent_at,
--     is_sso_user,
--     deleted_at,
--     is_anonymous
-- ) VALUES (
--     '00000000-0000-0000-0000-000000000000',
--     gen_random_uuid(),
--     'authenticated',
--     'authenticated',
--     'anapaula@fortimeddistribuidora.com.br',
--     crypt('Compras@01', gen_salt('bf')),
--     NOW(),
--     NULL,
--     '',
--     NULL,
--     '',
--     NULL,
--     '',
--     '',
--     NULL,
--     NOW(),
--     '{"provider":"email","providers":["email"]}',
--     '{"full_name":"Ana Paula"}',
--     FALSE,
--     NOW(),
--     NOW(),
--     NULL,
--     NULL,
--     NULL,
--     '',
--     NULL,
--     '',
--     '',
--     NULL,
--     '',
--     NULL,
--     FALSE,
--     NULL,
--     FALSE
-- );


-- 2. INSERIR NA TABELA users (schema público)
-- Esta tabela armazena metadados adicionais
INSERT INTO public.users (
    email,
    name,
    role,
    created_at,
    updated_at
) VALUES (
    'anapaula@fortimeddistribuidora.com.br',
    'Ana Paula',
    'admin',
    NOW(),
    NOW()
) 
ON CONFLICT (email) DO UPDATE SET
    name = 'Ana Paula',
    role = 'admin',
    updated_at = NOW()
RETURNING *;


-- 3. VERIFICAR SE O USUÁRIO FOI CRIADO
SELECT 
    id,
    email,
    name,
    role,
    created_at,
    updated_at
FROM public.users
WHERE email = 'anapaula@fortimeddistribuidora.com.br';


-- ════════════════════════════════════════════════════════════════════
-- NOTAS IMPORTANTES:
--
-- 1. O usuario será criado em dois lugares:
--    a) auth.users - tabela de autenticação do Supabase
--    b) public.users - tabela de metadados da aplicação
--
-- 2. A senha será criptografada automaticamente
--
-- 3. O campo 'role' = 'admin' dará acesso total ao sistema
--
-- 4. O usuário poderá fazer login imediatamente após criação
--
-- 5. Se usar a página de importação (importar-usuarios.html), use:
--    anapaula@fortimeddistribuidora.com.br,Compras@01,admin,Ana Paula
--
-- ════════════════════════════════════════════════════════════════════
