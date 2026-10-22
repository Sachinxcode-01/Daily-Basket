/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}',
    '../../packages/*/src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // Daily Basket Design Tokens (design.md)
        'primary': '#2d9d43',
        'primary-container': '#078730',
        'on-primary': '#ffffff',
        'on-primary-container': '#f7fff2',
        'primary-fixed': '#8cfa93',
        'primary-fixed-dim': '#70dd7a',
        'on-primary-fixed': '#002106',
        'on-primary-fixed-variant': '#00531a',
        'inverse-primary': '#70dd7a',

        'surface': '#f9f9fc',
        'surface-dim': '#dadadc',
        'surface-bright': '#f9f9fc',
        'surface-container-lowest': '#ffffff',
        'surface-container-low': '#f3f3f6',
        'surface-container': '#eceef0',
        'surface-container-high': '#e6e8ea',
        'surface-container-highest': '#e0e3e5',
        'surface-variant': '#e0e3e5',
        'surface-tint': '#2d9d43',
        'background': '#f9f9fc',
        'on-background': '#191c1e',

        'on-surface': '#191c1e',
        'on-surface-variant': '#3f4a3d',
        'on-surface-subtle': '#64748b',
        'inverse-surface': '#2f3133',
        'inverse-on-surface': '#eff1f3',

        'outline': '#6e7a6c',
        'outline-variant': '#becab9',

        'secondary': '#58605a',
        'secondary-container': '#dce5dd',
        'on-secondary': '#ffffff',
        'on-secondary-container': '#5e6660',
        'secondary-fixed': '#dce5dd',
        'secondary-fixed-dim': '#c0c9c1',
        'on-secondary-fixed': '#151d19',
        'on-secondary-fixed-variant': '#404943',

        'tertiary': '#a42f57',
        'tertiary-container': '#c4486f',
        'on-tertiary': '#ffffff',
        'on-tertiary-container': '#fffbff',
        'tertiary-fixed': '#ffd9e0',
        'tertiary-fixed-dim': '#ffb1c3',
        'on-tertiary-fixed': '#3f0019',
        'on-tertiary-fixed-variant': '#881842',

        'status-success': '#15803d',
        'status-warning': '#b45309',
        'status-error': '#ba1a1a',
        'error': '#ba1a1a',
        'error-container': '#ffdad6',
        'on-error': '#ffffff',
        'on-error-container': '#93000a',
        'status-info': '#0369a1',

        brand: {
          500: '#2d9d43',
          600: '#078730',
        },
      },
      borderRadius: {
        DEFAULT: '8px',
        sm: '4px',
        md: '8px',
        lg: '16px',
        xl: '24px',
        '2xl': '24px',
        full: '9999px',
      },
      fontFamily: {
        sans: ['Outfit', 'sans-serif'],
        display: ['Outfit', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
