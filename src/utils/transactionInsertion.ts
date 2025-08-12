import { supabase } from '@/integrations/supabase/client';
import { getTableNameForInsertion, shouldUseMonthlyTable } from './monthlyTableUtils';

export interface TransactionData {
  user_id: string;
  description?: string;
  amount: number;
  transaction_type: 'income' | 'expense' | 'transfer';
  category?: string;
  transaction_date: string;
  account_name: string;
  client_name?: string | null;
}

export interface InsertResult {
  success: boolean;
  error?: string;
  tableName: string;
  data?: any;
}

/**
 * Insere uma transação na tabela correta baseada na data
 */
export async function insertTransactionInCorrectTable(
  transactionData: TransactionData
): Promise<InsertResult> {
  try {
    // Determinar tabela baseada na data
    const tableName = getTableNameForInsertion(transactionData.transaction_date);
    const useMonthlyTable = shouldUseMonthlyTable(transactionData.transaction_date);
    
    console.log(`=== INSERÇÃO INTELIGENTE ===`);
    console.log(`Data: ${transactionData.transaction_date}`);
    console.log(`Tabela escolhida: ${tableName}`);
    console.log(`Usando tabela mensal: ${useMonthlyTable}`);
    
    console.log(`Dados para inserção:`, transactionData);
    
    // Inserir na tabela determinada
    const { data, error } = await supabase
      .from(tableName)
      .insert([transactionData])
      .select();
    
    if (error) {
      console.error(`Erro ao inserir na tabela ${tableName}:`, error);
      return {
        success: false,
        error: error.message,
        tableName: tableName
      };
    }
    
    console.log(`✅ Transação inserida com sucesso na tabela ${tableName}`);
    
    return {
      success: true,
      tableName: tableName,
      data: data
    };
    
  } catch (error: any) {
    console.error('Erro na inserção inteligente:', error);
    return {
      success: false,
      error: error.message,
      tableName: 'unknown'
    };
  }
}

/**
 * Atualiza uma transação (pode envolver mudança de tabela se a data mudou)
 */
export async function updateTransactionInCorrectTable(
  transactionId: string,
  originalData: TransactionData,
  updatedData: TransactionData
): Promise<InsertResult> {
  try {
    const originalTable = getTableNameForInsertion(originalData.transaction_date);
    const newTable = getTableNameForInsertion(updatedData.transaction_date);
    
    console.log(`=== ATUALIZAÇÃO INTELIGENTE ===`);
    console.log(`ID da transação: ${transactionId}`);
    console.log(`Data original: ${originalData.transaction_date} (tabela: ${originalTable})`);
    console.log(`Nova data: ${updatedData.transaction_date} (tabela: ${newTable})`);
    
    // Se a tabela não mudou, fazer update simples
    if (originalTable === newTable) {
      console.log(`🔄 Atualizando na mesma tabela: ${originalTable}`);
      
      const { data, error } = await supabase
        .from(originalTable)
        .update(updatedData)
        .eq('id', transactionId)
        .select();
      
      if (error) {
        console.error(`❌ Erro no update: ${error.message}`);
        return {
          success: false,
          error: error.message,
          tableName: originalTable
        };
      }
      
      console.log(`✅ Transação atualizada na mesma tabela ${originalTable}`);
      return {
        success: true,
        tableName: originalTable,
        data: data
      };
    }
    
    // Se a tabela mudou, usar abordagem mais simples
    console.log(`⚠️ Mudança de tabela detectada: ${originalTable} → ${newTable}`);
    console.log(`🔄 Usando abordagem de recriação...`);
    
    // 1. Buscar dados completos da transação original
    const { data: originalTransaction, error: fetchError } = await supabase
      .from(originalTable)
      .select('*')
      .eq('id', transactionId)
      .single();
    
    if (fetchError) {
      console.error(`❌ Erro ao buscar transação original: ${fetchError.message}`);
      return {
        success: false,
        error: `Erro ao buscar transação original: ${fetchError.message}`,
        tableName: originalTable
      };
    }
    
    console.log(`📋 Transação original encontrada:`, originalTransaction);
    
    // 2. Preparar dados para inserção na nova tabela
    const newTransactionData = {
      user_id: originalTransaction.user_id,
      description: updatedData.description || originalTransaction.description,
      amount: updatedData.amount,
      transaction_type: updatedData.transaction_type,
      category: updatedData.category || originalTransaction.category,
      transaction_date: updatedData.transaction_date,
      account_name: updatedData.account_name,
      client_name: updatedData.client_name || originalTransaction.client_name,
      created_at: originalTransaction.created_at, // Manter data de criação original
      updated_at: new Date().toISOString()
    };
    
    console.log(`📤 Dados para nova tabela:`, newTransactionData);
    
    // 3. Inserir na nova tabela
    const { data: newTransaction, error: insertError } = await supabase
      .from(newTable)
      .insert([newTransactionData])
      .select()
      .single();
    
    if (insertError) {
      console.error(`❌ Erro ao inserir na nova tabela: ${insertError.message}`);
      return {
        success: false,
        error: `Erro ao inserir na nova tabela: ${insertError.message}`,
        tableName: newTable
      };
    }
    
    console.log(`✅ Transação inserida na nova tabela:`, newTransaction);
    
    // 4. Remover da tabela original
    const { error: deleteError } = await supabase
      .from(originalTable)
      .delete()
      .eq('id', transactionId);
    
    if (deleteError) {
      console.error(`❌ Erro ao remover da tabela original: ${deleteError.message}`);
      // A transação foi inserida na nova tabela, mas não removida da original
      // Vamos remover a nova transação para evitar duplicação
      await supabase
        .from(newTable)
        .delete()
        .eq('id', newTransaction.id);
      
      return {
        success: false,
        error: `Erro ao remover da tabela original: ${deleteError.message}`,
        tableName: originalTable
      };
    }
    
    console.log(`✅ Transação removida da tabela original`);
    console.log(`✅ Transação movida com sucesso: ${originalTable} → ${newTable}`);
    
    return {
      success: true,
      tableName: newTable,
      data: [newTransaction]
    };
    
  } catch (error: any) {
    console.error('❌ Erro na atualização inteligente:', error);
    return {
      success: false,
      error: error.message,
      tableName: 'unknown'
    };
  }
}

