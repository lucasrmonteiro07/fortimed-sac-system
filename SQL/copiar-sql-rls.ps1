# Script para copiar SQL de limpeza RLS para clipboard
# Execute este arquivo PowerShell para copiar o SQL automaticamente

$sql = @"
-- Remover TODAS as políticas
DROP POLICY IF EXISTS admin_can_view_all_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_view_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_create_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_create_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_update_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_update_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_delete_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_delete_own_occurrences ON occurrences;
DROP POLICY IF EXISTS allow_all ON occurrences;
DROP POLICY IF EXISTS occurrences_select_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_insert_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_update_policy ON occurrences;
DROP POLICY IF EXISTS occurrences_delete_policy ON occurrences;

-- Desabilitar RLS
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;
"@

# Copiar para clipboard
Set-Clipboard -Value $sql

Write-Host "✅ SQL copiado para clipboard!" -ForegroundColor Green
Write-Host "`nProcedimento:" -ForegroundColor Cyan
Write-Host "1. Abra: https://supabase.com/dashboard/project/[seu-projeto]/sql/new" -ForegroundColor Yellow
Write-Host "2. Cole o SQL (Ctrl+V)" -ForegroundColor Yellow
Write-Host "3. Clique 'Run'" -ForegroundColor Yellow
Write-Host "4. Pronto! RLS foi removido" -ForegroundColor Yellow
Write-Host "`n⏭️  Depois:" -ForegroundColor Cyan
Write-Host "- Limpe cache (Ctrl+Shift+Delete)" -ForegroundColor Yellow
Write-Host "- Feche e reabra o navegador" -ForegroundColor Yellow
Write-Host "- Teste login como usuário comum" -ForegroundColor Yellow
