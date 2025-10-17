-- Solução para erro de Foreign Key: "occurrences_created_by_fkey"
-- 
-- Problema: Quando usuário tenta salvar ocorrência, recebe erro:
-- "insert or update on table "occurrences" violates foreign key constraint "occurrences_created_by_fkey""
--
-- Causa: O created_by deve estar vazio (NULL) ou referenciar um ID que existe em auth.users, 
-- não em public.users

-- PASSO 1: Verificar a constraint atual
SELECT constraint_name, table_name, column_name, referenced_table_name, referenced_column_name
FROM information_schema.referential_constraints
WHERE table_name = 'occurrences' AND column_name = 'created_by';

-- PASSO 2: Ver a coluna created_by na tabela occurrences
-- (Use SELECT * FROM occurrences LIMIT 1 para ver a estrutura)

-- PASSO 3: Se a constraint existe, permitir NULL no created_by
-- (Isso permite que ocorrências sejam criadas sem created_by)
ALTER TABLE occurrences
ALTER COLUMN created_by DROP NOT NULL;

-- PASSO 4: Se necessário, remover a constraint de foreign key e recriá-la
-- (Executar APENAS se o PASSO 3 não funcionar)
ALTER TABLE occurrences
DROP CONSTRAINT IF EXISTS occurrences_created_by_fkey;

-- PASSO 5: Usar auth.users como referência (a forma correta)
ALTER TABLE occurrences
ADD CONSTRAINT occurrences_created_by_fkey 
FOREIGN KEY (created_by) 
REFERENCES auth.users(id) 
ON DELETE CASCADE;

-- PASSO 6: Verificar se o usuário vendas02 existe em auth.users
SELECT id, email FROM auth.users WHERE email LIKE '%vendas02%';

-- PASSO 7: Se não existir, inserir o usuário na tabela users
-- (Encontre o ID real do vendas02 em auth.users e substitua UUID_AQUI)
INSERT INTO public.users (id, email, name, role)
VALUES ('UUID_AQUI', 'vendas02@fortimeddistribuidora.com.br', 'Vendas 02', 'user')
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;

-- PASSO 8: Testar se agora consegue salvar
-- (Fazer um INSERT na tabela occurrences através da interface)
