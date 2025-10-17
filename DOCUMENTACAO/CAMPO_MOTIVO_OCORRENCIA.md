╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║           ✅ REMOVER DELETE + ADICIONAR TRANSPORTADORA                    ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝


🎯 ALTERAÇÕES
════════════════════════════════════════════════════════════════════════════

1. ❌ Remover botão "Deletar" do formulário
2. ✅ Adicionar campo SELECT "Transportadora"


═════════════════════════════════════════════════════════════════════════════════

📊 ETAPAS
════════════════════════════════════════════════════════════════════════════════

✅ ETAPA 1: Adicionar coluna no banco de dados (1 minuto)

No Supabase SQL Editor:

ALTER TABLE occurrences ADD COLUMN transportadora TEXT;


✅ ETAPA 2: Editar index.html (5 minutos)

1. Abra: c:\...\fortimed-sac-system\index.html
2. Procure pelo botão de DELETAR
3. Comente/remova o botão
4. Adicione o campo SELECT de transportadora (veja abaixo)


✅ ETAPA 3: Editar app.js (5 minutos)

1. Abra: c:\...\fortimed-sac-system\app.js
2. Procure função saveOccurrence()
3. Adicione: transportadora: document.getElementById('transportadora').value,
4. Procure função loadOccurrence()
5. Adicione: document.getElementById('transportadora').value = ...


✅ ETAPA 4: Teste (2 minutos)

1. Recarregue página (Ctrl+Shift+R)
2. Criar ocorrência
3. Deve ver campo "Transportadora" com dropdown
4. Salve e teste edição


═════════════════════════════════════════════════════════════════════════════════

📋 CÓDIGO PARA ADICIONAR NO HTML
════════════════════════════════════════════════════════════════════════════════

<div class="form-group">
    <label for="transportadora">Transportadora:</label>
    <select id="transportadora" name="transportadora" required>
        <option value="">-- Selecione uma transportadora --</option>
        <option value="São Miguel">São Miguel</option>
        <option value="Leomar">Leomar</option>
        <option value="LKW">LKW</option>
        <option value="Fritz">Fritz</option>
        <option value="Vapt Vupt">Vapt Vupt</option>
        <option value="Multi">Multi</option>
        <option value="Minuano">Minuano</option>
        <option value="Garcias">Garcias</option>
        <option value="Fortimed">Fortimed</option>
        <option value="Outros">Outros</option>
    </select>
</div>


═════════════════════════════════════════════════════════════════════════════════

📋 CÓDIGO PARA ADICIONAR NO app.js (função saveOccurrence)
═════════════════════════════════════════════════════════════════════════════════

// Na função que salva, adicione:
transportadora: document.getElementById('transportadora').value,

Exemplo:
const data = {
    data: document.getElementById('data').value,
    status: document.getElementById('status').value,
    motivo: document.getElementById('motivo').value,
    transportadora: document.getElementById('transportadora').value,  ← AQUI
    descricao: document.getElementById('descricao').value,
    ...
};


═════════════════════════════════════════════════════════════════════════════════

⏱️ TEMPO TOTAL: ~15 minutos

═════════════════════════════════════════════════════════════════════════════════

Referência completa: GUIA_RAPIDO_MOTIVO.md

═════════════════════════════════════════════════════════════════════════════════
