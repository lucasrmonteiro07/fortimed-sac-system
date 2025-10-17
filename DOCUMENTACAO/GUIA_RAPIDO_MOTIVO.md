✅ GUIA PRÁTICO - ADICIONAR TRANSPORTADORA E REMOVER DELETE
═════════════════════════════════════════════════════════════════════════════════

🎯 2 ALTERAÇÕES PRINCIPAIS
──────────────────────────
1. ❌ Remover botão de DELETAR ocorrências
2. ✅ Adicionar SELECT de TRANSPORTADORA


═════════════════════════════════════════════════════════════════════════════════

## PASSO 1: ADICIONAR COLUNA NO BANCO DE DADOS
═════════════════════════════════════════════════════════════════════════════════

No Supabase SQL Editor, execute:

ALTER TABLE occurrences ADD COLUMN transportadora TEXT;
CREATE INDEX idx_occurrences_transportadora ON occurrences(transportadora);

Status esperado: "success" para ambos


═════════════════════════════════════════════════════════════════════════════════

## PASSO 2: EDITAR O ARQUIVO index.html
═════════════════════════════════════════════════════════════════════════════════

Abra: c:\Users\monteiro\Documents\GitHub\fortimed-sac-system\index.html

BUSQUE POR:
───────────
Um <form> ou formulário que contém campos como:
  • data
  • status
  • motivo
  • descrição


PROCURE E REMOVA/COMENTE o botão de DELETAR:

Procure por algo como:
  <button ... onclick="deleteOccurrence()">
    Deletar
  </button>

OU

  <button class="btn-delete">
    ❌ Deletar
  </button>

E COMENTE assim:
  <!--
  <button ... onclick="deleteOccurrence()">
    Deletar
  </button>
  -->


ADICIONE o campo TRANSPORTADORA:

No lugar que achar apropriado (perto de "motivo"), adicione:

────────────────────────────────────────────────────────────────

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

────────────────────────────────────────────────────────────────

Salve o arquivo.


═════════════════════════════════════════════════════════════════════════════════

## PASSO 3: EDITAR O ARQUIVO app.js
═════════════════════════════════════════════════════════════════════════════════

Abra: c:\Users\monteiro\Documents\GitHub\fortimed-sac-system\app.js

PROCURE POR:
─────────────
A função que salva ocorrências. Algo como:

  function saveOccurrence()
  ou
  async function submitOccurrence()
  ou
  function handleSaveOccurrence()


DENTRO dessa função, procure por algo como:

  const data = {
    data: document.getElementById('data').value,
    status: document.getElementById('status').value,
    motivo: document.getElementById('motivo').value,
    ...
  };


ADICIONE:

  transportadora: document.getElementById('transportadora').value,

Exemplo completo:

  const data = {
    data: document.getElementById('data').value,
    status: document.getElementById('status').value,
    motivo: document.getElementById('motivo').value,
    transportadora: document.getElementById('transportadora').value,  ← ADICIONE ISTO
    descricao: document.getElementById('descricao').value,
    ...
  };


TAMBÉM PROCURE POR:
────────────────────
Função que CARREGA ocorrência para editar. Algo como:

  function loadOccurrence(id)
  ou
  function editOccurrence(id)


ADICIONE NELA:

  document.getElementById('transportadora').value = ocurrence.transportadora || '';


Isto garante que ao editar, o campo preencha com o valor anterior.


═════════════════════════════════════════════════════════════════════════════════

## PASSO 4: TESTE
═════════════════════════════════════════════════════════════════════════════════

1. Recarregue a página (Ctrl+Shift+R para hard refresh)
2. Clique em criar nova ocorrência
3. Deve aparecer campo "Transportadora" com opções
4. Selecione uma opção (ex: "São Miguel")
5. Salve a ocorrência
6. Teste editar - deve manter a transportadora selecionada
7. ✅ Pronto!


═════════════════════════════════════════════════════════════════════════════════

❓ PRECISA DE AJUDA?
────────────────────

Veja: DOCUMENTACAO/GUIA_MODIFICACOES_INTERFACE.md

═════════════════════════════════════════════════════════════════════════════════
