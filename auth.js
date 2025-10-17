// Sistema de Autenticação

class AuthManager {
    constructor() {
        this.SESSION_KEY = 'fortimed_session';
        this.checkAuth();
    }

    checkAuth() {
        const currentPage = window.location.pathname.split('/').pop() || 'index.html';
        const isLoginPage = currentPage.includes('login.html') || currentPage === '';
        const isConfigPage = currentPage.includes('config.html');
        
        // Se estiver na página de login
        if (isLoginPage) {
            // Se já estiver logado, redirecionar para index
            if (this.isAuthenticated()) {
                window.location.href = '/index.html';
            }
            return;
        }

        // Se não estiver na página de login e não estiver autenticado
        if (!this.isAuthenticated()) {
            // Redirecionar para login
            window.location.href = '/login.html';
        } else {
            // Validar acesso à página de configuração (apenas admin)
            if (isConfigPage) {
                const currentUser = this.getCurrentUser();
                if (!currentUser || currentUser.role !== 'admin') {
                    alert('❌ Acesso negado! Apenas administradores podem acessar essa página.');
                    window.location.href = '/index.html';
                    return;
                }
            }
            this.displayUserInfo();
        }
    }

    isAuthenticated() {
        const session = this.getSession();
        return !!(session && session.user);
    }

    getSession() {
        const sessionData = localStorage.getItem(this.SESSION_KEY);
        if (sessionData) {
            try {
                return JSON.parse(sessionData);
            } catch (e) {
                return null;
            }
        }
        return null;
    }

    saveSession(user) {
        const session = {
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role || 'user'
            },
            timestamp: Date.now()
        };
        localStorage.setItem(this.SESSION_KEY, JSON.stringify(session));
    }

    clearSession() {
        localStorage.removeItem(this.SESSION_KEY);
    }

    displayUserInfo() {
        const session = this.getSession();
        if (session && session.user) {
            const userNameElement = document.getElementById('userName');
            if (userNameElement) {
                const roleIcon = session.user.role === 'admin' ? '👑' : '👤';
                const roleText = session.user.role === 'admin' ? ' (Admin)' : '';
                userNameElement.textContent = `${roleIcon} ${session.user.name}${roleText}`;
            }
        }
    }

    getCurrentUser() {
        const session = this.getSession();
        return session ? session.user : null;
    }
}

// Instância global do gerenciador de autenticação
const authManager = new AuthManager();

// Funções de Login
async function handleLogin(event) {
    event.preventDefault();
    
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const messageDiv = document.getElementById('loginMessage');

    messageDiv.className = 'message info';
    messageDiv.textContent = '🔄 Fazendo login...';

    try {
        const client = config.getClient();

        // Autenticar com Supabase
        const { data, error } = await client.auth.signInWithPassword({
            email: email,
            password: password
        });

        if (error) throw error;

        // Buscar dados adicionais do usuário
        let { data: userData, error: userError } = await client
            .from('users')
            .select('*')
            .eq('email', email)
            .single();

        if (userError && userError.code !== 'PGRST116') {
            console.error('Erro ao buscar dados do usuário:', userError);
        }

        // Se não existir registro na tabela users, cria (upsert)
        if (!userData) {
            const defaultName = (data.user.user_metadata && data.user.user_metadata.full_name) || (email.split('@')[0]);
            const defaultRole = email === 'administrativo@fortimeddistribuidora.com.br' ? 'admin' : 'user';
            const { error: upsertError } = await client
                .from('users')
                .upsert([
                    {
                        id: data.user.id,
                        email: email,
                        name: defaultName,
                        role: defaultRole,
                        password_hash: '' // Permitir NULL/vazio - senha gerenciada por Supabase Auth
                    }
                ], { onConflict: 'id' });
            if (upsertError) {
                console.error('Erro ao criar registro na tabela users:', upsertError);
                // Mesmo com erro, continuar - o usuário está autenticado em auth.users
            } else {
                userData = { id: data.user.id, email, name: defaultName, role: defaultRole };
            }
        }

        // Salvar sessão
        authManager.saveSession({
            id: data.user.id,
            email: data.user.email,
            name: userData ? userData.name : email.split('@')[0],
            role: userData ? userData.role : 'user'
        });

        messageDiv.className = 'message success';
        messageDiv.textContent = '✅ Login realizado com sucesso!';

        setTimeout(() => {
            window.location.href = '/index.html';
        }, 1000);

    } catch (error) {
        console.error('Erro no login:', error);
        messageDiv.className = 'message error';
        
        if (error.message.includes('Invalid login credentials')) {
            messageDiv.textContent = '❌ Email ou senha incorretos.';
        } else {
            messageDiv.textContent = '❌ Erro ao fazer login: ' + error.message;
        }
    }
}

// Funções de Registro
async function handleRegister(event) {
    event.preventDefault();
    
    const name = document.getElementById('regName').value.trim();
    const email = document.getElementById('regEmail').value.trim();
    const password = document.getElementById('regPassword').value;
    const passwordConfirm = document.getElementById('regPasswordConfirm').value;
    const messageDiv = document.getElementById('registerMessage');

    // Validação de senha
    if (password !== passwordConfirm) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ As senhas não coincidem.';
        return;
    }

    if (password.length < 6) {
        messageDiv.className = 'message error';
        messageDiv.textContent = '❌ A senha deve ter no mínimo 6 caracteres.';
        return;
    }

    messageDiv.className = 'message info';
    messageDiv.textContent = '🔄 Criando conta...';

    try {
        const client = config.getClient();

        // Criar usuário no Supabase Auth
        const { data, error } = await client.auth.signUp({
            email: email,
            password: password
        });

        if (error) throw error;

        // Inserir dados adicionais na tabela users
        const defaultRole = email === 'administrativo@fortimeddistribuidora.com.br' ? 'admin' : 'user';
        const { error: insertError } = await client
            .from('users')
            .insert([
                {
                    id: data.user.id,
                    email: email,
                    name: name,
                    role: defaultRole
                }
            ]);

        if (insertError && insertError.code !== '23505') { // 23505 = duplicate key
            console.error('Erro ao inserir dados do usuário:', insertError);
        }

        messageDiv.className = 'message success';
        messageDiv.textContent = '✅ Conta criada com sucesso! Redirecionando...';

        // Fazer login automático
        authManager.saveSession({
            id: data.user.id,
            email: email,
            name: name,
            role: defaultRole
        });

        setTimeout(() => {
            window.location.href = '/index.html';
        }, 1500);

    } catch (error) {
        console.error('Erro no registro:', error);
        messageDiv.className = 'message error';
        
        if (error.message.includes('already registered')) {
            messageDiv.textContent = '❌ Este email já está cadastrado.';
        } else if (error.message.includes('não configurado')) {
            messageDiv.textContent = '❌ ' + error.message;
        } else {
            messageDiv.textContent = '❌ Erro ao criar conta: ' + error.message;
        }
    }
}

// Alternar entre formulários de Login e Registro
function showRegister() {
    document.getElementById('loginForm').parentElement.style.display = 'none';
    document.getElementById('registerBox').style.display = 'block';
}

function showLogin() {
    document.getElementById('registerBox').style.display = 'none';
    document.getElementById('loginForm').parentElement.style.display = 'block';
}

// Função de Logout
function logout() {
    if (confirm('Deseja realmente sair?')) {
        authManager.clearSession();
        window.location.href = '/login.html';
    }
}
