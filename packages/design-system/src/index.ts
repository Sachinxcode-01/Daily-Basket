import { m3Colors, typography } from '@daily-basket/theme';

export const designTokens = {
  colors: m3Colors,
  typography: typography,
  borderRadius: {
    sm: '0.375rem',
    md: '0.5rem',
    lg: '0.75rem',
    xl: '1rem',
    full: '9999px',
  },
  shadows: {
    card: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
    modal: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
    elevated: '0 10px 15px -3px rgba(5, 150, 105, 0.15)',
  },
  transitions: {
    default: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
    spring: 'all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
  },
};
