# 🏥 Fortimed - Sistema de Controle de Ocorrências

Sistema completo de gerenciamento de ocorrências para a empresa Fortimed, desenvolvido em HTML/CSS/JavaScript puro com integração ao Supabase.

## 📋 Características

- ✅ Sistema de login e autenticação
- ✅ Cadastro de ocorrências/SAC
- ✅ Listagem e filtros de ocorrências
- ✅ Controle de status (Aberto, Em Andamento, Resolvido, Fechado)
- ✅ Rastreamento de responsáveis
- ✅ Interface responsiva e moderna
- ✅ Integração com Supabase (banco de dados)
- ✅ Deploy fácil no Vercel

## 🚀 Deploy no Vercel

### 1. Criar conta no Vercel
- Acesse: https://vercel.com
- Crie uma conta gratuita

### 2. Instalar Vercel CLI (Opcional)
```bash
npm install -g vercel
```

### 3. Deploy via GitHub (Recomendado)

1. Crie um repositório no GitHub
2. Faça upload de todos os arquivos do projeto
3. No Vercel, clique em "New Project"
4. Importe o repositório do GitHub
5. Clique em "Deploy"

### 4. Deploy via Vercel CLI

```bash
# Na pasta do projeto
vercel

# Seguir as instruções na tela
# Confirmar com Enter para aceitar as configurações padrão
```

## 🗄️ Configurar Supabase

### 1. Criar conta no Supabase
- Acesse: https://supabase.com
- Crie uma conta gratuita
- Crie um novo projeto

### 2. Executar o SQL de criação das tabelas

No painel do Supabase, vá em **SQL Editor** e execute:

```sql
-- Tabela de usuários
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela de ocorrências
CREATE TABLE occurrences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    num_pedido VARCHAR(100) NOT NULL,
    nota_fiscal VARCHAR(100),
    transportadora VARCHAR(255) NOT NULL,
    nome_cliente VARCHAR(255) NOT NULL,
    ocorrencia TEXT NOT NULL,
    status VARCHAR(50) NOT NULL,
    situacao TEXT,
    responsavel_falha VARCHAR(255),
    responsavel_resolucao VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES users(id)
);

-- Índices para melhor performance
CREATE INDEX idx_occurrences_num_pedido ON occurrences(num_pedido);
CREATE INDEX idx_occurrences_status ON occurrences(status);
CREATE INDEX idx_occurrences_created_at ON occurrences(created_at DESC);

-- Habilitar RLS (Row Level Security)
ALTER TABLE occurrences ENABLE ROW LEVEL SECURITY;

-- Política de acesso (todos podem ler/escrever após autenticação)
CREATE POLICY "Usuários autenticados podem ver ocorrências"
    ON occurrences FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem criar ocorrências"
    ON occurrences FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem atualizar ocorrências"
    ON occurrences FOR UPDATE
    USING (auth.role() = 'authenticated');

CREATE POLICY "Usuários autenticados podem deletar ocorrências"
    ON occurrences FOR DELETE
    USING (auth.role() = 'authenticated');
```

### 3. Habilitar Autenticação por Email

No painel do Supabase:
1. Vá em **Authentication** > **Providers**
2. Habilite **Email** (já deve estar habilitado por padrão)
3. Configure as opções conforme necessário

### 4. Obter as credenciais

