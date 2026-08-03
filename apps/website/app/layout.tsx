import React from 'react';
import { APP_NAME } from '@daily-basket/constants';
import { QueryProvider } from '../providers/QueryProvider';
import { ErrorBoundary } from '../components/common/ErrorBoundary';
import './globals.css';

export const metadata = {
  title: `${APP_NAME} | 10-Minute Instant Grocery Delivery`,
  description: 'Single-store quick-commerce daily grocery platform.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className="bg-slate-900 text-slate-100 antialiased min-h-screen">
        <ErrorBoundary>
          <QueryProvider>
            {children}
          </QueryProvider>
        </ErrorBoundary>
      </body>
    </html>
  );
}
