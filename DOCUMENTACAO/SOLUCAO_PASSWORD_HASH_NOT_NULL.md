# Solução: Erro de PASSWORD_HASH Not-Null Constraint

## ❌ Erro Recebido

```
ERROR:  23502: null value in column "password_hash" of relation "users" violates not-null constraint
DETAIL:  Failing row contains (0eb9bdf0-e48b-4295-b298-1d26ec48d63c, vendas02@fortimeddistribuidora.com.br, null, Vendas 02, 2025-10-17 20:29:28.132551, user).
```

## 🔍 Causa Raiz

A tabela `public.users` tem uma coluna `password_hash` que:
- ✗ Não aceita NULL (`NOT NULL`)
- ✗ Não tem valor padrão
- ✗ Quando o código em `auth.js` faz UPSERT, não fornece `password_hash`

Resultado: Erro 23502 (violação de constraint)

## ✅ Solução em 3 Passos

### **PASSO 1: Executar no Supabase SQL Editor**

```sql
ALTER TABLE public.users
ALTER COLUMN password_hash DROP NOT NULL;
```

Este comando **permite NULL** na coluna `password_hash`, permitindo que usuários criados via UPSERT do login funcionem normalmente.

**Alternativa** (se preferir manter NOT NULL com valor padrão):
```sql
ALTER TABLE public.users
ALTER COLUMN password_hash SET DEFAULT '';
```

### **PASSO 2: Testar o Fix**

Faça logout e tente login novamente como **vendas02@fortimeddistribuidora.com.br**

### **PASSO 3: Verificar Estrutura (Opcional)**

Se quiser confirmar que a mudança foi aplicada:
```sql
SELECT column_name, is_nullable, column_default, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public'
ORDER BY ordinal_position;
```

Procure pela linha `password_hash` e confirme que `is_nullable` está como `YES` (ou `true`).

## 🛠️ Modificação no Código (Já Realizada em auth.js)

O arquivo `auth.js` já está correto. Quando o usuário faz login:

1. Sistema verifica se usuário existe em `public.users`
2. Se NÃO existir, faz UPSERT com `id`, `email`, `name`, `role`
3. **Não** fornece `password_hash` (senha gerenciada por Supabase Auth)
4. Com a coluna aceitando NULL, o UPSERT funciona normalmente

## 🧪 Checklist de Teste

- [ ] Executou o SQL no Supabase SQL Editor
- [ ] Fez logout completamente
- [ ] Tentou login como vendas02
- [ ] Login funcionou sem erro "password_hash"
- [ ] Consegue ver a lista de ocorrências
- [ ] Consegue criar nova ocorrência
- [ ] A ocorrência foi salva com sucesso (sem erro "foreign key")

## 📋 Resultado Esperado

Após aplicar a solução:

```
✅ Login realizado com sucesso!
✅ Novo usuário criado automaticamente em public.users
✅ Ocorrências podem ser salvas normalmente
✅ created_by é preenchido com ID correto do auth.users
```

## 🚀 Próximos Passos

1. Aplicar SQL acima no Supabase
2. Testar login e criar ocorrência
3. Se funcionar, remover cache do navegador (Ctrl+Shift+Delete)
4. Testar novamente para garantir que está 100% funcionando
