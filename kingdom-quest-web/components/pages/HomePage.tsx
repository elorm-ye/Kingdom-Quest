'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Announcement, ChurchEvent, Inspiration } from '@/lib/types'
import { Megaphone, Calendar, Sun } from 'lucide-react';
import Link from 'next/link'

export default function HomePage() {
  const supabase = createClient()
  const [announcements, setAnnouncements] = useState<Announcement[]>([])
  const [inspirations, setInspirations] = useState<Inspiration[]>([])
  const [events, setEvents] = useState<ChurchEvent[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadData() {
      // Fetch announcements
      const { data: annData } = await supabase
        .from('announcements')
        .select('*, profiles(display_name)')
        .order('is_pinned', { ascending: false })
        .order('created_at', { ascending: false })
        .limit(3)
      setAnnouncements(annData ?? [])

      // Fetch inspirations
      const { data: inspData } = await supabase
        .from('inspirations')
        .select('*')
        .order('published_at', { ascending: false })
        .limit(3)
      setInspirations(inspData ?? [])

      // Fetch upcoming events
      const { data: evData } = await supabase
        .from('events')
        .select('*')
        .gte('start_time', new Date().toISOString())
        .order('start_time', { ascending: true })
        .limit(3)
      setEvents(evData ?? [])

      setLoading(false)
    }
    loadData()
  }, [supabase])

  if (loading) {
    return (
      <div className="p-6 space-y-6">
        <div className="h-8 w-48 skeleton" />
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3].map(i => <div key={i} className="h-40 skeleton" />)}
        </div>
      </div>
    )
  }

  return (
    <div className="p-6 space-y-8 animate-fade-in max-w-7xl mx-auto">
      <header className="mb-8">
        <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Welcome Home</h1>
        <p className="mt-1 text-lg" style={{ color: 'var(--text-muted)' }}>Here is what&apos;s happening in your community today.</p>
      </header>

      {/* Announcements */}
      <section>
        <div className="flex items-center gap-2 mb-4">
          <Megaphone size={20} style={{ color: 'var(--primary)' }} />
          <h2 className="text-xl font-bold font-display">Latest Announcements</h2>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {announcements.length === 0 ? (
            <p className="text-sm" style={{ color: 'var(--text-muted)' }}>No announcements right now.</p>
          ) : (
            announcements.map(ann => (
              <div key={ann.id} className="kq-card p-5 relative overflow-hidden flex flex-col">
                {ann.is_pinned && (
                  <div className="absolute top-0 right-0 px-3 py-1 text-xs font-bold bg-amber-100 text-amber-800 rounded-bl-lg">
                    Pinned
                  </div>
                )}
                <h3 className="font-bold text-lg mb-2" style={{ color: 'var(--text-primary)' }}>{ann.title}</h3>
                <p className="text-sm flex-1 mb-4" style={{ color: 'var(--text-secondary)' }}>
                  {ann.content.substring(0, 100)}{ann.content.length > 100 ? '...' : ''}
                </p>
                <div className="text-xs" style={{ color: 'var(--text-muted)' }}>
                  {new Date(ann.created_at).toLocaleDateString()} • {ann.profiles?.display_name ?? 'Admin'}
                </div>
              </div>
            ))
          )}
        </div>
      </section>

      {/* Daily Inspiration */}
      <section>
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <Sun size={20} style={{ color: 'var(--primary)' }} />
            <h2 className="text-xl font-bold font-display">Daily Inspiration</h2>
          </div>
          <Link href="/inspiration" className="text-sm font-semibold hover:underline" style={{ color: 'var(--primary)' }}>View All</Link>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {inspirations.length === 0 ? (
             <p className="text-sm" style={{ color: 'var(--text-muted)' }}>No recent inspiration.</p>
          ) : (
            inspirations.map(insp => (
              <Link href="/inspiration" key={insp.id} className="kq-card p-5 block group">
                <h3 className="font-bold text-lg mb-1 group-hover:text-primary transition-colors" style={{ color: 'var(--text-primary)' }}>{insp.title}</h3>
                {insp.bible_reference && <p className="text-xs font-semibold uppercase tracking-wide mb-2" style={{ color: 'var(--accent)' }}>{insp.bible_reference}</p>}
                <p className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>
                  {insp.content.substring(0, 100)}{insp.content.length > 100 ? '...' : ''}
                </p>
                <div className="flex items-center gap-3 text-xs" style={{ color: 'var(--text-muted)' }}>
                  <span>{insp.like_count} likes</span>
                  <span>{insp.comment_count} comments</span>
                </div>
              </Link>
            ))
          )}
        </div>
      </section>

      {/* Upcoming Events */}
      <section>
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <Calendar size={20} style={{ color: 'var(--primary)' }} />
            <h2 className="text-xl font-bold font-display">Upcoming Events</h2>
          </div>
          <Link href="/events" className="text-sm font-semibold hover:underline" style={{ color: 'var(--primary)' }}>View Calendar</Link>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {events.length === 0 ? (
             <p className="text-sm" style={{ color: 'var(--text-muted)' }}>No upcoming events.</p>
          ) : (
            events.map(ev => (
              <Link href="/events" key={ev.id} className="kq-card p-5 block group">
                <div className="text-xs font-bold uppercase mb-2" style={{ color: 'var(--accent)' }}>
                  {new Date(ev.start_time).toLocaleDateString(undefined, { weekday: 'short', month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' })}
                </div>
                <h3 className="font-bold text-lg mb-1 group-hover:text-primary transition-colors" style={{ color: 'var(--text-primary)' }}>{ev.title}</h3>
                {ev.location && <p className="text-sm flex items-center gap-1" style={{ color: 'var(--text-muted)' }}>📍 {ev.location}</p>}
              </Link>
            ))
          )}
        </div>
      </section>

    </div>
  )
}
