// Utilitários para determinar a tabela mensal correta baseada na data

export interface MonthlyTableInfo {
  table: string;
  month: string;
  monthNum: number;
  year: number;
}

/**
 * Retorna informações da tabela mensal baseada na data da transação
 */
export function getMonthlyTableFromDate(transactionDate: string): MonthlyTableInfo | null {
  try {
    const date = new Date(transactionDate);
    const year = date.getFullYear();
    const month = date.getMonth() + 1; // 0-based to 1-based
    
    // Por enquanto, só suportamos 2025
    if (year !== 2025) {
      console.warn(`Ano ${year} não suportado nas tabelas mensais. Usando tabela principal.`);
      return null;
    }
    
    const monthNames = [
      '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    
    return {
      table: `transactions_${year}_${String(month).padStart(2, '0')}`,
      month: monthNames[month],
      monthNum: month,
      year: year
    };
  } catch (error) {
    console.error('Erro ao determinar tabela mensal:', error);
    return null;
  }
}

/**
 * Lista todas as tabelas mensais disponíveis para um ano
 */
export function getAllMonthlyTables(year: number = 2025): MonthlyTableInfo[] {
  const monthNames = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
  
  return monthNames.map((month, index) => ({
    table: `transactions_${year}_${String(index + 1).padStart(2, '0')}`,
    month: month,
    monthNum: index + 1,
    year: year
  }));
}

/**
 * Verifica se uma data deve usar tabelas mensais ou tabela principal
 */
export function shouldUseMonthlyTable(transactionDate: string): boolean {
  const tableInfo = getMonthlyTableFromDate(transactionDate);
  return tableInfo !== null;
}

/**
 * Retorna o nome da tabela para inserção baseada na data
 */
export function getTableNameForInsertion(transactionDate: string): string {
  const tableInfo = getMonthlyTableFromDate(transactionDate);
  
  if (tableInfo) {
    return tableInfo.table;
  }
  
  // Fallback para tabela principal
  return 'transactions';
}

/**
 * Formatadores de data para diferentes usos
 */
export const dateUtils = {
  /**
   * Converte data para formato YYYY-MM-DD
   */
  toISODate: (date: Date | string): string => {
    if (typeof date === 'string') {
      return date.split('T')[0]; // Remove time part if present
    }
    return date.toISOString().split('T')[0];
  },
  
  /**
   * Obtém data atual no formato YYYY-MM-DD
   */
  getCurrentDate: (): string => {
    return new Date().toISOString().split('T')[0];
  },
  
  /**
   * Verifica se uma data é válida
   */
  isValidDate: (dateString: string): boolean => {
    const date = new Date(dateString);
    return !isNaN(date.getTime());
  }
};
