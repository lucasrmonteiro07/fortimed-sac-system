# ✅ SQL CORRIGIDO: Sincronizar Usuários (Sem user_metadata)

## ❌ Erro Anterior

```
ERROR:  42703: column au.user_metadata does not exist
```

A coluna `user_metadata` não existe na tabela `auth.users` do seu Supabase.

## ✅ SQL CORRIGIDO (Use Este!)

**Execute este SQL no Supabase SQL Editor:**

```sql
INSERT INTO public.users (id, email, name, role, password_hash)
SELECT 
    au.id,
    au.email,
    SPLIT_PART(au.email, '@', 1),
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
```

## 🔍 Diferenças

| Aspecto | Antes | Depois |
|---------|-------|--------|
| Nome do usuário | `au.user_metadata->>'full_name'` | `SPLIT_PART(au.email, '@', 1)` |
| Coluna usada | `user_metadata` (❌ não existe) | `email` (✅ sempre existe) |
| Nome extraído | Do campo de metadados | Da parte do email antes de `@` |

**Exemplo:**
```
Email: vendas03@fortimeddistribuidora.com.br
Nome extraído: vendas03 ✅
```

## 📋 Passos

1. Abra: https://supabase.com/dashboard
2. Vá para seu projeto
3. **SQL Editor** → **New Query**
4. **Cole o SQL acima** (Ctrl+V)
5. Clique **Run**
6. Veja ✅ **Query successful**

---

## ✅ Resultado Esperado

```
✅ Query successful
   Rows returned: 0 (ou número de usuários sincronizados)
```

Agora **VENDAS03, VENDAS04, VENDAS05, VENDAS06, ANAPAULA, LOGISTICA** estarão em `public.users`!

---

## 🧪 Verificar

Execute para confirmar:

```sql
SELECT COUNT(*) as total_usuarios
FROM public.users;

SELECT email, name, role
FROM public.users
ORDER BY email;
```

---

## ⏭️ Próximo Passo

Após executar o SQL:

1. **Limpar cache:** Ctrl+Shift+Delete
2. **Fechar navegador** completamente
3. **Reabrir** o navegador
4. **Logout e login** novamente
5. **Testar criar ocorrência**
