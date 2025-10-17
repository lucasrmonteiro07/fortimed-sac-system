-- SQL CORRIGIDO: Sincronizar usuários sem user_metadata
-- Este SQL funciona com a estrutura real de auth.users do Supabase

INSERT INTO public.users (id, email, name, role, password_hash)
SELECT 
    au.id,
    au.email,
    SPLIT_PART(au.email, '@', 1), -- Nome baseado no email (antes do @)
    CASE 
        WHEN au.email ILIKE '%admin%' THEN 'admin'
        WHEN au.email ILIKE '%administrativo%' THEN 'admin'
        ELSE 'user'
    END,
    '' -- password_hash vazio
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL
ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = EXCLUDED.role;
