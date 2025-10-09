# ✅ CHECKLIST DE INSTALAÇÃO - Sistema Fortimed SAC

Use este checklist para garantir que tudo foi configurado corretamente.

## 📋 FASE 1: PREPARAÇÃO (5 min)

- [ ] Baixei todos os arquivos do sistema
- [ ] Tenho conta no GitHub (ou vou criar)
- [ ] Tenho conexão com internet

---

## 🗄️ FASE 2: SUPABASE (10 min)

### Criar Projeto
- [ ] Acessei https://supabase.com
- [ ] Criei uma conta
- [ ] Criei um novo projeto chamado "fortimed-sac"
- [ ] Anotei a senha do banco de dados
- [ ] Aguardei o projeto ser criado (2-3 min)

### Criar Tabelas
- [ ] Abri SQL Editor no Supabase
- [ ] Copiei o SQL do arquivo README.md (seção "Configurar Supabase")
- [ ] Executei o SQL (cliquei em RUN)
- [ ] Vi mensagem "Success. No rows returned"
- [ ] Verifiquei em Database > Tables que as tabelas "users" e "occurrences" existem

### Obter Credenciais
- [ ] Fui em Settings > API
- [ ] Copiei a **Project URL** (ex: https://xxxxx.supabase.co)
- [ ] Copiei a **anon public key** (começa com eyJ...)
- [ ] Salvei essas informações em um arquivo .txt seguro

---

## 🚀 FASE 3: VERCEL (5 min)

### Preparar Código
- [ ] Criei um repositório no GitHub chamado "fortimed-sac-system"
- [ ] Fiz upload de TODOS os arquivos:
  - [ ] index.html
  - [ ] login.html
  - [ ] styles.css
  - [ ] config.js
  - [ ] auth.js
  - [ ] app.js
  - [ ] package.json
  - [ ] vercel.json
  - [ ] README.md
  - [ ] GUIA-DE-DEPLOY.md

### Deploy
- [ ] Acessei https://vercel.com
- [ ] Fiz login (usei mesma conta do GitHub)
- [ ] Cliquei em "Add New" > "Project"
- [ ] Importei o repositório "fortimed-sac-system"
- [ ] Cliquei em "Deploy"
- [ ] Aguardei o deploy (1-2 min)
- [ ] Copiei o link do site (ex: https://fortimed-sac-system.vercel.app)

---

## ⚙️ FASE 4: CONFIGURAR SISTEMA (3 min)

### Primeira Configuração
- [ ] Abri o link do Vercel no navegador
- [ ] Cliquei em "Registrar-se" (vai dar erro, é normal!)
- [ ] Fui direto para a aba "⚙️ Configurações"
- [ ] Colei a **Supabase URL**
- [ ] Colei a **Supabase Anon Key**
- [ ] Cliquei em "🔌 Testar Conexão"
- [ ] Vi mensagem "✅ Conexão estabelecida com sucesso!"
- [ ] Cliquei em "💾 Salvar Configurações"

### Criar Conta
- [ ] Cliquei em "Sair"
- [ ] Cliquei em "Registrar-se"
- [ ] Preenchi nome, email e senha
- [ ] Cliquei em "Criar Conta"
- [ ] Fui redirecionado para o dashboard

---

## 🎯 FASE 5: TESTAR (5 min)

### Testar Cadastro de Ocorrência
- [ ] Cliquei na aba "➕ Nova Ocorrência"
- [ ] Preenchi todos os campos obrigatórios:
  - [ ] Nº Pedido: "NF 1535"
  - [ ] Transportadora: "EXPRESSO SÃO MIGUEL"
  - [ ] Nome do Cliente: "HOESP"
  - [ ] Ocorrência: "DEVOLVIDOS 35 PACOTES DE MÁSCARA FORTFLEX POR QUEIXA DE MAL CHEIRO."
  - [ ] Status: "ABERTO"
- [ ] Cliquei em "💾 Salvar Ocorrência"
- [ ] Vi mensagem de sucesso

### Testar Listagem
- [ ] Voltei para aba "📋 Ocorrências"
- [ ] Vi a ocorrência que criei
- [ ] Cliquei na linha da ocorrência
- [ ] Vi os detalhes no modal

### Testar Edição
- [ ] No modal, cliquei em "✏️ Editar"
- [ ] Mudei o status para "EM ANDAMENTO"
- [ ] Salvei
- [ ] Voltei na lista e verifiquei a mudança

### Testar Filtros
- [ ] Usei o campo de busca para procurar "NF 1535"
- [ ] Usei o filtro de status
- [ ] Cliquei em "🔄 Atualizar"

---

## ✅ SISTEMA PRONTO!

Se você marcou todos os itens acima, seu sistema está 100% funcional!

---

## 📱 COMPARTILHAR COM EQUIPE

Para outros usuários usarem:

1. **Compartilhe o link**: https://seu-site.vercel.app
2. **Eles criam conta**: Cada pessoa cria sua própria conta
3. **Todos compartilham os dados**: Todos veem as mesmas ocorrências

---

## 🆘 SE ALGO DEU ERRADO

### ❌ Erro ao criar conta
**Verifique:**
- [ ] Supabase foi configurado no sistema?
- [ ] As tabelas foram criadas no Supabase?
- [ ] A URL e Key estão corretas?

### ❌ Erro ao salvar ocorrência
**Verifique:**
- [ ] Você está logado?
- [ ] Preencheu todos os campos obrigatórios?
- [ ] A conexão com Supabase está funcionando?

### ❌ Não vejo as ocorrências
**Verifique:**
- [ ] Clique em "🔄 Atualizar"
- [ ] Verifique se criou alguma ocorrência antes
- [ ] Verifique os filtros (limpe a busca e status)

---

## 📞 INFORMAÇÕES IMPORTANTES

**Links salvos:**
- Site do sistema: _______________________________
- Supabase Dashboard: https://app.supabase.com
- Vercel Dashboard: https://vercel.com/dashboard

**Credenciais Supabase:**
- URL: _______________________________
- Anon Key: _______________________________

---

**Sistema pronto para uso! 🎉**
