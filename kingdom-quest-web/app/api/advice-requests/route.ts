/**
 * app/api/advice-requests/route.ts
 *
 * Secured spiritual-advice request API.
 *
 * GET  — rate-limited list (120 req/min per IP)
 * POST — auth-required submission (20/hour per user)
 *
 * Security measures applied:
 *  - Rate limiting (IP for GET, user-id for POST)
 *  - Authentication check before any write
 *  - Schema validation + field whitelist (mass-assignment protection)
 *  - Sanitized strings stored to DB
 */

import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import {
  checkRateLimit,
  rateLimitExceededResponse,
  getClientIp,
  READ_RATE_LIMIT,
  CONTENT_RATE_LIMIT,
} from '@/lib/security/rateLimit'
import {
  validateAdviceRequestPayload,
  validationErrorResponse,
} from '@/lib/security/validation'

// ── GET /api/advice-requests ─────────────────────────────────────────────────
export async function GET(request: NextRequest) {
  const ip = getClientIp(request)
  const rlResult = checkRateLimit(ip, READ_RATE_LIMIT)
  if (!rlResult.allowed) {
    return rateLimitExceededResponse(rlResult, READ_RATE_LIMIT)
  }

  const supabase = await createClient()
  const { data, error } = await supabase
    .from('advice_requests')
    .select('*, advice_responses(*)')
    .order('created_at', { ascending: false })
    .limit(50)

  if (error) {
    return NextResponse.json({ error: 'Failed to load advice requests.' }, { status: 500 })
  }

  return NextResponse.json({ data }, { status: 200 })
}

// ── POST /api/advice-requests ────────────────────────────────────────────────
export async function POST(request: NextRequest) {
  const supabase = await createClient()

  // ── 1. Authentication ──────────────────────────────────────────────────────
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Authentication required.' }, { status: 401 })
  }

  // ── 2. Rate limit by user-id ───────────────────────────────────────────────
  const rlResult = checkRateLimit(user.id, CONTENT_RATE_LIMIT)
  if (!rlResult.allowed) {
    return rateLimitExceededResponse(rlResult, CONTENT_RATE_LIMIT)
  }

  // ── 3. Parse + validate ────────────────────────────────────────────────────
  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body.' }, { status: 400 })
  }

  const { errors, data } = validateAdviceRequestPayload(body)
  if (errors.length) return validationErrorResponse(errors)

  // ── 4. Fetch display name ──────────────────────────────────────────────────
  const { data: profile } = await supabase
    .from('profiles')
    .select('display_name')
    .eq('id', user.id)
    .single()

  // ── 5. Insert sanitized data ───────────────────────────────────────────────
  const { error: insertError } = await supabase
    .from('advice_requests')
    .insert({
      user_id: user.id,
      title: data!.title,
      description: data!.description,
      is_anonymous: data!.isAnonymous,
      display_name: data!.isAnonymous ? null : (profile?.display_name ?? null),
      status: 'pending',
    })

  if (insertError) {
    return NextResponse.json({ error: 'Failed to submit advice request.' }, { status: 500 })
  }

  return NextResponse.json({ success: true }, { status: 201 })
}
