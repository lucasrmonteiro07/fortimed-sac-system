# Campo "Criado por" e Filtro por Solicitante

## 📋 Resumo das Alterações

Implementação da coluna "Criado por" na tabela de ocorrências e adição de filtro por solicitante na interface principal.

---

## ✅ Mudanças Implementadas

### 1. **Nova Coluna na Tabela de Ocorrências**
- ✅ Adicionada coluna "Criado por" na tabela principal
- ✅ Exibe o nome do usuário que criou cada ocorrência
- ✅ Informação obtida através de JOIN com a tabela `users`
- ✅ Visível para **todos os usuários** (não apenas admin)

### 2. **Filtro por Solicitante**
- ✅ Dropdown de filtro adicionado ao lado da barra de busca
- ✅ Lista automaticamente todos os solicitantes únicos
- ✅ Permite filtrar ocorrências por quem as criou
- ✅ Funciona em conjunto com o filtro de busca textual
- ✅ Opção "Todos os Solicitantes" para remover filtro

### 3. **Modal de Detalhes**
- ✅ Campo "Criado por" adicionado no modal de detalhes
- ✅ Exibe abaixo do campo "Solicitante"
- ✅ Mostra informação completa do usuário criador

### 4. **Busca Aprimorada**
- ✅ Busca textual agora também pesquisa no campo "Criado por"
- ✅ Funciona em conjunto com filtro de solicitante
- ✅ Mantém paginação correta após filtros

---

## 🎨 Interface

### Antes:
```
PEDIDO | TRANSPORTADORA | CLIENTE | STATUS | DATA | AÇÕES
```

### Depois:
```
PEDIDO | TRANSPORTADORA | CLIENTE | STATUS | DATA | CRIADO POR | AÇÕES
```

### Novos Controles:
```
[Buscar por pedido, cliente, transportadora...] [Todos os Solicitantes ▼]
```

---

## 🔧 Arquivos Modificados

### 1. `index.html`
- Adicionada coluna "Criado por" no `<thead>` da tabela
- Adicionado dropdown de filtro por solicitante
- Ajustado colspan para 7 colunas

### 2. `app.js`
**Função `searchOccurrences()`:**
- Implementado filtro combinado (busca textual + solicitante)
- Busca agora inclui campo "Criado por"

**Função `loadOccurrences()`:**
- Adicionada chamada à função `populateSolicitanteFilter()`
- Query inclui JOIN com tabela users: `users!created_by(name)`

**Nova Função `populateSolicitanteFilter()`:**
- Preenche dropdown com lista única de solicitantes
- Ordena alfabeticamente
- Remove duplicatas

**Função `displayOccurrences()`:**
- Removida lógica específica para admin (coluna visível para todos)
- Adicionada célula `<td>` com nome do criador
- Simplificada estrutura do HTML

**Função `showOccurrenceDetails()`:**
- Adicionado campo "Criado por" no modal

**Função `paginateOccurrences()`:**
- Ajustado colspan para 7 colunas

### 3. `styles.css`
**Nova classe `.filter-box`:**
```css
.filter-box {
    min-width: 200px;
}

.filter-box select {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid var(--border-color);
    border-radius: 8px;
    font-size: 14px;
    background-color: var(--surface);
    color: var(--text-primary);
    cursor: pointer;
    transition: border-color 0.2s;
}
```

**Atualização `.search-container`:**
- Adicionado `align-items: center` para alinhamento vertical

---

## 🔍 Detalhes Técnicos

### Query Supabase
```javascript
const { data, error } = await client
    .from('occurrences')
    .select(`
        *,
        users!created_by(name)
    `)
    .order('created_at', { ascending: false });
```

### Estrutura de Dados
Cada ocorrência agora retorna:
```javascript
{
    id: "uuid",
    num_pedido: "123456",
    // ... outros campos
    created_by: "user_uuid",
    users: {
        name: "Nome do Usuário"
    }
}
```

### Filtro de Solicitantes
- Extrai nomes únicos: `[...new Set(occurrences.map(occ => occ.users?.name))]`
- Filtra valores nulos/undefined
- Ordena alfabeticamente
- Preenche dropdown dinamicamente

---

## 📱 Comportamento

### Filtro por Solicitante
1. **Carregamento inicial**: Dropdown mostra "Todos os Solicitantes"
2. **Ao selecionar um nome**: Filtra ocorrências daquele usuário
3. **Mantém busca textual**: Ambos os filtros funcionam juntos
4. **Reset**: Selecionar "Todos os Solicitantes" remove filtro

### Busca Combinada
```javascript
const matchesSearch = !searchTerm || 
    num.includes(searchTerm) || 
    cliente.includes(searchTerm) || 
    transportadora.includes(searchTerm) ||
    criadoPor.includes(searchTerm);

const matchesSolicitante = !solicitanteFilter || 
    (occ.users?.name === solicitanteFilter);

return matchesSearch && matchesSolicitante;
```

---

## ✅ Validações

- ✅ Coluna visível para todos os usuários
- ✅ Filtro populado automaticamente ao carregar ocorrências
- ✅ Busca funciona com ambos os filtros simultaneamente
- ✅ Paginação mantida após filtros
- ✅ Campo "Criado por" no modal de detalhes
- ✅ Fallback para "Usuário" quando nome não disponível
- ✅ Design responsivo mantido

---

## 🎯 Casos de Uso

### 1. Ver quem criou cada ocorrência
- Abrir página principal
- Visualizar coluna "Criado por" na tabela

### 2. Filtrar por solicitante específico
- Clicar no dropdown "Todos os Solicitantes"
- Selecionar nome desejado
- Visualizar apenas ocorrências daquele usuário

### 3. Buscar ocorrências de um solicitante
- Digitar nome na busca textual
- Ocorrências filtradas por nome do criador

### 4. Combinar filtros
- Selecionar solicitante no dropdown
- Digitar termo na busca (pedido, cliente, etc.)
- Ver apenas ocorrências que atendem ambos os critérios

---

## 📊 Resultado Visual

```
┌─────────────────────────────────────────────────────────────────────────┐
│  [🔍 Buscar por pedido...]  [👤 Todos os Solicitantes ▼]              │
├─────┬──────────────┬─────────┬────────┬──────┬────────────┬────────────┤
│ PED │ TRANSP       │ CLIENTE │ STATUS │ DATA │ CRIADO POR │ AÇÕES      │
├─────┼──────────────┼─────────┼────────┼──────┼────────────┼────────────┤
│ 123 │ São Miguel   │ João    │ 🟢     │ 20/01│ Ana Paula  │ ✏️ 🗑️    │
│ 124 │ Leomar       │ Maria   │ 🔴     │ 19/01│ Lucas      │ ✏️ 🗑️    │
│ 125 │ Fritz        │ Pedro   │ 🟡     │ 18/01│ Ana Paula  │ ✏️ 🗑️    │
└─────┴──────────────┴─────────┴────────┴──────┴────────────┴────────────┘
```

---

## 📝 Observações

- O campo usa o relacionamento `created_by` da tabela `occurrences`
- Informação vem da coluna `name` da tabela `users`
- Se usuário não tiver nome cadastrado, exibe "Usuário"
- Filtro é case-sensitive (considera maiúsculas/minúsculas)
- Lista de solicitantes é atualizada toda vez que carrega ocorrências

---

**Data de Implementação:** 20 de outubro de 2025  
**Status:** ✅ Concluído e Testado
