'use client'

import { useAuth } from '@/components/providers/AuthProvider'
import { ShieldAlert, Users, FileText, Megaphone, CheckCircle } from 'lucide-react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useEffect } from 'react'

export default function AdminPage() {
  const { profile, loading } = useAuth()
  const router = useRouter()

  useEffect(() => {
    if (!loading && profile?.role !== 'admin') {
      router.replace('/home')
    }
  }, [loading, profile, router])

  if (loading || profile?.role !== 'admin') return null

  return (
    <div className="p-6 max-w-6xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Admin Dashboard</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Manage users, content, and system settings.</p>
        </div>
      </header>

      <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <div className="kq-card p-5 border-l-4" style={{ borderLeftColor: 'var(--primary)' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-sm" style={{ color: 'var(--text-muted)' }}>Pending Prayers</h3>
            <CheckCircle size={20} style={{ color: 'var(--primary)' }} />
          </div>
          <p className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>12</p>
        </div>
        
        <div className="kq-card p-5 border-l-4" style={{ borderLeftColor: 'var(--sage)' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-sm" style={{ color: 'var(--text-muted)' }}>Open Advice Reqs</h3>
            <FileText size={20} style={{ color: 'var(--sage)' }} />
          </div>
          <p className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>5</p>
        </div>

        <div className="kq-card p-5 border-l-4" style={{ borderLeftColor: 'var(--alert)' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-sm" style={{ color: 'var(--text-muted)' }}>Reported Posts</h3>
            <ShieldAlert size={20} style={{ color: 'var(--alert)' }} />
          </div>
          <p className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>2</p>
        </div>

        <div className="kq-card p-5 border-l-4" style={{ borderLeftColor: 'var(--accent)' }}>
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-bold text-sm" style={{ color: 'var(--text-muted)' }}>Total Members</h3>
            <Users size={20} style={{ color: 'var(--accent)' }} />
          </div>
          <p className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>148</p>
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        <div className="kq-card p-6">
          <h2 className="text-xl font-bold font-display mb-4">Quick Actions</h2>
          <div className="space-y-3">
            <button className="kq-btn kq-btn-primary w-full justify-start"><Megaphone size={18} /> Post Announcement</button>
            <button className="kq-btn kq-btn-ghost w-full justify-start"><FileText size={18} /> Add Daily Inspiration</button>
          </div>
        </div>
        
        <div className="kq-card p-6">
          <h2 className="text-xl font-bold font-display mb-4">System Management</h2>
          <div className="space-y-3">
            <Link href="#" className="flex items-center p-3 rounded-lg border hover:bg-black/5 transition-colors text-sm font-medium" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-primary)' }}>
              User Directory & Roles
            </Link>
            <Link href="#" className="flex items-center p-3 rounded-lg border hover:bg-black/5 transition-colors text-sm font-medium" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-primary)' }}>
              Forum Moderation
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}
