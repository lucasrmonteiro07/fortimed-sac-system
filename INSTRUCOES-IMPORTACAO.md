# 👥 INSTRUÇÕES DE IMPORTAÇÃO DE USUÁRIOS

## 📅 Data: $(date)

## 🎯 Objetivo
Importar os 7 usuários do sistema Fortimed SAC no Supabase de forma rápida e eficiente.

## 📋 Usuários para Importar

| Tipo | Email | Senha | Role |
|------|-------|-------|------|
| **Admin** | administrativo@fortimeddistribuidora.com.br | Compras@01 | admin |
| **Vendas 01** | vendas01@fortimeddistribuidora.com.br | vendas01 | user |
| **Vendas 02** | vendas02@fortimeddistribuidora.com.br | vendas02 | user |
| **Vendas 03** | vendas03@fortimeddistribuidora.com.br | vendas03 | user |
| **Vendas 04** | vendas04@fortimeddistribuidora.com.br | vendas04 | user |
| **Vendas 05** | vendas05@fortimeddistribuidora.com.br | vendas05 | user |
| **Vendas 06** | vendas06@fortimeddistribuidora.com.br | vendas06 | user |

## ⚠️ IMPORTANTE: Desabilitar Verificação de Email

**ANTES de importar os usuários, você DEVE desabilitar a verificação de email no Supabase:**

1. **Acesse Supabase Dashboard:**
   - Vá em https://app.supabase.com
   - Authentication > Settings

2. **Desabilite estas opções:**
   - ❌ Enable email confirmations
   - ❌ Enable email change confirmations
   - ❌ Enable phone confirmations
   - ❌ Enable phone change confirmations

3. **Mantenha habilitado:**
   - ✅ Enable signup

4. **Salve as configurações**

**📋 Guia completo:** `DESABILITAR-EMAIL-RAPIDO.md`

---

## 🚀 MÉTODOS DE IMPORTAÇÃO

### **MÉTODO 1: Interface Web (Recomendado)**

1. **Acesse a página de importação:**
   - Abra `importar-usuarios.html` no navegador
   - Ou acesse: `https://seu-site.vercel.app/importar-usuarios.html`

2. **Execute a importação:**
   - Clique em "🚀 Importar Usuários"
   - Aguarde o processo (cerca de 10-15 segundos)
   - Verifique os resultados na tela

3. **Teste os logins:**
   - Clique em "🔐 Testar Logins"
   - Verifique se todos os usuários conseguem fazer login

### **MÉTODO 2: Console do Navegador**

1. **Abra o console:**
   - Pressione F12 no navegador
   - Vá na aba "Console"

2. **Cole o script:**
   - Abra o arquivo `importar-usuarios.js`
   - Copie todo o conteúdo
   - Cole no console

3. **Execute:**
   ```javascript
   importarUsuarios()
   ```

4. **Teste:**
   ```javascript
   testarLogins()
   ```

### **MÉTODO 3: Importação Manual (Supabase Dashboard)**

1. **Acesse o Supabase:**
   - Vá em https://app.supabase.com
   - Selecione seu projeto

2. **Crie cada usuário:**
   - Vá em Authentication > Users
   - Clique em "Add User"
   - Preencha email e senha para cada usuário
   - Repita para todos os 7 usuários

### **MÉTODO 4: CSV (Se disponível)**

1. **Use o arquivo CSV:**
   - Abra `usuarios.csv`
   - Importe via interface do Supabase (se suportado)

## 📁 ARQUIVOS DISPONÍVEIS

### **Para Importação Automática**
- `importar-usuarios.html` - Interface web para importação
- `importar-usuarios.js` - Script para console do navegador
- `usuarios.csv` - Arquivo CSV com os usuários

### **Para Configuração do Banco**
- `CRIAR-USUARIOS-COMPLETO.sql` - Script SQL completo
- `CRIAR-USUARIOS.sql` - Script SQL original

## 🔧 CONFIGURAÇÃO DO BANCO DE DADOS

### **1. Executar Script SQL**

1. Acesse Supabase > SQL Editor
2. Execute o arquivo `CRIAR-USUARIOS-COMPLETO.sql`
3. Aguarde a mensagem "Success. No rows returned"

### **2. Verificar Políticas RLS**

Execute esta query para verificar se as políticas foram criadas:

```sql
SELECT policyname, tablename, cmd
FROM pg_policies 
WHERE tablename = 'occurrences'
ORDER BY policyname;
```

## ✅ VERIFICAÇÃO PÓS-IMPORTAÇÃO

### **1. Testar Login de Cada Usuário**

1. Acesse o sistema
2. Teste login com cada usuário
3. Verifique se cada um vê apenas suas ocorrências

### **2. Testar Funcionalidades**

- ✅ Criar nova ocorrência
- ✅ Editar ocorrência existente
- ✅ Excluir ocorrência
- ✅ Filtrar e buscar
- ✅ Verificar isolamento entre usuários

### **3. Verificar Segurança**

- ✅ Usuário não vê ocorrências de outros usuários
- ✅ Usuário não pode editar ocorrências de outros
- ✅ Usuário não pode excluir ocorrências de outros

## 🚨 SOLUÇÃO DE PROBLEMAS

### **❌ Erro: "User already registered"**
- **Causa**: Usuário já existe no sistema
- **Solução**: Ignore o erro, o usuário já está criado

### **❌ Erro: "Invalid email"**
- **Causa**: Formato de email inválido
- **Solução**: Verifique se o email está correto

### **❌ Erro: "Password too weak"**
- **Causa**: Senha não atende aos critérios
- **Solução**: Use senhas mais fortes

### **❌ Usuário não consegue fazer login**
- **Causa**: Usuário não foi criado corretamente
- **Solução**: Crie manualmente no Supabase Dashboard

### **❌ Usuário vê ocorrências de outros**
- **Causa**: Políticas RLS não foram aplicadas
- **Solução**: Execute o script SQL novamente

## 📊 MONITORAMENTO

### **Verificar Usuários Criados**

```sql
SELECT email, created_at, email_confirmed_at
FROM auth.users
WHERE email LIKE '%@fortimeddistribuidora.com.br'
ORDER BY created_at;
```

### **Verificar Políticas Ativas**

```sql
SELECT policyname, cmd, qual
FROM pg_policies 
WHERE tablename = 'occurrences';
```

## 🎯 PRÓXIMOS PASSOS

1. **Importar usuários** usando um dos métodos acima
2. **Executar script SQL** para configurar políticas
3. **Testar sistema** com diferentes usuários
4. **Fazer deploy** no Vercel
5. **Treinar usuários** no sistema

## 📝 NOTAS IMPORTANTES

- ⚠️ **Senhas**: Mantenha as senhas seguras e não as compartilhe
- 🔒 **Segurança**: As políticas RLS são essenciais para funcionamento
- 👥 **Usuários**: Cada usuário terá acesso apenas às suas ocorrências
- 📱 **Teste**: Teste em diferentes dispositivos e navegadores

---

**Sistema pronto para uso com todos os usuários!** 🎉

_Desenvolvido para Fortimed - Sistema de Controle de Ocorrências v1.1_
