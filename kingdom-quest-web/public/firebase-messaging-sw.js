/**
 * public/firebase-messaging-sw.js
 *
 * Firebase Cloud Messaging background service worker.
 *
 * ── SECURITY: Configuration ──────────────────────────────────────────────────
 * Service workers run in a separate scope and cannot access Next.js environment
 * variables directly.  The recommended approach for FCM service workers is to
 * initialise Firebase in the worker using values injected at registration time
 * via the `serviceWorker.register()` call (passed as URL query params or via
 * `postMessage`), OR — as done here — to load them from a dedicated
 * `/__/firebase/init.json` endpoint served by Firebase Hosting.
 *
 * For self-hosted / Vercel deployments (which is our case) we use a
 * `/api/firebase-config` Server route (see app/api/firebase-config/route.ts)
 * that returns the public config as JSON.  The service worker fetches that
 * config on `activate` and caches it locally.
 *
 * HOW TO SET CONFIG:
 *  1. Fill in your NEXT_PUBLIC_FIREBASE_* variables in .env.local
 *  2. The /api/firebase-config route reads those server-side and returns them.
 *  3. This service worker fetches that route on first activation.
 *
 * NOTE: Firebase Web API keys are public by design — they identify the project
 * and are restricted by domain + Firebase Security Rules, not kept secret.
 * Do NOT use this pattern for service-account keys or other secrets.
 */

importScripts('https://www.gstatic.com/firebasejs/10.9.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.9.0/firebase-messaging-compat.js');

// The config object is populated once on `activate` via /api/firebase-config.
// Default to empty strings so the script parses without errors before config loads.
let firebaseConfig = {};

/**
 * Fetch the Firebase config from our secure Next.js API route and initialise
 * the SDK.  This avoids hard-coding any values in the service worker file.
 */
async function initFirebase() {
  try {
    const res = await fetch('/api/firebase-config');
    if (!res.ok) {
      console.error('[SW] Could not fetch Firebase config. Status:', res.status);
      return;
    }
    firebaseConfig = await res.json();

    // Only initialise if not already done (e.g. SW update / reload)
    if (!firebase.apps.length) {
      firebase.initializeApp(firebaseConfig);
      const messaging = firebase.messaging();

      messaging.onBackgroundMessage((payload) => {
        console.log('[firebase-messaging-sw.js] Received background message:', payload);

        const notificationTitle = payload.notification?.title || 'Kingdom Quest';
        const notificationOptions = {
          body: payload.notification?.body || '',
          icon: '/icons/icon-192.png',
          badge: '/icons/icon-72.png',
          data: payload.data,
        };

        self.registration.showNotification(notificationTitle, notificationOptions);
      });
    }
  } catch (err) {
    console.error('[SW] Firebase init error:', err);
  }
}

// Initialise as soon as the service worker activates
self.addEventListener('activate', (event) => {
  event.waitUntil(initFirebase());
});
