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
    console.log(`Data original: ${originalData.transaction_date} (tabela: ${originalTable})`);
    console.log(`Nova data: ${updatedData.transaction_date} (tabela: ${newTable})`);
    
    // Se a tabela não mudou, fazer update simples
    if (originalTable === newTable) {
      const { data, error } = await supabase
        .from(originalTable)
        .update(updatedData)
        .eq('id', transactionId)
        .select();
      
      if (error) {
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
    
    // Se a tabela mudou, precisamos mover a transação
    console.log(`⚠️ Mudança de tabela detectada: ${originalTable} → ${newTable}`);
    
    // 1. Inserir na nova tabela
    const insertResult = await insertTransactionInCorrectTable({
      ...updatedData,
      // Manter o mesmo ID se possível, senão gerar novo
    });
    
    if (!insertResult.success) {
      return insertResult;
    }
    
    // 2. Remover da tabela original
    const { error: deleteError } = await supabase
      .from(originalTable)
      .delete()
      .eq('id', transactionId);
    
    if (deleteError) {
      console.error(`Erro ao remover da tabela original ${originalTable}:`, deleteError);
      // A transação foi inserida na nova tabela, mas não removida da original
      // Isso pode causar duplicação, mas é melhor que perda de dados
    } else {
      console.log(`✅ Transação removida da tabela original ${originalTable}`);
    }
    
    console.log(`✅ Transação movida com sucesso: ${originalTable} → ${newTable}`);
    return insertResult;
    
  } catch (error: any) {
    console.error('Erro na atualização inteligente:', error);
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
    
    const { error } = await supabase
      .from(tableName)
      .delete()
      .eq('id', transactionId);
    
    if (error) {
      return {
        success: false,
        error: error.message,
        tableName: tableName
      };
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
