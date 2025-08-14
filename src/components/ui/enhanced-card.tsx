import React from 'react';
import { cn } from '@/lib/utils';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from './card';

interface EnhancedCardProps {
  title?: string;
  description?: string;
  children: React.ReactNode;
  icon?: React.ReactNode;
  variant?: 'default' | 'elevated' | 'outlined' | 'gradient';
  size?: 'sm' | 'md' | 'lg';
  hover?: boolean;
  loading?: boolean;
  className?: string;
  onClick?: () => void;
  disabled?: boolean;
}

const variantStyles = {
  default: 'bg-card border border-border',
  elevated: 'bg-card border-0 shadow-lg',
  outlined: 'bg-transparent border-2 border-border',
  gradient: 'bg-gradient-to-br from-primary/5 to-primary/10 border border-primary/20',
};

const sizeStyles = {
  sm: 'p-4',
  md: 'p-6',
  lg: 'p-8',
};

export const EnhancedCard: React.FC<EnhancedCardProps> = ({
  title,
  description,
  children,
  icon,
  variant = 'default',
  size = 'md',
  hover = true,
  loading = false,
  className,
  onClick,
  disabled = false,
}) => {
  const isInteractive = onClick && !disabled && !loading;

  return (
    <Card
      className={cn(
        'relative overflow-hidden transition-all duration-200',
        variantStyles[variant],
        sizeStyles[size],
        hover && 'card-hover',
        isInteractive && 'cursor-pointer',
        disabled && 'opacity-50 cursor-not-allowed',
        loading && 'animate-pulse',
        className
      )}
      onClick={isInteractive ? onClick : undefined}
    >
      {/* Loading overlay */}
      {loading && (
        <div className="absolute inset-0 bg-background/50 backdrop-blur-sm flex items-center justify-center z-10">
          <div className="loading-spinner" />
        </div>
      )}

      {/* Header */}
      {(title || description || icon) && (
        <CardHeader className={cn('pb-4', size === 'sm' && 'pb-3')}>
          <div className="flex items-start justify-between">
            <div className="flex-1">
              {title && (
                <CardTitle className={cn(
                  'flex items-center gap-2',
                  size === 'sm' ? 'text-base' : 'text-lg',
                  size === 'lg' && 'text-xl'
                )}>
                  {icon && (
                    <span className="flex-shrink-0 p-2 bg-primary/10 rounded-lg">
                      {icon}
                    </span>
                  )}
                  {title}
                </CardTitle>
              )}
              {description && (
                <CardDescription className={cn(
                  'mt-2',
                  size === 'sm' && 'text-sm',
                  size === 'lg' && 'text-base'
                )}>
                  {description}
                </CardDescription>
              )}
            </div>
          </div>
        </CardHeader>
      )}

      {/* Content */}
      <CardContent className={cn(
        'relative',
        !title && !description && !icon && 'pt-0'
      )}>
        {children}
      </CardContent>

      {/* Hover effect overlay */}
      {hover && isInteractive && (
        <div className="absolute inset-0 bg-primary/5 opacity-0 hover:opacity-100 transition-opacity duration-200 pointer-events-none" />
      )}
    </Card>
  );
};

// Card especializado para métricas
interface MetricCardProps {
  title: string;
  value: string | number;
  change?: {
    value: number;
    type: 'increase' | 'decrease';
  };
  icon?: React.ReactNode;
  trend?: 'up' | 'down' | 'neutral';
  className?: string;
}

export const MetricCard: React.FC<MetricCardProps> = ({
  title,
  value,
  change,
  icon,
  trend = 'neutral',
  className,
}) => {
  const trendColors = {
    up: 'text-green-600 dark:text-green-400',
    down: 'text-red-600 dark:text-red-400',
    neutral: 'text-muted-foreground',
  };

  const trendIcons = {
    up: '↗',
    down: '↘',
    neutral: '→',
  };

  return (
    <EnhancedCard
      variant="elevated"
      size="md"
      className={cn('text-center', className)}
    >
      <div className="flex flex-col items-center space-y-3">
        {/* Icon */}
        {icon && (
          <div className="p-3 bg-primary/10 rounded-full">
            {icon}
          </div>
        )}

        {/* Value */}
        <div className="space-y-1">
          <div className="text-3xl font-bold tracking-tight">
            {value}
          </div>
          <div className="text-sm text-muted-foreground">
            {title}
          </div>
        </div>

        {/* Change indicator */}
        {change && (
          <div className={cn(
            'flex items-center gap-1 text-sm font-medium',
            trendColors[trend]
          )}>
            <span>{trendIcons[trend]}</span>
            <span>
              {change.type === 'increase' ? '+' : ''}
              {change.value}%
            </span>
          </div>
        )}
      </div>
    </EnhancedCard>
  );
};

// Card especializado para estatísticas
interface StatsCardProps {
  title: string;
  stats: Array<{
    label: string;
    value: string | number;
    change?: number;
  }>;
  icon?: React.ReactNode;
  className?: string;
}

export const StatsCard: React.FC<StatsCardProps> = ({
  title,
  stats,
  icon,
  className,
}) => {
  return (
    <EnhancedCard
      title={title}
      icon={icon}
      variant="default"
      className={className}
    >
      <div className="space-y-4">
        {stats.map((stat, index) => (
          <div key={index} className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">
              {stat.label}
            </span>
            <div className="flex items-center gap-2">
              <span className="font-medium">
                {stat.value}
              </span>
              {stat.change !== undefined && (
                <span className={cn(
                  'text-xs px-2 py-1 rounded-full',
                  stat.change >= 0 
                    ? 'bg-green-100 text-green-700 dark:bg-green-900/20 dark:text-green-400'
                    : 'bg-red-100 text-red-700 dark:bg-red-900/20 dark:text-red-400'
                )}>
                  {stat.change >= 0 ? '+' : ''}{stat.change}%
                </span>
              )}
            </div>
          </div>
        ))}
      </div>
    </EnhancedCard>
  );
};

// Card especializado para ações
interface ActionCardProps {
  title: string;
  description?: string;
  icon?: React.ReactNode;
  action?: {
    label: string;
    onClick: () => void;
    variant?: 'default' | 'outline' | 'ghost';
  };
  className?: string;
}

export const ActionCard: React.FC<ActionCardProps> = ({
  title,
  description,
  icon,
  action,
  className,
}) => {
  return (
    <EnhancedCard
      title={title}
      description={description}
      icon={icon}
      variant="outlined"
      hover={true}
      onClick={action?.onClick}
      className={cn('group', className)}
    >
      {action && (
        <div className="mt-4 flex justify-end">
          <button
            onClick={(e) => {
              e.stopPropagation();
              action.onClick();
            }}
            className={cn(
              'px-4 py-2 text-sm font-medium rounded-md transition-colors',
              'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
              action.variant === 'outline' && 'border border-border hover:bg-muted',
              action.variant === 'ghost' && 'hover:bg-muted',
              !action.variant && 'bg-primary text-primary-foreground hover:bg-primary/90'
            )}
          >
            {action.label}
          </button>
        </div>
      )}
    </EnhancedCard>
  );
};
