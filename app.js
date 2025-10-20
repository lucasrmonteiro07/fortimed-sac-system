// Aplicação Principal - Gerenciamento de Ocorrências

let currentOccurrences = [];
let selectedOccurrence = null;
let currentPage = 1;
let pageSize = 25;
let filteredOccurrences = [];
let pendingDeleteId = null;

// ========== TOAST NOTIFICATIONS ==========
function showToast(message, type = 'info', duration = 3000) {
    const container = document.getElementById('toastContainer');
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    const icons = {
        success: '✓',
        error: '✕',
        info: 'ℹ',
        warning: '⚠'
    };
    
    toast.innerHTML = `
        <span class="toast-icon">${icons[type] || icons.info}</span>
        <span class="toast-message">${message}</span>
        <button class="toast-close" onclick="this.parentElement.remove()">✕</button>
    `;
    
    container.appendChild(toast);
    
    setTimeout(() => {
        toast.classList.add('hide');
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

// ========== LOADING SPINNER ==========
function showLoadingSpinner(text = 'Salvando ocorrência...') {
    const spinner = document.getElementById('loadingSpinner');
    document.getElementById('loadingText').textContent = text;
    spinner.classList.add('show');
}

function hideLoadingSpinner() {
    const spinner = document.getElementById('loadingSpinner');
    spinner.classList.remove('show');
}

// ========== CONFIRMAÇÃO DE EXCLUSÃO ==========
function showDeleteConfirmation(occurrenceId) {
    pendingDeleteId = occurrenceId;
    const modal = document.getElementById('confirmModal');
    const overlay = document.getElementById('confirmModalOverlay');
    modal.classList.add('show');
    overlay.classList.add('show');
}

function cancelDelete() {
    pendingDeleteId = null;
    const modal = document.getElementById('confirmModal');
    const overlay = document.getElementById('confirmModalOverlay');
    modal.classList.remove('show');
    overlay.classList.remove('show');
}

async function confirmDelete() {
    if (!pendingDeleteId) return;
    
    showLoadingSpinner('Deletando ocorrência...');
    try {
        const currentUser = authManager.getCurrentUser();
        const isAdmin = currentUser && currentUser.role === 'admin';
        
        // SEGURANÇA: Apenas admin pode deletar
        if (!isAdmin) {
            hideLoadingSpinner();
            showToast('❌ Apenas administradores podem deletar ocorrências!', 'error');
            cancelDelete();
            return;
        }
        
        const client = config.getClient();
        const { error } = await client
            .from('occurrences')
            .delete()
            .eq('id', pendingDeleteId);
        
        if (error) throw error;
        
        hideLoadingSpinner();
        showToast('✓ Ocorrência deletada com sucesso!', 'success');
        cancelDelete();
        loadOccurrences();
    } catch (error) {
        hideLoadingSpinner();
        showToast('✕ Erro ao deletar ocorrência: ' + error.message, 'error');
    }
}

// ========== BUSCA EM TEMPO REAL ==========
function searchOccurrences() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    
    if (!searchTerm) {
        filteredOccurrences = [...currentOccurrences];
    } else {
        filteredOccurrences = currentOccurrences.filter(occ => {
            const num = String(occ.num_pedido).toLowerCase();
            const cliente = (occ.nome_cliente || '').toLowerCase();
            const transportadora = (occ.transportadora || '').toLowerCase();
            
            return num.includes(searchTerm) || 
                   cliente.includes(searchTerm) || 
                   transportadora.includes(searchTerm);
        });
    }
    
    currentPage = 1;
    paginateOccurrences();
}

// ========== PAGINAÇÃO ==========
function paginateOccurrences() {
    if (filteredOccurrences.length === 0) {
        displayOccurrences([]);
        document.getElementById('paginationContainer').style.display = 'none';
        return;
    }
    
    const totalPages = Math.ceil(filteredOccurrences.length / pageSize);
    const start = (currentPage - 1) * pageSize;
    const end = start + pageSize;
    const paginatedData = filteredOccurrences.slice(start, end);
    
    displayOccurrences(paginatedData);
    
    // Atualizar controles de paginação
    if (totalPages > 1) {
        document.getElementById('paginationContainer').style.display = 'flex';
        document.getElementById('currentPage').textContent = currentPage;
        document.getElementById('totalPages').textContent = totalPages;
        document.getElementById('prevBtn').disabled = currentPage === 1;
        document.getElementById('nextBtn').disabled = currentPage === totalPages;
    } else {
        document.getElementById('paginationContainer').style.display = 'none';
    }
}

function previousPage() {
    if (currentPage > 1) {
        currentPage--;
        paginateOccurrences();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

function nextPage() {
    const totalPages = Math.ceil(filteredOccurrences.length / pageSize);
    if (currentPage < totalPages) {
        currentPage++;
        paginateOccurrences();
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
}

function changePageSize() {
    pageSize = parseInt(document.getElementById('pageSize').value);
    currentPage = 1;
    paginateOccurrences();
}

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
    } else if (tabName === 'novo') {
        // Limpar formulário automaticamente ao clicar em "Nova Ocorrência"
        clearOccurrenceForm();
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

        // TODOS veem TODAS as ocorrências (RLS desabilitado)
        const filteredData = data || [];
        currentOccurrences = filteredData;
        filteredOccurrences = [...filteredData];
        currentPage = 1;
        document.getElementById('searchInput').value = '';
        paginateOccurrences();
        

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
        
        // Botão de delete: APENAS para admin
        const deleteButton = isAdmin ? 
            `<button onclick="event.stopPropagation(); showDeleteConfirmation('${occ.id}')" class="btn-danger btn-sm" title="Deletar">🗑️</button>` : '';
        
        return `
            <tr onclick="showOccurrenceDetails('${occ.id}')">
                <td><strong>${escapeHtml(occ.num_pedido)}</strong></td>
                <td>${escapeHtml(occ.nome_cliente)}</td>
                <td>${escapeHtml(occ.transportadora)}</td>
                <td><span class="status-badge status-${normalizeStatus(occ.status)}">${formatStatus(occ.status)}</span></td>
                <td>${formatDate(occ.created_at)}</td>
                ${createdByInfo}
                <td>
                    <button onclick="event.stopPropagation(); editOccurrenceById('${occ.id}')" class="btn-primary btn-sm" title="Editar">✏️</button>
                    ${deleteButton}
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
        solicitante: document.getElementById('solicitante').value.trim() || null,
        ocorrencia: document.getElementById('ocorrencia').value.trim(),
        motivo: document.getElementById('motivo').value.trim() || null,
        status: document.getElementById('status').value,
        situacao: document.getElementById('situacao').value.trim() || null,
        responsavel_falha: (document.getElementById('responsavelFalha')?.value || '').trim() || null,
        responsavel_resolucao: (document.getElementById('responsavelResolucao')?.value || '').trim() || null
    };

    showLoadingSpinner('Salvando ocorrência...');

    try {
        const client = config.getClient();

        // Garantir que há sessão autenticada do Supabase
        const { data: { session } } = await client.auth.getSession();
        if (!session) {
            hideLoadingSpinner();
            showToast('Você precisa estar logado para salvar', 'error');
            return;
        }

        // Verificar se está editando usando o campo hidden
        const occurrenceIdField = document.getElementById('occurrenceId');
        const occurrenceId = occurrenceIdField ? occurrenceIdField.value : '';

        if (occurrenceId) {
            // Atualizar ocorrência existente
            // TODOS podem editar (RLS desabilitado)
            const { error } = await client
                .from('occurrences')
                .update({
                    ...baseData,
                    updated_at: new Date().toISOString()
                })
                .eq('id', occurrenceId);

            if (error) throw error;

            hideLoadingSpinner();
            showToast('✓ Ocorrência atualizada com sucesso!', 'success');
        } else {
            // Criar nova ocorrência
            const { error } = await client
                .from('occurrences')
                .insert([{ ...baseData, created_by: session.user.id }]);

            if (error) throw error;

            hideLoadingSpinner();
            showToast('✓ Ocorrência criada com sucesso!', 'success');
        }

        // Limpar formulário e variáveis APÓS salvar
        document.getElementById('occurrenceForm').reset();
        if (occurrenceIdField) occurrenceIdField.value = ''; // Limpar campo hidden
        const formTitleElement = document.getElementById('formTitle');
        if (formTitleElement) formTitleElement.textContent = '➕ Nova Ocorrência';
        selectedOccurrence = null;

        // Voltar para a lista clicando na aba correspondente
        const listTabBtn = document.querySelector('.tabs .tab[data-tab="lista"]');
        if (listTabBtn) listTabBtn.click();

    } catch (error) {
        hideLoadingSpinner();
        console.error('Erro ao salvar ocorrência:', error);
        showToast('✕ Erro ao salvar: ' + error.message, 'error');
    }
}

// Limpar formulário de ocorrência automaticamente
function clearOccurrenceForm() {
    // Resetar todos os campos do formulário
    document.getElementById('occurrenceForm').reset();
    
    // Limpar campos hidden
    document.getElementById('occurrenceId').value = '';
    document.getElementById('responsavelFalha').value = '';
    document.getElementById('responsavelResolucao').value = '';
    
    // Resetar variável de ocorrência selecionada
    selectedOccurrence = null;
    
    // Atualizar título do formulário
    const formTitleElement = document.getElementById('formTitle');
    if (formTitleElement) {
        formTitleElement.textContent = '➕ Nova Ocorrência';
    }
    
    // Preencher solicitante automaticamente com o usuário logado
    const currentUser = authManager.getCurrentUser();
    if (currentUser && currentUser.email) {
        document.getElementById('solicitante').value = currentUser.email;
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
        ${occurrence.solicitante ? `
        <div class="detail-item">
            <div class="detail-label">Solicitante</div>
            <div class="detail-value">${escapeHtml(occurrence.solicitante)}</div>
        </div>
        ` : ''}
        <div class="detail-item">
            <div class="detail-label">Ocorrência</div>
            <div class="detail-value">${escapeHtml(occurrence.ocorrencia)}</div>
        </div>
        ${occurrence.motivo ? `
        <div class="detail-item">
            <div class="detail-label">Motivo</div>
            <div class="detail-value">${escapeHtml(occurrence.motivo)}</div>
        </div>
        ` : ''}
        <div class="detail-item">
            <div class="detail-label">Status</div>
            <div class="detail-value"><span class="status-badge status-${normalizeStatus(occurrence.status)}">${formatStatus(occurrence.status)}</span></div>
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

    // Verificar se a ocorrência pertence ao usuário logado ou se é admin
    const currentUser = authManager.getCurrentUser();
    const isAdmin = currentUser && currentUser.role === 'admin';
    
    if (!isAdmin && selectedOccurrence.created_by !== currentUser.id) {
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
    document.getElementById('solicitante').value = selectedOccurrence.solicitante || '';
    document.getElementById('ocorrencia').value = selectedOccurrence.ocorrencia;
    document.getElementById('motivo').value = selectedOccurrence.motivo || '';
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

// Excluir ocorrência - DESABILITADO (não permitido deletar ocorrências)
// async function deleteOccurrence() {
//     if (!selectedOccurrence) return;

//     // Verificar permissão: admin pode deletar qualquer uma, user só sua própria
//     const currentUser = authManager.getCurrentUser();
//     const isAdmin = currentUser && currentUser.role === 'admin';
//     
//     if (!isAdmin && selectedOccurrence.created_by !== currentUser.id) {
//         showToast('Você só pode excluir suas próprias ocorrências', 'error');
//         return;
//     }

//     // Mostrar modal de confirmação
//     showDeleteConfirmation(selectedOccurrence.id);
// }

// Excluir ocorrência por ID - DESABILITADO (não permitido deletar ocorrências)
// async function deleteOccurrenceById(id) {
//     const occurrence = currentOccurrences.find(occ => occ.id === id);
//     if (!occurrence) return;

//     // Verificar permissão: admin pode deletar qualquer uma, user só sua própria
//     const currentUser = authManager.getCurrentUser();
//     const isAdmin = currentUser && currentUser.role === 'admin';
//     
//     if (!isAdmin && occurrence.created_by !== currentUser.id) {
//         showToast('Você só pode excluir suas próprias ocorrências', 'error');
//         return;
//     }

//     // Mostrar modal de confirmação
//     showDeleteConfirmation(id);
// }

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

// Formatar status com emoji e label legível
function formatStatus(status) {
    const statusMap = {
        'aberto': '🔴 Aberto',
        'em_andamento': '🟡 Em Andamento',
        'aguardando_transportadora': '🟣 Aguardando Transportadora',
        'fechado': '🟢 Fechado'
    };
    return statusMap[status] || status;
}

// Carregar ocorrências ao iniciar
document.addEventListener('DOMContentLoaded', () => {
    // Verificar se está logado antes de carregar ocorrências
    if (authManager.isAuthenticated()) {
        loadOccurrences();
        // Preencher solicitante automaticamente
        const currentUser = authManager.getCurrentUser();
        if (currentUser) {
            const solicitanteInput = document.getElementById('solicitante');
            if (solicitanteInput) {
                solicitanteInput.value = currentUser.name || currentUser.email || 'Usuário';
            }
        }
    } else {
        // Se não estiver logado, mostrar mensagem
        const tbody = document.getElementById('occurrencesBody');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="6" class="loading">🔐 Faça login para ver as ocorrências</td></tr>';
        }
    }
});
