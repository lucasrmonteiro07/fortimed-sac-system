# 🚀 GUIA RÁPIDO: Adicionar Coluna `motivo` no Supabase

## 📋 Resumo do Problema

Você está tentando salvar uma ocorrência com o novo campo "Motivo", mas o banco não reconhece a coluna. Solução rápida:

## ⚡ 3 PASSOS RÁPIDOS

### PASSO 1️⃣: Abrir SQL Editor no Supabase
```
1. Va para: https://app.supabase.com/
2. Faça login
3. Selecione seu projeto
4. Clique no menu → "SQL Editor"
```

### PASSO 2️⃣: Colar o Comando
Cole exatamente isto no editor SQL em branco:

```sql
ALTER TABLE occurrences ADD COLUMN motivo TEXT NULL;
```

### PASSO 3️⃣: Executar
- Clique no botão ▶️ "Execute" (ou Ctrl + Enter)
- Aguarde 2-3 segundos
- Feche a aba do navegador
- Reabra a aplicação (F5)

## ✅ Pronto!

Agora você pode:
- ✅ Salvar ocorrências com motivo
- ✅ Editar motivo
- ✅ Filtrar por motivo nos relatórios
- ✅ Exportar com motivo em todos os formatos

## 🎯 Próximo Passo

Após executar o comando SQL:
1. Volte para a aplicação
2. Teste criando uma nova ocorrência
3. Selecione um motivo e salve
4. Pronto! ✨

---

**Tempo Total**: ~1 minuto  
**Dificuldade**: ⭐ Fácil  
**Requer**: Acesso ao Supabase
