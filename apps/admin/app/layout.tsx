import React from 'react';
import './globals.css';

export const metadata = {
  title: 'Daily Basket | Store Admin & Inventory Portal',
  description: 'Inventory management, order dispatch, and sales analytics dashboard.',
};

export default function AdminLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-slate-900 text-slate-100 min-h-screen antialiased">
        {children}
      </body>
    </html>
  );
}
