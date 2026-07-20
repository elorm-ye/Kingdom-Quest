'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { PrayerRequest } from '@/lib/types'
import { Heart, Plus, Search } from 'lucide-react'

export default function PrayerRequestsPage() {
  const supabase = createClient()
  const [requests, setRequests] = useState<PrayerRequest[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [filter, setFilter] = useState<'all' | 'pending' | 'praying' | 'answered'>('all')

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('prayer_requests')
        .select('*, prayer_responses(*)')
        .order('created_at', { ascending: false })
      setRequests(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  const filteredRequests = requests.filter(r => {
    if (filter !== 'all' && r.status !== filter) return false
    if (search && !r.title.toLowerCase().includes(search.toLowerCase()) && !r.description.toLowerCase().includes(search.toLowerCase())) return false
    return true
  })

  return (
    <div className="p-6 max-w-4xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Prayer Requests</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Join your community in prayer.</p>
        </div>
        <button className="kq-btn kq-btn-primary self-start md:self-auto">
          <Plus size={18} /> Submit Request
        </button>
      </header>

      <div className="flex flex-col md:flex-row gap-4 mb-6">
        <div className="relative flex-1">
          <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-muted)' }} />
          <input 
            type="text" 
            placeholder="Search prayers..." 
            className="kq-input pl-10" 
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        <select 
          className="kq-input md:w-48"
          value={filter}
          onChange={e => setFilter(e.target.value as any)}
        >
          <option value="all">All Statuses</option>
          <option value="pending">Pending</option>
          <option value="praying">Praying</option>
          <option value="answered">Answered</option>
        </select>
      </div>

      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map(i => <div key={i} className="h-32 skeleton" />)}
        </div>
      ) : filteredRequests.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <Heart size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No prayer requests found</h3>
          <p style={{ color: 'var(--text-muted)' }}>Be the first to share a prayer request.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {filteredRequests.map(req => (
            <div key={req.id} className="kq-card p-5">
              <div className="flex items-start justify-between gap-4 mb-2">
                <h3 className="font-bold text-lg" style={{ color: 'var(--text-primary)' }}>{req.title}</h3>
                <span className={`kq-badge status-${req.status}`}>
                  {req.status === 'praying' ? 'Praying 🙏' : req.status === 'answered' ? 'Answered ✨' : 'Pending'}
                </span>
              </div>
              <p className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>{req.description}</p>
              <div className="flex flex-wrap items-center justify-between gap-2 border-t pt-4" style={{ borderColor: 'var(--border-subtle)' }}>
                <div className="flex items-center gap-3 text-xs font-medium" style={{ color: 'var(--text-muted)' }}>
                  <span>{req.is_anonymous ? (req.display_name || 'Anonymous') : (req.display_name || 'Member')}</span>
                  <span>•</span>
                  <span className="capitalize">{req.category.replace('_', ' ')}</span>
                  <span>•</span>
                  <span>{new Date(req.created_at).toLocaleDateString()}</span>
                </div>
                <button className="kq-btn kq-btn-ghost py-1.5 px-3 text-xs rounded-full">
                  <Heart size={14} className="mr-1" /> Pray ({req.prayer_count})
                </button>
              </div>
              
              {req.prayer_responses && req.prayer_responses.length > 0 && (
                <div className="mt-4 p-3 rounded-lg text-sm" style={{ background: 'var(--bg)' }}>
                  <span className="font-bold block mb-1">Response from Admin:</span>
                  <p style={{ color: 'var(--text-secondary)' }}>{req.prayer_responses[0].message}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
