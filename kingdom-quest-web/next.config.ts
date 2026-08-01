/**
 * next.config.ts
 *
 * Next.js configuration with hardened HTTP security headers.
 *
 * ── Security Headers Applied ──────────────────────────────────────────────────
 * OWASP references:
 *  - OWASP Secure Headers Project (https://owasp.org/www-project-secure-headers/)
 *  - OWASP ASVS 4.0 §14.4 — HTTP Security Headers
 *
 * Headers explained:
 *  Content-Security-Policy  — whitelist of allowed sources; blocks XSS / data injection.
 *  X-Frame-Options          — prevents clickjacking (superseded by CSP frame-ancestors,
 *                             included for legacy browser support).
 *  X-Content-Type-Options   — prevents MIME-sniffing attacks.
 *  Referrer-Policy          — limits referrer data leakage to third parties.
 *  Permissions-Policy       — opt-out of browser features not used by this app.
 *  Strict-Transport-Security— forces HTTPS (applied on production only via the
 *                             includeSubDomains + preload flags).
 *
 * IMPORTANT: The CSP `script-src` directive below includes `'unsafe-inline'`
 * because Next.js inline scripts are required for hydration. When you add a
 * nonce-based CSP in the future, remove `'unsafe-inline'` and inject the nonce
 * via middleware. See: https://nextjs.org/docs/app/building-your-application/configuring/content-security-policy
 */

import type { NextConfig } from 'next'

const isDev = process.env.NODE_ENV === 'development'

/**
 * Content Security Policy directives.
 * Adjust the whitelist as your third-party integrations grow.
 */
const cspDirectives = [
  // Default fallback — only allow same-origin resources
  "default-src 'self'",

  // Scripts: self + Next.js inline hydration + Firebase SDK CDN (service worker)
  // In production, tighten by replacing 'unsafe-inline' with a nonce.
  "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.gstatic.com",

  // Styles: self + inline (Tailwind / CSS-in-JS)
  "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",

  // Fonts
  "font-src 'self' https://fonts.gstatic.com",

  // Images: self + Supabase storage + data URIs (avatars)
  "img-src 'self' data: blob: https://*.supabase.co https://*.supabase.in",

  // Fetch/XHR: Supabase API + Firebase (FCM)
  `connect-src 'self' https://*.supabase.co https://*.supabase.in wss://*.supabase.co https://fcm.googleapis.com https://firebaseinstallations.googleapis.com ${isDev ? 'ws://localhost:*' : ''}`,

  // Workers: self + blob (Next.js service worker)
  "worker-src 'self' blob:",

  // Manifest
  "manifest-src 'self'",

  // Prevent embedding in iframes (clickjacking defence)
  "frame-ancestors 'none'",

  // Only allow form submissions to same origin
  "form-action 'self'",

  // Block mixed content (HTTP resources on HTTPS pages)
  "upgrade-insecure-requests",
].join('; ')

const securityHeaders = [
  // Prevent MIME-type sniffing — browsers must honour the declared Content-Type
  { key: 'X-Content-Type-Options', value: 'nosniff' },

  // Block clickjacking (legacy browser fallback; frame-ancestors in CSP is primary)
  { key: 'X-Frame-Options', value: 'DENY' },

  // Limit referrer information sent to third-party sites
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },

  // Restrict access to powerful browser APIs not used by this app
  {
    key: 'Permissions-Policy',
    value: [
      'camera=()',          // camera not used
      'microphone=()',      // microphone not used
      'geolocation=()',     // geolocation not used
      'payment=()',         // payment not used
      'usb=()',             // USB access not used
    ].join(', '),
  },

  // Content Security Policy (see directives above)
  { key: 'Content-Security-Policy', value: cspDirectives },

  // HTTP Strict Transport Security — forces HTTPS for 1 year
  // Only applied in production to avoid breaking local http:// dev server.
  ...(!isDev
    ? [
        {
          key: 'Strict-Transport-Security',
          value: 'max-age=31536000; includeSubDomains; preload',
        },
      ]
    : []),
]

const nextConfig: NextConfig = {
  // Apply security headers to all routes
  async headers() {
    return [
      {
        // Apply to every page and API route
        source: '/(.*)',
        headers: securityHeaders,
      },
    ]
  },

  // Disable the "X-Powered-By: Next.js" header — avoids fingerprinting
  poweredByHeader: false,
}

export default nextConfig
