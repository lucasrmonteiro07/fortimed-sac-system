-- ============================================================================
-- FORTIMED - DESABILITAR VERIFICAÇÃO DE EMAIL
-- Script SQL para desabilitar verificação de email no Supabase
-- ============================================================================
-- 
-- INSTRUÇÕES:
-- 1. Acesse seu projeto no Supabase (https://app.supabase.com)
-- 2. Vá em "SQL Editor" no menu lateral
-- 3. Clique em "+ New query"
-- 4. Copie e cole este arquivo
-- 5. Clique em "RUN" ou pressione Ctrl+Enter
-- 6. Aguarde a mensagem "Success. No rows returned"
-- 
-- ============================================================================

-- ============================================================================
-- DESABILITAR VERIFICAÇÃO DE EMAIL
-- ============================================================================

-- Atualizar configurações de autenticação para desabilitar verificação de email
UPDATE auth.config 
SET 
    enable_signup = true,
    enable_email_confirmations = false,
    enable_email_change_confirmations = false,
    enable_phone_confirmations = false,
    enable_phone_change_confirmations = false
WHERE id = 1;

-- ============================================================================
-- CONFIGURAÇÕES ADICIONAIS DE SEGURANÇA
-- ============================================================================

-- Configurar políticas de autenticação mais permissivas
UPDATE auth.config 
SET 
    enable_signup = true,
    enable_email_confirmations = false,
    enable_email_change_confirmations = false,
    enable_phone_confirmations = false,
    enable_phone_change_confirmations = false,
    enable_anonymous_users = false,
    enable_manual_linking = false
WHERE id = 1;

-- ============================================================================
-- VERIFICAR CONFIGURAÇÕES ATUAIS
-- ============================================================================

-- Verificar configurações de autenticação
SELECT 
    enable_signup,
    enable_email_confirmations,
    enable_email_change_confirmations,
    enable_phone_confirmations,
    enable_phone_change_confirmations
FROM auth.config;

-- ============================================================================
-- SUCESSO!
-- ============================================================================
-- 
-- Próximos passos:
-- 1. As configurações de verificação de email foram desabilitadas
-- 2. Agora você pode criar usuários sem verificação de email
-- 3. Use o arquivo importar-usuarios.html para criar os usuários
-- 4. Teste o login com os usuários criados
-- 
-- ============================================================================
