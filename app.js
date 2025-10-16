// Aplicação Principal - Gerenciamento de Ocorrências

let currentOccurrences = [];
let selectedOccurrence = null;

// Navegação entre Tabs (pode receber o botão ou o nome da aba)
function showTab(tabOrName, maybeName) {
    const tabName = typeof tabOrName === 'string' ? tabOrName : maybeName;
    const clickedEl = typeof tabOrName === 'string' ? null : tabOrName;

    // Remover classe active de todas as tabs e conteúdos
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

    // Ativar a aba clicada ou localizar pelo nome
    if (clickedEl) {
        clickedEl.classList.add('active');
    } else {
        const btn = document.querySelector(`.tabs .tab[data-tab="${tabName}"]`);
        if (btn) btn.classList.add('active');
    }
    const contentEl = document.getElementById(`tab-${tabName}`);
    if (contentEl) contentEl.classList.add('active');

    // Carregar dados se necessário
    if (tabName === 'lista') {
        loadOccurrences();
    } else if (tabName === 'config') {
        loadConfig();
    }
}

// Carregar ocorrências do banco de dados
async function loadOccurrences() {
    const tbody = document.getElementById('occurrencesBody');
    tbody.innerHTML = '<tr><td colspan="6" class="loading">🔄 Carregando ocorrências...</td></tr>';

    try {
        const client = config.getClient();
        
        // Verificar se há sessão ativa
        const { data: { session } } = await client.auth.getSession();
        if (!session) {
            throw new Error('Você precisa estar logado para ver as ocorrências.');
        }
        
        // Verificar se é admin
        const currentUser = authManager.getCurrentUser();
        const isAdmin = currentUser && currentUser.role === 'admin';
        
        // Consulta única - RLS permite tudo, filtramos no código
        const { data, error } = await client
            .from('occurrences')
            .select(`
                *,
                users!created_by(name)
            `)
            .order('created_at', { ascending: false });

        if (error) throw error;

        // Filtrar dados baseado no role do usuário
        let filteredData = data || [];
        
        if (!isAdmin) {
            // Usuário normal vê apenas suas próprias ocorrências
            filteredData = data.filter(occ => occ.created_by === session.user.id);
        }
        
        currentOccurrences = filteredData;
        displayOccurrences(currentOccurrences);
        

    } catch (error) {
        console.error('Erro ao carregar ocorrências:', error);
        tbody.innerHTML = `<tr><td colspan="6" class="loading">❌ Erro: ${error.message}</td></tr>`;
    }
}

// Exibir ocorrências na tabela
function displayOccurrences(occurrences) {
    const tbody = document.getElementById('occurrencesBody');
    const currentUser = authManager.getCurrentUser();
    const isAdmin = currentUser && currentUser.role === 'admin';

    if (occurrences.length === 0) {
        const colspan = isAdmin ? '7' : '6';
        tbody.innerHTML = `<tr><td colspan="${colspan}" class="loading">📭 Nenhuma ocorrência encontrada.</td></tr>`;
        return;
    }

    // Buscar informações dos usuários se for admin
    if (isAdmin) {
        // Adicionar coluna de criado por para admin
        const thead = document.querySelector('thead tr');
        if (thead && !thead.querySelector('.criado-por-header')) {
            thead.innerHTML = `
                <th>Nº Pedido</th>
                <th>Cliente</th>
                <th>Transportadora</th>
                <th>Status</th>
                <th>Data</th>
                <th class="criado-por-header">Criado por</th>
                <th>Ações</th>
            `;
        }
    }

    tbody.innerHTML = occurrences.map(occ => {
        const createdByInfo = isAdmin ? 
            `<td class="criado-por">${escapeHtml(occ.users?.name || 'Usuário')}</td>` : '';
        
        return `
            <tr onclick="showOccurrenceDetails('${occ.id}')">
                <td><strong>${escapeHtml(occ.num_pedido)}</strong></td>
                <td>${escapeHtml(occ.nome_cliente)}</td>
                <td>${escapeHtml(occ.transportadora)}</td>
                <td><span class="status-badge status-${normalizeStatus(occ.status)}">${escapeHtml(occ.status)}</span></td>
                <td>${formatDate(occ.created_at)}</td>
                ${createdByInfo}
                <td>
                    <button onclick="event.stopPropagation(); editOccurrenceById('${occ.id}')" class="btn-primary btn-sm">✏️</button>
                    <button onclick="event.stopPropagation(); deleteOccurrenceById('${occ.id}')" class="btn-danger btn-sm">🗑️</button>
                </td>
            </tr>
        `;
    }).join('');
}

