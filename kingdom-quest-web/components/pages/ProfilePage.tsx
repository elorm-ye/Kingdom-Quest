'use client'

import { useAuth } from '@/components/providers/AuthProvider'
import { User, LogOut } from 'lucide-react'

export default function ProfilePage() {
  const { user, profile, loading, signOut } = useAuth()

  if (loading) {
    return (
      <div className="p-6 max-w-2xl mx-auto">
        <div className="h-48 skeleton mb-6" />
        <div className="h-20 skeleton" />
      </div>
    )
  }

  if (!profile) return null

  return (
    <div className="p-6 max-w-2xl mx-auto animate-fade-in">
      <header className="mb-8">
        <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>My Profile</h1>
      </header>

      <div className="kq-card p-6 md:p-8 flex flex-col md:flex-row items-center gap-6 mb-6">
        <div className="w-32 h-32 rounded-full kq-gradient flex items-center justify-center shrink-0 shadow-lg text-4xl text-white font-bold font-display">
          {profile.avatar_url ? (
            <img src={profile.avatar_url} alt="Avatar" className="w-full h-full object-cover rounded-full" />
          ) : (
            profile.display_name?.[0]?.toUpperCase() ?? 'U'
          )}
        </div>
        
        <div className="flex-1 text-center md:text-left">
          <h2 className="text-2xl font-bold mb-1" style={{ color: 'var(--text-primary)' }}>{profile.display_name}</h2>
          <p className="text-sm mb-3" style={{ color: 'var(--text-secondary)' }}>{user?.email}</p>
          
          <div className="flex flex-wrap justify-center md:justify-start gap-2 mb-4">
            <span className="kq-badge capitalize" style={{ background: 'var(--surface-raised)', border: '1px solid var(--border)' }}>
              Role: {profile.role}
            </span>
            <span className="kq-badge capitalize" style={{ background: 'var(--surface-raised)', border: '1px solid var(--border)' }}>
              Gender: {profile.gender === 'preferNotToSay' ? 'Private' : profile.gender}
            </span>
          </div>
          
          {profile.bio && (
            <p className="text-sm text-left italic" style={{ color: 'var(--text-muted)' }}>"{profile.bio}"</p>
          )}
        </div>
      </div>

      <div className="kq-card p-4 space-y-2">
        <button className="w-full flex items-center justify-between p-4 rounded-lg hover:bg-black/5 transition-colors text-sm font-medium" style={{ color: 'var(--text-primary)' }}>
          <div className="flex items-center gap-3"><User size={18} /> Edit Profile Info</div>
        </button>
        <button onClick={signOut} className="w-full flex items-center justify-between p-4 rounded-lg hover:bg-red-50 transition-colors text-sm font-medium" style={{ color: 'var(--alert)' }}>
          <div className="flex items-center gap-3"><LogOut size={18} /> Sign Out</div>
        </button>
      </div>
    </div>
  )
}
