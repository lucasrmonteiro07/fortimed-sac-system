// Script para executar SQL no Supabase
// Adiciona coluna transportadora à tabela occurrences

const { createClient } = require('@supabase/supabase-js');

// Configurações do Supabase
const SUPABASE_URL = 'https://iowfcilmbeynrfszqlhu.supabase.co';
const SUPABASE_SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlvd2ZjaWxtYmV5bnJmc3pxbGh1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTk1NDQzOCwiZXhwIjoyMDc1NTMwNDM4fQ.Nh5CUZIoJvRlG-nWKO5UBxOKN5K9L7K9vZ4h3Z9z4A8';

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

async function addTransportadoraColumn() {
    try {
        console.log('🔄 Executando alteração no banco de dados...\n');

        // SQL para adicionar a coluna
        const sql = `
            ALTER TABLE occurrences 
            ADD COLUMN IF NOT EXISTS transportadora TEXT;
            
            CREATE INDEX IF NOT EXISTS idx_occurrences_transportadora 
            ON occurrences(transportadora);
        `;

        // Executar SQL via RPC ou diretamente
        const { data, error } = await supabase.rpc('execute_sql', { sql });

        if (error) {
            console.error('❌ Erro ao executar SQL:', error.message);
            return false;
        }

        console.log('✅ Coluna transportadora adicionada com sucesso!');
        console.log('✅ Índice criado para melhor performance!\n');
        
        console.log('📊 Resultado:');
        console.log('   • Coluna: transportadora (TEXT)');
        console.log('   • Tipo: Texto (até 255 caracteres)');
        console.log('   • Permitido: NULL');
        console.log('   • Índice: idx_occurrences_transportadora\n');

        return true;
    } catch (error) {
        console.error('❌ Erro geral:', error);
        return false;
    }
}

// Executar
addTransportadoraColumn();
