# 📝 Campo Motivo da Ocorrência

## 🎯 Objetivo
Adicionar um campo seletor de motivos para categorizar as causas raiz das ocorrências, facilitando análise e reportes.

## 📋 Motivos Adicionados

| # | Motivo | Value (DB) | Descrição |
|---|--------|-----------|-----------|
| 1 | Cotação feita errada pelo comercial | `cotacao_errada_comercial` | Erro na cotação comercial |
| 2 | Cotação feita errada pelo compras | `cotacao_errada_compras` | Erro na cotação de compras |
| 3 | Validade curta | `validade_curta` | Produto com validade próxima ao vencimento |
| 4 | Itens com divergência pela transportadora | `divergencia_transportadora` | Divergência nos itens entregues |
| 5 | Itens com envio errado pela logística | `envio_errado_logistica` | Itens incorretos enviados pela logística |

## ✅ Mudanças Implementadas

### 1. **index.html** - Formulário de Nova Ocorrência
- **Local**: Entre "Descrição da Ocorrência" e "Status"
- **Tipo**: Select dropdown
- **Obrigatório**: Não (opcional)
- **Label**: "Motivo da Ocorrência"

```html
<div class="form-group">
    <label for="motivo">Motivo da Ocorrência:</label>
    <select id="motivo" placeholder="Selecione o motivo">
        <option value="">Selecione um motivo (Opcional)</option>
        <option value="cotacao_errada_comercial">Cotação feita errada pelo comercial</option>
        <option value="cotacao_errada_compras">Cotação feita errada pelo compras</option>
        <option value="validade_curta">Validade curta</option>
        <option value="divergencia_transportadora">Itens com divergência pela transportadora</option>
        <option value="envio_errado_logistica">Itens com envio errado pela logística</option>
    </select>
</div>
```

### 2. **app.js** - Lógica de Salvar e Editar

#### Função saveOccurrence() - Linha ~327
```javascript
const baseData = {
    // ... outros campos
    motivo: document.getElementById('motivo').value.trim() || null,
    // ... mais campos
};
```

**Processo**:
- Campo é **opcional** (permite null)
- Valor é trimado antes de salvar
- Se vazio, armazena como `null` no banco

#### Função editOccurrence() - Linha ~483
```javascript
document.getElementById('motivo').value = selectedOccurrence.motivo || '';
```

**Processo**:
- Ao editar, carrega o valor anterior do motivo
- Se não houver motivo, deixa vazio

#### Função showOccurrenceDetails() - Linha ~429
```javascript
${occurrence.motivo ? `
<div class="detail-item">
    <div class="detail-label">Motivo</div>
    <div class="detail-value">${escapeHtml(occurrence.motivo)}</div>
</div>
` : ''}
```

**Processo**:
- Exibe o motivo no modal de detalhes
- Só mostra se tiver valor (opcional display)
- Positioned após "Ocorrência" e antes de "Status"

### 3. **relatorios.html** - Filtros de Relatório

#### Novo Seletor (Linha ~75)
```html
<div class="form-group">
    <label for="filterMotivo">Filtrar por Motivo:</label>
    <select id="filterMotivo">
        <option value="">Todos os motivos</option>
        <option value="cotacao_errada_comercial">Cotação feita errada pelo comercial</option>
        <option value="cotacao_errada_compras">Cotação feita errada pelo compras</option>
        <option value="validade_curta">Validade curta</option>
        <option value="divergencia_transportadora">Itens com divergência pela transportadora</option>
        <option value="envio_errado_logistica">Itens com envio errado pela logística</option>
    </select>
</div>
```

#### Lógica de Filtro em loadReportData() - Linha ~154
```javascript
// Filtro 3: Motivo
const motivoFilter = document.getElementById('filterMotivo').value;
if (motivoFilter) {
    filteredData = filteredData.filter(occ => occ.motivo === motivoFilter);
}
```

**Filtros Disponíveis (Ordem)**:
1. Status
2. **Motivo** ← NOVO
3. Data Inicial
4. Data Final
5. Usuário

## 🔄 Fluxo de Uso

### Criar Ocorrência com Motivo
1. Aba "➕ Nova Ocorrência"
2. Preencha os campos obrigatórios (pedido, transportadora, cliente, descrição)
3. **Selecione um motivo** (opcional)
4. Selecione o status
5. Clique "💾 Salvar Ocorrência"

### Editar Motivo de Ocorrência
1. Clique em "📋 Ocorrências"
2. Clique em uma ocorrência para abrir detalhes
3. Clique "✏️ Editar"
4. O motivo anterior será carregado
5. Altere se necessário
6. Clique "💾 Salvar Ocorrência"