/**
 * Remove uma transação da tabela correta baseada na data
 */
export async function deleteTransactionFromCorrectTable(
  transactionId: string,
  transactionDate: string
): Promise<InsertResult> {
  try {
    const tableName = getTableNameForInsertion(transactionDate);
    
    console.log(`=== REMOÇÃO INTELIGENTE ===`);
    console.log(`Data: ${transactionDate}`);
    console.log(`Tabela: ${tableName}`);
    console.log(`ID: ${transactionId}`);
    
    // Primeiro, tentar delete direto
    const { error } = await supabase
      .from(tableName)
      .delete()
      .eq('id', transactionId);
    
    if (error) {
      console.log(`❌ Erro no delete direto: ${error.message}`);
      console.log(`🔄 Tentando função RPC como fallback...`);
      
      // Se falhar, tentar função RPC
      const { data: rpcResult, error: rpcError } = await supabase.rpc(
        'delete_transaction_safe',
        {
          p_transaction_id: transactionId,
          p_user_id: (await supabase.auth.getUser()).data.user?.id,
          p_transaction_date: transactionDate
        }
      );
      
      if (rpcError) {
        console.error(`❌ Erro na função RPC: ${rpcError.message}`);
        return {
          success: false,
          error: rpcError.message,
          tableName: tableName
        };
      }
      
      console.log(`✅ Delete via RPC:`, rpcResult);
      
      if (rpcResult && rpcResult.success) {
        return {
          success: true,
          tableName: rpcResult.table_name || tableName,
          data: rpcResult
        };
      } else {
        return {
          success: false,
          error: 'Transação não encontrada ou não pode ser deletada',
          tableName: tableName
        };
      }
    }
    
    console.log(`✅ Transação removida da tabela ${tableName}`);
    return {
      success: true,
      tableName: tableName
    };
    
  } catch (error: any) {
    console.error('Erro na remoção inteligente:', error);
    return {
      success: false,
      error: error.message,
      tableName: 'unknown'
    };
  }
}

/**
 * Insere uma transação na tabela correta baseada no mês selecionado
 */
export async function insertTransactionInSelectedMonthTable(
  transactionData: TransactionData,
  selectedMonth: number
): Promise<InsertResult> {
  try {
    // Determinar tabela baseada no mês selecionado
    const year = 2025; // Por enquanto fixo em 2025
    const tableName = `transactions_${year}_${String(selectedMonth).padStart(2, '0')}`;
    
    console.log(`=== INSERÇÃO POR MÊS SELECIONADO ===`);
    console.log(`Mês selecionado: ${selectedMonth}`);
    console.log(`Tabela escolhida: ${tableName}`);
    console.log(`Data da transação: ${transactionData.transaction_date}`);
    
    console.log(`Dados para inserção:`, transactionData);
    
    // Inserir na tabela determinada
    const { data, error } = await supabase
      .from(tableName)
      .insert([transactionData])
      .select();
    
    if (error) {
      console.error(`Erro ao inserir na tabela ${tableName}:`, error);
      return {
        success: false,
        error: error.message,
        tableName: tableName
      };
    }
    
    console.log(`✅ Transação inserida com sucesso na tabela ${tableName}`);
    
    return {
      success: true,
      tableName: tableName,
      data: data
    };
    
  } catch (error: any) {
    console.error('Erro na inserção por mês selecionado:', error);
    return {
      success: false,
      error: error.message,
      tableName: 'unknown'
    };
  }
}
