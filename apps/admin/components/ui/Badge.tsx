import React from 'react';

export type BadgeVariant =
  | 'default'
  | 'success'
  | 'warning'
  | 'danger'
  | 'brand'
  | 'outline'
  | 'mono';

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: BadgeVariant;
  pulse?: boolean;
}

export function Badge({
  variant = 'default',
  pulse = false,
  className = '',
  children,
  ...props
}: BadgeProps) {
  const base =
    'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[11px] font-semibold tracking-tight transition-colors';

  const variants: Record<BadgeVariant, string> = {
    default: 'bg-zinc-100 text-zinc-800 border border-zinc-200/60',
    mono: 'bg-zinc-900 text-zinc-100 border border-zinc-700 font-mono text-[10px]',
    success: 'bg-emerald-50 text-emerald-700 border border-emerald-200/80',
    warning: 'bg-amber-50 text-amber-800 border border-amber-200/80',
    danger: 'bg-rose-50 text-rose-700 border border-rose-200/80',
    brand: 'bg-[#006b23]/10 text-[#006b23] border border-[#006b23]/20',
    outline: 'bg-transparent text-zinc-600 border border-zinc-300',
  };

  const pulseColors: Record<BadgeVariant, string> = {
    default: 'bg-zinc-500',
    mono: 'bg-emerald-400',
    success: 'bg-emerald-500',
    warning: 'bg-amber-500',
    danger: 'bg-rose-500',
    brand: 'bg-[#006b23]',
    outline: 'bg-zinc-400',
  };

  return (
    <span className={`${base} ${variants[variant]} ${className}`} {...props}>
      {pulse && (
        <span className="relative flex h-2 w-2">
          <span
            className={`animate-ping absolute inline-flex h-full w-full rounded-full opacity-75 ${pulseColors[variant]}`}
          />
          <span
            className={`relative inline-flex rounded-full h-2 w-2 ${pulseColors[variant]}`}
          />
        </span>
      )}
      {children}
    </span>
  );
}
export default Badge;
