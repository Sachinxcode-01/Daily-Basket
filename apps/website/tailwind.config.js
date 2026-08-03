/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
    '../../packages/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      // ─── Google Stitch Design System Exact Colour Palette ─────────────────
      colors: {
        // Primary (Grocery Green)
        'primary':                  '#006b23',
        'on-primary':               '#ffffff',
        'primary-container':        '#078730',
        'on-primary-container':     '#f7fff2',
        'surface-tint':             '#006e25',
        'inverse-primary':          '#70dd7a',
        'primary-fixed':            '#8cfa93',
        'primary-fixed-dim':        '#70dd7a',
        'on-primary-fixed':         '#002106',
        'on-primary-fixed-variant': '#00531a',
        // Secondary
        'secondary':                '#58605a',
        'on-secondary':             '#ffffff',
        'secondary-container':      '#dce5dd',
        'on-secondary-container':   '#5e6660',
        'secondary-fixed':          '#dce5dd',
        'secondary-fixed-dim':      '#c0c9c1',
        'on-secondary-fixed':       '#151d19',
        'on-secondary-fixed-variant':'#404943',
        // Tertiary
        'tertiary':                 '#5a5c5c',
        'on-tertiary':              '#ffffff',
        'tertiary-container':       '#737575',
        'on-tertiary-container':    '#fcfcfc',
        'tertiary-fixed':           '#e2e2e2',
        'tertiary-fixed-dim':       '#c6c6c7',
        'on-tertiary-fixed':        '#1a1c1c',
        'on-tertiary-fixed-variant':'#454747',
        // Surface
        'surface':                  '#f9f9fc',
        'surface-dim':              '#dadadc',
        'surface-bright':           '#f9f9fc',
        'surface-container-lowest': '#ffffff',
        'surface-container-low':    '#f3f3f6',
        'surface-container':        '#eeeef0',
        'surface-container-high':   '#e8e8ea',
        'surface-container-highest':'#e2e2e5',
        'surface-variant':          '#e2e2e5',
        'on-surface':               '#1a1c1e',
        'on-surface-variant':       '#3f4a3d',
        'inverse-surface':          '#2f3133',
        'inverse-on-surface':       '#f0f0f3',
        // Outline
        'outline':                  '#6e7a6c',
        'outline-variant':          '#becab9',
        // Background
        'background':               '#f9f9fc',
        'on-background':            '#1a1c1e',
        // Error
        'error':                    '#ba1a1a',
        'on-error':                 '#ffffff',
        'error-container':          '#ffdad6',
        'on-error-container':       '#93000a',
      },
      // ─── Border Radius (Extra Rounded — Stitch Shape Language) ────────────
      borderRadius: {
        'DEFAULT': '0.25rem',  // 4px – sm
        'md':      '0.75rem',  // 12px – inputs & buttons
        'lg':      '1rem',     // 16px – product cards
        'xl':      '1.5rem',   // 24px – large containers
        'full':    '9999px',   // pills & chips
      },
      // ─── Spacing (8px base unit) ───────────────────────────────────────────
      spacing: {
        'xs':             '4px',
        'sm':             '8px',
        'md':             '16px',
        'lg':             '24px',
        'xl':             '32px',
        'unit':           '4px',
        'gutter':         '16px',
        'margin-mobile':  '16px',
        'margin-desktop': '48px',
      },
      // ─── Font Families ─────────────────────────────────────────────────────
      fontFamily: {
        'display-lg':          ['Outfit', 'sans-serif'],
        'headline-lg':         ['Outfit', 'sans-serif'],
        'headline-lg-mobile':  ['Outfit', 'sans-serif'],
        'title-md':            ['Outfit', 'sans-serif'],
        'body-lg':             ['Inter', 'sans-serif'],
        'body-sm':             ['Inter', 'sans-serif'],
        'label-md':            ['Inter', 'sans-serif'],
        'sans':                ['Inter', 'sans-serif'],
      },
      // ─── Font Sizes ────────────────────────────────────────────────────────
      fontSize: {
        'display-lg':         ['48px', { lineHeight: '56px', letterSpacing: '-0.02em', fontWeight: '700' }],
        'headline-lg':        ['32px', { lineHeight: '40px', letterSpacing: '-0.01em', fontWeight: '600' }],
        'headline-lg-mobile': ['24px', { lineHeight: '32px', fontWeight: '600' }],
        'title-md':           ['20px', { lineHeight: '28px', fontWeight: '500' }],
        'body-lg':            ['16px', { lineHeight: '24px', fontWeight: '400' }],
        'body-sm':            ['14px', { lineHeight: '20px', fontWeight: '400' }],
        'label-md':           ['12px', { lineHeight: '16px', letterSpacing: '0.05em', fontWeight: '600' }],
      },
      // ─── Box Shadows (Elevation Model) ────────────────────────────────────
      boxShadow: {
        'level-1': '0px 2px 8px rgba(0, 0, 0, 0.04)',
        'level-2': '0px 4px 12px rgba(0, 0, 0, 0.08)',
        'level-3': '0px 8px 24px rgba(0, 0, 0, 0.12)',
      },
      // ─── Max Widths ────────────────────────────────────────────────────────
      maxWidth: {
        'mobile': '480px',
        'content': '1280px',
      },
    },
  },
  plugins: [],
};
