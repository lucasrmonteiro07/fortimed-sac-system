# 🚀 DICAS AVANÇADAS E PERSONALIZAÇÕES

## 🎨 PERSONALIZAR AS CORES DO SISTEMA

### Passo 1: Abrir o arquivo `styles.css`

### Passo 2: Alterar as variáveis CSS no início do arquivo

```css
:root {
    --primary-color: #2563eb;      /* Cor principal (azul) */
    --primary-hover: #1d4ed8;      /* Cor ao passar mouse */
    --secondary-color: #64748b;    /* Cor secundária (cinza) */
    --success-color: #10b981;      /* Cor de sucesso (verde) */
    --danger-color: #ef4444;       /* Cor de perigo (vermelho) */
    --warning-color: #f59e0b;      /* Cor de aviso (amarelo) */
}
```

### Exemplos de Cores Personalizadas:

**Tema Verde/Saúde:**
```css
--primary-color: #059669;
--primary-hover: #047857;
```

**Tema Laranja/Energia:**
```css
--primary-color: #ea580c;
--primary-hover: #c2410c;
```

**Tema Roxo/Moderno:**
```css
--primary-color: #7c3aed;
--primary-hover: #6d28d9;
```

---

## 📝 ADICIONAR NOVOS CAMPOS

### Exemplo: Adicionar campo "Prioridade"

#### 1. Atualizar o banco de dados (Supabase SQL Editor):
```sql
ALTER TABLE occurrences 
ADD COLUMN prioridade VARCHAR(50);
```

#### 2. Adicionar no formulário (index.html):
```html
<div class="form-group">
    <label for="prioridade">Prioridade:</label>
    <select id="prioridade">
        <option value="BAIXA">Baixa</option>
        <option value="MÉDIA">Média</option>
        <option value="ALTA">Alta</option>
        <option value="URGENTE">Urgente</option>
    </select>
</div>
```

#### 3. Incluir no JavaScript (app.js) na função saveOccurrence:
```javascript
const formData = {
    // ... outros campos
    prioridade: document.getElementById('prioridade').value,
};
```

#### 4. Mostrar na tabela (app.js) na função displayOccurrences:
```javascript
<td>${escapeHtml(occ.prioridade)}</td>
```

---

## 📊 ADICIONAR EXPORTAÇÃO PARA EXCEL

### Adicionar biblioteca (no index.html):
```html
<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
```

### Adicionar botão (index.html):
```html
<button onclick="exportToExcel()" class="btn-secondary">📥 Exportar Excel</button>
```

### Adicionar função (app.js):
```javascript
function exportToExcel() {
    const data = currentOccurrences.map(occ => ({
        'Nº Pedido': occ.num_pedido,
        'Cliente': occ.nome_cliente,
        'Transportadora': occ.transportadora,
        'Status': occ.status,
        'Data': formatDate(occ.created_at)
    }));

    const ws = XLSX.utils.json_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Ocorrências");
    XLSX.writeFile(wb, "ocorrencias_fortimed.xlsx");
}
```

---

## 📧 ADICIONAR NOTIFICAÇÕES POR EMAIL

### 1. Configurar Email no Supabase:
- Vá em Authentication > Email Templates
- Configure SMTP ou use o padrão do Supabase

### 2. Criar função no Supabase (Database > Functions):
```sql
CREATE OR REPLACE FUNCTION notify_new_occurrence()
RETURNS TRIGGER AS $$
BEGIN
    -- Aqui você pode adicionar lógica para enviar email
    -- Usando Supabase Edge Functions ou integrações
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_occurrence_created
AFTER INSERT ON occurrences
FOR EACH ROW
EXECUTE FUNCTION notify_new_occurrence();
```

---

## 📱 ADICIONAR NOTIFICAÇÕES PUSH

### Usando OneSignal (gratuito):

#### 1. Criar conta em https://onesignal.com

#### 2. Adicionar SDK no index.html:
```html
<script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" defer></script>
<script>
  window.OneSignal = window.OneSignal || [];
  OneSignal.push(function() {
    OneSignal.init({
      appId: "SEU_APP_ID_AQUI",
    });
  });
</script>
```

