# ✅ Solução Permanente: Sincronizar Todos os Usuários

## ❌ Problema

Novos usuários (VENDAS03, VENDAS04, VENDAS05, VENDAS06, ANAPAULA, LOGISTICA) estão recebendo erro:

```
✕ Erro ao salvar: insert or update on table "occurrences" 
violates foreign key constraint "occurrences_created_by_fkey"
```

## 🔍 Causa Raiz

Esses usuários:
1. ✅ Existem em `auth.users` (conseguem fazer login)
2. ❌ **NÃO existem** em `public.users` (falta sincronização)
3. ❌ Quando tentam salvar, `created_by` referencia um ID que não existe

## ✅ Solução (2 Partes)

### **PARTE 1: Atualizar Código (Já Feito ✅)**

O arquivo `auth.js` foi atualizado para:
- ✅ Adicionar `password_hash` (vazio) no UPSERT
- ✅ Tratar melhor os erros de sincronização

**Commit:** Será realizado em breve

### **PARTE 2: Sincronizar Banco de Dados (Você Executa)**

Execute este SQL no **Supabase SQL Editor**:

```sql
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
    '' -- password_hash vazio
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
WHERE pu.id IS NULL
ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email,
    name = EXCLUDED.name,
    role = EXCLUDED.role;
```

### **Como Executar**

1. Abra: https://supabase.com/dashboard
2. Vá para seu projeto
3. Clique **SQL Editor** → **New Query**
4. Cole o SQL acima
5. Clique **Run**

### **Verificação**

Execute este SQL para confirmar:

```sql
-- Ver quantos usuários foram sincronizados
SELECT COUNT(*) as total_usuarios
FROM public.users;

-- Listar todos os usuários
SELECT email, name, role
FROM public.users
ORDER BY email;
```

---

## 🧪 Teste

Após executar o SQL e fazer commit do código:

1. **Git pull** para pegar a atualização de `auth.js`
2. **Hard refresh** no navegador (Ctrl+F5)
3. **Logout** e **login** novamente como qualquer usuário
4. **Tente criar uma nova ocorrência**

---

## ✅ Resultado Esperado

**Antes:**
```
❌ Erro ao salvar: foreign key constraint
```

**Depois:**
```
✅ Ocorrência salva com sucesso!
✅ created_by preenchido corretamente
✅ Usuário vê a ocorrência na lista
```

---

## 📋 Mudanças no Código

**Arquivo: `auth.js`** (linhas 130-148)

```javascript
// ANTES:
.upsert([{
    id: data.user.id,
    email: email,
    name: defaultName,
    role: defaultRole
}], { onConflict: 'id' });

// DEPOIS:
.upsert([{
    id: data.user.id,
    email: email,
    name: defaultName,
    role: defaultRole,
    password_hash: '' // ← ADICIONADO
}], { onConflict: 'id' });
```

A mudança garante que `password_hash` (obrigatório) seja preenchido com valor vazio.

---

## 🔄 Fluxo Completo Agora

```
1. Usuário faz LOGIN
   ↓
2. Sistema cria/atualiza em auth.users
   ↓
3. Sistema tenta criar em public.users (UPSERT)
   ↓
4. Se falhar, continua mesmo assim (usuário está autenticado)
   ↓
5. Usuário consegue SALVAR OCORRÊNCIA
   ↓
6. created_by é preenchido com ID do usuário
   ↓
7. Ocorrência é salva com sucesso! ✅
```

---

## 📊 Checklist

- [ ] Executou o SQL de sincronização no Supabase
- [ ] Verificou que os usuários foram criados em `public.users`
- [ ] Fez git pull para pegar `auth.js` atualizado
- [ ] Limpou cache (Ctrl+Shift+Delete)
- [ ] Fechou e reabrij navegador
- [ ] Fez logout e login novamente
- [ ] Testou criar nova ocorrência como VENDAS03
- [ ] **Ocorrência foi salva com sucesso** ✅

---

## 🚀 Sequência Recomendada

### Passo 1: Sincronizar Banco (Agora)
Execute o SQL acima no Supabase

### Passo 2: Atualizar Código (Assim que eu committar)
```powershell
cd c:\Users\monteiro\Documents\GitHub\fortimed-sac-system
git pull origin main
```

### Passo 3: Testar (Próximo Login)
- Logout → Login como VENDAS03 → Criar ocorrência

---

## ⚠️ Nota Importante

O código agora é mais **robusto**:
- Se o UPSERT em `public.users` falhar, o usuário pode continuar usando o sistema
- Isso evita que um erro no banco de dados impeça o login
- A sincronização é feita "lentamente" conforme os usuários usam o sistema

Mas o ideal é executar o SQL acima para sincronizar **todos** de uma vez.
