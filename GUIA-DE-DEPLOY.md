# 🚀 Guia de Deploy - Fortimed SAC System

## Parte 1: Configurar o Supabase (5-10 minutos)

### Passo 1: Criar conta no Supabase
1. Acesse https://supabase.com
2. Clique em "Start your project"
3. Faça login com GitHub, Google ou Email
4. Clique em "New Project"

### Passo 2: Criar o Projeto
1. Nome do projeto: `fortimed-sac`
2. Database Password: Crie uma senha forte (ANOTE!)
3. Region: Escolha "South America (São Paulo)" para melhor performance no Brasil
4. Clique em "Create new project"
5. Aguarde 2-3 minutos enquanto o projeto é criado

### Passo 3: Criar as Tabelas
1. No menu lateral, clique em **SQL Editor**
2. Clique em "+ New query"
3. Cole todo o SQL abaixo:

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

4. Clique em **RUN** ou pressione Ctrl+Enter
5. Você deve ver "Success. No rows returned"

### Passo 4: Verificar as Tabelas
1. No menu lateral, clique em **Database** > **Tables**
2. Você deve ver as tabelas `users` e `occurrences`

### Passo 5: Obter as Credenciais
1. No menu lateral, clique em **Settings** (⚙️)
2. Clique em **API**
3. Você verá:
   - **Project URL**: (algo como https://xxxxx.supabase.co)
   - **anon public**: (uma chave longa começando com eyJ...)
4. **COPIE E GUARDE ESSAS DUAS INFORMAÇÕES!**

---

## Parte 2: Deploy no Vercel (5 minutos)

### Opção A: Deploy via GitHub (Recomendado)

#### Passo 1: Criar repositório no GitHub
1. Acesse https://github.com
2. Clique no "+" no canto superior direito
3. Clique em "New repository"
4. Nome: `fortimed-sac-system`
5. Deixe como "Public" ou "Private"
6. Clique em "Create repository"

#### Passo 2: Fazer upload dos arquivos
1. Na página do repositório, clique em "uploading an existing file"
2. Arraste todos os arquivos do projeto:
   - index.html
   - login.html
   - styles.css
   - config.js
   - auth.js
   - app.js
   - package.json
   - vercel.json
   - README.md
   - .gitignore
3. Clique em "Commit changes"

#### Passo 3: Deploy no Vercel
1. Acesse https://vercel.com
2. Faça login (recomendado usar a mesma conta do GitHub)
3. Clique em "Add New..." > "Project"
4. Clique em "Import" no repositório `fortimed-sac-system`
5. Deixe todas as configurações padrão
6. Clique em "Deploy"
7. Aguarde 1-2 minutos
8. Clique no link gerado (algo como https://fortimed-sac-system.vercel.app)

### Opção B: Deploy Manual (mais rápido)

#### Usando Vercel CLI:
```bash
# Instalar Vercel CLI (só precisa fazer uma vez)
npm install -g vercel

# Na pasta do projeto, executar:
vercel

# Seguir as instruções:
# - Set up and deploy? Y
# - Which scope? (escolher sua conta)
# - Link to existing project? N
# - What's your project's name? fortimed-sac-system
# - In which directory is your code located? ./
# - Want to override the settings? N
```

#### Ou pelo site:
1. Acesse https://vercel.com
2. Clique em "Add New..." > "Project"
3. Clique na aba "Deploy from..."
4. Arraste a pasta do projeto
5. Clique em "Deploy"

---

## Parte 3: Configurar o Sistema (2 minutos)

### Passo 1: Acessar o sistema
1. Abra o link do Vercel no navegador
2. Você verá a página de Login

### Passo 2: Criar sua primeira conta
1. Clique em "Registrar-se"
2. Preencha:
   - Nome: Seu nome
   - Email: seu@email.com
   - Senha: mínimo 6 caracteres
3. **IMPORTANTE**: Esta primeira conta ainda NÃO funcionará até configurar o Supabase

### Passo 3: Configurar o Supabase no sistema
1. Vá até a aba **⚙️ Configurações**
2. Cole os dados que você guardou:
   - **Supabase URL**: https://xxxxx.supabase.co
   - **Supabase Anon Key**: eyJ...
3. Clique em **🔌 Testar Conexão**
4. Deve aparecer: "✅ Conexão estabelecida com sucesso!"
5. Clique em **💾 Salvar Configurações**

### Passo 4: Fazer logout e login novamente
1. Clique em **Sair**
2. Agora clique em **Registrar-se** novamente
3. Crie sua conta:
   - Nome: Seu nome
   - Email: seu@email.com
   - Senha: sua senha
4. Clique em "Criar Conta"
5. Você será redirecionado automaticamente

---

## ✅ Pronto! O sistema está funcionando!

Agora você pode:
- ✅ Criar ocorrências
- ✅ Visualizar ocorrências
- ✅ Editar ocorrências
- ✅ Excluir ocorrências
- ✅ Filtrar por status
- ✅ Buscar por pedido/cliente

---

## 🔗 Links Úteis

- **Supabase Dashboard**: https://app.supabase.com
- **Vercel Dashboard**: https://vercel.com/dashboard
- **Documentação Supabase**: https://supabase.com/docs
- **Documentação Vercel**: https://vercel.com/docs

---

## 📞 Solução de Problemas Comuns

### ❌ "Configure o Supabase na aba Configurações"
**Solução**: Vá na aba Configurações e insira a URL e Key do Supabase

### ❌ "Invalid API key"
**Solução**: 
1. Volte no Supabase > Settings > API
2. Copie novamente a "anon public" key
3. Cole no sistema
4. Salve

### ❌ Erro ao criar conta
**Solução**: 
1. Verifique se você configurou o Supabase primeiro
2. Verifique se as tabelas foram criadas corretamente
3. Vá em Supabase > Authentication > verifique se Email está habilitado

### ❌ Não consigo ver as ocorrências
**Solução**: 
1. Clique em "🔄 Atualizar"
2. Verifique se você está logado
3. Verifique se as políticas RLS foram criadas corretamente

---

## 🎉 Compartilhar o Sistema

Para permitir que outros usuários usem o sistema:

1. **Compartilhe o link do Vercel** (ex: https://fortimed-sac-system.vercel.app)
2. **Eles precisarão criar uma conta** na tela de login
3. **Todos verão as mesmas ocorrências** (sistema compartilhado)

---

**Desenvolvido para Fortimed** 🏥
