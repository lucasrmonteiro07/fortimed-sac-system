-- ============================================================================
-- FORTIMED - DEBUG ADMIN - Verificar por que admin não vê chamados
-- Execute este script no Supabase SQL Editor para diagnosticar
-- ============================================================================

-- 1. Verificar usuários na tabela users
SELECT '=== USUÁRIOS NA TABELA USERS ===' as info;
SELECT id, email, name, role, created_at FROM users ORDER BY created_at;

-- 2. Verificar usuários no Supabase Auth
SELECT '=== USUÁRIOS NO SUPABASE AUTH ===' as info;
SELECT id, email, created_at FROM auth.users ORDER BY created_at;

-- 3. Verificar ocorrências existentes
SELECT '=== OCORRÊNCIAS EXISTENTES ===' as info;
SELECT 
    id, 
    num_pedido, 
    nome_cliente, 
    created_by, 
    created_at,
    CASE 
        WHEN created_by IN (SELECT id FROM users WHERE role = 'admin') THEN 'Admin'
        WHEN created_by IN (SELECT id FROM users WHERE role = 'user') THEN 'User'
        ELSE 'Sem role definido'
    END as tipo_usuario
FROM occurrences 
ORDER BY created_at DESC;

-- 4. Verificar políticas RLS ativas
SELECT '=== POLÍTICAS RLS ATIVAS ===' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'occurrences';

-- 5. Testar consulta como admin (substitua o ID pelo ID real do admin)
SELECT '=== TESTE DE CONSULTA COMO ADMIN ===' as info;
-- Substitua 'ID_DO_ADMIN_AQUI' pelo ID real do usuário admin
/*
SELECT 
    o.*,
    u.name as created_by_name
FROM occurrences o
LEFT JOIN users u ON o.created_by = u.id
WHERE EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = 'ID_DO_ADMIN_AQUI' 
    AND users.role = 'admin'
)
OR o.created_by = 'ID_DO_ADMIN_AQUI'
ORDER BY o.created_at DESC;
*/

-- 6. Verificar se há inconsistências entre auth.users e users
SELECT '=== INCONSISTÊNCIAS ENTRE AUTH E USERS ===' as info;
SELECT 
    au.id as auth_id,
    au.email as auth_email,
    u.id as users_id,
    u.email as users_email,
    u.role
FROM auth.users au
LEFT JOIN users u ON au.id = u.id
WHERE u.id IS NULL OR au.email != u.email;

-- 7. Verificar ocorrências órfãs (sem usuário correspondente)
SELECT '=== OCORRÊNCIAS ÓRFÃS ===' as info;
SELECT 
    o.id,
    o.num_pedido,
    o.created_by,
    o.created_at
FROM occurrences o
LEFT JOIN users u ON o.created_by = u.id
WHERE u.id IS NULL;

SELECT '=== DEBUG CONCLUÍDO ===' as info;
