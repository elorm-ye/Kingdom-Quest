// ── Types mirroring the Flutter models and Supabase schema ──────────────────

export type UserRole = 'member' | 'admin'
export type Gender = 'male' | 'female' | 'preferNotToSay'
export type PrayerStatus = 'pending' | 'praying' | 'answered'
export type PetitionStatus = 'pending' | 'under_review' | 'resolved'
export type AdviceStatus = 'pending' | 'in_progress' | 'completed'
export type InspirationType = 'devotional' | 'motivation' | 'challenge' | 'verse' | 'testimony'

export interface Profile {
  id: string
  display_name: string
  avatar_url: string | null
  bio: string | null
  gender: Gender
  role: UserRole
  church_id: string | null
  created_at: string
}

export interface PrayerResponse {
  id: string
  prayer_request_id: string
  admin_id: string
  message: string
  created_at: string
}

export interface PrayerRequest {
  id: string
  user_id: string | null
  church_id: string | null
  title: string
  description: string
  category: string
  is_anonymous: boolean
  display_name: string | null
  status: PrayerStatus
  prayer_count: number
  created_at: string
  prayer_responses?: PrayerResponse[]
}

export interface Petition {
  id: string
  user_id: string | null
  church_id: string | null
  subject: string
  description: string
  is_anonymous: boolean
  display_name: string | null
  status: PetitionStatus
  created_at: string
  updated_at: string
}

export interface AdviceResponse {
  id: string
  advice_request_id: string
  admin_id: string
  message: string
  bible_references: string[]
  created_at: string
}

export interface AdviceRequest {
  id: string
  user_id: string | null
  church_id: string | null
  title: string
  description: string
  is_anonymous: boolean
  display_name: string | null
  status: AdviceStatus
  created_at: string
  advice_responses?: AdviceResponse[]
}

export interface Inspiration {
  id: string
  admin_id: string
  church_id: string | null
  title: string
  content: string
  type: InspirationType
  bible_reference: string | null
  media_url: string | null
  published_at: string | null
  like_count: number
  comment_count: number
  created_at: string
  // joined
  isLikedByUser?: boolean
}

export interface ForumPost {
  id: string
  anonymous_token: string
  church_id: string | null
  title: string
  content: string
  display_name: string
  vote_score: number
  like_count: number
  comment_count: number
  is_removed: boolean
  created_at: string
}

export interface ChurchEvent {
  id: string
  church_id: string | null
  title: string
  description: string | null
  location: string | null
  start_time: string
  end_time: string
  is_recurring: boolean
  recurring_pattern: string | null
  created_by: string | null
  registration_count: number
  created_at: string
  // joined
  isRegistered?: boolean
}

export interface Announcement {
  id: string
  church_id: string | null
  admin_id: string | null
  title: string
  content: string
  media_urls: string[]
  is_pinned: boolean
  created_at: string
  // joined
  profiles?: { display_name: string } | null
}

export interface AppNotification {
  id: string
  user_id: string
  type: string
  title: string
  body: string
  data: Record<string, unknown>
  is_read: boolean
  created_at: string
}