#### 3. Enviar notificação quando criar ocorrência (app.js):
```javascript
OneSignal.push(function() {
    OneSignal.sendSelfNotification(
        "Nova Ocorrência",
        `Pedido ${formData.num_pedido} cadastrado`
    );
});
```

---

## 📈 ADICIONAR DASHBOARD COM GRÁFICOS

### Adicionar Chart.js (index.html):
```html
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
```

### Criar aba de Dashboard (index.html):
```html
<div id="tab-dashboard" class="tab-content">
    <canvas id="statusChart"></canvas>
</div>
```

### Criar gráfico (app.js):
```javascript
function createDashboard() {
    const ctx = document.getElementById('statusChart').getContext('2d');
    
    // Contar ocorrências por status
    const statusCount = {
        'ABERTO': 0,
        'EM ANDAMENTO': 0,
        'RESOLVIDO': 0,
        'FECHADO': 0
    };
    
    currentOccurrences.forEach(occ => {
        statusCount[occ.status]++;
    });
    
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(statusCount),
            datasets: [{
                label: 'Ocorrências por Status',
                data: Object.values(statusCount),
                backgroundColor: [
                    '#3b82f6',
                    '#f59e0b',
                    '#10b981',
                    '#6b7280'
                ]
            }]
        }
    });
}
```

---

## 🔔 ADICIONAR CONTADOR DE NOTIFICAÇÕES

### No header (index.html):
```html
<div class="notifications">
    <button onclick="showNotifications()">
        🔔 <span class="badge" id="notifCount">0</span>
    </button>
</div>
```

### Estilo (styles.css):
```css
.notifications {
    position: relative;
}

.badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: var(--danger-color);
    color: white;
    border-radius: 50%;
    padding: 2px 6px;
    font-size: 10px;
}
```

### Lógica (app.js):
```javascript
function updateNotificationCount() {
    const openCount = currentOccurrences.filter(
        occ => occ.status === 'ABERTO'
    ).length;
    
    document.getElementById('notifCount').textContent = openCount;
}
```

---

## 🖨️ ADICIONAR IMPRESSÃO DE RELATÓRIOS

### Adicionar botão (index.html):
```html
<button onclick="printReport()" class="btn-secondary">🖨️ Imprimir</button>
```

### Adicionar estilo de impressão (styles.css):
```css
@media print {
    .tabs, .filters, .btn-primary, .btn-secondary {
        display: none !important;
    }
    
    table {
        font-size: 12px;
    }
}
```

### Função de impressão (app.js):
```javascript
function printReport() {
    window.print();
}
```

---

## 🔍 ADICIONAR BUSCA AVANÇADA

### Adicionar mais filtros (index.html):
```html
<input type="date" id="filterDateFrom" placeholder="Data início">
<input type="date" id="filterDateTo" placeholder="Data fim">
<select id="filterTransportadora">
    <option value="">Todas Transportadoras</option>
    <!-- Preencher dinamicamente -->
</select>
```

### Atualizar função de filtro (app.js):
```javascript
function filterOccurrences() {
    const searchTerm = document.getElementById('searchOrder').value.toLowerCase();
    const statusFilter = document.getElementById('filterStatus').value;
    const dateFrom = document.getElementById('filterDateFrom').value;
    const dateTo = document.getElementById('filterDateTo').value;
    const transportFilter = document.getElementById('filterTransportadora').value;

    const filtered = currentOccurrences.filter(occ => {
        const matchesSearch = occ.num_pedido.toLowerCase().includes(searchTerm);
        const matchesStatus = !statusFilter || occ.status === statusFilter;
        const matchesTransport = !transportFilter || occ.transportadora === transportFilter;
        
        // Filtro de data
        let matchesDate = true;
        if (dateFrom || dateTo) {
            const occDate = new Date(occ.created_at);
            if (dateFrom && occDate < new Date(dateFrom)) matchesDate = false;
            if (dateTo && occDate > new Date(dateTo)) matchesDate = false;
        }

        return matchesSearch && matchesStatus && matchesTransport && matchesDate;
    });

    displayOccurrences(filtered);
}
```

