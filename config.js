// Configuração do Supabase
class Config {
    constructor() {
        this.STORAGE_KEY = 'fortimed_supabase_config';
        this.loadFromStorage();
    }

    loadFromStorage() {
        const saved = localStorage.getItem(this.STORAGE_KEY);
        if (saved) {
            const config = JSON.parse(saved);
            this.supabaseUrl = config.url;
            this.supabaseKey = config.key;
        }
    }

    save(url, key) {
        this.supabaseUrl = url;
        this.supabaseKey = key;
        localStorage.setItem(this.STORAGE_KEY, JSON.stringify({
            url: url,
            key: key
        }));
    }

    isConfigured() {
        return !!(this.supabaseUrl && this.supabaseKey);
    }

    getClient() {
        if (!this.isConfigured()) {
            throw new Error('Supabase não configurado. Por favor, configure na aba Configurações.');
        }
        return supabase.createClient(this.supabaseUrl, this.supabaseKey);
    }
}

// Instância global de configuração
const config = new Config();

// Funções auxiliares para configuração
async function saveConfig(event) {
    event.preventDefault();
    
    const url = document.getElementById('supabaseUrl').value.trim();
    const key = document.getElementById('supabaseKey').value.trim();

    if (!url || !key) {
        showTestResult('Por favor, preencha todos os campos.', 'error');
        return;
    }

    config.save(url, key);
    showTestResult('✅ Configurações salvas com sucesso!', 'success');
}

function loadConfig() {
    if (config.isConfigured()) {
        document.getElementById('supabaseUrl').value = config.supabaseUrl;
        document.getElementById('supabaseKey').value = config.supabaseKey;
        showTestResult('✅ Configurações carregadas!', 'success');
    } else {
        showTestResult('❌ Nenhuma configuração salva encontrada.', 'error');
    }
}

async function testConnection() {
    try {
        const url = document.getElementById('supabaseUrl').value.trim();
        const key = document.getElementById('supabaseKey').value.trim();

        if (!url || !key) {
            showTestResult('❌ Por favor, preencha todos os campos antes de testar.', 'error');
            return;
        }

        showTestResult('🔄 Testando conexão...', 'info');

        // Criar cliente temporário para teste
        const testClient = supabase.createClient(url, key);

        // Testar conexão fazendo uma query simples (head=true não retorna linhas)
        const { error } = await testClient
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
    resultDiv.textContent = message;
    resultDiv.className = `test-result ${type}`;
}

function copySQL() {
    const sqlCode = document.querySelector('.database-info pre code').textContent;
    navigator.clipboard.writeText(sqlCode).then(() => {
        alert('✅ SQL copiado para a área de transferência!');
    }).catch(err => {
        console.error('Erro ao copiar:', err);
        alert('❌ Erro ao copiar. Por favor, copie manualmente.');
    });
}
