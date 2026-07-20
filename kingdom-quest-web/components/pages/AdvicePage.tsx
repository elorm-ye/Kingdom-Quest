'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { AdviceRequest } from '@/lib/types'
import { MessagesSquare, Plus, Search } from 'lucide-react';

export default function AdvicePage() {
  const supabase = createClient()
  const [requests, setRequests] = useState<AdviceRequest[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('advice_requests')
        .select('*, advice_responses(*)')
        .order('created_at', { ascending: false })
      setRequests(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  const filtered = requests.filter(r => 
    !search || r.title.toLowerCase().includes(search.toLowerCase()) || r.description.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div className="p-6 max-w-4xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Spiritual Advice</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Seek guidance from church leaders.</p>
        </div>
        <button className="kq-btn kq-btn-primary self-start md:self-auto">
          <Plus size={18} /> Request Advice
        </button>
      </header>

      <div className="relative mb-6">
        <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-muted)' }} />
        <input 
          type="text" 
          placeholder="Search advice requests..." 
          className="kq-input pl-10" 
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
      </div>

      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map(i => <div key={i} className="h-32 skeleton" />)}
        </div>
      ) : filtered.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <MessagesSquare size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No advice requests</h3>
          <p style={{ color: 'var(--text-muted)' }}>Be the first to seek spiritual guidance.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {filtered.map(req => (
            <div key={req.id} className="kq-card p-5">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-2 mb-2">
                <h3 className="font-bold text-lg" style={{ color: 'var(--text-primary)' }}>{req.title}</h3>
                <span className={`kq-badge self-start status-${req.status.replace('_', '-')}`}>
                  {req.status.replace('_', ' ')}
                </span>
              </div>
              <p className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>{req.description}</p>
              <div className="flex flex-wrap items-center gap-3 text-xs font-medium border-t pt-4" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-muted)' }}>
                <span>{req.is_anonymous ? 'Anonymous' : (req.display_name || 'Member')}</span>
                <span>•</span>
                <span>{new Date(req.created_at).toLocaleDateString()}</span>
              </div>

              {req.advice_responses && req.advice_responses.length > 0 && (
                <div className="mt-4 p-4 rounded-lg text-sm border" style={{ background: 'rgba(91,138,104,0.05)', borderColor: 'rgba(91,138,104,0.2)' }}>
                  <div className="flex items-center gap-2 mb-2">
                    <span className="font-bold text-sage">Response from Leaders:</span>
                  </div>
                  <p style={{ color: 'var(--text-secondary)' }}>{req.advice_responses[0].message}</p>
                  
                  {req.advice_responses[0].bible_references && req.advice_responses[0].bible_references.length > 0 && (
                    <div className="mt-3 pt-3 border-t flex flex-wrap gap-2" style={{ borderColor: 'rgba(91,138,104,0.1)' }}>
                      {req.advice_responses[0].bible_references.map((ref, idx) => (
                        <span key={idx} className="kq-badge" style={{ background: 'white', color: 'var(--sage)' }}>{ref}</span>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
