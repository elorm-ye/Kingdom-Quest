'use client'

import { useState, useEffect } from 'react'
import { X, Download } from 'lucide-react';

export function PWAInstallPrompt() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [deferredPrompt, setDeferredPrompt] = useState<any>(null)
  const [showPrompt, setShowPrompt] = useState(false)

  useEffect(() => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const handleBeforeInstallPrompt = (e: any) => {
      // Prevent Chrome 67 and earlier from automatically showing the prompt
      e.preventDefault()
      // Stash the event so it can be triggered later.
      setDeferredPrompt(e)
      // Update UI to notify the user they can add to home screen
      setShowPrompt(true)
    }

    window.addEventListener('beforeinstallprompt', handleBeforeInstallPrompt)

    // Check if already installed (standalone mode)
    if (window.matchMedia('(display-mode: standalone)').matches) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      setShowPrompt(false)
    }

    // Register Service Worker
    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/sw.js').catch(err => {
        console.error('Service Worker registration failed:', err)
      })
    }

    return () => {
      window.removeEventListener('beforeinstallprompt', handleBeforeInstallPrompt)
    }
  }, [])

  const handleInstallClick = async () => {
    if (!deferredPrompt) return

    // Show the install prompt
    deferredPrompt.prompt()
    
    // Wait for the user to respond to the prompt
    const { outcome } = await deferredPrompt.userChoice
    
    if (outcome === 'accepted') {
      console.log('User accepted the install prompt')
    } else {
      console.log('User dismissed the install prompt')
    }
    
    // We've used the prompt, and can't use it again, throw it away
    setDeferredPrompt(null)
    setShowPrompt(false)
  }

  if (!showPrompt) return null

  return (
    <div className="fixed bottom-20 md:bottom-4 left-4 right-4 md:left-auto md:right-4 z-50 animate-slide-up">
      <div className="kq-card p-4 flex items-center gap-4 max-w-sm ml-auto bg-white shadow-2xl">
        <div className="kq-gradient w-12 h-12 rounded-xl flex items-center justify-center shrink-0">
          <span className="text-white text-xl font-bold font-display">K</span>
        </div>
        <div className="flex-1">
          <h3 className="font-bold text-sm" style={{ color: 'var(--text-primary)' }}>Install Kingdom Quest</h3>
          <p className="text-xs" style={{ color: 'var(--text-muted)' }}>Add to your home screen for a better experience.</p>
        </div>
        <div className="flex items-center gap-2">
          <button onClick={handleInstallClick} className="kq-btn kq-btn-primary p-2 h-auto text-xs flex items-center gap-1">
            <Download size={14} /> Install
          </button>
          <button onClick={() => setShowPrompt(false)} className="p-1 rounded-full hover:bg-black/5" style={{ color: 'var(--text-muted)' }}>
            <X size={16} />
          </button>
        </div>
      </div>
    </div>
  )
}
