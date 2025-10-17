// Script para criar rapidamente o usuário admin Ana Paula
// Coloque este código no console do navegador ou execute na página importar-usuarios.html

async function criarAdminAnaPaula() {
    const client = config.getClient();
    const email = 'anapaula@fortimeddistribuidora.com.br';
    const password = 'Compras@01';
    const name = 'Ana Paula';
    
    console.log('🔄 Criando usuário admin Ana Paula...');
    
    try {
        // 1. Criar usuário de autenticação no Supabase
        console.log('1️⃣ Criando usuário de autenticação...');
        const { data: authData, error: authError } = await client.auth.admin.createUser({
            email: email,
            password: password,
            email_confirm: true,
            user_metadata: {
                full_name: name
            }
        });
        
        if (authError) {
            console.error('❌ Erro ao criar usuário de autenticação:', authError);
            throw authError;
        }
        
        console.log('✅ Usuário de autenticação criado:', authData.user.id);
        
        // 2. Inserir na tabela users
        console.log('2️⃣ Inserindo na tabela de usuários...');
        const { data: userData, error: userError } = await client
            .from('users')
            .upsert([
                {
                    id: authData.user.id,
                    email: email,
                    name: name,
                    role: 'admin'
                }
            ], { onConflict: 'id' });
        
        if (userError && userError.code !== '23505') {
            console.error('❌ Erro ao inserir na tabela users:', userError);
            throw userError;
        }
        
        console.log('✅ Usuário inserido na tabela de metadados');
        
        // 3. Confirmação final
        console.log('═════════════════════════════════════════════════════════');
        console.log('✅ SUCESSO! Usuário Admin criado com sucesso!');
        console.log('═════════════════════════════════════════════════════════');
        console.log('Email: ' + email);
        console.log('Senha: Compras@01');
        console.log('Função: Admin');
        console.log('Nome: ' + name);
        console.log('═════════════════════════════════════════════════════════');
        console.log('O usuário pode fazer login imediatamente!');
        
        alert('✅ Usuário Admin Ana Paula criado com sucesso!\n\nEmail: ' + email + '\nSenha: Compras@01');
        
    } catch (error) {
        console.error('❌ ERRO ao criar usuário:', error);
        alert('❌ Erro ao criar usuário. Verifique o console para detalhes.');
    }
}

// Função auxiliar para testar se está funcionando
async function testarLoginAnaPaula() {
    const client = config.getClient();
    
    console.log('🔐 Testando login de Ana Paula...');
    
    try {
        const { data, error } = await client.auth.signInWithPassword({
            email: 'anapaula@fortimeddistribuidora.com.br',
            password: 'Compras@01'
        });
        
        if (error) {
            console.error('❌ Erro no login:', error.message);
            alert('❌ Login falhou: ' + error.message);
            return false;
        }
        
        console.log('✅ Login bem-sucedido!');
        console.log('Usuário:', data.user.email);
        alert('✅ Login de teste bem-sucedido para: ' + data.user.email);
        
        return true;
        
    } catch (error) {
        console.error('❌ Erro ao testar login:', error);
        alert('❌ Erro ao testar login. Verifique o console.');
        return false;
    }
}

// ═════════════════════════════════════════════════════════════════════════════════
// COMO USAR:
// ═════════════════════════════════════════════════════════════════════════════════
//
// 1. Abra o navegador na página do sistema (ex: http://localhost:5173)
// 2. Abra o console (F12 ou DevTools)
// 3. Cole este arquivo completo no console
// 4. Execute um dos comandos:
//
//    • Para criar: criarAdminAnaPaula()
//    • Para testar login: testarLoginAnaPaula()
//
// ═════════════════════════════════════════════════════════════════════════════════

console.log('✅ Script de criação de admin carregado!');
console.log('Execute: criarAdminAnaPaula() para criar o usuário');
console.log('Execute: testarLoginAnaPaula() para testar o login');
