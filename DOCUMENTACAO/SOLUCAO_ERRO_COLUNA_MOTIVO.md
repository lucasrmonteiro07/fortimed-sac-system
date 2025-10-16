# 🔧 Solução: Adicionar Coluna `motivo` no Supabase

## ❌ Problema
```
Error: Could not find the 'motivo' column of 'occurrences' in the schema cache
```

**Causa**: A coluna `motivo` não existe na tabela `occurrences` do banco de dados Supabase.

## ✅ Solução

### Passo 1: Acessar o Supabase
1. Abra https://app.supabase.com/
2. Faça login com sua conta
3. Selecione o projeto
4. Clique em "SQL Editor" no menu lateral

### Passo 2: Executar o Script SQL

Copie e cole o seguinte comando no SQL Editor:

```sql
ALTER TABLE occurrences
ADD COLUMN motivo TEXT NULL;
```

### Passo 3: Adicionar Índice (Opcional mas Recomendado)

Para melhorar performance ao filtrar por motivo:

```sql
CREATE INDEX idx_occurrences_motivo ON occurrences(motivo);
```

### Passo 4: Verificar se Foi Criado

Execute o seguinte para confirmar:

```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'occurrences' 
ORDER BY ordinal_position;
```

**Resultado esperado**: Deve aparecer a linha `motivo | text | YES`

## 📊 Estrutura Completa da Tabela (Após Adicionar)

| Coluna | Tipo | Nullable | Descrição |
|--------|------|----------|-----------|
| id | uuid | NO | Chave primária |
| created_at | timestamp | NO | Data de criação |
| updated_at | timestamp | YES | Última atualização |
| num_pedido | text | NO | Número do pedido |
| nota_fiscal | text | YES | Nota fiscal |
| transportadora | text | NO | Transportadora |
| nome_cliente | text | NO | Nome do cliente |
| ocorrencia | text | NO | Descrição da ocorrência |
| **motivo** | **text** | **YES** | **Motivo da ocorrência** ← NOVO |
| status | text | NO | Status (aberto, em_andamento, etc) |
| situacao | text | YES | Situação/resolução |
| responsavel_falha | text | YES | Responsável pela falha |
| responsavel_resolucao | text | YES | Responsável pela resolução |
| created_by | uuid | NO | ID do usuário que criou |

## 🔐 RLS Policies (Sem Mudanças)

As políticas RLS existentes continuam funcionando normalmente, pois:
- ✅ O novo campo é opcional (NULL allowed)
- ✅ Não requer autenticação especial
- ✅ Admin pode ver/editar igual a outros campos
- ✅ Users veem apenas suas ocorrências (como antes)

## 🎯 Próximos Passos

1. **Após executar o SQL**:
   - Aguarde 2-3 segundos
   - Atualize a página do navegador (F5)
   - Tente salvar uma ocorrência novamente

2. **Se o erro persistir**:
   - Limpe o cache do navegador (Ctrl + Shift + Delete)
   - Logout e login novamente
   - Teste em uma aba privada/incógnita

3. **Para verificar localmente**:
   - Abra DevTools (F12)
   - Console
   - Execute: `const client = config.getClient(); await client.from('occurrences').select('*').limit(1);`
   - Procure por `motivo` nas colunas retornadas

## 📝 Validação

Após adicionar a coluna, teste os seguintes cenários:

✅ **Criar ocorrência SEM motivo**
```
Pedido: 123456
Status: Aberto
Motivo: [deixar vazio]
Resultado: Deve salvar com motivo = NULL
```

✅ **Criar ocorrência COM motivo**
```
Pedido: 123457
Status: Aberto
Motivo: Validade curta
Resultado: Deve salvar com motivo = 'validade_curta'
```

✅ **Editar motivo**
```
Editar ocorrência anterior
Alterar motivo para: Cotação feita errada pelo comercial
Resultado: Deve atualizar com novo motivo
```

✅ **Filtrar por motivo nos relatórios**
```
Gerar relatório filtrando por: Validade curta
Resultado: Deve retornar apenas ocorrências com esse motivo
```

## 🆘 Se o Problema Persistir

### 1. Verificar se Supabase está respondendo
- Teste a conexão: vá em "config.html"
- Clique em "Testar Conexão"
- Deve aparecer: ✅ Conectado com sucesso

### 2. Limpar cache do Supabase
Execute no SQL Editor:
```sql
-- Verificar última modificação da tabela
SELECT * FROM pg_stat_user_tables WHERE relname = 'occurrences';
```

### 3. Recriar a tabela (Último Resort)
Se nada funcionar, contacte o suporte ou:
```bash
# No terminal, dentro da pasta do projeto
git log --oneline | head -1  # Pega commit mais recente
```

## 📞 Contato de Suporte

Se o erro persistir após seguir os passos:
1. Envie screenshot do SQL Editor mostrando o comando executado
2. Confirme se a coluna aparecem em "SELECT * FROM occurrences LIMIT 1"
3. Verifique o painel "Database" do Supabase → Abas → occurrences

---

**Arquivo Script**: `SQL/adicionar_coluna_motivo.sql`  
**Status**: Aguardando execução manual no Supabase  
**Tempo Estimado**: 30 segundos  
**Dificuldade**: ⭐ Fácil
