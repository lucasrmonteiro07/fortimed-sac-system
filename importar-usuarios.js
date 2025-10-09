// ============================================================================
// FORTIMED - IMPORTADOR DE USUÁRIOS
// Script para importar usuários automaticamente no Supabase
// ============================================================================
// 
// INSTRUÇÕES:
// 1. Abra o console do navegador (F12)
// 2. Cole este script no console
// 3. Execute: importarUsuarios()
// 
// ============================================================================

// Configurações do Supabase
const SUPABASE_URL = 'https://iowfcilmbeynrfszqlhu.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlvd2ZjaWxtYmV5bnJmc3pxbGh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NTQ0MzgsImV4cCI6MjA3NTUzMDQzOH0.jhLS67YUFaJUf45Xc732I_oOopaNqpnHnFShJaRdPks';

// Lista de usuários para criar
const usuarios = [
    {
        email: 'administrativo@fortimeddistribuidora.com.br',
        password: 'Compras@01',
        role: 'admin',
        name: 'Administrador'
    },
    {
        email: 'vendas01@fortimeddistribuidora.com.br',
        password: 'vendas01',
        role: 'user',
        name: 'Vendas 01'
    },
    {
        email: 'vendas02@fortimeddistribuidora.com.br',
        password: 'vendas02',
        role: 'user',
        name: 'Vendas 02'
    },
    {
        email: 'vendas03@fortimeddistribuidora.com.br',
        password: 'vendas03',
        role: 'user',
        name: 'Vendas 03'
    },
    {
        email: 'vendas04@fortimeddistribuidora.com.br',
        password: 'vendas04',
        role: 'user',
        name: 'Vendas 04'
    },
    {
        email: 'vendas05@fortimeddistribuidora.com.br',
        password: 'vendas05',
        role: 'user',
        name: 'Vendas 05'
    },
    {
        email: 'vendas06@fortimeddistribuidora.com.br',
        password: 'vendas06',
        role: 'user',
        name: 'Vendas 06'
    }
];

// Função para importar usuários
async function importarUsuarios() {
    console.log('🚀 Iniciando importação de usuários...');
    
    // Criar cliente Supabase
    const { createClient } = supabase;
    const client = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    
    let sucessos = 0;
    let erros = 0;
    
    for (const usuario of usuarios) {
        try {
            console.log(`📝 Criando usuário: ${usuario.email}`);
            
            // Criar usuário no Supabase Auth (sem verificação de email)
            const { data, error } = await client.auth.signUp({
                email: usuario.email,
                password: usuario.password,
                options: {
                    emailRedirectTo: undefined, // Desabilitar redirecionamento de email
                    data: {
                        name: usuario.name,
                        role: usuario.role
                    }
                }
            });
            
            if (error) {
                console.error(`❌ Erro ao criar ${usuario.email}:`, error.message);
                erros++;
            } else {
                console.log(`✅ Usuário criado com sucesso: ${usuario.email}`);
                
                // Aguardar um pouco para evitar rate limiting
                await new Promise(resolve => setTimeout(resolve, 1000));
                
                sucessos++;
            }
        } catch (error) {
            console.error(`❌ Erro inesperado ao criar ${usuario.email}:`, error);
            erros++;
        }
    }
    
    console.log(`\n📊 Resumo da importação:`);
    console.log(`✅ Sucessos: ${sucessos}`);
    console.log(`❌ Erros: ${erros}`);
    console.log(`📝 Total: ${usuarios.length}`);
    
    if (erros === 0) {
        console.log('🎉 Todos os usuários foram criados com sucesso!');
    } else {
        console.log('⚠️ Alguns usuários não puderam ser criados. Verifique os erros acima.');
    }
}

// Função para testar login dos usuários
async function testarLogins() {
    console.log('🔐 Testando logins dos usuários...');
    
    const { createClient } = supabase;
    const client = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    
    for (const usuario of usuarios) {
        try {
            console.log(`🔑 Testando login: ${usuario.email}`);
            
            const { data, error } = await client.auth.signInWithPassword({
                email: usuario.email,
                password: usuario.password
            });
            
            if (error) {
                console.error(`❌ Erro no login ${usuario.email}:`, error.message);
            } else {
                console.log(`✅ Login bem-sucedido: ${usuario.email}`);
                
                // Fazer logout
                await client.auth.signOut();
            }
        } catch (error) {
            console.error(`❌ Erro inesperado no login ${usuario.email}:`, error);
        }
    }
    
    console.log('🏁 Teste de logins concluído!');
}

// Executar importação automaticamente
console.log('📋 Script de importação de usuários carregado!');
console.log('💡 Execute: importarUsuarios() para criar os usuários');
console.log('💡 Execute: testarLogins() para testar os logins');
