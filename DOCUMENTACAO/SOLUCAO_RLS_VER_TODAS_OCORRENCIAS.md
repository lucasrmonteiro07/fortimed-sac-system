# ❌ Problema: Vendas02 Só Vê Suas Próprias Ocorrências

## 🔍 Diagnóstico

O usuário **vendas02** conseguiu criar ocorrência com sucesso, mas:
- ✗ Só consegue ver a ocorrência que ele criou
- ✗ Não consegue ver ocorrências de outros usuários
- ✗ Problema de **RLS (Row Level Security)** na tabela

## ✅ Solução Rápida: Desabilitar RLS

Execute este SQL no **Supabase SQL Editor**:

```sql
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;
```

**Por quê?** Porque sua aplicação não precisa de restrição por usuário - todos devem ver todas as ocorrências.

### Verificar se funcionou:

```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'occurrences';
```

Deve retornar:
```
tablename  | rowsecurity
-----------+------------
occurrences| f
```

(O `f` significa FALSE = RLS desabilitado)

---

## 🧪 Teste Final

1. Faça **logout** completamente
2. Faça **login como vendas02**
3. Vá para a aba **"Ocorrências"**
4. Verifique se agora aparecem **TODAS as ocorrências** (suas + de outros usuários)

Se sim ✅ → Problema resolvido!

---

## 🆘 Se Ainda Não Funcionar

Tente estas ações em ordem:

### 1️⃣ Hard Refresh no Navegador
- **Ctrl+Shift+Delete** (limpar cache)
- Ou **F12 → Network → Disable cache → Refresh**
- Ou **Ctrl+F5** (hard refresh)

### 2️⃣ Fazer Git Pull

Se o código localmente estiver desatualizado:

```powershell
cd c:\Users\monteiro\Documents\GitHub\fortimed-sac-system
git pull origin main
```

### 3️⃣ Verificar se a Política RLS Correta Existe

```sql
SELECT schemaname, tablename, policyname, permissive, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'occurrences'
ORDER BY tablename, policyname;
```

Se houver muitas políticas restritivas, pode ser que a que você desabilitou tenha sido substituída. Nesse caso, remova todas e recrie:

```sql
-- Remover TODAS as políticas existentes
DROP POLICY IF EXISTS admin_can_view_all_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_view_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_create_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_create_own_occurrences ON occurrences;
DROP POLICY IF EXISTS admin_can_update_occurrences ON occurrences;
DROP POLICY IF EXISTS users_can_update_own_occurrences ON occurrences;
DROP POLICY IF EXISTS allow_all ON occurrences;

-- Desabilitar RLS
ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;
```

---

## 📋 Checklist

- [ ] Executou `ALTER TABLE occurrences DISABLE ROW LEVEL SECURITY;`
- [ ] Verificou que rowsecurity = f
- [ ] Fez logout e login novamente como vendas02
- [ ] Limpou cache do navegador (Ctrl+Shift+Delete)
- [ ] Refreshed a página
- [ ] **Agora consegue ver TODAS as ocorrências** ✅

---

## 💡 Por Que Isso Funcionou?

**Antes:** RLS (Row Level Security) estava habilitado
- Cada usuário só podia ver suas próprias linhas (created_by = seu_id)

**Depois:** RLS desabilitado
- Não há restrição de acesso
- Todos os usuários veem todos os dados da tabela
- Parecido com um sistema de "permissão aberta"

---

## 🚀 Próximo Passo

Após confirmar que está funcionando, remova o cache do navegador permanentemente:

1. **Chrome/Edge:** 
   - F12 → Application → Clear Site Data
   
2. **Firefox:**
   - Ctrl+Shift+Delete → Limpar Tudo

3. **Alternativa (PowerShell):**
   ```powershell
   # Para Chrome
   Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Recurse -Force
   ```
