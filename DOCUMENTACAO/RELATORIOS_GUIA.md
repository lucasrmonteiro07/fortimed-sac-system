# 📊 Guia de Relatórios - Fortimed SAC

## 🎯 Visão Geral

A página de configurações agora inclui uma **seção completa de geração de relatórios** que permite exportar todos os chamados cadastrados em múltiplos formatos.

## 📋 Formatos Disponíveis

### 1️⃣ **Relatório Excel (.XLSX)**
- ✅ Formato nativo do Excel
- ✅ Todas as colunas com dados
- ✅ Formatação automática
- ✅ Fácil importação em sistemas externos
- 📥 Botão: **"📥 Baixar Excel"**

**Colunas incluídas:**
- Nº Pedido
- Nota Fiscal
- Transportadora
- Cliente
- Descrição
- Status
- Situação
- Responsável Falha
- Responsável Resolução
- Criado Por
- Data

---

### 2️⃣ **Relatório PDF**
- ✅ Pronto para impressão
- ✅ Tabela formatada
- ✅ Informações de data e total de registros
- ✅ Numeração de páginas
- 📥 Botão: **"📥 Baixar PDF"**

**Características:**
- Cabeçalho com título e data
- Tabela com as principais informações
- Rodapé com numeração de páginas
- Design profissional e responsivo

---

### 3️⃣ **Relatório CSV**
- ✅ Compatível com qualquer planilha
- ✅ Separação por vírgulas
- ✅ Escape automático de caracteres especiais
- ✅ Ideal para análise de dados
- 📥 Botão: **"📥 Baixar CSV"**

**Uso:** Abra em Excel, Google Sheets, Calc, etc.

---

### 4️⃣ **Relatório JSON**
- ✅ Formato estruturado
- ✅ Pronto para APIs
- ✅ Fácil parsing em aplicações
- ✅ Backup estruturado
- 📥 Botão: **"📥 Baixar JSON"**

**Estrutura:**
```json
{
  "titulo": "Relatório de Chamados - Fortimed",
  "dataGeracao": "15/10/2025 15:30:45",
  "totalRegistros": 42,
  "chamados": [
    {
      "numeroPedido": "12345",
      "notaFiscal": "NF-2025-001",
      "transportadora": "Transportadora X",
      "cliente": "Cliente Y",
      ...
    }
  ]
}
```

---

## 🔍 Filtros Disponíveis

### Status
```
- Todos os status (padrão)
- Aberto
- Em Análise
- Resolvido
- Fechado
```

### Data
- **Data Inicial**: Filtra chamados a partir de uma data
- **Data Final**: Filtra chamados até uma data

### Usuário
- Filtra por nome do usuário que criou o chamado
- Deixe vazio para incluir todos

---

## 📱 Controle de Acesso

### 👑 Administrador
- ✅ Vê **TODOS** os chamados
- ✅ Pode gerar relatórios com todos os dados
- ✅ Sem restrições de filtro por usuário

### 👤 Usuário Normal
- ✅ Vê apenas **seus próprios** chamados
- ✅ Relatórios incluem apenas suas ocorrências
- ✅ Filtros aplicam sobre seus dados

---

## 🚀 Como Usar

### Passo 1: Acessar Relatórios
1. Abra a página: https://fortimed-sac-system.vercel.app/config.html
2. Role até a seção **"📊 Geração de Relatórios"**

### Passo 2: Configurar Filtros (Opcional)
1. Selecione um **Status** (ou deixe vazio para todos)
2. Defina um **intervalo de datas** (opcional)
3. Filtre por **usuário** (opcional)

### Passo 3: Gerar Relatório
Clique em um dos botões:
- 📥 **Baixar Excel** - Para análises em planilha
- 📥 **Baixar PDF** - Para impressão/visualização
- 📥 **Baixar CSV** - Para importação em sistemas
- 📥 **Baixar JSON** - Para integração com APIs

### Passo 4: Aguardar Download
- A primeira geração pode levar 2-3 segundos (carregamento de bibliotecas)
- Próximas gerações são mais rápidas
- O arquivo será baixado automaticamente

---

## 📊 Exemplos de Uso

### Cenário 1: Analisar Chamados por Período
1. Defina **Data Inicial**: 01/10/2025
2. Defina **Data Final**: 15/10/2025
3. Clique **"📥 Baixar Excel"**
4. Abra em Excel para análise

### Cenário 2: Relatório de Chamados Abertos
1. Selecione **Status**: "Aberto"
2. Clique **"📥 Baixar PDF"**
3. Imprima ou compartilhe o documento

### Cenário 3: Backup Estruturado
1. Deixe todos os filtros vazios (todos os dados)
2. Clique **"📥 Baixar JSON"**
3. Salve para backup em sistema

---

## 🔧 Detalhes Técnicos

### Bibliotecas Utilizadas

| Formato | Biblioteca | CDN |
|---------|-----------|-----|
| Excel | XLSX.js | cdnjs.cloudflare.com |
| PDF | jsPDF + AutoTable | cdnjs.cloudflare.com |
| CSV | Nativo (JavaScript) | - |
| JSON | Nativo (JavaScript) | - |

### Carregamento Dinâmico
- Bibliotecas são carregadas sob demanda (primeira geração)
- Não aumenta o tamanho inicial da página
- Cached pelo navegador para próximas gerações

---

## ⚙️ Limitações e Considerações

| Item | Limite |
|------|--------|
| Máximo de registros por relatório | Sem limite (depende do servidor) |
| Tamanho máximo do arquivo | ~10 MB (considerando limite do navegador) |
| Formato de data | DD/MM/YYYY (conforme configuração) |
| Charset | UTF-8 (suporta acentuação) |

---

## 🐛 Troubleshooting

### "❌ Nenhum dado encontrado para o relatório"
**Solução**: Você pode não ter permissão para ver esses dados ou não existem chamados com os filtros aplicados.

### "❌ Erro ao gerar relatório"
**Solução**: 
1. Verifique sua conexão com a internet
2. Limpe o cache do navegador (Ctrl+F5)
3. Tente novamente em alguns segundos

### Relatório não baixa
**Solução**:
1. Verifique se pop-ups estão bloqueados
2. Desabilite bloqueadores de anúncios
3. Tente em outro navegador

### Arquivo corrompido
**Solução**: 
1. Tente gerar novamente
2. Se persistir, tente outro formato (Excel → CSV)

---

## 📈 Funcionalidades Futuras

Possíveis melhorias para próximas versões:

- [ ] Gráficos e dashboards
- [ ] Agendamento de relatórios
- [ ] Envio por email
- [ ] Filtro por status múltiplos
- [ ] Geração de relatórios comparativos
- [ ] Integração com Power BI
- [ ] Exportação para Google Sheets

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte o **README.md**
2. Verifique a documentação em **SOLUCAO-RAPIDA.md**
3. Contate o administrador do sistema

---

**Data da Documentação**: 15 de outubro de 2025  
**Versão**: 1.0  
**Status**: ✅ Produção
