'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { ForumPost, SermonNote } from '@/lib/types'
import { MessageSquare, ArrowUp, Plus, MessagesSquare, BookOpen, User, ChevronDown, ChevronUp } from 'lucide-react';

export default function ForumPage() {
  const supabase = createClient()
  const [posts, setPosts] = useState<ForumPost[]>([])
  const [sermonNotes, setSermonNotes] = useState<SermonNote[]>([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState<'forum' | 'sermon-notes'>('forum')
  const [expandedNote, setExpandedNote] = useState<string | null>(null)

  useEffect(() => {
    async function loadData() {
      const [{ data: forumData }, { data: notesData }] = await Promise.all([
        supabase
          .from('forum_posts')
          .select('*')
          .eq('is_removed', false)
          .order('vote_score', { ascending: false }),
        supabase
          .from('sermon_notes')
          .select('*')
          .order('sermon_date', { ascending: false }),
      ])
      setPosts(forumData ?? [])
      setSermonNotes(notesData ?? [])
      setLoading(false)
    }
    loadData()

    // Realtime subscription for forum
    const channel = supabase.channel('public:forum_posts')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'forum_posts' }, () => {
        loadData()
      })
      .subscribe()
      
    return () => { supabase.removeChannel(channel) }
  }, [supabase])

  return (
    <div className="p-6 max-w-4xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Community</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Forum discussions &amp; sermon summaries.</p>
        </div>
        {activeTab === 'forum' && (
          <button className="kq-btn kq-btn-primary self-start md:self-auto">
            <Plus size={18} /> New Post
          </button>
        )}
      </header>

      {/* ── Segmented Control ── */}
      <div className="flex rounded-xl p-1 mb-6" style={{ backgroundColor: 'var(--card)' }}>
        <button
          onClick={() => setActiveTab('forum')}
          className="flex-1 py-2.5 px-4 rounded-lg text-sm font-semibold transition-all duration-200"
          style={{
            backgroundColor: activeTab === 'forum' ? 'var(--primary)' : 'transparent',
            color: activeTab === 'forum' ? '#fff' : 'var(--text-muted)',
          }}
        >
          Forum
        </button>
        <button
          onClick={() => setActiveTab('sermon-notes')}
          className="flex-1 py-2.5 px-4 rounded-lg text-sm font-semibold transition-all duration-200"
          style={{
            backgroundColor: activeTab === 'sermon-notes' ? 'var(--primary)' : 'transparent',
            color: activeTab === 'sermon-notes' ? '#fff' : 'var(--text-muted)',
          }}
        >
          <span className="flex items-center justify-center gap-2">
            <BookOpen size={16} /> Sermon Notes
          </span>
        </button>
      </div>

      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map(i => <div key={i} className="h-32 skeleton" />)}
        </div>
      ) : activeTab === 'forum' ? (
        /* ── Forum Tab ── */
        posts.length === 0 ? (
          <div className="text-center py-12 kq-card">
            <MessagesSquare size={48} className="mx-auto mb-4 opacity-20" />
            <h3 className="text-xl font-bold mb-2">No posts yet</h3>
            <p style={{ color: 'var(--text-muted)' }}>Start the conversation.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {posts.map(post => (
              <div key={post.id} className="kq-card p-0 flex">
                <div className="p-4 flex flex-col items-center justify-start border-r bg-gray-50/50" style={{ borderColor: 'var(--border-subtle)', minWidth: '60px' }}>
                  <button className="p-1 hover:text-green-600 transition-colors" style={{ color: 'var(--text-muted)' }}><ArrowUp size={20} /></button>
                  <span className="font-bold my-1">{post.vote_score}</span>
                  <button className="p-1 hover:text-red-600 transition-colors transform rotate-180" style={{ color: 'var(--text-muted)' }}><ArrowUp size={20} /></button>
                </div>
                <div className="p-4 flex-1">
                  <div className="flex items-center gap-2 text-xs mb-2" style={{ color: 'var(--text-muted)' }}>
                    <span className="font-semibold text-gray-700">{post.display_name}</span>
                    <span>•</span>
                    <span>{new Date(post.created_at).toLocaleDateString()}</span>
                  </div>
                  <h3 className="font-bold text-lg mb-2" style={{ color: 'var(--text-primary)' }}>{post.title}</h3>
                  <p className="text-sm mb-4 line-clamp-3" style={{ color: 'var(--text-secondary)' }}>{post.content}</p>
                  <div className="flex items-center gap-4 text-xs font-medium" style={{ color: 'var(--text-muted)' }}>
                    <button className="flex items-center gap-1.5 hover:text-gray-900 transition-colors">
                      <MessageSquare size={16} /> {post.comment_count} Comments
                    </button>
                    <button className="hover:text-red-600 transition-colors ml-auto">Report</button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )
      ) : (
        /* ── Sermon Notes Tab ── */
        sermonNotes.length === 0 ? (
          <div className="text-center py-12 kq-card">
            <BookOpen size={48} className="mx-auto mb-4 opacity-20" />
            <h3 className="text-xl font-bold mb-2">No sermon notes yet</h3>
            <p style={{ color: 'var(--text-muted)' }}>Sermon summaries will appear here after Sunday services.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {sermonNotes.map(note => {
              const isExpanded = expandedNote === note.id
              return (
                <div
                  key={note.id}
                  className="kq-card p-5 cursor-pointer transition-all duration-200"
                  style={{
                    borderLeft: '4px solid var(--primary)',
                  }}
                  onClick={() => setExpandedNote(isExpanded ? null : note.id)}
                >
                  {/* Date chip */}
                  <div className="flex items-center gap-2 mb-3">
                    <span className="text-xs font-semibold px-2 py-0.5 rounded" style={{ backgroundColor: 'var(--primary-alpha-10, rgba(184, 97, 74, 0.1))', color: 'var(--primary)' }}>
                      {new Date(note.sermon_date + 'T00:00:00').toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric', year: 'numeric' })}
                    </span>
                  </div>

                  {/* Title */}
                  <h3 className="font-bold text-lg font-display mb-2" style={{ color: 'var(--text-primary)' }}>{note.title}</h3>

                  {/* Preacher + Scripture */}
                  <div className="flex items-center gap-4 text-xs mb-3" style={{ color: 'var(--text-muted)' }}>
                    <span className="flex items-center gap-1.5">
                      <User size={14} /> {note.preacher_name}
                    </span>
                    <span className="flex items-center gap-1.5 font-semibold" style={{ color: 'var(--primary)' }}>
                      <BookOpen size={14} /> {note.scripture_reference}
                    </span>
                  </div>

                  {/* Content */}
                  <p className={`text-sm leading-relaxed mb-2 ${isExpanded ? '' : 'line-clamp-2'}`} style={{ color: 'var(--text-secondary)' }}>
                    {note.content}
                  </p>

                  {/* Expand indicator */}
                  <div className="flex items-center justify-center gap-1 pt-1 text-xs" style={{ color: 'var(--text-muted)' }}>
                    {isExpanded ? <ChevronUp size={16} /> : <ChevronDown size={16} />}
                    {isExpanded ? 'Tap to collapse' : 'Tap to read more'}
                  </div>
                </div>
              )
            })}
          </div>
        )
      )}
    </div>
  )
}