No painel do Supabase, vá em **Settings** > **API**:
- Copie a **Project URL** (ex: https://xyz.supabase.co)
- Copie a **anon/public key**

### 5. Configurar no sistema

1. Acesse o sistema implantado no Vercel
2. Faça login ou crie uma conta
3. Vá na aba **Configurações**
4. Cole a **Supabase URL** e **Supabase Anon Key**
5. Clique em **Testar Conexão** para verificar
6. Clique em **Salvar Configurações**

## 📱 Como usar o sistema

### 1. Primeira vez - Criar conta
- Acesse o sistema
- Clique em "Registrar-se"
- Preencha nome, email e senha
- Clique em "Criar Conta"

### 2. Login
- Digite seu email e senha
- Clique em "Entrar"

### 3. Registrar nova ocorrência
- Clique na aba "➕ Nova Ocorrência"
- Preencha os campos:
  - **Nº Pedido**: Número do pedido (ex: NF 1535)
  - **Nota Fiscal**: Número da nota fiscal (opcional)
  - **Transportadora**: Nome da transportadora
  - **Nome do Cliente**: Nome do cliente
  - **Ocorrência**: Descreva o problema
  - **Status**: Selecione o status (Aberto, Em Andamento, etc.)
  - **Situação**: Situação atual (opcional)
  - **Responsável pela Falha**: Nome (opcional)
  - **Responsável pela Resolução**: Nome (opcional)
- Clique em "💾 Salvar Ocorrência"

### 4. Visualizar ocorrências
- A aba "📋 Ocorrências" mostra todas as ocorrências
- Use o campo de busca para filtrar por Nº Pedido, Cliente ou Transportadora
- Use o filtro de status para ver apenas ocorrências com status específico
- Clique em "🔄 Atualizar" para recarregar a lista

### 5. Editar ocorrência
- Na lista de ocorrências, clique no botão "✏️" da ocorrência
- OU clique na linha da ocorrência e depois em "✏️ Editar"
- Faça as alterações necessárias
- Clique em "💾 Salvar Ocorrência"

### 6. Excluir ocorrência
- Na lista de ocorrências, clique no botão "🗑️" da ocorrência
- OU clique na linha da ocorrência e depois em "🗑️ Excluir"
- Confirme a exclusão

## 🔧 Estrutura de arquivos

```
fortimed-sac-system/
├── index.html          # Página principal (dashboard)
├── login.html          # Página de login/registro
├── styles.css          # Estilos CSS
├── config.js           # Gerenciamento de configurações
├── auth.js             # Sistema de autenticação
├── app.js              # Lógica principal da aplicação
├── package.json        # Configurações do projeto
├── vercel.json         # Configuração do Vercel
└── README.md           # Este arquivo
```

## 🔐 Segurança

- As senhas são criptografadas pelo Supabase Auth
- Row Level Security (RLS) habilitado no banco de dados
- Apenas usuários autenticados podem acessar o sistema
- As credenciais do Supabase são armazenadas localmente no navegador

## 🆘 Solução de problemas

### Erro: "Configure o Supabase na aba Configurações"
- Vá na aba Configurações
- Insira a URL e Anon Key do Supabase
- Clique em "Testar Conexão"
- Se o teste passar, clique em "Salvar Configurações"

### Erro: "Invalid API key"
- Verifique se a Anon Key está correta
- Copie novamente do painel do Supabase (Settings > API)

### Erro ao criar conta: "already registered"
- Este email já está cadastrado
- Use outro email ou faça login

### Tabelas não encontradas
- Execute o SQL de criação no Supabase SQL Editor
- Verifique se as tabelas foram criadas em Database > Tables

## 📞 Campos disponíveis

O sistema captura os seguintes campos para cada ocorrência:

- **Nº Pedido** (obrigatório)
- **Nota Fiscal** (opcional)
- **Transportadora** (obrigatório)
- **Nome do Cliente** (obrigatório)
- **Ocorrência** (descrição detalhada - obrigatório)
- **Status** (Aberto, Em Andamento, Resolvido, Fechado - obrigatório)
- **Situação** (informações adicionais - opcional)
- **Responsável pela Falha** (opcional)
- **Responsável pela Resolução** (opcional)
- **Data de Criação** (automático)
- **Data de Atualização** (automático)

## 🎨 Tecnologias utilizadas

- HTML5
- CSS3
- JavaScript (Vanilla)
- Supabase (Backend/Database)
- Vercel (Hosting)

## 📝 Licença

Este projeto é de propriedade da Fortimed.

---

**Desenvolvido para Fortimed** 🏥
