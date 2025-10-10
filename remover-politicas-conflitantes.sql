-- ============================================================================
-- FORTIMED - REMOVER POLÍTICAS CONFLITANTES
-- Execute este script no Supabase SQL Editor para resolver o problema do admin
-- ============================================================================

-- 1. Remover TODAS as políticas existentes (incluindo as conflitantes)
DROP POLICY IF EXISTS "Usuários veem apenas suas ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários atualizam apenas suas próprias ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários deletam apenas suas próprias ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem ver ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem criar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem atualizar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários autenticados podem deletar ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Permitir tudo para usuários autenticados" ON occurrences;
DROP POLICY IF EXISTS "Admin vê todas as ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Usuários veem suas próprias ocorrências" ON occurrences;
DROP POLICY IF EXISTS "Controle de acesso por role" ON occurrences;

-- 2. Criar APENAS uma política simples que permite tudo para usuários autenticados
-- (O controle de acesso será feito no JavaScript)
CREATE POLICY "Permitir tudo para usuários autenticados"
    ON occurrences FOR ALL
    USING (auth.role() = 'authenticated');

-- 3. Garantir que o usuário admin existe com o role correto
INSERT INTO users (id, email, name, role) 
VALUES (
    'e1b0416f-e883-42c9-8e67-30c974b5e392', 
    'administrativo@fortimeddistribuidora.com.br', 
    'Administrador', 
    'admin'
) ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = 'admin';

-- 4. Verificar se as políticas foram removidas corretamente
SELECT 'Políticas conflitantes removidas! Agora deve funcionar.' as status;

-- 5. Mostrar políticas ativas (deve ter apenas uma)
SELECT policyname, cmd, qual 
FROM pg_policies 
WHERE tablename = 'occurrences';


