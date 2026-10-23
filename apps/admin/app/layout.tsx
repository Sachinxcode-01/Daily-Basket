import React from 'react';
import './globals.css';
import { AuthProvider } from './lib/auth-context';
import AdminShell from '../components/layout/AdminShell';

export const metadata = {
  title: 'Daily Basket | Store Admin & Quick-Commerce Suite',
  description: 'Inventory management, daily mandi pricing, order dispatch, and rider tracking.',
  icons: {
    icon: '/images/daily_basket_logo.png',
    shortcut: '/images/daily_basket_logo.png',
    apple: '/images/daily_basket_logo.png',
  },
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="light">
      <body className="bg-[#f7f8fa] text-zinc-900 min-h-screen font-sans antialiased selection:bg-emerald-500 selection:text-white">
        <AuthProvider>
          <AdminShell>{children}</AdminShell>
        </AuthProvider>
      </body>
    </html>
  );
}
