import React from 'react';

export const metadata = {
  title: 'Daily Basket | Delivery Partner Portal',
  description: 'Real-time order acceptance, GPS navigation, and earnings dashboard.',
};

export default function DeliveryLayout({
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
          href="https://fonts.googleapis.com/css2?family=Outfit:wght@500;600;700&family=Inter:wght@400;500;600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="bg-slate-50 text-slate-900 min-h-screen antialiased">
        {children}
      </body>
    </html>
  );
}
