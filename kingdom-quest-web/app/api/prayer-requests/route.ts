/**
 * app/api/prayer-requests/route.ts
 *
 * Secured prayer-request content API.
 *
 * GET  — returns a paginated list (rate-limited by IP: 120 req/min)
 * POST — submits a new prayer request (auth required, 20 submissions/hour per user)
 *
 * Security measures applied:
 *  - Rate limiting (IP for GET, user-id for POST)
 *  - Authentication check before any write
 *  - Schema validation + field whitelist (mass-assignment protection)
 *  - Sanitized strings stored to DB (no raw HTML)
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
  validatePrayerRequestPayload,
  validationErrorResponse,
} from '@/lib/security/validation'

// ── GET /api/prayer-requests ─────────────────────────────────────────────────
export async function GET(request: NextRequest) {
  // Rate limit reads by IP
  const ip = getClientIp(request)
  const rlResult = checkRateLimit(ip, READ_RATE_LIMIT)
  if (!rlResult.allowed) {
    return rateLimitExceededResponse(rlResult, READ_RATE_LIMIT)
  }

  const supabase = await createClient()
  const { data, error } = await supabase
    .from('prayer_requests')
    .select('*, prayer_responses(*)')
    .order('created_at', { ascending: false })
    .limit(50) // Server-enforced page size

  if (error) {
    return NextResponse.json({ error: 'Failed to load prayer requests.' }, { status: 500 })
  }

  return NextResponse.json({ data }, { status: 200 })
}

// ── POST /api/prayer-requests ────────────────────────────────────────────────
export async function POST(request: NextRequest) {
  const supabase = await createClient()

  // ── 1. Authentication ──────────────────────────────────────────────────────
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Authentication required.' }, { status: 401 })
  }

  // ── 2. Rate limit by authenticated user-id ─────────────────────────────────
  // Using the user-id (not IP) so VPN/proxy rotation doesn't bypass the limit.
  const rlResult = checkRateLimit(user.id, CONTENT_RATE_LIMIT)
  if (!rlResult.allowed) {
    return rateLimitExceededResponse(rlResult, CONTENT_RATE_LIMIT)
  }

  // ── 3. Parse + validate body ───────────────────────────────────────────────
  let body: unknown
  try {
    body = await request.json()
  } catch {
    return NextResponse.json({ error: 'Invalid JSON body.' }, { status: 400 })
  }

  const { errors, data } = validatePrayerRequestPayload(body)
  if (errors.length) return validationErrorResponse(errors)

  // ── 4. Fetch profile for display_name ─────────────────────────────────────
  const { data: profile } = await supabase
    .from('profiles')
    .select('display_name')
    .eq('id', user.id)
    .single()

  // ── 5. Write to DB with sanitized data only ────────────────────────────────
  const { error: insertError } = await supabase
    .from('prayer_requests')
    .insert({
      user_id: user.id,
      title: data!.title,
      description: data!.description,
      category: data!.category,
      is_anonymous: data!.isAnonymous,
      // Only store display_name if user chose not to be anonymous
      display_name: data!.isAnonymous ? null : (profile?.display_name ?? null),
      status: 'pending',
      prayer_count: 0,
    })

  if (insertError) {
    return NextResponse.json({ error: 'Failed to submit prayer request.' }, { status: 500 })
  }

  return NextResponse.json({ success: true }, { status: 201 })
}
