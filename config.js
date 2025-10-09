// Configuração do Supabase - Configurações Fixas
class Config {
    constructor() {
        // Configurações fixas do Supabase
        this.supabaseUrl = 'https://iowfcilmbeynrfszqlhu.supabase.co';
        this.supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlvd2ZjaWxtYmV5bnJmc3pxbGh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NTQ0MzgsImV4cCI6MjA3NTUzMDQzOH0.jhLS67YUFaJUf45Xc732I_oOopaNqpnHnFShJaRdPks';
        this._client = null; // Cache da instância do cliente
    }

    isConfigured() {
        return true; // Sempre configurado com as credenciais fixas
    }

    getClient() {
        // Usar singleton para evitar múltiplas instâncias
        if (!this._client) {
            this._client = supabase.createClient(this.supabaseUrl, this.supabaseKey);
        }
        return this._client;
    }
}

// Instância global de configuração
const config = new Config();

// Funções auxiliares para configuração (mantidas para compatibilidade)
async function saveConfig(event) {
    event.preventDefault();
    // Configuração fixa - não precisa salvar
    alert('✅ Sistema já configurado com credenciais fixas!');
}

function loadConfig() {
    // Configuração fixa - sempre carregada
    if (document.getElementById('supabaseUrl')) {
        document.getElementById('supabaseUrl').value = config.supabaseUrl;
    }
    if (document.getElementById('supabaseKey')) {
        document.getElementById('supabaseKey').value = config.supabaseKey;
    }
}

async function testConnection() {
    try {
        showTestResult('🔄 Testando conexão...', 'info');

        // Testar conexão com as credenciais fixas
        const { error } = await config.getClient()
            .from('occurrences')
            .select('*', { count: 'exact', head: true });

        // Se a tabela não existir ainda, considerar OK pois a conectividade foi validada
        if (error && error.code !== 'PGRST116' && error.code !== '42P01') {
            // PGRST116: relation not found (PostgREST), 42P01: undefined table (Postgres)
            throw error;
        }

        showTestResult('✅ Conexão estabelecida com sucesso! Banco de dados está acessível.', 'success');
        
    } catch (error) {
        console.error('Erro ao testar conexão:', error);
        let errorMsg = '❌ Erro ao conectar: ';
        
        if (error.message.includes('Failed to fetch')) {
            errorMsg += 'URL inválida ou serviço indisponível.';
        } else if (error.message.includes('Invalid API key')) {
            errorMsg += 'Chave de API inválida.';
        } else {
            errorMsg += error.message;
        }
        
        showTestResult(errorMsg, 'error');
    }
}

function showTestResult(message, type) {
    const resultDiv = document.getElementById('testResult');
    if (resultDiv) {
        resultDiv.textContent = message;
        resultDiv.className = `test-result ${type}`;
    }
}

function copySQL() {
    const sqlCode = document.querySelector('.database-info pre code');
    if (sqlCode) {
        navigator.clipboard.writeText(sqlCode.textContent).then(() => {
            alert('✅ SQL copiado para a área de transferência!');
        }).catch(err => {
            console.error('Erro ao copiar:', err);
            alert('❌ Erro ao copiar. Por favor, copie manualmente.');
        });
    }
}
