import { m3Colors, typography, googleStitchColors } from '@daily-basket/theme';

export const designTokens = {
  colors: m3Colors,
  stitchColors: googleStitchColors,
  typography: typography,
  borderRadius: {
    xs: '4px',
    sm: '6px',
    DEFAULT: '8px',
    md: '8px',        // Input fields & small cards
    lg: '16px',       // Product tiles & bento cards
    xl: '24px',       // Bottom navigation & modal sheets
    full: '9999px',   // Badges & action pills
  },
  spacing: {
    base: '4px',
    marginMobile: '16px',
    gutterHorizontal: '12px',
    gutterVertical: '16px',
    touchTargetMin: '48px',
  },
  shadows: {
    card: '0 4px 12px rgba(0, 0, 0, 0.06)',
    modal: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
    bottomNav: '0px -4px 16px rgba(0, 0, 0, 0.06)',
    floatingCta: '0px 8px 20px rgba(45, 157, 67, 0.25)',
    elevated: '0 10px 15px -3px rgba(45, 157, 67, 0.18)',
  },
  transitions: {
    default: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
    spring: 'all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)',
  },
};