// Filtrar ocorrências
function filterOccurrences() {
    const searchTerm = document.getElementById('searchOrder').value.toLowerCase();
    const statusFilter = document.getElementById('filterStatus').value;

    const filtered = currentOccurrences.filter(occ => {
        const matchesSearch = occ.num_pedido.toLowerCase().includes(searchTerm) ||
                            occ.nome_cliente.toLowerCase().includes(searchTerm) ||
                            occ.transportadora.toLowerCase().includes(searchTerm);
        
        const matchesStatus = !statusFilter || occ.status === statusFilter;

        return matchesSearch && matchesStatus;
    });

    displayOccurrences(filtered);
}

// Salvar nova ocorrência
async function saveOccurrence(event) {
    event.preventDefault();

    const baseData = {
        num_pedido: document.getElementById('numPedido').value.trim(),
        nota_fiscal: document.getElementById('notaFiscal').value.trim() || null,
        transportadora: document.getElementById('transportadora').value.trim(),
        nome_cliente: document.getElementById('nomeCliente').value.trim(),
        ocorrencia: document.getElementById('ocorrencia').value.trim(),
        status: document.getElementById('status').value,
        situacao: document.getElementById('situacao').value.trim() || null,
        responsavel_falha: (document.getElementById('responsavelFalha')?.value || '').trim() || null,
        responsavel_resolucao: (document.getElementById('responsavelResolucao')?.value || '').trim() || null
    };

    try {
        const client = config.getClient();

        // Garantir que há sessão autenticada do Supabase
        const { data: { session } } = await client.auth.getSession();
        if (!session) {
            alert('❌ Você precisa estar logado para salvar. Faça login e tente novamente.');
            return;
        }

        // Verificar se está editando usando o campo hidden
        const occurrenceIdField = document.getElementById('occurrenceId');
        const occurrenceId = occurrenceIdField ? occurrenceIdField.value : '';

        if (occurrenceId) {
            // Atualizar ocorrência existente
            const { error } = await client
                .from('occurrences')
                .update({
                    ...baseData,
                    updated_at: new Date().toISOString()
                })
                .eq('id', occurrenceId)
                .eq('created_by', session.user.id);

            if (error) throw error;

            alert('✅ Ocorrência atualizada com sucesso!');
        } else {
            // Criar nova ocorrência
            const { error } = await client
                .from('occurrences')
                .insert([{ ...baseData, created_by: session.user.id }]);

            if (error) throw error;

            alert('✅ Ocorrência criada com sucesso!');
        }

        // Limpar formulário e variáveis APÓS salvar
        document.getElementById('occurrenceForm').reset();
        if (occurrenceIdField) occurrenceIdField.value = ''; // Limpar campo hidden
        document.getElementById('formTitle').textContent = '➕ Nova Ocorrência';
        selectedOccurrence = null;

    // Voltar para a lista clicando na aba correspondente
    const listTabBtn = document.querySelector('.tabs .tab[data-tab="lista"]');
    if (listTabBtn) listTabBtn.click();

    } catch (error) {
        console.error('Erro ao salvar ocorrência:', error);
        alert('❌ Erro ao salvar: ' + error.message);
    }
}

