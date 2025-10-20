# 🎯 GUIA DE PERMISSÕES - NOVO SISTEMA

**Data:** 20 de outubro de 2025  
**Versão:** 1.2.0 ✨

---

## 📊 MATRIZ DE PERMISSÕES

```
┌─────────────────────┬──────────────┬──────────────┬──────────────┐
│       AÇÃO          │   ADMIN      │  VENDAS02+   │   PUBLIC     │
├─────────────────────┼──────────────┼──────────────┼──────────────┤
│ Visualizar          │     ✅       │     ✅       │     ❌       │
│ Editar              │     ✅       │     ✅       │     ❌       │
│ Deletar             │     ✅       │     ❌       │     ❌       │
│ Ver "Criado por"    │     ✅       │     ❌       │     ❌       │
└─────────────────────┴──────────────┴──────────────┴──────────────┘
```

---

## 🎨 INTERFACE

### Coluna de AÇÕES na Tabela

#### Para ADMIN:
```
┌────────────────────────────────────┐
│          AÇÕES (Admin)             │
├────────────────────────────────────┤
│                                    │
│    [✏️ Editar]  [🗑️ Deletar]       │
│                                    │
└────────────────────────────────────┘
```

#### Para USUÁRIOS COMUNS (vendas02, vendas03, etc):
```
┌────────────────────────────────────┐
│        AÇÕES (User)                │
├────────────────────────────────────┤
│                                    │
│         [✏️ Editar]                │
│                                    │
└────────────────────────────────────┘
```

---

## 🔧 COMO TESTAR

### ✅ Teste 1: Admin Deletando

**Passos:**
1. Login como **admin**
2. Vá para aba **"📋 Ocorrências"**
3. Procure por uma ocorrência
4. Na coluna "Ações", veja: **✏️** e **🗑️** (dois botões)
5. Clique no **🗑️**
6. Modal aparece pedindo confirmação
7. Clique "Excluir"
8. ✅ Ocorrência desaparece da tabela

**Resultado esperado:**
```
✓ Toast: "Ocorrência deletada com sucesso!"
✓ Tabela recarrega
✓ Ocorrência não aparece mais
```

---

### ✅ Teste 2: Usuário Comum NÃO Pode Deletar

**Passos:**
1. Login como **vendas02** (ou vendas03, vendas04, etc)
2. Vá para aba **"📋 Ocorrências"**
3. Procure por uma ocorrência
4. Na coluna "Ações", veja: **✏️ APENAS** (sem 🗑️)
5. Tente clicar... NÃO CONSEGUE (botão não existe)

**Resultado esperado:**
```
✓ Botão de delete NÃO aparece
✓ Apenas botão de editar está disponível
✓ Usuário não consegue acessar exclusão
```

---

### ✅ Teste 3: Usuário Comum Pode Editar

**Passos:**
1. Login como **vendas02**
2. Vá para aba **"📋 Ocorrências"**
3. Clique em uma ocorrência
4. Modal abre com os dados
5. Modifique algum campo (ex: status)
6. Clique "Salvar"
7. ✅ Alteração salva

**Resultado esperado:**
```
✓ Toast: "Ocorrência atualizada com sucesso!"
✓ Tabela recarrega com dados novos
```

---

### ✅ Teste 4: Visualizar

**Passos:**
1. Login como qualquer usuário (admin ou comum)
2. Vá para aba **"📋 Ocorrências"**
3. Veja lista completa de ocorrências

**Resultado esperado:**
```
✓ Todos veem a mesma lista
✓ Sem restrições por usuário
✓ Paginação funciona normalmente
```

---

## 🔐 SEGURANÇA

### Camadas de Proteção:

#### 1️⃣ Frontend (Interface):
```javascript
// Botão só aparece se isAdmin == true
const deleteButton = isAdmin ? 
    `<button onclick="showDeleteConfirmation('${occ.id}')">🗑️</button>` 
    : '';  // vazio para usuários comuns
```

#### 2️⃣ Backend (JavaScript):
```javascript
async function confirmDelete() {
    const isAdmin = currentUser.role === 'admin';
    
    if (!isAdmin) {
        showToast('❌ Apenas administradores...', 'error');
        return;  // Para aqui se não for admin
    }
    
    // Continua a deleção só se admin
    const { error } = await client
        .from('occurrences')
        .delete()
        .eq('id', pendingDeleteId);
}
```

