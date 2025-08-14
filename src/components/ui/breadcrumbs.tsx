import React from 'react';
import { Link } from 'react-router-dom';
import { ChevronRight, Home } from 'lucide-react';
import { cn } from '@/lib/utils';

interface BreadcrumbItem {
  label: string;
  href?: string;
  icon?: React.ReactNode;
}

interface BreadcrumbsProps {
  items: BreadcrumbItem[];
  className?: string;
  showHome?: boolean;
  separator?: React.ReactNode;
}

export const Breadcrumbs: React.FC<BreadcrumbsProps> = ({
  items,
  className,
  showHome = true,
  separator = <ChevronRight className="w-4 h-4" />,
}) => {
  const allItems = showHome 
    ? [{ label: 'Início', href: '/', icon: <Home className="w-4 h-4" /> }, ...items]
    : items;

  return (
    <nav 
      className={cn(
        'flex items-center space-x-2 text-sm text-muted-foreground mb-6',
        'custom-scrollbar overflow-x-auto',
        className
      )}
      aria-label="Breadcrumb"
    >
      {allItems.map((item, index) => (
        <div key={index} className="flex items-center">
          {index > 0 && (
            <span className="mx-2 text-muted-foreground/50">
              {separator}
            </span>
          )}
          
          {item.href ? (
            <Link
              to={item.href}
              className={cn(
                'flex items-center space-x-1 hover:text-foreground transition-colors',
                'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 rounded',
                'px-2 py-1 -mx-2',
                index === allItems.length - 1 && 'text-foreground font-medium'
              )}
              aria-current={index === allItems.length - 1 ? 'page' : undefined}
            >
              {item.icon && <span className="flex-shrink-0">{item.icon}</span>}
              <span className="truncate">{item.label}</span>
            </Link>
          ) : (
            <span 
              className={cn(
                'flex items-center space-x-1 px-2 py-1',
                index === allItems.length - 1 && 'text-foreground font-medium'
              )}
              aria-current="page"
            >
              {item.icon && <span className="flex-shrink-0">{item.icon}</span>}
              <span className="truncate">{item.label}</span>
            </span>
          )}
        </div>
      ))}
    </nav>
  );
};

// Hook para gerar breadcrumbs automaticamente baseado na rota
export const useBreadcrumbs = (currentPath: string) => {
  const pathSegments = currentPath.split('/').filter(Boolean);
  
  const breadcrumbItems: BreadcrumbItem[] = pathSegments.map((segment, index) => {
    const href = '/' + pathSegments.slice(0, index + 1).join('/');
    const label = segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, ' ');
    
    return {
      label,
      href: index < pathSegments.length - 1 ? href : undefined,
    };
  });

  return breadcrumbItems;
};

// Componente de breadcrumbs responsivo
interface ResponsiveBreadcrumbsProps {
  items: BreadcrumbItem[];
  className?: string;
  maxItems?: number;
}

export const ResponsiveBreadcrumbs: React.FC<ResponsiveBreadcrumbsProps> = ({
  items,
  className,
  maxItems = 3,
}) => {
  const shouldCollapse = items.length > maxItems;
  
  if (!shouldCollapse) {
    return <Breadcrumbs items={items} className={className} />;
  }

  const firstItem = items[0];
  const lastItem = items[items.length - 1];
  const middleItems = items.slice(1, -1);
  const collapsedItems = middleItems.slice(0, -1);
  const lastMiddleItem = middleItems[middleItems.length - 1];

  return (
    <nav 
      className={cn(
        'flex items-center space-x-2 text-sm text-muted-foreground mb-6',
        'custom-scrollbar overflow-x-auto',
        className
      )}
    >
      {/* Primeiro item */}
      <div className="flex items-center">
        <Link
          to={firstItem.href || '#'}
          className="flex items-center space-x-1 hover:text-foreground transition-colors px-2 py-1 -mx-2 rounded focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
        >
          {firstItem.icon && <span className="flex-shrink-0">{firstItem.icon}</span>}
          <span className="truncate">{firstItem.label}</span>
        </Link>
      </div>

      <ChevronRight className="w-4 h-4" />

      {/* Items colapsados */}
      {collapsedItems.length > 0 && (
        <>
          <span className="px-2 py-1 text-xs bg-muted rounded-full">
            +{collapsedItems.length}
          </span>
          <ChevronRight className="w-4 h-4" />
        </>
      )}

      {/* Penúltimo item */}
      {lastMiddleItem && (
        <>
          <Link
            to={lastMiddleItem.href || '#'}
            className="flex items-center space-x-1 hover:text-foreground transition-colors px-2 py-1 -mx-2 rounded focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
          >
            {lastMiddleItem.icon && <span className="flex-shrink-0">{lastMiddleItem.icon}</span>}
            <span className="truncate">{lastMiddleItem.label}</span>
          </Link>
          <ChevronRight className="w-4 h-4" />
        </>
      )}

      {/* Último item */}
      <span className="px-2 py-1 text-foreground font-medium" aria-current="page">
        {lastItem.icon && <span className="flex-shrink-0">{lastItem.icon}</span>}
        <span className="truncate">{lastItem.label}</span>
      </span>
    </nav>
  );
};