// Mostrar detalhes da ocorrência em modal
function showOccurrenceDetails(id) {
    const occurrence = currentOccurrences.find(occ => occ.id === id);
    if (!occurrence) return;

    selectedOccurrence = occurrence;

    const modalBody = document.getElementById('modalBody');
    modalBody.innerHTML = `
        <div class="detail-item">
            <div class="detail-label">Nº Pedido</div>
            <div class="detail-value"><strong>${escapeHtml(occurrence.num_pedido)}</strong></div>
        </div>
        ${occurrence.nota_fiscal ? `
        <div class="detail-item">
            <div class="detail-label">Nota Fiscal</div>
            <div class="detail-value">${escapeHtml(occurrence.nota_fiscal)}</div>
        </div>
        ` : ''}
        <div class="detail-item">
            <div class="detail-label">Transportadora</div>
            <div class="detail-value">${escapeHtml(occurrence.transportadora)}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Cliente</div>
            <div class="detail-value">${escapeHtml(occurrence.nome_cliente)}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Ocorrência</div>
            <div class="detail-value">${escapeHtml(occurrence.ocorrencia)}</div>
        </div>
        <div class="detail-item">
            <div class="detail-label">Status</div>
            <div class="detail-value"><span class="status-badge status-${normalizeStatus(occurrence.status)}">${escapeHtml(occurrence.status)}</span></div>
        </div>
        ${occurrence.situacao ? `
        <div class="detail-item">
            <div class="detail-label">Situação</div>
            <div class="detail-value">${escapeHtml(occurrence.situacao)}</div>
        </div>
        ` : ''}
        ${occurrence.responsavel_falha ? `
        <div class="detail-item">
            <div class="detail-label">Responsável pela Falha</div>
            <div class="detail-value">${escapeHtml(occurrence.responsavel_falha)}</div>
        </div>
        ` : ''}
        ${occurrence.responsavel_resolucao ? `
        <div class="detail-item">
            <div class="detail-label">Responsável pela Resolução</div>
            <div class="detail-value">${escapeHtml(occurrence.responsavel_resolucao)}</div>
        </div>
        ` : ''}
        <div class="detail-item">
            <div class="detail-label">Data de Criação</div>
            <div class="detail-value">${formatDate(occurrence.created_at)}</div>
        </div>
        ${occurrence.updated_at && occurrence.updated_at !== occurrence.created_at ? `
        <div class="detail-item">
            <div class="detail-label">Última Atualização</div>
            <div class="detail-value">${formatDate(occurrence.updated_at)}</div>
        </div>
        ` : ''}
    `;

    document.getElementById('detailsModal').style.display = 'block';
}

// Editar ocorrência
function editOccurrence() {
    if (!selectedOccurrence) return;

    // Verificar se a ocorrência pertence ao usuário logado
    const currentUser = authManager.getCurrentUser();
    if (selectedOccurrence.created_by !== currentUser.id) {
        alert('❌ Você só pode editar suas próprias ocorrências.');
        return;
    }

    // Preencher formulário
    const occurrenceIdField = document.getElementById('occurrenceId');
    if (occurrenceIdField) occurrenceIdField.value = selectedOccurrence.id;
    
    document.getElementById('numPedido').value = selectedOccurrence.num_pedido;
    document.getElementById('notaFiscal').value = selectedOccurrence.nota_fiscal || '';
    document.getElementById('transportadora').value = selectedOccurrence.transportadora;
    document.getElementById('nomeCliente').value = selectedOccurrence.nome_cliente;
    document.getElementById('ocorrencia').value = selectedOccurrence.ocorrencia;
    document.getElementById('status').value = selectedOccurrence.status;
    document.getElementById('situacao').value = selectedOccurrence.situacao || '';
    
    const falhaField = document.getElementById('responsavelFalha');
    if (falhaField) falhaField.value = selectedOccurrence.responsavel_falha || '';
    
    const resolucaoField = document.getElementById('responsavelResolucao');
    if (resolucaoField) resolucaoField.value = selectedOccurrence.responsavel_resolucao || '';

    // Atualizar título do formulário para mostrar que está editando
    const formTitleElement = document.getElementById('formTitle');
    if (formTitleElement) formTitleElement.textContent = '✏️ Editar Ocorrência';

    // Fechar modal e ir para a tab de novo
    closeModal();
    document.querySelectorAll('.tab')[1].click(); // Tab "Nova Ocorrência"
}

