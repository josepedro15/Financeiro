import { Badge } from '@/components/ui/badge';
import { getMonthlyTableFromDate, shouldUseMonthlyTable } from '@/utils/monthlyTableUtils';
import { Database, Calendar } from 'lucide-react';

interface TableIndicatorProps {
  transactionDate: string;
  className?: string;
}

export function TableIndicator({ transactionDate, className = '' }: TableIndicatorProps) {
  if (!transactionDate) {
    return null;
  }

  const useMonthlyTable = shouldUseMonthlyTable(transactionDate);
  const tableInfo = getMonthlyTableFromDate(transactionDate);

  if (useMonthlyTable && tableInfo) {
    return (
      <div className={`flex items-center gap-2 ${className}`}>
        <Database className="h-4 w-4 text-blue-600" />
        <Badge variant="secondary" className="text-xs">
          Tabela: {tableInfo.table}
        </Badge>
        <Badge variant="outline" className="text-xs">
          {tableInfo.month}/{tableInfo.year}
        </Badge>
      </div>
    );
  }

  return (
    <div className={`flex items-center gap-2 ${className}`}>
      <Database className="h-4 w-4 text-gray-600" />
      <Badge variant="secondary" className="text-xs">
        Tabela: transactions (principal)
      </Badge>
      <Badge variant="outline" className="text-xs">
        <Calendar className="h-3 w-3 mr-1" />
        Outras datas
      </Badge>
    </div>
  );
}

export default TableIndicator;
