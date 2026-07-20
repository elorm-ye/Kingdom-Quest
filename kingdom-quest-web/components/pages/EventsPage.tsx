'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { ChurchEvent } from '@/lib/types'
import { MapPin, Calendar, Clock } from 'lucide-react';

export default function EventsPage() {
  const supabase = createClient()
  const [events, setEvents] = useState<ChurchEvent[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('events')
        .select('*')
        .gte('start_time', new Date().toISOString())
        .order('start_time', { ascending: true })
      setEvents(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  return (
    <div className="p-6 max-w-6xl mx-auto animate-fade-in">
      <header className="mb-8">
        <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Events</h1>
        <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Upcoming youth ministry events.</p>
      </header>

      {loading ? (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4].map(i => <div key={i} className="h-64 skeleton" />)}
        </div>
      ) : events.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <Calendar size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No upcoming events</h3>
          <p style={{ color: 'var(--text-muted)' }}>Check back later for updates.</p>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {events.map(ev => (
            <div key={ev.id} className="kq-card overflow-hidden flex flex-col">
              <div className="h-32 kq-gradient flex flex-col items-center justify-center text-white p-4 text-center">
                <span className="font-bold text-3xl">{new Date(ev.start_time).getDate()}</span>
                <span className="uppercase text-sm font-semibold tracking-wider">{new Date(ev.start_time).toLocaleDateString(undefined, { month: 'short' })}</span>
              </div>
              <div className="p-5 flex flex-col flex-1">
                <h3 className="font-bold text-xl mb-3" style={{ color: 'var(--text-primary)' }}>{ev.title}</h3>
                {ev.description && (
                  <p className="text-sm mb-4 flex-1" style={{ color: 'var(--text-secondary)' }}>
                    {ev.description.length > 120 ? ev.description.substring(0, 120) + '...' : ev.description}
                  </p>
                )}
                <div className="space-y-2 text-sm mt-auto border-t pt-4" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-muted)' }}>
                  <div className="flex items-center gap-2">
                    <Clock size={16} /> 
                    <span>
                      {new Date(ev.start_time).toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' })}
                      {ev.end_time && ` - ${new Date(ev.end_time).toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' })}`}
                    </span>
                  </div>
                  {ev.location && (
                    <div className="flex items-center gap-2">
                      <MapPin size={16} /> <span>{ev.location}</span>
                    </div>
                  )}
                </div>
                <button className="kq-btn kq-btn-ghost w-full mt-4 h-10 text-sm">Register</button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
