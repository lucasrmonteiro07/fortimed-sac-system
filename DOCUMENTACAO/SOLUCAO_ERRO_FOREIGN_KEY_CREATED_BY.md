# 🔴 ERRO: Foreign Key Constraint - created_by

**Data:** 17 de outubro de 2025  
**Erro:** `violates foreign key constraint "occurrences_created_by_fkey"`  
**Usuário Afetado:** vendas02  
**Status:** ⏳ INVESTIGANDO

---

## 🔍 O QUE ESTÁ ACONTECENDO

### Erro Exato:
```
✕ Erro ao salvar: insert or update on table "occurrences" 
violates foreign key constraint "occurrences_created_by_fkey"
```

### Problema:
Quando o usuário `vendas02` tenta **salvar uma nova ocorrência**, o banco de dados rejeita porque:
- A coluna `created_by` na tabela `occurrences` faz referência (foreign key) a outra tabela
- O ID do usuário `vendas02` **NÃO EXISTE** nessa tabela referenciada
- Pode ser `public.users` ou `auth.users`, dependendo da configuração

---

## 🎯 CAUSA PROVÁVEL

### Cenário 1: Usuário foi criado em auth.users mas não em public.users
```
✅ Existe em: auth.users (Supabase Auth)
❌ Não existe em: public.users (Banco de dados)
❌ Resultado: Constraint viola ao tentar criar ocorrência
```

### Cenário 2: Constraint aponta para tabela errada
```
❌ created_by FK → public.users (local certo mas usuário não existe)
✅ created_by FK → auth.users (local correto, usuário existe)
```

---

## 🛠️ SOLUÇÃO EM 3 PASSOS

### ✅ PASSO 1: Verificar qual tabela a constraint referencia

Executar no Supabase SQL Editor:
```sql
SELECT constraint_name, table_name, column_name, 
       referenced_table_name, referenced_column_name
FROM information_schema.referential_constraints
WHERE table_name = 'occurrences' AND column_name = 'created_by';
```

**O que procurar:**
- Se `referenced_table_name` = `users` → Cenário 1
- Se `referenced_table_name` = `auth.users` → Cenário 2 (menos provável)

---

### ✅ PASSO 2: Verificar se usuário vendas02 existe

Executar no Supabase SQL Editor:
```sql
-- Procurar em auth.users
SELECT id, email FROM auth.users 
WHERE email LIKE '%vendas02%' OR email LIKE '%vendas%';
```

**Resultado esperado:**
```
id          | email
------------|----------------------------------
abc123...   | vendas02@fortimeddistribuidora.com.br
```

**Se não encontrar nada:** O usuário não foi criado corretamente.

---

### ✅ PASSO 3: Criar registro na tabela public.users

Se o usuário existe em `auth.users` mas não em `public.users`:

```sql
-- Copie o ID real do resultado do PASSO 2
INSERT INTO public.users (id, email, name, role)
VALUES (
    'COLE_O_ID_AQUI',  -- Ex: '2e6d9014-8fdf-4e5a-b41f-ac7e2c2ea53f'
    'vendas02@fortimeddistribuidora.com.br',
    'Vendas 02',
    'user'
)
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
```

---

## 📋 CHECKLIST DE TESTE

Após executar os passos acima:

- [ ] Desconectar do sistema (logout)
- [ ] Reconectar como vendas02
- [ ] Ir para "➕ Nova Ocorrência"
- [ ] Preencher todos os campos
- [ ] Clicar em "💾 Salvar Ocorrência"
- [ ] ✅ Verificar se salvou sem erro

---

## 🔧 PROBLEMA FUTURO: Como Evitar?

### Modificar auth.js para garantir que usuário é criado em public.users

Quando usuário faz login (linha 140-160 do auth.js):
```javascript
// Já existe código para criar usuário em public.users se não existir!
// O código usa UPSERT, mas pode ter problema
```

**Solução:** Verificar que o UPSERT está funcionando corretamente.

---

## 📞 PRÓXIMOS PASSOS

1. **Execute o PASSO 2** e copie o ID do vendas02
2. **Execute o PASSO 3** com o ID real
3. **Teste conforme CHECKLIST**
4. **Reporte resultado**

---

## 🚨 IMPORTANTE

⚠️ **Não feche o formulário sem testar!**

Se receber erro após os passos acima:
- [ ] Copie o **ID exato** do PASSO 2
- [ ] Verifique se copiou corretamente (sem espaços)
- [ ] Tente novamente

---

*Documento atualizado em 17 de outubro de 2025*
