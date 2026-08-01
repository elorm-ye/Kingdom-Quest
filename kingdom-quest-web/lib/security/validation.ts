/**
 * lib/security/validation.ts
 *
 * Schema-based input validation and sanitization utilities.
 *
 * OWASP references:
 *  - OWASP ASVS 4.0 §5.1 — Input Validation Requirements.
 *  - OWASP Input Validation Cheat Sheet — whitelist approach, normalise, then validate.
 *  - OWASP XSS Prevention Cheat Sheet — strip/encode HTML in user-supplied strings.
 *
 * Design decisions:
 *  - No runtime schema library dependency (Zod/Yup) to keep the bundle lean.
 *    All schemas are plain TypeScript so they compile away completely.
 *  - Each field validator returns a typed `FieldError | null` so callers can
 *    surface precise, field-level errors to the UI.
 *  - Sanitization (strip leading/trailing whitespace, collapse internal spaces,
 *    remove HTML tags) is applied before any length check so limits are
 *    measured on the "clean" value — preventing bypass via padding.
 */

// ── Constants ────────────────────────────────────────────────────────────────

/** Maximum field lengths (characters, after trimming). */
export const MAX_LENGTHS = {
  email: 254,        // RFC 5321 maximum
  password: 128,     // Practical upper bound; prevents DoS via bcrypt
  displayName: 80,
  bio: 500,
  title: 120,
  description: 2000,
  subject: 120,
  message: 3000,
  category: 50,
  searchQuery: 200,
} as const

/** Allowed gender values — reject unexpected enum values. */
export const ALLOWED_GENDERS = ['male', 'female', 'preferNotToSay'] as const
export type AllowedGender = (typeof ALLOWED_GENDERS)[number]

/** Allowed prayer-request status values. */
export const ALLOWED_PRAYER_STATUSES = ['pending', 'praying', 'answered'] as const

/** Allowed advice-request status values. */
export const ALLOWED_ADVICE_STATUSES = ['pending', 'in_progress', 'completed'] as const

/** Allowed petition status values. */
export const ALLOWED_PETITION_STATUSES = ['pending', 'under_review', 'resolved'] as const

/** Simple email pattern — intentionally lenient; real deliverability checked by Supabase. */
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

// ── Sanitizers ───────────────────────────────────────────────────────────────

/**
 * Strip HTML tags and encode common XSS vectors.
 * This is a defence-in-depth measure; the database layer (Supabase RLS) and
 * output escaping in React are the primary XSS defences.
 */
export function stripHtml(value: string): string {
  return value
    .replace(/<[^>]*>/g, '')        // remove HTML tags
    .replace(/&/g, '&amp;')         // encode ampersands
    .replace(/</g, '&lt;')          // encode angle brackets (belt-and-suspenders)
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;')
}

/**
 * Normalize a plain-text string:
 *  1. Trim surrounding whitespace.
 *  2. Collapse runs of whitespace (spaces, tabs) to a single space.
 *  3. Strip HTML tags and encode XSS chars.
 */
export function sanitizeText(value: unknown): string {
  if (typeof value !== 'string') return ''
  return stripHtml(value.trim().replace(/\s+/g, ' '))
}

/** Normalize an email address: lowercase + trim. */
export function sanitizeEmail(value: unknown): string {
  if (typeof value !== 'string') return ''
  return value.trim().toLowerCase()
}

// ── Field validators ─────────────────────────────────────────────────────────

export interface FieldError {
  field: string
  message: string
}

export function validateEmail(value: unknown, field = 'email'): FieldError | null {
  const email = sanitizeEmail(value)
  if (!email) return { field, message: 'Email is required.' }
  if (email.length > MAX_LENGTHS.email)
    return { field, message: `Email must not exceed ${MAX_LENGTHS.email} characters.` }
  if (!EMAIL_REGEX.test(email))
    return { field, message: 'Enter a valid email address.' }
  return null
}

export function validatePassword(value: unknown, field = 'password'): FieldError | null {
  if (typeof value !== 'string' || value.length === 0)
    return { field, message: 'Password is required.' }
  if (value.length < 6)
    return { field, message: 'Password must be at least 6 characters.' }
  if (value.length > MAX_LENGTHS.password)
    return { field, message: `Password must not exceed ${MAX_LENGTHS.password} characters.` }
  return null
}

export function validateDisplayName(value: unknown, field = 'display_name'): FieldError | null {
  const name = sanitizeText(value)
  if (!name) return { field, message: 'Display name is required.' }
  if (name.length > MAX_LENGTHS.displayName)
    return { field, message: `Display name must not exceed ${MAX_LENGTHS.displayName} characters.` }
  return null
}

