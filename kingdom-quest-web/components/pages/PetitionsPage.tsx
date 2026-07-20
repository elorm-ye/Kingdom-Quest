'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Petition } from '@/lib/types'
import { FileText, Plus, Search } from 'lucide-react'

export default function PetitionsPage() {
  const supabase = createClient()
  const [petitions, setPetitions] = useState<Petition[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('petitions')
        .select('*')
        .order('created_at', { ascending: false })
      setPetitions(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  const filteredPetitions = petitions.filter(p => 
    !search || p.subject.toLowerCase().includes(search.toLowerCase()) || p.description.toLowerCase().includes(search.toLowerCase())
  )

  return (
    <div className="p-6 max-w-4xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Petitions</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Submit feedback, ideas, or grievances.</p>
        </div>
        <button className="kq-btn kq-btn-primary self-start md:self-auto">
          <Plus size={18} /> New Petition
        </button>
      </header>

      <div className="relative mb-6">
        <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2" style={{ color: 'var(--text-muted)' }} />
        <input 
          type="text" 
          placeholder="Search petitions..." 
          className="kq-input pl-10" 
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
      </div>

      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map(i => <div key={i} className="h-32 skeleton" />)}
        </div>
      ) : filteredPetitions.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <FileText size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No petitions found</h3>
          <p style={{ color: 'var(--text-muted)' }}>There are no petitions matching your search.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {filteredPetitions.map(pet => (
            <div key={pet.id} className="kq-card p-5">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-2 mb-2">
                <h3 className="font-bold text-lg" style={{ color: 'var(--text-primary)' }}>{pet.subject}</h3>
                <span className={`kq-badge self-start status-${pet.status.replace('_', '-')}`}>
                  {pet.status.replace('_', ' ')}
                </span>
              </div>
              <p className="text-sm mb-4" style={{ color: 'var(--text-secondary)' }}>{pet.description}</p>
              <div className="flex flex-wrap items-center gap-3 text-xs font-medium border-t pt-4" style={{ borderColor: 'var(--border-subtle)', color: 'var(--text-muted)' }}>
                <span>{pet.is_anonymous ? 'Anonymous' : (pet.display_name || 'Member')}</span>
                <span>•</span>
                <span>Submitted: {new Date(pet.created_at).toLocaleDateString()}</span>
                {pet.updated_at !== pet.created_at && (
                  <>
                    <span>•</span>
                    <span>Updated: {new Date(pet.updated_at).toLocaleDateString()}</span>
                  </>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
