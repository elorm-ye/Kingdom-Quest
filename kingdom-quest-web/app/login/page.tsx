'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { HugeiconsIcon } from '@hugeicons/react';
import { ViewIcon, ViewOffIcon, Loading01Icon } from '@hugeicons/core-free-icons';
import { createClient } from '@/lib/supabase/client'

export default function LoginPage() {
  const router = useRouter()
  const supabase = createClient()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPass, setShowPass] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)
    const { error } = await supabase.auth.signInWithPassword({ email: email.trim(), password })
    if (error) {
      setError(error.message)
      setLoading(false)
    } else {
      router.push('/home')
      router.refresh()
    }
  }

  const handleForgotPassword = async () => {
    if (!email || !email.includes('@')) {
      setError('Enter your email above first.')
      return
    }
    setLoading(true)
    await supabase.auth.resetPasswordForEmail(email.trim())
    setLoading(false)
    setError(null)
    alert('Password reset email sent! Check your inbox.')
  }

  return (
    <div className="min-h-dvh flex items-center justify-center px-6 py-12"
      style={{ background: 'var(--bg)' }}>
      <div className="w-full max-w-md animate-slide-up">

        {/* Brand mark */}
        <div className="flex flex-col items-center mb-10">
          <div className="kq-gradient w-16 h-16 rounded-2xl flex items-center justify-center mb-5 animate-pulse-glow">
            <div className="w-8 h-8 rounded-t-full rounded-b-sm flex items-center justify-center"
              style={{ background: 'rgba(248,241,232,0.9)' }}>
              <div className="w-3.5 h-3.5 rounded-full mb-1"
                style={{ background: 'var(--terracotta)' }} />
            </div>
          </div>
          <h1 className="font-display text-3xl font-bold" style={{ color: 'var(--text-primary)' }}>
            Welcome back
          </h1>
          <p className="mt-1 text-center" style={{ color: 'var(--text-muted)', fontSize: 14 }}>
            Sign in to continue your journey
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleLogin} className="space-y-5">
          {error && (
            <div className="p-4 rounded-xl text-sm font-medium animate-fade-in"
              style={{ background: 'rgba(226,78,54,0.1)', color: 'var(--alert)', border: '1px solid rgba(226,78,54,0.2)' }}>
              {error}
            </div>
          )}

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>
              Email
            </label>
            <input
              id="login-email"
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              placeholder="your@email.com"
              required
              className="kq-input"
            />
          </div>

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>
              Password
            </label>
            <div className="relative">
              <input
                id="login-password"
                type={showPass ? 'text' : 'password'}
                value={password}
                onChange={e => setPassword(e.target.value)}
                placeholder="Enter your password"
                required
                minLength={6}
                className="kq-input pr-12"
              />
              <button
                type="button"
                onClick={() => setShowPass(!showPass)}
                className="absolute right-3 top-1/2 -translate-y-1/2 p-1"
                style={{ color: 'var(--text-muted)' }}>
                {showPass ? <HugeiconsIcon icon={ViewOffIcon} size={18} /> : <HugeiconsIcon icon={ViewIcon} size={18} />}
              </button>
            </div>
            <div className="flex justify-end mt-2">
              <button type="button" onClick={handleForgotPassword}
                className="text-sm font-medium hover:underline"
                style={{ color: 'var(--primary)', background: 'none', border: 'none', cursor: 'pointer' }}>
                Forgot password?
              </button>
            </div>
          </div>

          <button id="login-submit" type="submit" disabled={loading}
            className="kq-btn kq-btn-primary w-full h-13 text-base mt-2">
            {loading ? <HugeiconsIcon icon={Loading01Icon} size={20} className="animate-spin" /> : 'Sign In'}
          </button>
        </form>

        {/* Divider */}
        <div className="flex items-center gap-4 my-7">
          <div className="flex-1 h-px" style={{ background: 'var(--border)' }} />
          <span className="text-sm" style={{ color: 'var(--text-muted)' }}>or continue with</span>
          <div className="flex-1 h-px" style={{ background: 'var(--border)' }} />
        </div>

        {/* Google */}
        <button
          id="login-google"
          onClick={async () => {
            await supabase.auth.signInWithOAuth({ provider: 'google', options: { redirectTo: `${location.origin}/home` } })
          }}
          className="kq-btn kq-btn-ghost w-full h-13 text-base"
        >
          <svg width="20" height="20" viewBox="0 0 24 24">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          Continue with Google
        </button>

        {/* Sign up link */}
        <p className="text-center mt-8 text-sm" style={{ color: 'var(--text-muted)' }}>
          Don&apos;t have an account?{' '}
          <Link href="/register" className="font-semibold hover:underline" style={{ color: 'var(--primary)' }}>
            Sign Up
          </Link>
        </p>
      </div>
    </div>
  )
}
