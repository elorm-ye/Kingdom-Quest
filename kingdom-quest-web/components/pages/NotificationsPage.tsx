'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { AppNotification } from '@/lib/types'
import { Bell } from 'lucide-react'

export default function NotificationsPage() {
  const supabase = createClient()
  const [notifications, setNotifications] = useState<AppNotification[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function loadData() {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return

      const { data } = await supabase
        .from('notifications')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
      setNotifications(data ?? [])
      setLoading(false)
    }
    loadData()
  }, [supabase])

  const markAllAsRead = async () => {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return
    await supabase.from('notifications').update({ is_read: true }).eq('user_id', user.id).eq('is_read', false)
    setNotifications(prev => prev.map(n => ({ ...n, is_read: true })))
  }

  return (
    <div className="p-6 max-w-3xl mx-auto animate-fade-in">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
          <h1 className="text-3xl font-bold font-display" style={{ color: 'var(--text-primary)' }}>Notifications</h1>
        </div>
        <button onClick={markAllAsRead} className="kq-btn kq-btn-ghost self-start md:self-auto text-sm py-1.5 px-3 h-auto">
          Mark all as read
        </button>
      </header>

      {loading ? (
        <div className="space-y-2">
          {[1, 2, 3, 4].map(i => <div key={i} className="h-20 skeleton" />)}
        </div>
      ) : notifications.length === 0 ? (
        <div className="text-center py-12 kq-card">
          <Bell size={48} className="mx-auto mb-4 opacity-20" />
          <h3 className="text-xl font-bold mb-2">No notifications</h3>
          <p style={{ color: 'var(--text-muted)' }}>You're all caught up!</p>
        </div>
      ) : (
        <div className="space-y-2">
          {notifications.map(notif => (
            <div key={notif.id} className={`p-4 rounded-xl border flex items-start gap-4 transition-colors ${notif.is_read ? 'bg-transparent' : 'bg-surface'}`} style={{ borderColor: 'var(--border-subtle)', background: notif.is_read ? 'transparent' : 'var(--surface)' }}>
              <div className="w-2 h-2 rounded-full mt-2 shrink-0" style={{ background: notif.is_read ? 'transparent' : 'var(--primary)' }} />
              <div className="flex-1">
                <h4 className="font-bold text-sm mb-1" style={{ color: 'var(--text-primary)' }}>{notif.title}</h4>
                <p className="text-sm mb-2" style={{ color: 'var(--text-secondary)' }}>{notif.body}</p>
                <span className="text-xs font-medium" style={{ color: 'var(--text-muted)' }}>{new Date(notif.created_at).toLocaleString()}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
