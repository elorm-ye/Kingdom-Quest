'use client'

import { useState } from 'react'

import Link from 'next/link'
import { Eye, EyeOff, ArrowLeft, Loader2 } from 'lucide-react';
import { createClient } from '@/lib/supabase/client'

export default function RegisterPage() {

  const supabase = createClient()
  const [form, setForm] = useState({ name: '', email: '', gender: 'preferNotToSay', password: '', confirm: '' })
  const [showPass, setShowPass] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  const set = (k: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) =>
    setForm(f => ({ ...f, [k]: e.target.value }))

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    if (form.password !== form.confirm) { setError('Passwords do not match'); return }
    if (form.password.length < 6) { setError('Password must be at least 6 characters'); return }
    setLoading(true)
    const { error } = await supabase.auth.signUp({
      email: form.email.trim(),
      password: form.password,
      options: { data: { display_name: form.name.trim(), gender: form.gender } },
    })
    if (error) { setError(error.message); setLoading(false) }
    else { setSuccess(true); setLoading(false) }
  }

  if (success) {
    return (
      <div className="min-h-dvh flex items-center justify-center px-6"
        style={{ background: 'var(--bg)' }}>
        <div className="max-w-md w-full text-center animate-slide-up">
          <div className="w-20 h-20 rounded-full mx-auto mb-6 flex items-center justify-center text-4xl"
            style={{ background: 'rgba(91,138,104,0.12)' }}>🎉</div>
          <h2 className="font-display text-2xl font-bold mb-3" style={{ color: 'var(--text-primary)' }}>
            Account Created!
          </h2>
          <p className="mb-6" style={{ color: 'var(--text-muted)', fontSize: 15 }}>
            Check your email to confirm your account, then sign in to start your journey.
          </p>
          <Link href="/login" className="kq-btn kq-btn-primary inline-flex">
            Go to Sign In
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-dvh flex items-center justify-center px-6 py-12"
      style={{ background: 'var(--bg)' }}>
      <div className="w-full max-w-md animate-slide-up">

        <div className="mb-8">
          <Link href="/login" className="inline-flex items-center gap-2 mb-6 text-sm"
            style={{ color: 'var(--text-muted)' }}>
            <ArrowLeft size={16} /> Back to Sign In
          </Link>
          <h1 className="font-display text-3xl font-bold" style={{ color: 'var(--text-primary)' }}>
            Join Kingdom Quest
          </h1>
          <p className="mt-1" style={{ color: 'var(--text-muted)', fontSize: 14 }}>
            A safe, sacred space for young people
          </p>
        </div>

        <form onSubmit={handleRegister} className="space-y-5">
          {error && (
            <div className="p-4 rounded-xl text-sm font-medium animate-fade-in"
              style={{ background: 'rgba(226,78,54,0.1)', color: 'var(--alert)', border: '1px solid rgba(226,78,54,0.2)' }}>
              {error}
            </div>
          )}

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>Full Name</label>
            <input id="reg-name" type="text" value={form.name} onChange={set('name')}
              placeholder="Enter your name" required className="kq-input" />
          </div>

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>Email</label>
            <input id="reg-email" type="email" value={form.email} onChange={set('email')}
              placeholder="your@email.com" required className="kq-input" />
          </div>

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>Gender</label>
            <select id="reg-gender" value={form.gender}
              onChange={e => setForm(f => ({ ...f, gender: e.target.value }))}
              className="kq-input" style={{ cursor: 'pointer' }}>
              <option value="male">Brother (Male)</option>
              <option value="female">Sister (Female)</option>
              <option value="preferNotToSay">Prefer not to say</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>Password</label>
            <div className="relative">
              <input id="reg-password" type={showPass ? 'text' : 'password'} value={form.password}
                onChange={set('password')} placeholder="Min 6 characters" required minLength={6}
                className="kq-input pr-12" />
              <button type="button" onClick={() => setShowPass(!showPass)}
                className="absolute right-3 top-1/2 -translate-y-1/2 p-1"
                style={{ color: 'var(--text-muted)' }}>
                {showPass ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>Confirm Password</label>
            <input id="reg-confirm" type="password" value={form.confirm} onChange={set('confirm')}
              placeholder="Re-enter password" required className="kq-input" />
          </div>

          <button id="reg-submit" type="submit" disabled={loading}
            className="kq-btn kq-btn-primary w-full h-13 text-base mt-2">
            {loading ? <Loader2 size={20} className="animate-spin" /> : 'Create Account'}
          </button>
        </form>

        <p className="text-center mt-7 text-sm" style={{ color: 'var(--text-muted)' }}>
          Already have an account?{' '}
          <Link href="/login" className="font-semibold hover:underline" style={{ color: 'var(--primary)' }}>
            Sign In
          </Link>
        </p>
      </div>
    </div>
  )
}
