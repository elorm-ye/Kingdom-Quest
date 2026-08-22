# Kingdom Quest — Web App

> A safe, sacred space for youth ministry — prayer requests, spiritual advice, daily inspiration, community forum, events, and more.

Built with **Next.js 16**, **Supabase**, and **Firebase Cloud Messaging**.

---

## Features

- 🙏 **Prayer Requests** — submit and view community prayer requests with anonymous posting
- 📜 **Petitions** — raise feedback, ideas, or grievances to church leadership
- 💬 **Spiritual Advice** — seek guidance from church leaders with admin responses
- ✨ **Daily Inspiration** — devotionals, verses, challenges, and testimonies
- 🗣️ **Community Forum** — anonymous, vote-ranked discussion board with moderation
- 📅 **Events** — church event listings with registration
- 🔔 **Push Notifications** — Firebase Cloud Messaging (web + mobile)
- 🛡️ **Admin Dashboard** — manage users, moderate content, respond to requests
- 📲 **PWA** — installable on desktop and mobile

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Next.js 16 (App Router) |
| Auth & Database | Supabase (PostgreSQL + Row Level Security) |
| Styling | Tailwind CSS v4 |
| Push Notifications | Firebase Cloud Messaging |
| Icons | Lucide React |
| Language | TypeScript |

---

## Getting Started

### 1. Install Dependencies

```bash
cd kingdom-quest-web
npm install
```

### 2. Configure Environment Variables

```bash
cp .env.local.example .env.local
```

Open `.env.local` and fill in your values:

| Variable | Where to Get It |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase Dashboard → Project Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase Dashboard → Project Settings → API |
| `NEXT_PUBLIC_FIREBASE_API_KEY` | Firebase Console → Project settings → Your apps → Web |
| `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` | Same as above |
| `NEXT_PUBLIC_FIREBASE_PROJECT_ID` | Same as above |
| `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` | Same as above |
| `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` | Same as above |
| `NEXT_PUBLIC_FIREBASE_APP_ID` | Same as above |
| `NEXT_PUBLIC_FIREBASE_VAPID_KEY` | Firebase Console → Project settings → Cloud Messaging → Web Push certificates |

> **Never commit `.env.local`** — it is git-ignored. Only `.env.local.example` (which contains no secrets) is committed.

### 3. Run the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

---

## Project Structure

```
kingdom-quest-web/
├── app/
│   ├── api/                        # Secured server-side API routes
│   │   ├── auth/
│   │   │   ├── login/route.ts      # Rate-limited login endpoint
│   │   │   └── register/route.ts   # Rate-limited registration endpoint
│   │   ├── prayer-requests/route.ts
│   │   ├── petitions/route.ts
│   │   ├── advice-requests/route.ts
│   │   └── firebase-config/route.ts # Safe config for the service worker
│   ├── login/          # Login page (client-side)
│   ├── register/       # Registration page (client-side)
│   ├── home/           # Protected home screen
│   ├── prayer-requests/
│   ├── petitions/
│   ├── advice/
│   ├── inspiration/
│   ├── forum/
│   ├── events/
│   ├── notifications/
│   ├── profile/
│   └── admin/          # Admin-only dashboard
├── components/
│   ├── layout/         # Navigation, shell
│   ├── pages/          # Page-level components (client)
│   │   └── admin/
│   └── providers/
│       └── AuthProvider.tsx
├── lib/
│   ├── supabase/
│   │   ├── client.ts   # Browser Supabase client
│   │   └── server.ts   # Server-side Supabase client (SSR)
│   ├── firebase/
│   │   └── client.ts   # FCM — keys loaded from env vars
│   ├── security/
│   │   ├── rateLimit.ts    # Sliding-window rate limiter
│   │   └── validation.ts   # Schema validation & sanitization
│   └── types/
│       └── index.ts    # Shared TypeScript types
├── public/
│   ├── firebase-messaging-sw.js  # FCM background service worker
│   └── icons/
├── proxy.ts            # Next.js proxy (session refresh + route guard + rate limiting)
├── next.config.ts      # Security headers (CSP, HSTS, etc.)
└── .env.local.example  # Environment variable template (safe to commit)
```

---

## Security Architecture

