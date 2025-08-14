import React from 'react';
import { cn } from '@/lib/utils';
import { Button } from './button';
import { Loader2 } from 'lucide-react';

interface EnhancedButtonProps {
  children: React.ReactNode;
  variant?: 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link';
  size?: 'default' | 'sm' | 'lg' | 'icon';
  loading?: boolean;
  disabled?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  onClick?: () => void;
  className?: string;
  fullWidth?: boolean;
  ripple?: boolean;
  href?: string;
  target?: string;
  rel?: string;
}

export const EnhancedButton: React.FC<EnhancedButtonProps> = ({
  children,
  variant = 'default',
  size = 'default',
  loading = false,
  disabled = false,
  icon,
  iconPosition = 'left',
  onClick,
  className,
  fullWidth = false,
  ripple = true,
  href,
  target,
  rel,
  ...props
}) => {
  const [isRippling, setIsRippling] = React.useState(false);
  const [ripplePosition, setRipplePosition] = React.useState({ x: 0, y: 0 });
  const buttonRef = React.useRef<HTMLButtonElement>(null);

  const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
    if (ripple && buttonRef.current) {
      const rect = buttonRef.current.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      
      setRipplePosition({ x, y });
      setIsRippling(true);
      
      setTimeout(() => setIsRippling(false), 600);
    }
    
    onClick?.(e);
  };

  const buttonContent = (
    <>
      {/* Ripple effect */}
      {ripple && isRippling && (
        <span
          className="absolute inset-0 rounded-md bg-white/20 animate-ping"
          style={{
            left: ripplePosition.x - 50,
            top: ripplePosition.y - 50,
            width: 100,
            height: 100,
          }}
        />
      )}

      {/* Loading spinner */}
      {loading && (
        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
      )}

      {/* Icon left */}
      {icon && iconPosition === 'left' && !loading && (
        <span className="mr-2">{icon}</span>
      )}

      {/* Content */}
      <span className="flex items-center justify-center">
        {children}
      </span>

      {/* Icon right */}
      {icon && iconPosition === 'right' && !loading && (
        <span className="ml-2">{icon}</span>
      )}
    </>
  );

  const buttonClasses = cn(
    'relative overflow-hidden transition-all duration-200',
    'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
    'disabled:opacity-50 disabled:cursor-not-allowed',
    fullWidth && 'w-full',
    'btn-hover',
    className
  );

  // Se tem href, renderizar como link
  if (href) {
    return (
      <a
        href={href}
        target={target}
        rel={rel}
        className={cn(
          buttonClasses,
          'inline-flex items-center justify-center',
          'text-sm font-medium rounded-md',
          'transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
          'disabled:pointer-events-none disabled:opacity-50',
          {
            'bg-primary text-primary-foreground hover:bg-primary/90': variant === 'default',
            'bg-destructive text-destructive-foreground hover:bg-destructive/90': variant === 'destructive',
            'border border-input bg-background hover:bg-accent hover:text-accent-foreground': variant === 'outline',
            'bg-secondary text-secondary-foreground hover:bg-secondary/80': variant === 'secondary',
            'hover:bg-accent hover:text-accent-foreground': variant === 'ghost',
            'text-primary underline-offset-4 hover:underline': variant === 'link',
            'h-10 px-4 py-2': size === 'default',
            'h-9 rounded-md px-3': size === 'sm',
            'h-11 rounded-md px-8': size === 'lg',
            'h-10 w-10': size === 'icon',
          }
        )}
      >
        {buttonContent}
      </a>
    );
  }

  return (
    <Button
      ref={buttonRef}
      variant={variant}
      size={size}
      disabled={disabled || loading}
      onClick={handleClick}
      className={buttonClasses}
      {...props}
    >
      {buttonContent}
    </Button>
  );
};

// Botão com gradiente
interface GradientButtonProps {
  children: React.ReactNode;
  gradient?: 'primary' | 'success' | 'warning' | 'destructive';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  disabled?: boolean;
  onClick?: () => void;
  className?: string;
}

export const GradientButton: React.FC<GradientButtonProps> = ({
  children,
  gradient = 'primary',
  size = 'md',
  loading = false,
  disabled = false,
  onClick,
  className,
}) => {
  const gradientClasses = {
    primary: 'bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary/70',
    success: 'bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700',
    warning: 'bg-gradient-to-r from-yellow-500 to-yellow-600 hover:from-yellow-600 hover:to-yellow-700',
    destructive: 'bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700',
  };

  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg',
  };

  return (
    <button
      onClick={onClick}
      disabled={disabled || loading}
      className={cn(
        'relative overflow-hidden rounded-lg font-medium text-white',
        'transition-all duration-200 transform hover:scale-105 active:scale-95',
        'focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary',
        'disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none',
        gradientClasses[gradient],
        sizeClasses[size],
        'btn-hover',
        className
      )}
    >
      {/* Shimmer effect */}
      <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full hover:translate-x-full transition-transform duration-1000" />
      
      {/* Content */}
      <span className="relative flex items-center justify-center">
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {children}
      </span>
    </button>
  );
};

// Botão flutuante
interface FloatingButtonProps {
  icon: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'destructive';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export const FloatingButton: React.FC<FloatingButtonProps> = ({
  icon,
  onClick,
  variant = 'primary',
  size = 'md',
  className,
}) => {
  const variantClasses = {
    primary: 'bg-primary text-primary-foreground hover:bg-primary/90',
    secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
    success: 'bg-green-500 text-white hover:bg-green-600',
    warning: 'bg-yellow-500 text-white hover:bg-yellow-600',
    destructive: 'bg-red-500 text-white hover:bg-red-600',
  };

  const sizeClasses = {
    sm: 'w-10 h-10',
    md: 'w-12 h-12',
    lg: 'w-14 h-14',
  };

  return (
    <button
      onClick={onClick}
      className={cn(
        'fixed bottom-6 right-6 rounded-full shadow-lg',
        'transition-all duration-200 transform hover:scale-110 active:scale-95',
        'focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary',
        'flex items-center justify-center',
        variantClasses[variant],
        sizeClasses[size],
        'btn-hover',
        className
      )}
    >
      {icon}
    </button>
  );
};

// Botão de toggle
interface ToggleButtonProps {
  pressed: boolean;
  onPressedChange: (pressed: boolean) => void;
  children: React.ReactNode;
  variant?: 'default' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export const ToggleButton: React.FC<ToggleButtonProps> = ({
  pressed,
  onPressedChange,
  children,
  variant = 'default',
  size = 'md',
  className,
}) => {
  const variantClasses = {
    default: pressed 
      ? 'bg-primary text-primary-foreground' 
      : 'bg-muted text-muted-foreground hover:bg-muted/80',
    outline: pressed 
      ? 'border-primary bg-primary/10 text-primary' 
      : 'border-border hover:bg-muted',
  };

  const sizeClasses = {
    sm: 'h-8 px-3 text-sm',
    md: 'h-10 px-4',
    lg: 'h-12 px-6 text-lg',
  };

  return (
    <button
      onClick={() => onPressedChange(!pressed)}
      className={cn(
        'rounded-md border transition-all duration-200',
        'focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2',
        variantClasses[variant],
        sizeClasses[size],
        'btn-hover',
        className
      )}
    >
      {children}
    </button>
  );
};
