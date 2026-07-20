'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { ForumPost } from '@/lib/types'
import { MessageSquare, ArrowUp, Plus, MessagesSquare } from 'lucide-react';

export default function ForumPage() {
  const supabase = createClient()
  const [posts, setPosts] = useState<ForumPost[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadData() {
      const { data } = await supabase
        .from('forum_posts')
        .select('*')
        .eq('is_removed', false)
        .order('vote_score', { ascending: false })
      setPosts(data ?? [])
      setLoading(false)
    }
    loadData()

    // Realtime subscription
    const channel = supabase.channel('public:forum_posts')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'forum_posts' }, () => {
        loadData() // Reload on any change
      })
      .subscribe()
      
    return () => { supabase.removeChannel(channel) }
  }, [supabase])

  return (
    <div className="p-6 max-w-4xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Community Forum</h1>
          <p className="mt-1 text-base" style={{ color: 'var(--text-muted)' }}>Anonymous, safe discussions.</p>
        </div>
        <button className="kq-btn kq-btn-primary self-start md:self-auto">
          <Plus size={18} /> New Post
        </button>
      </header>

      {loading ? (
        <div className="space-y-4">
          {[1, 2, 3].map(i => <div key={i} className="h-32 skeleton" />)}
        </div>
      ) : posts.length === 0 ? (
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
      )}
    </div>
  )
}
