'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Inspiration } from '@/lib/types'
import { HugeiconsIcon } from '@hugeicons/react';
import { FavouriteIcon, Message01Icon, Sun01Icon } from '@hugeicons/core-free-icons';

export default function InspirationPage() {
  const supabase = createClient()
  const [inspirations, setInspirations] = useState<Inspiration[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('inspirations')
        .select('*')
        .order('published_at', { ascending: false })
      setInspirations(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  return (
    <div className="p-6 max-w-5xl mx-auto animate-fade-in">
      <header className="mb-8">
        <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Daily Inspiration</h1>
        <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Devotionals, verses, and testimonies to uplift you.</p>
      </header>

      {loading ? (
        <div className="grid md:grid-cols-2 gap-6">
          {[1, 2, 3, 4].map(i => <div key={i} className="h-64 skeleton" />)}
        </div>
      ) : inspirations.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <HugeiconsIcon icon={Sun01Icon} size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No inspiration found</h3>
          <p style={{ color: 'var(--text-muted)' }}>Check back later for new content.</p>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 gap-6">
          {inspirations.map(insp => (
            <div key={insp.id} className="kq-card overflow-hidden flex flex-col">
              {insp.media_url && (
                <div className="h-48 bg-gray-200 relative">
                  <img src={insp.media_url} alt={insp.title} className="w-full h-full object-cover" />
                </div>
              )}
              <div className="p-6 flex flex-col flex-1">
                <div className="flex items-center justify-between mb-3">
                  <span className="text-xs font-bold uppercase tracking-wider px-2 py-1 rounded" style={{ background: 'var(--surface-raised)', color: 'var(--primary)' }}>
                    {insp.type}
                  </span>
                  <span className="text-xs font-medium" style={{ color: 'var(--text-muted)' }}>
                    {insp.published_at ? new Date(insp.published_at).toLocaleDateString() : 'Draft'}
                  </span>
                </div>
                <h3 className="font-bold text-xl mb-2" style={{ color: 'var(--text-primary)' }}>{insp.title}</h3>
                {insp.bible_reference && <p className="text-sm font-semibold mb-3" style={{ color: 'var(--accent)' }}>{insp.bible_reference}</p>}
                <p className="text-sm flex-1 mb-6 whitespace-pre-wrap" style={{ color: 'var(--text-secondary)' }}>{insp.content}</p>
                
                <div className="flex items-center gap-6 mt-auto pt-4 border-t" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-muted)' }}>
                  <button className="flex items-center gap-1.5 hover:text-red-500 transition-colors text-sm font-medium">
                    <HugeiconsIcon icon={FavouriteIcon} size={18} /> {insp.like_count}
                  </button>
                  <button className="flex items-center gap-1.5 hover:text-gray-900 transition-colors text-sm font-medium">
                    <HugeiconsIcon icon={Message01Icon} size={18} /> {insp.comment_count}
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
