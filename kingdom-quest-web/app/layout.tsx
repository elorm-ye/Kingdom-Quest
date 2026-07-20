import type { Metadata, Viewport } from 'next'
import { AuthProvider } from '@/components/providers/AuthProvider'
import { PWAInstallPrompt } from '@/components/PWAInstallPrompt'
import './globals.css'

export const metadata: Metadata = {
  title: {
    default: 'Kingdom Quest',
    template: '%s | Kingdom Quest',
  },
  description: 'A safe, sacred space for youth ministry — prayer requests, spiritual advice, daily inspiration, and community.',
  keywords: ['church', 'youth ministry', 'prayer', 'Christian', 'faith', 'community'],
  manifest: '/manifest.json',
  appleWebApp: {
    capable: true,
    statusBarStyle: 'black-translucent',
    title: 'Kingdom Quest',
  },
  openGraph: {
    type: 'website',
    title: 'Kingdom Quest',
    description: 'A safe, sacred space for youth ministry',
    siteName: 'Kingdom Quest',
  },
}

export const viewport: Viewport = {
  themeColor: '#B8614A',
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="apple-touch-icon" href="/icons/icon-192.png" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
      </head>
      <body>
        <AuthProvider>
          {children}
          <PWAInstallPrompt />
        </AuthProvider>
      </body>
    </html>
  )
}