#### 3️⃣ Validação de Sessão:
```javascript
const session = await client.auth.getSession();
if (!session) {
    showToast('Você precisa estar logado', 'error');
    return;
}
```

---

## 📱 COMPORTAMENTO POR ROLE

### ADMIN (administrativo@fortimeddistribuidora.com.br)
```
┌─────────────────────────────────┐
│ 👑 Admin (Admin)                │
├─────────────────────────────────┤
│ Permissões:                     │
│  ✅ Ver todas ocorrências       │
│  ✅ Editar todas               │
│  ✅ Deletar todas ⭐            │
│  ✅ Ver coluna "Criado por"    │
│  ✅ Acessar /config.html       │
│                                 │
│ Ações disponíveis:              │
│  • ✏️ Editar (qualquer uma)    │
│  • 🗑️ Deletar (qualquer uma)   │
│                                 │
└─────────────────────────────────┘
```

### USUÁRIO COMUM (vendas02@, vendas03@, etc)
```
┌─────────────────────────────────┐
│ 👤 Vendas 02                    │
├─────────────────────────────────┤
│ Permissões:                     │
│  ✅ Ver todas ocorrências       │
│  ✅ Editar todas               │
│  ❌ Deletar (não tem acesso)    │
│  ❌ Ver coluna "Criado por"    │
│  ❌ Acessar /config.html       │
│                                 │
│ Ações disponíveis:              │
│  • ✏️ Editar (qualquer uma)    │
│  • 🗑️ NÃO DISPONÍVEL           │
│                                 │
└─────────────────────────────────┘
```

---

## 📋 MODAL DE CONFIRMAÇÃO

```
┌──────────────────────────────────────┐
│    ⚠️  Confirmação de Exclusão       │
├──────────────────────────────────────┤
│                                      │
│  Tem certeza que deseja excluir      │
│  esta ocorrência?                    │
│                                      │
│  Esta ação não pode ser desfeita.    │
│                                      │
│      [Cancelar]    [Excluir]         │
│                                      │
└──────────────────────────────────────┘
```

**Comportamento:**
- ✅ Clicar "Cancelar" → fecha modal, nada acontece
- ✅ Clicar "Excluir" → deleta e recarrega tabela
- ✅ Clicar fora → fecha modal (se tiver)

---

## 🧪 CHECKLIST DE VALIDAÇÃO

### Admin Testing
- [ ] Login como admin funciona
- [ ] Vê coluna "Criado por" na tabela
- [ ] Botão 🗑️ aparece em todas as linhas
- [ ] Clica 🗑️ e modal aparece
- [ ] Clica "Excluir" e ocorrência desaparece
- [ ] Toast de sucesso aparece
- [ ] Tabela recarrega automaticamente

### User Testing
- [ ] Login como vendas02+ funciona
- [ ] NÃO vê coluna "Criado por"
- [ ] Botão 🗑️ NÃO aparece (apenas ✏️)
- [ ] Consegue editar ocorrência
- [ ] NÃO consegue deletar (sem acesso)

---

## 🚀 COMANDOS ÚTEIS

### Ver quem é admin no banco:
```sql
SELECT email, role FROM public.users WHERE role = 'admin';
```

### Mudar alguém para admin:
```sql
UPDATE public.users SET role = 'admin' WHERE email = 'email@fortimeddistribuidora.com.br';
```

### Ver todas as ocorrências deletadas (se houver auditoria):
```sql
SELECT * FROM occurrences WHERE deleted_at IS NOT NULL;
```

---

## 📞 SUPORTE

**Problema:** Usuário comum vê botão de delete  
**Solução:** Limpar cache (Ctrl+Shift+Delete) e fazer git pull

**Problema:** Admin não consegue deletar  
**Solução:** Verificar se está logado como admin (vê 👑 no canto)

**Problema:** Modal não aparece ao clicar 🗑️  
**Solução:** F12 → Console → Procurar por erros

---

**Status:** ✅ PRONTO PARA USO

Commit: **6e8d82d**  
Data: 20 de outubro de 2025
