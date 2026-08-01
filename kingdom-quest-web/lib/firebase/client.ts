/**
 * lib/firebase/client.ts
 *
 * Firebase Web SDK initialisation.
 *
 * ── SECURITY: API Key Handling ──────────────────────────────────────────────
 * Firebase Web API keys are intentionally client-side values: they identify
 * your project and are restricted by domain + Firebase Security Rules, NOT
 * kept secret.  That said, we still load them from environment variables to:
 *  1. Avoid committing project-specific identifiers to source control.
 *  2. Enable different Firebase projects per environment (dev / staging / prod).
 *  3. Follow the principle of least surprise for developers.
 *
 * All values use the `NEXT_PUBLIC_` prefix so Next.js inlines them at build
 * time — they are intentionally visible in the client bundle.
 *
 * NEVER put secret credentials (service account keys, SMTP passwords, etc.)
 * in `NEXT_PUBLIC_` variables.  Those belong in server-only env vars accessed
 * only in API routes / Server Components.
 *
 * How to configure:
 *  1. Copy `.env.local.example` → `.env.local`
 *  2. Fill in your values from the Firebase Console → Project settings → General
 *  3. Restart `next dev`
 *
 * OWASP references:
 *  - OWASP ASVS 4.0 §2.10 — Service credentials must not be hard-coded.
 *  - OWASP Top 10 A05:2021 — Security Misconfiguration.
 */

import { initializeApp, getApps } from 'firebase/app'
import { getMessaging, getToken, onMessage, isSupported } from 'firebase/messaging'
import { createClient } from '@/lib/supabase/client'

// ── Environment variable guard ──────────────────────────────────────────────
// All six Firebase config values are required.  Missing any will cause a
// descriptive error at startup rather than a cryptic runtime failure.
function requireEnv(name: string): string {
  const value = process.env[name]
  if (!value) {
    // In production builds Next.js replaces process.env at build time, so a
    // missing variable means the .env file was never filled in.
    throw new Error(
      `Missing required environment variable: ${name}. ` +
      'Copy .env.local.example to .env.local and fill in your Firebase config.'
    )
  }
  return value
}

const firebaseConfig = {
  apiKey:            requireEnv('NEXT_PUBLIC_FIREBASE_API_KEY'),
  authDomain:        requireEnv('NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN'),
  projectId:         requireEnv('NEXT_PUBLIC_FIREBASE_PROJECT_ID'),
  storageBucket:     requireEnv('NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET'),
  messagingSenderId: requireEnv('NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID'),
  appId:             requireEnv('NEXT_PUBLIC_FIREBASE_APP_ID'),
}

// Initialise Firebase only once (Next.js hot-reload safety)
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0]

/**
 * Request push-notification permission, obtain an FCM registration token, and
 * persist it to Supabase so the backend can send targeted notifications.
 *
 * @returns FCM token string, or null if permission denied / unsupported.
 */
export async function requestNotificationPermission(): Promise<string | null> {
  const supported = await isSupported()
  if (!supported) {
    console.warn('[FCM] Firebase Messaging is not supported in this browser.')
    return null
  }

  const messaging = getMessaging(app)
  try {
    const permission = await Notification.requestPermission()
    if (permission !== 'granted') {
      console.warn('[FCM] Notification permission not granted.')
      return null
    }

    // VAPID key is a web-push public key — safe to expose client-side.
    // Generate one in: Firebase Console → Project settings → Cloud Messaging → Web Push certificates
    const vapidKey = process.env.NEXT_PUBLIC_FIREBASE_VAPID_KEY
    if (!vapidKey) {
      console.error(
        '[FCM] NEXT_PUBLIC_FIREBASE_VAPID_KEY is not set. ' +
        'Push tokens cannot be obtained without a VAPID key.'
      )
      return null
    }

    const currentToken = await getToken(messaging, { vapidKey })

    if (currentToken) {
      // Persist the FCM token so the server can push to this device
      const supabase = createClient()
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        await supabase.from('fcm_tokens').upsert(
          { user_id: user.id, token: currentToken, platform: 'web' },
          { onConflict: 'user_id, token' }
        )
        console.info('[FCM] Web FCM token saved to Supabase.')
      }
      return currentToken
    }

    console.warn('[FCM] No FCM registration token available.')
    return null
  } catch (err) {
    console.error('[FCM] Error obtaining FCM token:', err)
    return null
  }
}

/**
 * Subscribe to foreground FCM messages.
 * Call once after the user has granted notification permission.
 */
export async function listenForBackgroundMessages(): Promise<void> {
  const supported = await isSupported()
  if (!supported) return

  const messaging = getMessaging(app)
  onMessage(messaging, (payload) => {
    console.info('[FCM] Foreground message received:', payload)
    // Extend here: show a toast, update notification badge, etc.
  })
}
