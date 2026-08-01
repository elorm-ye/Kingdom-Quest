/**
 * app/api/firebase-config/route.ts
 *
 * Returns the public Firebase client config as JSON.
 *
 * This endpoint is consumed by the service worker (firebase-messaging-sw.js)
 * which cannot access Next.js environment variables directly.
 *
 * ── SECURITY NOTES ────────────────────────────────────────────────────────────
 *  - Only NEXT_PUBLIC_ values are returned — these are public by design and
 *    already embedded in the client bundle by Next.js.
 *  - No secrets, service-account keys, or private data are ever returned here.
 *  - The response is cache-controlled to reduce latency on repeat SW activations.
 *  - OWASP ASVS §2.10 — Service credentials must not be hard-coded.
 */

import { NextResponse } from 'next/server'

export async function GET() {
  // All six Firebase config values are public web SDK identifiers, NOT secrets.
  // They are already inlined by Next.js into the client JS bundle via
  // NEXT_PUBLIC_ prefix; returning them here makes them accessible to the SW.
  const config = {
    apiKey:            process.env.NEXT_PUBLIC_FIREBASE_API_KEY            ?? '',
    authDomain:        process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN        ?? '',
    projectId:         process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID         ?? '',
    storageBucket:     process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET     ?? '',
    messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID ?? '',
    appId:             process.env.NEXT_PUBLIC_FIREBASE_APP_ID              ?? '',
  }

  return NextResponse.json(config, {
    status: 200,
    headers: {
      // Cache for 1 hour — these values rarely change and the SW fetches this
      // on every activation event.
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400',
    },
  })
}
