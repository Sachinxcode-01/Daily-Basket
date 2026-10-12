import React, { forwardRef } from 'react';
import { Loader2 } from 'lucide-react';

export type ButtonVariant =
  | 'primary'
  | 'secondary'
  | 'outline'
  | 'ghost'
  | 'destructive'
  | 'brand'
  | 'glow';

export type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'icon';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  isLoading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  (
    {
      className = '',
      variant = 'primary',
      size = 'md',
      isLoading = false,
      leftIcon,
      rightIcon,
      disabled,
      children,
      type = 'button',
      ...props
    },
    ref
  ) => {
    // Vercel design system tokens
    const baseStyles =
      'inline-flex items-center justify-center font-medium select-none transition-all duration-150 ease-out outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none disabled:cursor-not-allowed';

    const variants: Record<ButtonVariant, string> = {
      primary:
        'bg-zinc-950 hover:bg-zinc-800 text-white border border-zinc-800/80 shadow-[0_1px_2px_rgba(0,0,0,0.12)] active:scale-[0.98] focus-visible:ring-zinc-950',
      secondary:
        'bg-white hover:bg-zinc-50 text-zinc-900 border border-zinc-200 shadow-[0_1px_2px_rgba(0,0,0,0.04)] active:scale-[0.98] focus-visible:ring-zinc-400',
      outline:
        'bg-transparent hover:bg-zinc-100 text-zinc-700 border border-zinc-300 active:scale-[0.98] focus-visible:ring-zinc-400',
      ghost:
        'bg-transparent hover:bg-zinc-100/80 text-zinc-600 hover:text-zinc-900 active:scale-[0.98] focus-visible:ring-zinc-300',
      destructive:
        'bg-rose-600 hover:bg-rose-700 text-white shadow-sm active:scale-[0.98] focus-visible:ring-rose-500',
      brand:
        'bg-[#006b23] hover:bg-[#00551c] text-white shadow-sm border border-[#00551c]/50 active:scale-[0.98] focus-visible:ring-[#006b23]',
      glow:
        'bg-zinc-950 hover:bg-zinc-900 text-white border border-emerald-500/30 shadow-[0_0_15px_rgba(0,107,35,0.25)] hover:shadow-[0_0_20px_rgba(0,107,35,0.4)] active:scale-[0.98] focus-visible:ring-emerald-500',
    };

    const sizes: Record<ButtonSize, string> = {
      xs: 'text-[11px] px-2.5 py-1 rounded-md gap-1.5 font-medium',
      sm: 'text-xs px-3 py-1.5 rounded-lg gap-2 font-medium',
      md: 'text-xs md:text-sm px-4 py-2 rounded-xl gap-2 font-semibold',
      lg: 'text-sm md:text-base px-5 py-2.5 rounded-xl gap-2.5 font-semibold',
      icon: 'p-2 rounded-xl aspect-square',
    };

    return (
      <button
        ref={ref}
        type={type}
        disabled={disabled || isLoading}
        className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`}
        {...props}
      >
        {isLoading ? (
          <Loader2 className="w-4 h-4 animate-spin text-current" />
        ) : (
          leftIcon && <span className="inline-flex shrink-0">{leftIcon}</span>
        )}
        <span>{children}</span>
        {!isLoading && rightIcon && (
          <span className="inline-flex shrink-0">{rightIcon}</span>
        )}
      </button>
    );
  }
);

Button.displayName = 'Button';
export default Button;