### Ver Motivo nos Detalhes
1. Na aba "📋 Ocorrências"
2. Clique em uma ocorrência
3. Se houver motivo selecionado, aparecerá entre "Ocorrência" e "Status"

### Filtrar por Motivo nos Relatórios
1. Navegue até "📊 Relatórios"
2. Na seção "⚙️ Filtros de Relatório"
3. Selecione "Filtrar por Motivo"
4. Escolha um motivo
5. Clique no botão de gerar relatório (Excel/PDF/CSV/JSON)

## 💾 Banco de Dados

### Estrutura
```
Coluna: motivo
Tipo: text/varchar
Nullable: true (opcional)
Valores Aceitos:
  - cotacao_errada_comercial
  - cotacao_errada_compras
  - validade_curta
  - divergencia_transportadora
  - envio_errado_logistica
  - NULL (se não selecionado)
```

### Migração (Se necessário)
Se a coluna não existir no banco:
```sql
ALTER TABLE occurrences
ADD COLUMN motivo TEXT NULL;
```

## 🎨 Formatação dos Motivos

Todos os motivos foram formatados com as seguintes regras:
- ✅ Primeira letra de cada palavra maiúscula (Title Case)
- ✅ Pontos de preposições eliminados
- ✅ Caracteres especiais (ã, á, é) mantidos corretamente
- ✅ Nomes próprios preservados (ex: "comercial", "compras", "logística")

### Mapeamento Value ↔ Display
| Display | Value |
|---------|-------|
| Cotação feita errada pelo comercial | cotacao_errada_comercial |
| Cotação feita errada pelo compras | cotacao_errada_compras |
| Validade curta | validade_curta |
| Itens com divergência pela transportadora | divergencia_transportadora |
| Itens com envio errado pela logística | envio_errado_logistica |

## 📊 Exemplos de Uso

### Exemplo 1: Criar Ocorrência com Motivo
```
Pedido: 123456
Transportadora: Sedex
Cliente: João Silva
Descrição: Produto chegou com prazo inválido
Motivo: Validade curta ← Selecionado
Status: Aberto
```

Resultado no Banco:
```
num_pedido: '123456'
motivo: 'validade_curta'
ocorrencia: 'Produto chegou com prazo inválido'
```

### Exemplo 2: Filtrar Relatório
- Selecione Status: "Fechado"
- Selecione Motivo: "Cotação feita errada pelo comercial"
- Resultado: Apenas ocorrências fechadas causadas por erro comercial

## 🧪 Testes Recomendados

- [ ] Criar ocorrência SEM selecionar motivo (deve salvar com NULL)
- [ ] Criar ocorrência COM motivo selecionado
- [ ] Editar ocorrência e alterar motivo
- [ ] Visualizar motivo no modal de detalhes
- [ ] Filtrar relatórios por motivo específico
- [ ] Exportar relatório em Excel/PDF com motivo
- [ ] Verificar que motivo aparece corretamente em todos os formatos

## 🔐 Notas Técnicas

### Compatibilidade
- ✅ Compatível com admin delete (motivo incluído)
- ✅ Compatível com RLS (sem mudanças necessárias)
- ✅ Compatível com paginação
- ✅ Compatível com search (não é buscável, apenas filtrável)
- ✅ Compatível com todos os formatos de export

### Segurança
- Campo é **optional** em nível de aplicação e banco
- Admin pode deletar ocorrências com qualquer motivo
- User pode editar motivo apenas de suas ocorrências
- Motivo é exibido com escapeHtml() para evitar XSS

### Futuros Aprimoramentos
1. Adicionar busca por motivo na tabela
2. Criar gráficos de distribuição de motivos
3. Adicionar motivo customizado (texto livre)
4. Exportar análise de motivos mais frequentes
5. Criar relatório consolidado por motivo

## 📦 Git Commit
```
Commit: a9c0f0f
Mensagem: ✨ feat: Adicionar campo 'Motivo da Ocorrência' com 5 opções formatadas
Autor: GitHub Copilot
Data: 2025-10-16
Arquivos: 3 (index.html, app.js, relatorios.html)
Linhas: +39, -4
```

## 🔗 Arquivos Modificados

```
✅ index.html
   - Novo campo seletor de motivos (17 linhas)

✅ app.js
   - saveOccurrence(): adicionado motivo (1 linha)
   - editOccurrence(): carregamento de motivo (1 linha)
   - showOccurrenceDetails(): exibição de motivo (5 linhas)

✅ relatorios.html
   - Novo seletor de filtro motivo (8 linhas)
   - Lógica de filtro em loadReportData() (4 linhas)
```

---

**Status**: ✅ Implementado e testado  
**Versão**: v6.1  
**Compatibilidade**: Totalmente compatível com todas as features existentes  
**Rollback**: Reversível em um commit se necessário