---

## 🌙 ADICIONAR MODO ESCURO

### Toggle no header (index.html):
```html
<button onclick="toggleDarkMode()" class="btn-secondary">🌓</button>
```

### Estilos do modo escuro (styles.css):
```css
body.dark-mode {
    --background: #1e293b;
    --surface: #334155;
    --text-primary: #f1f5f9;
    --text-secondary: #cbd5e1;
    --border-color: #475569;
}
```

### Função (app.js):
```javascript
function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
    
    // Salvar preferência
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('darkMode', isDark);
}

// Carregar preferência ao iniciar
document.addEventListener('DOMContentLoaded', () => {
    if (localStorage.getItem('darkMode') === 'true') {
        document.body.classList.add('dark-mode');
    }
});
```

---

## 📱 ADICIONAR APP MOBILE (PWA)

### Criar manifest.json:
```json
{
  "name": "Fortimed SAC",
  "short_name": "Fortimed",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2563eb",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### Adicionar no index.html:
```html
<link rel="manifest" href="manifest.json">
<meta name="theme-color" content="#2563eb">
```

---

## 🔐 ADICIONAR NÍVEIS DE PERMISSÃO

### Atualizar tabela users (Supabase):
```sql
ALTER TABLE users 
ADD COLUMN role VARCHAR(50) DEFAULT 'user';

-- Criar roles: 'admin', 'manager', 'user'
```

### Verificar permissão (auth.js):
```javascript
function checkPermission(requiredRole) {
    const user = authManager.getCurrentUser();
    const roles = {
        'admin': 3,
        'manager': 2,
        'user': 1
    };
    
    return roles[user.role] >= roles[requiredRole];
}
```

### Usar na aplicação:
```javascript
if (checkPermission('admin')) {
    // Mostrar botão de exclusão
    document.querySelector('.btn-danger').style.display = 'block';
}
```

---

## 🚀 DICAS DE PERFORMANCE

### 1. Adicionar paginação:
```javascript
const ITEMS_PER_PAGE = 50;
let currentPage = 1;

function displayOccurrences(occurrences) {
    const start = (currentPage - 1) * ITEMS_PER_PAGE;
    const end = start + ITEMS_PER_PAGE;
    const pageItems = occurrences.slice(start, end);
    
    // Renderizar apenas pageItems
}
```

### 2. Cache de dados:
```javascript
const CACHE_TIME = 5 * 60 * 1000; // 5 minutos
let lastFetch = 0;
let cachedData = [];

async function loadOccurrences() {
    const now = Date.now();
    if (now - lastFetch < CACHE_TIME && cachedData.length > 0) {
        displayOccurrences(cachedData);
        return;
    }
    
    // Buscar do servidor
    // ...
}
```

---

## 📝 ADICIONAR HISTÓRICO DE ALTERAÇÕES

### Criar tabela (Supabase):
```sql
CREATE TABLE occurrence_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    occurrence_id UUID REFERENCES occurrences(id),
    field_changed VARCHAR(100),
    old_value TEXT,
    new_value TEXT,
    changed_by UUID REFERENCES users(id),
    changed_at TIMESTAMP DEFAULT NOW()
);
```

### Registrar mudanças:
```javascript
async function logChange(occurrenceId, field, oldValue, newValue) {
    const client = config.getClient();
    await client.from('occurrence_history').insert({
        occurrence_id: occurrenceId,
        field_changed: field,
        old_value: oldValue,
        new_value: newValue,
        changed_by: authManager.getCurrentUser().id
    });
}
```

---

**Essas são apenas algumas das muitas personalizações possíveis!**

💡 **Dica:** Faça uma cópia de backup antes de fazer alterações significativas.

🔧 **Lembre-se:** Teste todas as mudanças em ambiente local antes de fazer deploy.
