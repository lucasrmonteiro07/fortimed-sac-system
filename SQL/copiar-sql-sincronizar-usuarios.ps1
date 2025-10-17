# Script para copiar SQL de sincronização de usuários para clipboard
# Execute este arquivo PowerShell para copiar o SQL automaticamente

$sql = @"
-- Sincronizar TODOS os usuários de auth.users para public.users
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
    ''
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL
ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = EXCLUDED.role;
"@

# Copiar para clipboard
Set-Clipboard -Value $sql

Write-Host "✅ SQL de sincronização copiado para clipboard!" -ForegroundColor Green
Write-Host "`nProcedimento:" -ForegroundColor Cyan
Write-Host "1. Abra: https://supabase.com/dashboard" -ForegroundColor Yellow
Write-Host "2. Vá para seu projeto" -ForegroundColor Yellow
Write-Host "3. SQL Editor → New Query" -ForegroundColor Yellow
Write-Host "4. Cole o SQL (Ctrl+V)" -ForegroundColor Yellow
Write-Host "5. Clique 'Run'" -ForegroundColor Yellow
Write-Host "`n⏭️  Depois:" -ForegroundColor Cyan
Write-Host "- git pull (para pegar auth.js atualizado)" -ForegroundColor Yellow
Write-Host "- Limpe cache (Ctrl+Shift+Delete)" -ForegroundColor Yellow
Write-Host "- Faça logout e login novamente" -ForegroundColor Yellow
Write-Host "- Teste criar ocorrência com VENDAS03+" -ForegroundColor Yellow
