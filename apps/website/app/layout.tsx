import React from 'react';
import { APP_NAME } from '@daily-basket/constants';
import { QueryProvider } from '../providers/QueryProvider';
import { ErrorBoundary } from '../components/common/ErrorBoundary';
import QuickNavMenu from '../components/navigation/QuickNavMenu';
import './globals.css';

export const metadata = {
  title: `${APP_NAME} | 10-Minute Instant Grocery Delivery`,
  description: 'Fresh groceries, daily essentials, and exclusive offers delivered to your doorstep in 10 minutes.',
  keywords: 'grocery delivery, quick commerce, 10 minute delivery, fresh groceries, daily basket',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Outfit:wght@500;600;700&family=Inter:wght@400;500;600&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
          rel="stylesheet"
        />
        <script
          src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAOVYRIgupAurZup5y1PRh8Ismb1A3lLao&libraries=places"
          async
          defer
        ></script>
      </head>
      <body className="bg-background text-on-background font-body-lg antialiased min-h-screen">
        <ErrorBoundary>
          <QueryProvider>
            {children}
            <QuickNavMenu />
          </QueryProvider>
        </ErrorBoundary>
      </body>
    </html>
  );
}
