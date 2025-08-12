import { getMonthlyTableFromDate, shouldUseMonthlyTable } from '@/utils/monthlyTableUtils';

interface TableIndicatorProps {
  transactionDate: string;
  className?: string;
}

export function TableIndicator({ transactionDate, className = '' }: TableIndicatorProps) {
  // Componente mantido apenas para compatibilidade
  // A exibição da tabela foi removida da UI conforme solicitado
  return null;
}

export default TableIndicator;
