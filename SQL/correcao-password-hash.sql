-- Solução para erro: null value in column "password_hash" violates not-null constraint
-- 
-- Problema: A coluna password_hash em public.users não pode ser NULL
-- Erro completo: "ERROR: 23502: null value in column "password_hash" of relation "users" violates not-null constraint"
--
-- Solução: Alterar a coluna password_hash para aceitar NULL ou usar valor padrão

-- OPÇÃO 1: Permitir NULL na coluna password_hash
ALTER TABLE public.users
ALTER COLUMN password_hash DROP NOT NULL;

-- OPÇÃO 2 (Alternativa): Se quiser manter NOT NULL, usar um valor padrão
-- ALTER TABLE public.users
-- ALTER COLUMN password_hash SET DEFAULT '';

-- PASSO 2: Verificar estrutura da tabela users
-- SELECT column_name, is_nullable, column_default, data_type 
-- FROM information_schema.columns 
-- WHERE table_name = 'users' AND table_schema = 'public';

-- PASSO 3: Se fez OPÇÃO 1, agora o UPSERT funcionará sem password_hash
-- Testar login novamente como vendas02
