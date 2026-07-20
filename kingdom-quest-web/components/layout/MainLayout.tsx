'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { HugeiconsIcon } from '@hugeicons/react';
import { Cancel01Icon, Logout01Icon, Menu01Icon, MessageMultiple01Icon, FavouriteIcon, File01Icon, Calendar01Icon, UserIcon, Sun01Icon, Home01Icon, Notification01Icon, Shield01Icon, Settings01Icon } from '@hugeicons/core-free-icons';
import { createClient } from '@/lib/supabase/client'
import type { Profile } from '@/lib/types'

interface NavItem {
  href: string
  icon: React.ReactNode
  label: string
  id: string
}

const memberNav: NavItem[] = [
  { href: '/home',             icon: <HugeiconsIcon icon={Home01Icon} size={20} />,          label: 'Home',        id: 'nav-home' },
  { href: '/prayer-requests',  icon: <HugeiconsIcon icon={FavouriteIcon} size={20} />,         label: 'Prayers',     id: 'nav-prayers' },
  { href: '/petitions',        icon: <HugeiconsIcon icon={File01Icon} size={20} />,      label: 'Petitions',   id: 'nav-petitions' },
  { href: '/advice',           icon: <HugeiconsIcon icon={MessageMultiple01Icon} size={20} />, label: 'Advice',      id: 'nav-advice' },
  { href: '/inspiration',      icon: <HugeiconsIcon icon={Sun01Icon} size={20} />,     label: 'Inspiration', id: 'nav-inspiration' },
  { href: '/forum',            icon: <HugeiconsIcon icon={MessageMultiple01Icon} size={20} />, label: 'Forum',       id: 'nav-forum' },
  { href: '/events',           icon: <HugeiconsIcon icon={Calendar01Icon} size={20} />,      label: 'Events',      id: 'nav-events' },
  { href: '/notifications',    icon: <HugeiconsIcon icon={Notification01Icon} size={20} />,          label: 'Alerts',      id: 'nav-alerts' },
  { href: '/profile',          icon: <HugeiconsIcon icon={UserIcon} size={20} />,          label: 'Profile',     id: 'nav-profile' },
]

const bottomNav: NavItem[] = [
  { href: '/home',          icon: <HugeiconsIcon icon={Home01Icon} size={22} />,          label: 'Home',        id: 'bnav-home' },
  { href: '/inspiration',   icon: <HugeiconsIcon icon={Sun01Icon} size={22} />,     label: 'Inspire',     id: 'bnav-inspiration' },
  { href: '/forum',         icon: <HugeiconsIcon icon={MessageMultiple01Icon} size={22} />, label: 'Forum',       id: 'bnav-forum' },
  { href: '/events',        icon: <HugeiconsIcon icon={Calendar01Icon} size={22} />,      label: 'Events',      id: 'bnav-events' },
  { href: '/profile',       icon: <HugeiconsIcon icon={UserIcon} size={22} />,          label: 'Profile',     id: 'bnav-profile' },
]

function NavLink({ item, active, onClick }: { item: NavItem; active: boolean; onClick?: () => void }) {
  return (
    <Link
      id={item.id}
      href={item.href}
      onClick={onClick}
      className="flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm font-medium transition-all duration-200"
      style={{
        color: active ? 'white' : 'var(--text-secondary)',
        background: active ? 'var(--primary)' : 'transparent',
        boxShadow: active ? '0 2px 8px rgba(184,97,74,0.3)' : 'none',
      }}
    >
      <span style={{ opacity: active ? 1 : 0.7 }}>{item.icon}</span>
      {item.label}
    </Link>
  )
}

