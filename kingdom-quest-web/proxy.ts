import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

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

  // Refresh session — IMPORTANT: do not remove this
  const {
    data: { user },
  } = await supabase.auth.getUser()

  const { pathname } = request.nextUrl

  const isAuthPage = pathname.startsWith('/login') || pathname.startsWith('/register')
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