export function validateGender(value: unknown, field = 'gender'): FieldError | null {
  if (!ALLOWED_GENDERS.includes(value as AllowedGender))
    return { field, message: `Gender must be one of: ${ALLOWED_GENDERS.join(', ')}.` }
  return null
}

export function validateTitle(value: unknown, field = 'title'): FieldError | null {
  const title = sanitizeText(value)
  if (!title) return { field, message: 'Title is required.' }
  if (title.length > MAX_LENGTHS.title)
    return { field, message: `Title must not exceed ${MAX_LENGTHS.title} characters.` }
  return null
}

export function validateDescription(value: unknown, field = 'description'): FieldError | null {
  const desc = sanitizeText(value)
  if (!desc) return { field, message: 'Description is required.' }
  if (desc.length > MAX_LENGTHS.description)
    return { field, message: `Description must not exceed ${MAX_LENGTHS.description} characters.` }
  return null
}

export function validateSubject(value: unknown, field = 'subject'): FieldError | null {
  const subj = sanitizeText(value)
  if (!subj) return { field, message: 'Subject is required.' }
  if (subj.length > MAX_LENGTHS.subject)
    return { field, message: `Subject must not exceed ${MAX_LENGTHS.subject} characters.` }
  return null
}

export function validateCategory(value: unknown, field = 'category'): FieldError | null {
  const cat = sanitizeText(value)
  if (!cat) return { field, message: 'Category is required.' }
  if (cat.length > MAX_LENGTHS.category)
    return { field, message: `Category must not exceed ${MAX_LENGTHS.category} characters.` }
  return null
}

// ── Schema validators ────────────────────────────────────────────────────────

/**
 * Validate and sanitize a login payload.
 * Returns `{ errors, data }` — errors is empty when valid.
 */
export function validateLoginPayload(body: unknown): {
  errors: FieldError[]
  data: { email: string; password: string } | null
} {
  const errors: FieldError[] = []

  // Type-guard: body must be a plain object
  if (typeof body !== 'object' || body === null || Array.isArray(body)) {
    return { errors: [{ field: 'body', message: 'Invalid request body.' }], data: null }
  }

  // Reject unexpected fields (OWASP — mass-assignment protection)
  const allowed = new Set(['email', 'password'])
  for (const key of Object.keys(body as Record<string, unknown>)) {
    if (!allowed.has(key)) {
      errors.push({ field: key, message: `Unexpected field: ${key}.` })
    }
  }
  if (errors.length) return { errors, data: null }

  const raw = body as Record<string, unknown>

  const emailErr = validateEmail(raw.email)
  if (emailErr) errors.push(emailErr)

  const passErr = validatePassword(raw.password)
  if (passErr) errors.push(passErr)

  if (errors.length) return { errors, data: null }

  return {
    errors: [],
    data: {
      email: sanitizeEmail(raw.email),
      password: raw.password as string,   // never sanitize passwords (trimming breaks them)
    },
  }
}

/**
 * Validate and sanitize a registration payload.
 */
export function validateRegisterPayload(body: unknown): {
  errors: FieldError[]
  data: { email: string; password: string; displayName: string; gender: AllowedGender } | null
} {
  const errors: FieldError[] = []

  if (typeof body !== 'object' || body === null || Array.isArray(body)) {
    return { errors: [{ field: 'body', message: 'Invalid request body.' }], data: null }
  }

  // Reject unexpected fields
  const allowed = new Set(['email', 'password', 'displayName', 'gender'])
  for (const key of Object.keys(body as Record<string, unknown>)) {
    if (!allowed.has(key)) {
      errors.push({ field: key, message: `Unexpected field: ${key}.` })
    }
  }
  if (errors.length) return { errors, data: null }

  const raw = body as Record<string, unknown>

  const emailErr = validateEmail(raw.email)
  if (emailErr) errors.push(emailErr)

  const passErr = validatePassword(raw.password)
  if (passErr) errors.push(passErr)

  const nameErr = validateDisplayName(raw.displayName)
  if (nameErr) errors.push(nameErr)

  const genderErr = validateGender(raw.gender)
  if (genderErr) errors.push(genderErr)

  if (errors.length) return { errors, data: null }

  return {
    errors: [],
    data: {
      email: sanitizeEmail(raw.email),
      password: raw.password as string,
      displayName: sanitizeText(raw.displayName),
      gender: raw.gender as AllowedGender,
    },
  }
}

