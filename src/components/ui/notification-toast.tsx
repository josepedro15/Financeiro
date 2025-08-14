import React from 'react';
import { X, CheckCircle, AlertCircle, AlertTriangle, Info } from 'lucide-react';
import { cn } from '@/lib/utils';

interface NotificationToastProps {
  type: 'success' | 'error' | 'warning' | 'info';
  title: string;
  message?: string;
  onClose?: () => void;
  duration?: number;
  className?: string;
}

const notificationStyles = {
  success: {
    icon: CheckCircle,
    bgColor: 'bg-green-50 dark:bg-green-900/20',
    borderColor: 'border-green-200 dark:border-green-800',
    iconColor: 'text-green-600 dark:text-green-400',
    textColor: 'text-green-800 dark:text-green-200',
  },
  error: {
    icon: AlertCircle,
    bgColor: 'bg-red-50 dark:bg-red-900/20',
    borderColor: 'border-red-200 dark:border-red-800',
    iconColor: 'text-red-600 dark:text-red-400',
    textColor: 'text-red-800 dark:text-red-200',
  },
  warning: {
    icon: AlertTriangle,
    bgColor: 'bg-yellow-50 dark:bg-yellow-900/20',
    borderColor: 'border-yellow-200 dark:border-yellow-800',
    iconColor: 'text-yellow-600 dark:text-yellow-400',
    textColor: 'text-yellow-800 dark:text-yellow-200',
  },
  info: {
    icon: Info,
    bgColor: 'bg-blue-50 dark:bg-blue-900/20',
    borderColor: 'border-blue-200 dark:border-blue-800',
    iconColor: 'text-blue-600 dark:text-blue-400',
    textColor: 'text-blue-800 dark:text-blue-200',
  },
};

export const NotificationToast: React.FC<NotificationToastProps> = ({
  type,
  title,
  message,
  onClose,
  duration = 5000,
  className,
}) => {
  const [isVisible, setIsVisible] = React.useState(true);
  const [isExiting, setIsExiting] = React.useState(false);
  const timeoutRef = React.useRef<NodeJS.Timeout>();
  const styles = notificationStyles[type];
  const Icon = styles.icon;

  React.useEffect(() => {
    if (duration > 0) {
      timeoutRef.current = setTimeout(() => {
        handleClose();
      }, duration);
    }

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [duration]);

  const handleClose = () => {
    setIsExiting(true);
    setTimeout(() => {
      setIsVisible(false);
      onClose?.();
    }, 300);
  };

  if (!isVisible) return null;

  return (
    <div
      className={cn(
        'slide-in-right',
        'relative overflow-hidden',
        'bg-white dark:bg-gray-800',
        'border border-gray-200 dark:border-gray-700',
        'rounded-lg shadow-lg',
        'p-4 pr-12',
        'max-w-sm w-full',
        'animate-in slide-in-from-right-full duration-300',
        isExiting && 'animate-out slide-out-to-right-full duration-300',
        className
      )}
      role="alert"
      aria-live="assertive"
    >
      {/* Background color overlay */}
      <div
        className={cn(
          'absolute inset-0 opacity-10',
          styles.bgColor
        )}
      />

      {/* Content */}
      <div className="relative flex items-start space-x-3">
        {/* Icon */}
        <div className={cn('flex-shrink-0 p-1', styles.iconColor)}>
          <Icon className="w-5 h-5" />
        </div>

        {/* Text content */}
        <div className="flex-1 min-w-0">
          <h4 className={cn('text-sm font-medium', styles.textColor)}>
            {title}
          </h4>
          {message && (
            <p className="mt-1 text-sm text-muted-foreground">
              {message}
            </p>
          )}
        </div>

        {/* Close button */}
        {onClose && (
          <button
            onClick={handleClose}
            className={cn(
              'absolute top-2 right-2',
              'p-1 rounded-md',
              'text-muted-foreground hover:text-foreground',
              'hover:bg-muted/50',
              'transition-colors',
              'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2'
            )}
            aria-label="Fechar notificação"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>

      {/* Progress bar */}
      {duration > 0 && (
        <div className="absolute bottom-0 left-0 right-0 h-1 bg-muted">
          <div
            className={cn(
              'h-full transition-all duration-300 ease-linear',
              styles.iconColor.replace('text-', 'bg-')
            )}
            style={{
              width: isExiting ? '0%' : '100%',
              transitionDuration: `${duration}ms`,
            }}
          />
        </div>
      )}
    </div>
  );
};

// Hook para gerenciar notificações
export const useNotifications = () => {
  const [notifications, setNotifications] = React.useState<
    Array<NotificationToastProps & { id: string }>
  >([]);

  const addNotification = React.useCallback(
    (notification: Omit<NotificationToastProps, 'onClose'>) => {
      const id = Math.random().toString(36).substr(2, 9);
      const newNotification = {
        ...notification,
        id,
        onClose: () => removeNotification(id),
      };
      setNotifications(prev => [...prev, newNotification]);
    },
    []
  );

  const removeNotification = React.useCallback((id: string) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
  }, []);

  const clearAll = React.useCallback(() => {
    setNotifications([]);
  }, []);

  return {
    notifications,
    addNotification,
    removeNotification,
    clearAll,
  };
};

// Componente de container para notificações
interface NotificationContainerProps {
  notifications: Array<NotificationToastProps & { id: string }>;
  position?: 'top-right' | 'top-left' | 'bottom-right' | 'bottom-left';
  className?: string;
}

export const NotificationContainer: React.FC<NotificationContainerProps> = ({
  notifications,
  position = 'top-right',
  className,
}) => {
  const positionClasses = {
    'top-right': 'top-4 right-4',
    'top-left': 'top-4 left-4',
    'bottom-right': 'bottom-4 right-4',
    'bottom-left': 'bottom-4 left-4',
  };

  return (
    <div
      className={cn(
        'fixed z-50 space-y-2',
        positionClasses[position],
        'max-w-sm w-full',
        className
      )}
    >
      {notifications.map(notification => (
        <NotificationToast
          key={notification.id}
          {...notification}
        />
      ))}
    </div>
  );
};
