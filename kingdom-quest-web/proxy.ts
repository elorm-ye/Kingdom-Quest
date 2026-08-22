/**
 * proxy.ts — Next.js 16 Edge Proxy (formerly middleware.ts)
 *
 * In Next.js 16+, the "proxy" file convention replaces "middleware".
 * This file is auto-loaded by Next.js from the project root.
 *
 * Responsibilities:
 *  1. Supabase session refresh on every request (required for SSR auth).
 *  2. Route protection — redirect unauthenticated users to /login.
 *  3. Rate limiting on auth pages — prevent brute-force via browser navigation.
 *  4. Standard security headers forwarded to all responses (belt-and-suspenders
 *     on top of next.config.ts headers, which are set per-route).
 *
 * OWASP references:
 *  - OWASP ASVS 4.0 §13.2.6 — Rate limiting on all public endpoints.
 *  - OWASP ASVS 4.0 §3.3   — Session management and invalidation.
 */

import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'
import {
  checkRateLimit,
  rateLimitExceededResponse,
  getClientIp,
  AUTH_RATE_LIMIT,
} from '@/lib/security/rateLimit'

export default async function proxy(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  // Refresh session — IMPORTANT: do not remove this block.
  // It keeps the Supabase session cookie fresh on every request.
  const {
    data: { user },
  } = await supabase.auth.getUser()

  const { pathname } = request.nextUrl

  // ── Rate limiting on auth pages ──────────────────────────────────────────
  // Applies to the login and register pages (browser-based navigation).
  // This complements the /api/auth/* route rate limits.
  const isAuthPage = pathname.startsWith('/login') || pathname.startsWith('/register')
  if (isAuthPage) {
    const ip = getClientIp(request)
    // Use a lighter limit for page views (30 req / 15 min) to allow normal
    // browser usage while still blocking automated scanners.
    const authPageLimit = { ...AUTH_RATE_LIMIT, limit: 30, namespace: 'auth-page' }
    const rlResult = checkRateLimit(ip, authPageLimit)
    if (!rlResult.allowed) {
      return rateLimitExceededResponse(rlResult, authPageLimit)
    }
  }

  // ── Route protection ─────────────────────────────────────────────────────
  const isProtected =
    pathname.startsWith('/home') ||
    pathname.startsWith('/prayer-requests') ||
    pathname.startsWith('/petitions') ||
    pathname.startsWith('/advice') ||
    pathname.startsWith('/inspiration') ||
    pathname.startsWith('/forum') ||
    pathname.startsWith('/events') ||
    pathname.startsWith('/notifications') ||
    pathname.startsWith('/profile') ||
    pathname.startsWith('/admin')

  // Not signed in → redirect to login
  if (!user && isProtected) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // Signed in → skip auth pages
  if (user && isAuthPage) {
    const url = request.nextUrl.clone()
    url.pathname = '/home'
    return NextResponse.redirect(url)
  }

  // Root → redirect to home or login
  if (pathname === '/') {
    const url = request.nextUrl.clone()
    url.pathname = user ? '/home' : '/login'
    return NextResponse.redirect(url)
  }

  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|icons|manifest.json|sw.js|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
