✅ MODIFICAÇÕES NA INTERFACE - INSTRUÇÕES COMPLETAS
═════════════════════════════════════════════════════════════════════════════════

📋 ALTERAÇÕES A FAZER:
──────────────────────
1. ❌ Remover botão/opção de DELETAR ocorrências
2. ✅ Adicionar campo SELECT de TRANSPORTADORA

═════════════════════════════════════════════════════════════════════════════════

## MODIFICAÇÃO 1: REMOVER OPÇÃO DE DELETAR
═════════════════════════════════════════════════════════════════════════════════

Arquivo a editar: index.html

PROCURE POR (no formulário de ocorrências):
───────────────────────────────────────────

  <button ... onclick="deleteOccurrence()" ... >
    Deletar
  </button>

OU

  <button ... class="delete" ... >
    ❌ Deletar
  </button>

OU procure por qualquer função relacionada a DELETE.


SOLUÇÃO:
─────────
Encontre o botão de DELETAR e:
  • COMENTE (<!-- ... -->) 
  • OU REMOVA completamente
  • OU simplesmente esconda (display: none)


EXEMPLO (se comentar):
────────────────────

<!-- Botão de deletar removido -->
<!-- 
<button onclick="deleteOccurrence()">
  Deletar
</button>
-->


═════════════════════════════════════════════════════════════════════════════════

## MODIFICAÇÃO 2: ADICIONAR CAMPO TRANSPORTADORA
═════════════════════════════════════════════════════════════════════════════════

Local: Formulário de ocorrências (onde cria/edita)

PROCURE POR:
─────────────
Um <form> ou <div> que contém os campos do formulário.
Procure por: <input>, <select>, etc.


ADICIONE ESTE CÓDIGO:
─────────────────────

<!-- Campo de Transportadora -->
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


LOCAL IDEAL:
─────────────
Coloque ANTES ou DEPOIS do campo de "motivo" ou "descrição".

Exemplo de ordem sugerida:
  1. Data
  2. Usuário
  3. Status
  4. Motivo
  5. **Transportadora** ← AQUI
  6. Descrição
  7. Botões (Salvar, Cancelar)


═════════════════════════════════════════════════════════════════════════════════

## MODIFICAÇÃO 3: SALVAR NO BANCO DE DADOS
═════════════════════════════════════════════════════════════════════════════════

Você também precisa:

1. Adicionar coluna "transportadora" na tabela "occurrences" do Supabase:

   ALTER TABLE occurrences 
   ADD COLUMN transportadora TEXT;

2. Atualizar o código JavaScript que SALVA a ocorrência:

   Procure por: saveOccurrence() ou submitForm()

   Adicione:
   ────────
   transportadora: document.getElementById('transportadora').value,


3. Atualizar o código que CARREGA a ocorrência:

   Quando edita, precisa preencher o select:
   document.getElementById('transportadora').value = ocurrence.transportadora;


═════════════════════════════════════════════════════════════════════════════════

## CSS (OPCIONAL - para estilo)
═════════════════════════════════════════════════════════════════════════════════

Adicione ao styles.css:

.form-group select {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
    font-family: Arial, sans-serif;
}

.form-group select:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}


═════════════════════════════════════════════════════════════════════════════════

RESUMO DAS ALTERAÇÕES:
──────────────────────

[✓] 1. Encontre e remova/comente o botão de DELETAR
[✓] 2. Adicione o campo SELECT de TRANSPORTADORA no HTML
[✓] 3. Execute SQL para adicionar coluna no Supabase
[✓] 4. Atualize JavaScript para salvar/carregar transportadora
[✓] 5. Teste criando/editando uma ocorrência

═════════════════════════════════════════════════════════════════════════════════