This app follows **OWASP ASVS 4.0** and **OWASP Top 10 2021** guidelines.

### Rate Limiting

Implemented in `lib/security/rateLimit.ts` using an in-memory sliding-window algorithm.

| Endpoint | Strategy | Limit |
|---|---|---|
| `POST /api/auth/login` | Per IP | 10 req / 15 min |
| `POST /api/auth/register` | Per IP | 10 req / 15 min |
| `/login`, `/register` pages | Per IP | 30 req / 15 min |
| `POST` content endpoints | Per authenticated user-ID | 20 req / hour |
| `GET` content endpoints | Per IP | 120 req / min |

Rate-limited responses return **HTTP 429** with `Retry-After`, `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and `X-RateLimit-Reset` headers.

> For multi-instance / edge deployments, swap the in-memory `Map` in `rateLimit.ts` for an [Upstash Redis](https://upstash.com/) store.

### Input Validation

All API route handlers use `lib/security/validation.ts`:
- **Allowlist field checking** — unexpected fields are rejected (mass-assignment protection)
- **Type checks** — strings, booleans, and enum values are strictly validated
- **Length limits** — all text fields are bounded (e.g. email ≤ 254 chars, description ≤ 2,000 chars)
- **HTML stripping** — all user-supplied text has HTML tags removed and XSS chars encoded before storage

### API Key Handling

- All Firebase and Supabase credentials are loaded from **environment variables** — no hardcoded values in source code
- Firebase Web SDK keys (`NEXT_PUBLIC_*`) are public by design (identified by domain + Security Rules), but kept out of source control for clean environment separation
- The service worker obtains its Firebase config from `/api/firebase-config` rather than reading hardcoded values from the public directory
- **Server-only secrets** (e.g. service-role key) must only ever be used in API routes / Server Components, never in `NEXT_PUBLIC_` variables

### HTTP Security Headers (`next.config.ts`)

| Header | Value |
|---|---|
| `Content-Security-Policy` | Per-source whitelist (self, Supabase, gstatic, Google Fonts) |
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` | `DENY` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | Camera, mic, geo, payment, USB all disabled |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` (production) |
| `X-Powered-By` | Removed (prevents server fingerprinting) |

### Authentication & Session Management

- Sessions managed entirely by **Supabase Auth** with secure `HttpOnly` cookies via `@supabase/ssr`
- Proxy (`proxy.ts`) refreshes the session token on every request
- All protected routes redirect to `/login` when no valid session is present
- Admin routes additionally verify `profile.role === 'admin'` client-side (with server-side RLS as the authoritative control)

---

## API Reference

All API routes are under `/api/` and return JSON.

### `POST /api/auth/login`
```json
{ "email": "user@example.com", "password": "secret" }
```
Returns `200` on success, `401` on invalid credentials, `429` when rate-limited.

### `POST /api/auth/register`
```json
{ "email": "user@example.com", "password": "secret", "displayName": "Jane", "gender": "female" }
```
Returns `201` on success. `gender` must be one of `male | female | preferNotToSay`.

### `GET /api/prayer-requests`
Returns latest 50 prayer requests with responses. Requires valid session.

### `POST /api/prayer-requests`
```json
{ "title": "...", "description": "...", "category": "healing", "isAnonymous": false }
```

### `GET /api/petitions` / `POST /api/petitions`
```json
{ "subject": "...", "description": "...", "isAnonymous": true }
```

### `GET /api/advice-requests` / `POST /api/advice-requests`
```json
{ "title": "...", "description": "...", "isAnonymous": false }
```

All `POST` endpoints require authentication and return `400` with field-level error details on validation failure.

---

## Deployment

### Vercel (Recommended)

1. Push to GitHub
2. Import the repo in [Vercel](https://vercel.com)
3. Set all environment variables from `.env.local.example` in the Vercel project settings
4. Deploy

### Environment Variables for Production

All `NEXT_PUBLIC_*` variables must be set in your hosting platform's environment configuration. Never rely on the `.env.local` file in production.

---

## Contributing

1. Branch from `main`
2. Run `npm run lint` before committing
3. Never commit secrets or `.env.local`
4. Follow the existing OWASP-aligned patterns in `lib/security/`
