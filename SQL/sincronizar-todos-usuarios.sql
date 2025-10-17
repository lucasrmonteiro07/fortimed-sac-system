-- Script para sincronizar TODOS os usuários de auth.users para public.users
-- Objetivo: Garantir que cada usuário que fez login existe em public.users

-- PASSO 1: Ver quantos usuários faltam sincronizar
SELECT COUNT(au.id) as usuarios_em_auth_mas_nao_em_public
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL;

-- PASSO 2: Inserir TODOS os usuários que faltam
-- Este comando sincroniza auth.users com public.users automaticamente
INSERT INTO public.users (id, email, name, role, password_hash)
SELECT 
    au.id,
    au.email,
    COALESCE(au.user_metadata->>'full_name', SPLIT_PART(au.email, '@', 1), 'Usuário'),
    CASE 
        WHEN au.email ILIKE '%admin%' THEN 'admin'
        WHEN au.email ILIKE '%administrativo%' THEN 'admin'
        ELSE 'user'
    END,
    '' -- password_hash vazio (gerenciado por Supabase Auth)
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL
ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = EXCLUDED.role;

-- PASSO 3: Verificar resultado
SELECT COUNT(*) as total_usuarios_sincronizados
FROM public.users;

-- PASSO 4: Listar todos os usuários sincronizados
SELECT id, email, name, role
FROM public.users
ORDER BY email;

-- PASSO 5: Verificar se há ainda usuários faltando
SELECT COUNT(au.id) as usuarios_faltando_sincronizar
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL;

-- Se retornar 0, significa que TODOS estão sincronizados! ✅