/**
 * Validate and sanitize a prayer-request submission.
 */
export function validatePrayerRequestPayload(body: unknown): {
  errors: FieldError[]
  data: { title: string; description: string; category: string; isAnonymous: boolean } | null
} {
  const errors: FieldError[] = []

  if (typeof body !== 'object' || body === null || Array.isArray(body)) {
    return { errors: [{ field: 'body', message: 'Invalid request body.' }], data: null }
  }

  // Reject unexpected fields
  const allowed = new Set(['title', 'description', 'category', 'isAnonymous'])
  for (const key of Object.keys(body as Record<string, unknown>)) {
    if (!allowed.has(key)) {
      errors.push({ field: key, message: `Unexpected field: ${key}.` })
    }
  }
  if (errors.length) return { errors, data: null }

  const raw = body as Record<string, unknown>

  const titleErr = validateTitle(raw.title)
  if (titleErr) errors.push(titleErr)

  const descErr = validateDescription(raw.description)
  if (descErr) errors.push(descErr)

  const catErr = validateCategory(raw.category)
  if (catErr) errors.push(catErr)

  if (typeof raw.isAnonymous !== 'boolean') {
    errors.push({ field: 'isAnonymous', message: 'isAnonymous must be a boolean.' })
  }

  if (errors.length) return { errors, data: null }

  return {
    errors: [],
    data: {
      title: sanitizeText(raw.title),
      description: sanitizeText(raw.description),
      category: sanitizeText(raw.category),
      isAnonymous: raw.isAnonymous as boolean,
    },
  }
}

/**
 * Validate and sanitize a petition submission.
 */
export function validatePetitionPayload(body: unknown): {
  errors: FieldError[]
  data: { subject: string; description: string; isAnonymous: boolean } | null
} {
  const errors: FieldError[] = []

  if (typeof body !== 'object' || body === null || Array.isArray(body)) {
    return { errors: [{ field: 'body', message: 'Invalid request body.' }], data: null }
  }

  const allowed = new Set(['subject', 'description', 'isAnonymous'])
  for (const key of Object.keys(body as Record<string, unknown>)) {
    if (!allowed.has(key)) {
      errors.push({ field: key, message: `Unexpected field: ${key}.` })
    }
  }
  if (errors.length) return { errors, data: null }

  const raw = body as Record<string, unknown>

  const subjErr = validateSubject(raw.subject)
  if (subjErr) errors.push(subjErr)

  const descErr = validateDescription(raw.description)
  if (descErr) errors.push(descErr)

  if (typeof raw.isAnonymous !== 'boolean') {
    errors.push({ field: 'isAnonymous', message: 'isAnonymous must be a boolean.' })
  }

  if (errors.length) return { errors, data: null }

  return {
    errors: [],
    data: {
      subject: sanitizeText(raw.subject),
      description: sanitizeText(raw.description),
      isAnonymous: raw.isAnonymous as boolean,
    },
  }
}

/**
 * Validate and sanitize an advice-request submission.
 */
export function validateAdviceRequestPayload(body: unknown): {
  errors: FieldError[]
  data: { title: string; description: string; isAnonymous: boolean } | null
} {
  const errors: FieldError[] = []

  if (typeof body !== 'object' || body === null || Array.isArray(body)) {
    return { errors: [{ field: 'body', message: 'Invalid request body.' }], data: null }
  }

  const allowed = new Set(['title', 'description', 'isAnonymous'])
  for (const key of Object.keys(body as Record<string, unknown>)) {
    if (!allowed.has(key)) {
      errors.push({ field: key, message: `Unexpected field: ${key}.` })
    }
  }
  if (errors.length) return { errors, data: null }

  const raw = body as Record<string, unknown>

  const titleErr = validateTitle(raw.title)
  if (titleErr) errors.push(titleErr)

  const descErr = validateDescription(raw.description)
  if (descErr) errors.push(descErr)

  if (typeof raw.isAnonymous !== 'boolean') {
    errors.push({ field: 'isAnonymous', message: 'isAnonymous must be a boolean.' })
  }

  if (errors.length) return { errors, data: null }

  return {
    errors: [],
    data: {
      title: sanitizeText(raw.title),
      description: sanitizeText(raw.description),
      isAnonymous: raw.isAnonymous as boolean,
    },
  }
}

/**
 * Build a standard 400 Bad Request response from an array of field errors.
 */
export function validationErrorResponse(errors: FieldError[]): Response {
  return new Response(
    JSON.stringify({ error: 'Validation failed.', details: errors }),
    {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    }
  )
}
