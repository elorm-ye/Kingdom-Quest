import { initializeApp, getApps } from 'firebase/app'
import { getMessaging, getToken, onMessage, isSupported } from 'firebase/messaging'
import { createClient } from '@/lib/supabase/client'

// TODO: Replace with your Firebase Web Config from the Firebase Console
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
}

// Initialize Firebase only once
const app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0]

export async function requestNotificationPermission() {
  const supported = await isSupported()
  if (!supported) {
    console.warn('Firebase Messaging is not supported in this browser.')
    return null
  }

  const messaging = getMessaging(app)
  try {
    const permission = await Notification.requestPermission()
    if (permission === 'granted') {
      // Get the FCM token
      // TODO: Get VAPID Key from Firebase Console -> Cloud Messaging -> Web Push certificates
      const currentToken = await getToken(messaging, {
        vapidKey: 'YOUR_VAPID_KEY_HERE' 
      })
      
      if (currentToken) {
        // Save to Supabase
        const supabase = createClient()
        const { data: { user } } = await supabase.auth.getUser()
        if (user) {
          await supabase.from('fcm_tokens').upsert({
            user_id: user.id,
            token: currentToken,
            platform: 'web'
          }, { onConflict: 'user_id, token' })
          console.log('Saved web FCM token to Supabase')
        }
        return currentToken
      } else {
        console.warn('No registration token available.')
      }
    }
  } catch (err) {
    console.error('An error occurred while retrieving token. ', err)
  }
  return null
}

export async function listenForBackgroundMessages() {
  const supported = await isSupported()
  if (!supported) return

  const messaging = getMessaging(app)
  onMessage(messaging, (payload) => {
    console.log('Message received in foreground. ', payload)
    // Optional: show a toast or custom UI here
  })
}