function editOccurrenceById(id) {
    const occurrence = currentOccurrences.find(occ => occ.id === id);
    
    if (occurrence) {
        selectedOccurrence = occurrence;
        editOccurrence();
    } else {
        alert('❌ Ocorrência não encontrada.');
    }
}

// Excluir ocorrência
async function deleteOccurrence() {
    if (!selectedOccurrence) return;

    // Verificar se a ocorrência pertence ao usuário logado
    const currentUser = authManager.getCurrentUser();
    if (selectedOccurrence.created_by !== currentUser.id) {
        alert('❌ Você só pode excluir suas próprias ocorrências.');
        return;
    }

    if (!confirm('Tem certeza que deseja excluir esta ocorrência?')) {
        return;
    }

    try {
        const client = config.getClient();
        const { data: { session } } = await client.auth.getSession();
        if (!session) {
            alert('❌ Você precisa estar logado para excluir. Faça login e tente novamente.');
            return;
        }
        const { error } = await client
            .from('occurrences')
            .delete()
            .eq('id', selectedOccurrence.id)
            .eq('created_by', session.user.id); // Garantir que só exclui suas próprias ocorrências

        if (error) throw error;

        alert('✅ Ocorrência excluída com sucesso!');
        closeModal();
        loadOccurrences();

    } catch (error) {
        console.error('Erro ao excluir ocorrência:', error);
        alert('❌ Erro ao excluir: ' + error.message);
    }
}

async function deleteOccurrenceById(id) {
    const occurrence = currentOccurrences.find(occ => occ.id === id);
    if (!occurrence) return;

    // Verificar se a ocorrência pertence ao usuário logado
    const currentUser = authManager.getCurrentUser();
    if (occurrence.created_by !== currentUser.id) {
        alert('❌ Você só pode excluir suas próprias ocorrências.');
        return;
    }

    if (!confirm(`Tem certeza que deseja excluir a ocorrência ${occurrence.num_pedido}?`)) {
        return;
    }

    try {
        const client = config.getClient();
        const { data: { session } } = await client.auth.getSession();
        if (!session) {
            alert('❌ Você precisa estar logado para excluir. Faça login e tente novamente.');
            return;
        }
        const { error } = await client
            .from('occurrences')
            .delete()
            .eq('id', id)
            .eq('created_by', session.user.id); // Garantir que só exclui suas próprias ocorrências

        if (error) throw error;

        alert('✅ Ocorrência excluída com sucesso!');
        loadOccurrences();

    } catch (error) {
        console.error('Erro ao excluir ocorrência:', error);
        alert('❌ Erro ao excluir: ' + error.message);
    }
}

// Fechar modal
function closeModal() {
    document.getElementById('detailsModal').style.display = 'none';
    selectedOccurrence = null;
}

// Fechar modal ao clicar fora
window.onclick = function(event) {
    const modal = document.getElementById('detailsModal');
    if (event.target === modal) {
        closeModal();
    }
}

// Funções auxiliares
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function formatDate(dateString) {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('pt-BR') + ' ' + date.toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
}

function normalizeStatus(status) {
    if (!status) return '';
    return status.toLowerCase().replace(/\s+/g, '-');
}

// Carregar ocorrências ao iniciar
document.addEventListener('DOMContentLoaded', () => {
    // Verificar se está logado antes de carregar ocorrências
    if (authManager.isAuthenticated()) {
        loadOccurrences();
    } else {
        // Se não estiver logado, mostrar mensagem
        const tbody = document.getElementById('occurrencesBody');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="6" class="loading">🔐 Faça login para ver as ocorrências</td></tr>';
        }
    }
});
