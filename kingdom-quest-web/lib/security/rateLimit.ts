/**
 * lib/security/rateLimit.ts
 *
 * Lightweight, zero-dependency, in-memory sliding-window rate limiter.
 *
 * OWASP references:
 *  - OWASP ASVS 4.0 §13.2.6 — Ensure rate limiting is applied on all public API endpoints.
 *  - OWASP API Security Top 10 #4 — Lack of Resources & Rate Limiting.
 *
 * Strategy:
 *  - One sliding window per (key + namespace) pair.
 *  - Key = authenticated user-id when available, otherwise IP address.
 *    This prevents an attacker from bypassing IP limits by rotating IPs once
 *    they are logged in, and protects unauthenticated endpoints by IP.
 *  - Old entries are pruned on each check to avoid unbounded memory growth.
 *
 * Limitations:
 *  - Resets on process restart (suitable for single-instance deployments or
 *    development).  For multi-instance / edge environments swap the Map for
 *    a Redis / Upstash store using the same interface.
 */

interface RateLimitWindow {
  /** Timestamps (ms) of each request in the current window */
  timestamps: number[]
}

// Module-level store — persists across hot-reloads in dev and across requests
// in the same Node.js process.
const store = new Map<string, RateLimitWindow>()

export interface RateLimitConfig {
  /** Maximum number of requests allowed within `windowMs` */
  limit: number
  /** Sliding window duration in milliseconds */
  windowMs: number
  /**
   * Namespace isolates different endpoints so a burst on /login does not
   * consume quota for /register, etc.
   */
  namespace: string
}

export interface RateLimitResult {
  /** true → request is within limit; false → limit exceeded */
  allowed: boolean
  /** How many requests remain in the current window */
  remaining: number
  /** Epoch-ms timestamp when the oldest request in the window will expire */
  resetAt: number
}

/**
 * Check whether a request identified by `key` is within the rate limit.
 *
 * @param key       Unique identifier for the requester (user ID or IP address).
 * @param config    Rate-limit configuration for this endpoint.
 */
export function checkRateLimit(
  key: string,
  config: RateLimitConfig
): RateLimitResult {
  const { limit, windowMs, namespace } = config
  const storeKey = `${namespace}:${key}`
  const now = Date.now()
  const windowStart = now - windowMs

  // Retrieve or initialise the window for this key
  const window = store.get(storeKey) ?? { timestamps: [] }

  // Prune timestamps that fall outside the sliding window
  window.timestamps = window.timestamps.filter((ts) => ts > windowStart)

  const currentCount = window.timestamps.length

  if (currentCount >= limit) {
    // Oldest timestamp in window tells us when the first slot frees up
    const resetAt = window.timestamps[0] + windowMs
    store.set(storeKey, window)
    return { allowed: false, remaining: 0, resetAt }
  }

  // Record this request
  window.timestamps.push(now)
  store.set(storeKey, window)

  return {
    allowed: true,
    remaining: limit - window.timestamps.length,
    resetAt: window.timestamps[0] + windowMs,
  }
}

/**
 * Convenience: build a `Response` (Next.js compatible) for a 429 Too Many Requests.
 *
 * Includes standard headers:
 *  - Retry-After        (seconds until the window resets)
 *  - X-RateLimit-Limit
 *  - X-RateLimit-Remaining
 *  - X-RateLimit-Reset  (Unix timestamp)
 */
export function rateLimitExceededResponse(
  result: RateLimitResult,
  config: RateLimitConfig
): Response {
  const retryAfterSeconds = Math.ceil((result.resetAt - Date.now()) / 1000)
  return new Response(
    JSON.stringify({
      error: 'Too many requests. Please wait and try again.',
      retryAfterSeconds,
    }),
    {
      status: 429,
      headers: {
        'Content-Type': 'application/json',
        'Retry-After': String(retryAfterSeconds),
        'X-RateLimit-Limit': String(config.limit),
        'X-RateLimit-Remaining': '0',
        'X-RateLimit-Reset': String(Math.ceil(result.resetAt / 1000)),
      },
    }
  )
}

/**
 * Extract the best available IP address from a Next.js request.
 * Respects the `x-forwarded-for` header set by reverse proxies / Vercel.
 */
export function getClientIp(request: Request): string {
  // x-forwarded-for may contain a comma-separated list; first value is the
  // originating client IP.
  const forwarded = (request.headers as Headers).get('x-forwarded-for')
  if (forwarded) {
    return forwarded.split(',')[0].trim()
  }
  // Fallback — real-ip header used by some proxies
  const realIp = (request.headers as Headers).get('x-real-ip')
  if (realIp) return realIp.trim()
  // Ultimate fallback (never reaches here in Vercel/Node.js, but keeps types happy)
  return '127.0.0.1'
}

// ── Pre-configured limiters for reuse across route handlers ─────────────────

/** Auth endpoints (login, register, reset): 10 attempts per 15 minutes per IP */
export const AUTH_RATE_LIMIT: RateLimitConfig = {
  limit: 10,
  windowMs: 15 * 60 * 1000,
  namespace: 'auth',
}

/** Content creation endpoints (prayer, petition, advice): 20 per hour per user */
export const CONTENT_RATE_LIMIT: RateLimitConfig = {
  limit: 20,
  windowMs: 60 * 60 * 1000,
  namespace: 'content',
}

/** General read endpoints: 120 per minute per IP */
export const READ_RATE_LIMIT: RateLimitConfig = {
  limit: 120,
  windowMs: 60 * 1000,
  namespace: 'read',
}
