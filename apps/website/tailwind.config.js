/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
    '../../packages/*/src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      // ─── Daily Basket Design System (Single Source of Truth: design.md) ──────
      colors: {
        // Primary & Brand Colors
        'primary':                  '#2d9d43',
        'on-primary':               '#ffffff',
        'primary-container':        '#078730',
        'on-primary-container':     '#f7fff2',
        'surface-tint':             '#2d9d43',
        'inverse-primary':          '#70dd7a',
        'primary-fixed':            '#8cfa93',
        'primary-fixed-dim':        '#70dd7a',
        'on-primary-fixed':         '#002106',
        'on-primary-fixed-variant': '#00531a',

        // Secondary & Tertiary
        'secondary':                '#58605a',
        'on-secondary':             '#ffffff',
        'secondary-container':      '#dce5dd',
        'on-secondary-container':   '#5e6660',
        'secondary-fixed':          '#dce5dd',
        'secondary-fixed-dim':      '#c0c9c1',
        'on-secondary-fixed':       '#151d19',
        'on-secondary-fixed-variant':'#404943',
        'tertiary':                 '#5a5c5c',
        'on-tertiary':              '#ffffff',
        'tertiary-container':       '#737575',
        'on-tertiary-container':    '#fcfcfc',

        // Surface & Background Tokens
        'surface':                  '#f9f9fc',
        'surface-dim':              '#dadadc',
        'surface-bright':           '#f9f9fc',
        'surface-container-lowest': '#ffffff',
        'surface-container-low':    '#f3f3f6',
        'surface-container':        '#eceef0',
        'surface-container-high':   '#e6e8ea',
        'surface-container-highest':'#e0e3e5',
        'surface-variant':          '#e0e3e5',
        'background':               '#f9f9fc',
        'on-background':            '#191c1e',

        // Text & On-Surface
        'on-surface':               '#191c1e',
        'on-surface-variant':       '#3f4a3d',
        'on-surface-subtle':        '#64748b',
        'inverse-surface':          '#2f3133',
        'inverse-on-surface':       '#f0f0f3',

        // Outline & Border
        'outline':                  '#6e7a6c',
        'outline-variant':          '#becab9',

        // Semantic & Feedback
        'status-success':           '#15803d',
        'status-warning':           '#b45309',
        'status-error':             '#ba1a1a',
        'error':                    '#ba1a1a',
        'on-error':                 '#ffffff',
        'error-container':          '#ffdad6',
        'on-error-container':       '#93000a',
        'status-info':              '#0369a1',
      },
      // ─── Border Radius (design.md Core Geometry) ───────────────────────────
      borderRadius: {
        'sm':      '4px',
        'DEFAULT': '8px',   // Core 8px grid
        'md':      '8px',   // Inputs & small cards
        'lg':      '16px',  // Product tiles & bento cards
        'xl':      '24px',  // Bottom nav & modal sheets
        '2xl':     '24px',
        'full':    '9999px',// Pills & chips
      },
      // ─── Spacing (4px baseline, 8px grid) ──────────────────────────────────
      spacing: {
        'xs':             '4px',
        'sm':             '8px',
        'md':             '16px',
        'lg':             '24px',
        'xl':             '32px',
        'unit':           '4px',
        'gutter':         '12px',
        'gutter-v':       '16px',
        'margin-mobile':  '16px',
        'margin-desktop': '48px',
      },
      // ─── Font Families ─────────────────────────────────────────────────────
      fontFamily: {
        'display':             ['Outfit', 'sans-serif'],
        'display-lg':          ['Outfit', 'sans-serif'],
        'headline':            ['Outfit', 'sans-serif'],
        'headline-lg':         ['Outfit', 'sans-serif'],
        'headline-lg-mobile':  ['Outfit', 'sans-serif'],
        'title-md':            ['Outfit', 'sans-serif'],
        'body-lg':             ['Outfit', 'sans-serif'],
        'body-sm':             ['Outfit', 'sans-serif'],
        'label-md':            ['Outfit', 'sans-serif'],
        'sans':                ['Outfit', 'sans-serif'],
      },
      // ─── Font Sizes ────────────────────────────────────────────────────────
      fontSize: {
        'headline-lg':        ['28px', { lineHeight: '36px', letterSpacing: '-0.02em', fontWeight: '700' }],
        'headline-md':        ['22px', { lineHeight: '28px', fontWeight: '600' }],
        'headline-sm':        ['18px', { lineHeight: '24px', fontWeight: '600' }],
        'title-md':           ['16px', { lineHeight: '24px', fontWeight: '600' }],
        'body-lg':            ['16px', { lineHeight: '24px', fontWeight: '400' }],
        'body-md':            ['14px', { lineHeight: '20px', fontWeight: '400' }],
        'body-sm':            ['12px', { lineHeight: '16px', fontWeight: '400' }],
        'label-lg':           ['14px', { lineHeight: '20px', letterSpacing: '0.1px', fontWeight: '600' }],
        'label-md':           ['12px', { lineHeight: '16px', letterSpacing: '0.5px', fontWeight: '600' }],
      },
      // ─── Box Shadows (Elevation Model) ────────────────────────────────────
      boxShadow: {
        'level-1':     '0px 2px 8px rgba(0, 0, 0, 0.04)',
        'level-2':     '0px 4px 12px rgba(0, 0, 0, 0.08)',
        'level-3':     '0px 8px 24px rgba(0, 0, 0, 0.12)',
        'bottom-nav':  '0px -4px 16px rgba(0, 0, 0, 0.06)',
        'floating-cta':'0px 8px 20px rgba(45, 157, 67, 0.25)',
      },
      // ─── Max Widths ────────────────────────────────────────────────────────
      maxWidth: {
        'mobile': '390px',
        'content': '1280px',
      },
    },
  },
  plugins: [],
};
