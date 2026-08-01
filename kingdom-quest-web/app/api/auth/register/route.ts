/**
 * app/api/auth/register/route.ts
 *
 * Server-side registration endpoint that adds:
 *  1. Rate limiting — 10 attempts / 15 min per IP (prevents mass account creation)
 *  2. Input validation — email, password strength, display name, gender enum
 *  3. Unexpected field rejection (mass-assignment protection)
 *
 * The existing client-side register page (register/page.tsx) continues to work
 * unchanged; this route is used by programmatic / API consumers.
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
  validateRegisterPayload,
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

  const { errors, data } = validateRegisterPayload(body)
  if (errors.length) return validationErrorResponse(errors)

  // ── 3. Create user via Supabase ────────────────────────────────────────────
  const supabase = await createClient()
  const { error } = await supabase.auth.signUp({
    email: data!.email,
    password: data!.password,
    options: {
      data: {
        display_name: data!.displayName,
        gender: data!.gender,
      },
    },
  })

  if (error) {
    // Generic message — do not reveal if email is already registered
    // (OWASP ASVS §2.2.2 / account enumeration prevention)
    return NextResponse.json(
      { error: 'Registration failed. Please try again later.' },
      { status: 400 }
    )
  }

  return NextResponse.json(
    { success: true, message: 'Account created. Please check your email to confirm.' },
    { status: 201 }
  )
}
