/**
 * app/api/auth/login/route.ts
 *
 * Server-side login endpoint that adds:
 *  1. Rate limiting  — 10 attempts / 15 min per IP (OWASP ASVS §2.2.1)
 *  2. Input validation — email format, length limits, unexpected-field rejection
 *  3. Generic error messages — never reveal whether email exists (OWASP ASVS §2.2.2)
 *
 * The existing client-side login (login/page.tsx) continues to work unchanged;
 * this route is the authoritative server-side path for programmatic / API consumers.
 */

import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import {
  checkRateLimit,
  rateLimitExceededResponse,
  getClientIp,
  AUTH_RATE_LIMIT,
} from '@/lib/security/rateLimit'
import {
  validateLoginPayload,
  validationErrorResponse,
} from '@/lib/security/validation'

export async function POST(request: NextRequest) {
  // ── 1. Rate limit by IP ────────────────────────────────────────────────────
  const ip = getClientIp(request)
  const rlResult = checkRateLimit(ip, AUTH_RATE_LIMIT)
  if (!rlResult.allowed) {
    return rateLimitExceededResponse(rlResult, AUTH_RATE_LIMIT)
  }

  // ── 2. Parse + validate body ───────────────────────────────────────────────
  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body.' }, { status: 400 })
  }

  const { errors, data } = validateLoginPayload(body)
  if (errors.length) return validationErrorResponse(errors)

  // ── 3. Authenticate via Supabase ───────────────────────────────────────────
  const supabase = await createClient()
  const { error } = await supabase.auth.signInWithPassword({
    email: data!.email,
    password: data!.password,
  })

  if (error) {
    // OWASP ASVS §2.2.2 — use a generic message regardless of the actual reason
    // (wrong password, unconfirmed email, account disabled, etc.)
    return NextResponse.json(
      { error: 'Invalid credentials. Please check your email and password.' },
      { status: 401 }
    )
  }

  return NextResponse.json({ success: true }, { status: 200 })
}
