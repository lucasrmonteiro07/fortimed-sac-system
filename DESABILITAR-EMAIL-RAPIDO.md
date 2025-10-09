# ⚡ DESABILITAR VERIFICAÇÃO DE EMAIL - RÁPIDO

## 🎯 Objetivo
Desabilitar verificação de email no Supabase para criar usuários sem confirmação.

## 🚀 PASSOS RÁPIDOS

### **1. Acessar Supabase**
1. Vá em https://app.supabase.com
2. Selecione seu projeto
3. Clique em **Authentication** no menu lateral
4. Clique em **Settings** (Configurações)

### **2. Desabilitar Verificação**
1. Encontre **"Email Confirmations"**
2. **DESABILITE** estas opções:
   - ❌ Enable email confirmations
   - ❌ Enable email change confirmations
   - ❌ Enable phone confirmations
   - ❌ Enable phone change confirmations

3. **MANTENHA** habilitado:
   - ✅ Enable signup

### **3. Salvar**
1. Clique em **Save**
2. Aguarde confirmação

## ✅ PRONTO!

Agora você pode:
- Criar usuários sem verificação de email
- Usar `importar-usuarios.html` para importar todos os usuários
- Fazer login imediatamente após criação

## 🔧 ALTERNATIVA: Via SQL

Se preferir SQL, execute no **SQL Editor**:

```sql
UPDATE auth.config 
SET 
    enable_email_confirmations = false,
    enable_email_change_confirmations = false,
    enable_phone_confirmations = false,
    enable_phone_change_confirmations = false
WHERE id = 1;
```

## 🎯 TESTE

1. Abra `importar-usuarios.html`
2. Clique em "🚀 Importar Usuários"
3. Deve funcionar sem erros de verificação de email

---

**Configuração concluída em 2 minutos!** ⚡
