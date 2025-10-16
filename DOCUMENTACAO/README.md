# 🏥 Sistema Fortimed SAC

Sistema de controle de ocorrências para Fortimed Distribuidora.

## 🚀 Configuração Inicial

### 1. Configurar Banco de Dados (Supabase)
1. Acesse https://app.supabase.com
2. Crie um novo projeto
3. Vá em SQL Editor
4. Execute o arquivo `setup-database.sql`
5. Copie a URL e Anon Key do projeto

### 2. Atualizar Credenciais
Edite o arquivo `config.js` e substitua:
- `supabaseUrl` pela URL do seu projeto
- `supabaseKey` pela Anon Key do seu projeto

### 3. Testar Sistema
1. Abra `index.html` no navegador
2. Registre-se com seu email
3. Crie uma ocorrência de teste
4. Deve funcionar sem erros

## 👥 Usuários do Sistema

- **👑 Admin**: administrativo@fortimeddistribuidora.com.br (Compras@01) - **Vê todos os chamados**
- **👤 Vendas 01-06**: vendas01@fortimeddistribuidora.com.br até vendas06@fortimeddistribuidora.com.br - **Vê apenas seus chamados**

## 📁 Arquivos do Sistema

- `index.html` - Página principal
- `login.html` - Página de login
- `styles.css` - Estilos do sistema
- `app.js` - Lógica principal
- `auth.js` - Sistema de autenticação
- `config.js` - Configurações Supabase
- `importar-usuarios.html` - Importar usuários
- `setup-database.sql` - Script de configuração do banco
- `img/logo.png` - Logo da empresa

## 🔧 Deploy no Vercel

1. Faça upload dos arquivos para o GitHub
2. Conecte o repositório ao Vercel
3. Deploy automático
4. Acesse o link gerado

## ✅ Sistema Pronto!

Após a configuração, o sistema estará funcionando com:
- ✅ Login e registro de usuários
- ✅ Criação de ocorrências
- ✅ Edição e exclusão de ocorrências (sem duplicação)
- ✅ Filtros e busca
- ✅ Controle de acesso por usuário

## 🔧 Resolver Duplicação de Ocorrências

Se você já tem ocorrências duplicadas no sistema:
1. Execute o arquivo `limpar-duplicatas.sql` no Supabase
2. Isso manterá apenas a versão mais recente de cada ocorrência
3. O problema de duplicação ao editar foi corrigido no código

## 👑 Funcionalidade de Admin

Para ativar a funcionalidade de admin (ver todos os chamados):
1. Execute o arquivo `atualizar-admin.sql` no Supabase
2. O usuário administrativo@fortimeddistribuidora.com.br poderá ver todos os chamados
3. Usuários normais continuam vendo apenas seus próprios chamados

---

**Sistema desenvolvido para Fortimed Distribuidora** 🏥