export default function MainLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()
  const router = useRouter()
  const supabase = createClient()
  const [profile, setProfile] = useState<Profile | null>(null)
  const [menuOpen, setMenuOpen] = useState(false)

  useEffect(() => {
    supabase.auth.getUser().then(({ data: { user } }) => {
      if (!user) return
      supabase.from('profiles').select('*').eq('id', user.id).single()
        .then(({ data }) => setProfile(data))
    })
  }, []) // eslint-disable-line react-hooks/exhaustive-deps

  const handleSignOut = async () => {
    await supabase.auth.signOut()
    router.push('/login')
  }

  const isAdmin = profile?.role === 'admin'

  return (
    <div className="flex min-h-dvh" style={{ background: 'var(--bg)' }}>

      {/* ── Sidebar (desktop) ────────────────────────────────────────────── */}
      <aside className="hidden lg:flex flex-col w-64 shrink-0 border-r py-6"
        style={{ background: 'var(--surface)', borderColor: 'var(--border-subtle)', position: 'sticky', top: 0, height: '100dvh' }}>

        {/* Brand */}
        <Link href="/home" className="flex items-center gap-3 px-5 mb-8">
          <div className="kq-gradient w-10 h-10 rounded-xl flex items-center justify-center shrink-0">
            <span className="text-white text-lg font-bold font-display">K</span>
          </div>
          <span className="font-display font-bold text-lg" style={{ color: 'var(--text-primary)' }}>Kingdom Quest</span>
        </Link>

        {/* Nav */}
        <nav className="flex-1 px-3 space-y-1 overflow-y-auto">
          {memberNav.map(item => (
            <NavLink key={item.href} item={item} active={pathname.startsWith(item.href)} />
          ))}
          {isAdmin && (
            <>
              <div className="my-3 mx-2 h-px" style={{ background: 'var(--border)' }} />
              <NavLink item={{ href: '/admin', icon: <HugeiconsIcon icon={Shield01Icon} size={20} />, label: 'Admin', id: 'nav-admin' }}
                active={pathname.startsWith('/admin')} />
            </>
          )}
        </nav>

        {/* Footer */}
        <div className="px-3 pt-4 border-t space-y-1" style={{ borderColor: 'var(--border-subtle)' }}>
          <NavLink item={{ href: '/settings', icon: <HugeiconsIcon icon={Settings01Icon} size={20} />, label: 'Settings', id: 'nav-settings' }}
            active={pathname === '/settings'} />
          <button id="sidebar-signout"
            onClick={handleSignOut}
            className="flex items-center gap-3 w-full px-4 py-2.5 rounded-xl text-sm font-medium transition-all duration-200"
            style={{ color: 'var(--alert)', background: 'transparent' }}>
            <HugeiconsIcon icon={Logout01Icon} size={20} />
            Sign Out
          </button>
        </div>

        {/* User chip */}
        {profile && (
          <Link href="/profile"
            className="flex items-center gap-3 mx-3 mt-3 p-3 rounded-xl"
            style={{ background: 'var(--bg)' }}>
            <div className="w-9 h-9 rounded-full overflow-hidden shrink-0 flex items-center justify-center font-bold text-sm text-white kq-gradient">
              {profile.display_name?.[0]?.toUpperCase() ?? 'U'}
            </div>
            <div className="overflow-hidden">
              <p className="text-sm font-semibold truncate" style={{ color: 'var(--text-primary)' }}>{profile.display_name}</p>
              <p className="text-xs truncate capitalize" style={{ color: 'var(--text-muted)' }}>{profile.role}</p>
            </div>
          </Link>
        )}
      </aside>

      {/* ── Mobile header ────────────────────────────────────────────────── */}
      <header className="lg:hidden fixed top-0 left-0 right-0 z-40 h-14 flex items-center justify-between px-4 border-b"
        style={{ background: 'var(--surface)', borderColor: 'var(--border-subtle)', backdropFilter: 'blur(8px)' }}>
        <Link href="/home" className="flex items-center gap-2">
          <div className="kq-gradient w-8 h-8 rounded-lg flex items-center justify-center">
            <span className="text-white text-sm font-bold font-display">K</span>
          </div>
          <span className="font-display font-bold text-base" style={{ color: 'var(--text-primary)' }}>Kingdom Quest</span>
        </Link>
        <button id="mobile-menu-btn" onClick={() => setMenuOpen(true)}
          className="p-2 rounded-lg" style={{ color: 'var(--text-secondary)' }}>
          <HugeiconsIcon icon={Menu01Icon} size={22} />
        </button>
      </header>

      {/* ── Mobile drawer ────────────────────────────────────────────────── */}
      {menuOpen && (
        <div className="lg:hidden fixed inset-0 z-50">
          <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setMenuOpen(false)} />
          <aside className="absolute right-0 top-0 h-full w-72 flex flex-col py-6 shadow-2xl animate-slide-up"
            style={{ background: 'var(--surface)' }}>
            <div className="flex items-center justify-between px-5 mb-6">
              <span className="font-display font-bold text-lg" style={{ color: 'var(--text-primary)' }}>Menu</span>
              <button onClick={() => setMenuOpen(false)} style={{ color: 'var(--text-muted)' }}><HugeiconsIcon icon={Cancel01Icon} size={22} /></button>
            </div>
            <nav className="flex-1 px-3 space-y-1 overflow-y-auto">
              {memberNav.map(item => (
                <NavLink key={item.href} item={item} active={pathname.startsWith(item.href)} onClick={() => setMenuOpen(false)} />
              ))}
              {isAdmin && (
                <>
                  <div className="my-3 mx-2 h-px" style={{ background: 'var(--border)' }} />
                  <NavLink item={{ href: '/admin', icon: <HugeiconsIcon icon={Shield01Icon} size={20} />, label: 'Admin Dashboard', id: 'nav-admin-mobile' }}
                    active={pathname.startsWith('/admin')} onClick={() => setMenuOpen(false)} />
                </>
              )}
            </nav>
            <div className="px-3 pt-4 border-t space-y-1" style={{ borderColor: 'var(--border-subtle)' }}>
              <NavLink item={{ href: '/settings', icon: <HugeiconsIcon icon={Settings01Icon} size={20} />, label: 'Settings', id: 'nav-settings-mobile' }}
                active={pathname === '/settings'} onClick={() => setMenuOpen(false)} />
              <button onClick={() => { setMenuOpen(false); handleSignOut() }}
                className="flex items-center gap-3 w-full px-4 py-2.5 rounded-xl text-sm font-medium"
                style={{ color: 'var(--alert)' }}>
                <HugeiconsIcon icon={Logout01Icon} size={20} /> Sign Out
              </button>
            </div>
          </aside>
        </div>
      )}

      {/* ── Main content ─────────────────────────────────────────────────── */}
      <main className="flex-1 flex flex-col min-w-0 pt-14 lg:pt-0 pb-20 lg:pb-0">
        <div className="flex-1">
          {children}
        </div>
      </main>

      {/* ── Bottom nav (mobile) ──────────────────────────────────────────── */}
      <nav className="lg:hidden fixed bottom-0 left-0 right-0 z-30 flex border-t"
        style={{ background: 'var(--surface)', borderColor: 'var(--border-subtle)' }}>
        {bottomNav.map(item => {
          const active = pathname.startsWith(item.href)
          return (
            <Link key={item.href} id={item.id} href={item.href}
              className="flex-1 flex flex-col items-center justify-center gap-1 py-3 text-xs font-medium transition-colors"
              style={{ color: active ? 'var(--primary)' : 'var(--text-muted)' }}>
              <span style={{ transform: active ? 'scale(1.1)' : 'scale(1)', transition: 'transform 0.2s' }}>
                {item.icon}
              </span>
              {item.label}
              {active && (
                <span className="w-4 h-0.5 rounded-full" style={{ background: 'var(--primary)' }} />
              )}
            </Link>
          )
        })}
      </nav>
    </div>
  )
}
