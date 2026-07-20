-- ============================================================
-- Kingdom Quest — Supabase Database Schema + RLS Policies
-- Run this entire script in your Supabase SQL Editor
-- ============================================================

-- ─────────────────────────────────────────────────────────────
-- EXTENSIONS
-- ─────────────────────────────────────────────────────────────
create extension if not exists "pgcrypto";
create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────
-- HELPER FUNCTION: is_admin
-- ─────────────────────────────────────────────────────────────
create or replace function is_admin(uid uuid)
returns boolean
language sql
security definer
stable
as $$
  select exists (
    select 1 from public.profiles where id = uid and role = 'admin'
  );
$$;

-- ─────────────────────────────────────────────────────────────
-- TABLE: churches
-- ─────────────────────────────────────────────────────────────
create table if not exists public.churches (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  logo_url    text,
  theme_color text default '#B8614A',
  created_at  timestamptz not null default now()
);

alter table public.churches enable row level security;

create policy "Anyone authenticated can read churches"
  on public.churches for select
  to authenticated using (true);

create policy "Only admins can update churches"
  on public.churches for update
  to authenticated using (is_admin(auth.uid()));

-- Insert default church
insert into public.churches (id, name, theme_color)
values ('00000000-0000-0000-0000-000000000001', 'Kingdom Quest Church', '#B8614A')
on conflict (id) do nothing;

-- ─────────────────────────────────────────────────────────────
-- TABLE: profiles
-- Extended user data linked to auth.users
-- ─────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  display_name  text not null default 'Member',
  avatar_url    text,
  bio           text,
  gender        text not null default 'preferNotToSay' check (gender in ('male','female','preferNotToSay')),
  role          text not null default 'member' check (role in ('member','admin')),
  church_id     uuid references public.churches(id) on delete set null,
  created_at    timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can read all profiles in their church"
  on public.profiles for select
  to authenticated using (true);

create policy "Users can update their own profile"
  on public.profiles for update
  to authenticated using (auth.uid() = id);

create policy "Users can insert their own profile"
  on public.profiles for insert
  to authenticated with check (auth.uid() = id);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name, gender, church_id)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'gender', 'preferNotToSay'),
    '00000000-0000-0000-0000-000000000001'::uuid
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─────────────────────────────────────────────────────────────
-- TABLE: prayer_requests
-- ─────────────────────────────────────────────────────────────
create table if not exists public.prayer_requests (
  id                      uuid primary key default gen_random_uuid(),
  user_id                 uuid references auth.users(id) on delete set null,
  church_id               uuid references public.churches(id) on delete cascade,
  title                   text not null,
  description             text not null,
  category                text not null default 'other',
  is_anonymous            boolean not null default false,
  display_name            text,
  status                  text not null default 'pending' check (status in ('pending','praying','answered')),
  prayer_count            integer not null default 0,
  created_at              timestamptz not null default now()
);

alter table public.prayer_requests enable row level security;

create policy "Church members can read prayer requests"
  on public.prayer_requests for select
  to authenticated using (true);

create policy "Authenticated users can submit prayer requests"
  on public.prayer_requests for insert
  to authenticated with check (auth.uid() = user_id or user_id is null);

create policy "Users can delete their own requests"
  on public.prayer_requests for delete
  to authenticated using (auth.uid() = user_id);

create policy "Admins can update prayer request status"
  on public.prayer_requests for update
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: prayer_responses
-- ─────────────────────────────────────────────────────────────
create table if not exists public.prayer_responses (
  id                 uuid primary key default gen_random_uuid(),
  prayer_request_id  uuid not null references public.prayer_requests(id) on delete cascade,
  admin_id           uuid not null references auth.users(id) on delete cascade,
  message            text not null,
  created_at         timestamptz not null default now()
);

alter table public.prayer_responses enable row level security;

create policy "Church members can read responses"
  on public.prayer_responses for select
  to authenticated using (true);

create policy "Admins can insert responses"
  on public.prayer_responses for insert
  to authenticated with check (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: petitions
-- ─────────────────────────────────────────────────────────────
create table if not exists public.petitions (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references auth.users(id) on delete set null,
  church_id     uuid references public.churches(id) on delete cascade,
  subject       text not null,
  description   text not null,
  is_anonymous  boolean not null default false,
  display_name  text,
  status        text not null default 'pending' check (status in ('pending','under_review','resolved')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.petitions enable row level security;

create policy "Church members can read petitions"
  on public.petitions for select
  to authenticated using (true);

create policy "Authenticated users can submit petitions"
  on public.petitions for insert
  to authenticated with check (auth.uid() = user_id or user_id is null);

create policy "Users can delete their own petitions"
  on public.petitions for delete
  to authenticated using (auth.uid() = user_id);

create policy "Admins can update petition status"
  on public.petitions for update
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: advice_requests
-- ─────────────────────────────────────────────────────────────
create table if not exists public.advice_requests (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid references auth.users(id) on delete set null,
  church_id     uuid references public.churches(id) on delete cascade,
  title         text not null,
  description   text not null,
  is_anonymous  boolean not null default false,
  display_name  text,
  status        text not null default 'pending' check (status in ('pending','in_progress','completed')),
  created_at    timestamptz not null default now()
);

alter table public.advice_requests enable row level security;

create policy "Admins can read all advice requests"
  on public.advice_requests for select
  to authenticated using (
    is_admin(auth.uid()) or user_id = auth.uid()
  );

create policy "Authenticated users can submit advice requests"
  on public.advice_requests for insert
  to authenticated with check (auth.uid() = user_id or user_id is null);

create policy "Users can delete their own requests"
  on public.advice_requests for delete
  to authenticated using (auth.uid() = user_id);

create policy "Admins can update advice status"
  on public.advice_requests for update
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: advice_responses
-- ─────────────────────────────────────────────────────────────
create table if not exists public.advice_responses (
  id                  uuid primary key default gen_random_uuid(),
  advice_request_id   uuid not null references public.advice_requests(id) on delete cascade,
  admin_id            uuid not null references auth.users(id) on delete cascade,
  message             text not null,
  bible_references    text[] not null default '{}',
  created_at          timestamptz not null default now()
);

alter table public.advice_responses enable row level security;

create policy "Owner and admins can read advice responses"
  on public.advice_responses for select
  to authenticated using (
    is_admin(auth.uid()) or
    exists (select 1 from public.advice_requests where id = advice_request_id and user_id = auth.uid())
  );

create policy "Admins can insert advice responses"
  on public.advice_responses for insert
  to authenticated with check (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: inspirations
-- ─────────────────────────────────────────────────────────────
create table if not exists public.inspirations (
  id              uuid primary key default gen_random_uuid(),
  admin_id        uuid not null references auth.users(id) on delete cascade,
  church_id       uuid references public.churches(id) on delete cascade,
  title           text not null,
  content         text not null,
  type            text not null default 'motivation' check (type in ('devotional','motivation','challenge','verse','testimony')),
  bible_reference text,
  media_url       text,
  scheduled_at    timestamptz,
  published_at    timestamptz default now(),
  like_count      integer not null default 0,
  comment_count   integer not null default 0,
  created_at      timestamptz not null default now()
);

alter table public.inspirations enable row level security;

create policy "Church members can read inspirations"
  on public.inspirations for select
  to authenticated using (true);

create policy "Admins can insert inspirations"
  on public.inspirations for insert
  to authenticated with check (is_admin(auth.uid()));

create policy "Admins can update inspirations"
  on public.inspirations for update
  to authenticated using (is_admin(auth.uid()));

create policy "Admins can delete inspirations"
  on public.inspirations for delete
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: inspiration_reactions
-- ─────────────────────────────────────────────────────────────
create table if not exists public.inspiration_reactions (
  id              uuid primary key default gen_random_uuid(),
  inspiration_id  uuid not null references public.inspirations(id) on delete cascade,
  user_id         uuid not null references auth.users(id) on delete cascade,
  reaction_type   text not null default 'like',
  created_at      timestamptz not null default now(),
  unique (inspiration_id, user_id)
);

alter table public.inspiration_reactions enable row level security;

create policy "Users can read reactions"
  on public.inspiration_reactions for select
  to authenticated using (true);

create policy "Users can add their own reaction"
  on public.inspiration_reactions for insert
  to authenticated with check (auth.uid() = user_id);

create policy "Users can remove their own reaction"
  on public.inspiration_reactions for delete
  to authenticated using (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────
-- TABLE: forum_posts  (privacy-preserving anonymous tokens)
-- ─────────────────────────────────────────────────────────────
create table if not exists public.forum_posts (
  id              uuid primary key default gen_random_uuid(),
  anonymous_token text not null,       -- SHA-256 hash of user_id + server salt
  church_id       uuid references public.churches(id) on delete cascade,
  title           text not null,
  content         text not null,
  display_name    text not null default 'Anonymous Member',
  vote_score      integer not null default 0,
  like_count      integer not null default 0,
  comment_count   integer not null default 0,
  is_removed      boolean not null default false,
  created_at      timestamptz not null default now()
);

alter table public.forum_posts enable row level security;

create policy "Church members can read non-removed forum posts"
  on public.forum_posts for select
  to authenticated using (not is_removed);

create policy "Authenticated users can create forum posts"
  on public.forum_posts for insert
  to authenticated with check (true);

create policy "Admins can update/remove forum posts"
  on public.forum_posts for update
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: forum_votes
-- ─────────────────────────────────────────────────────────────
create table if not exists public.forum_votes (
  id              uuid primary key default gen_random_uuid(),
  post_id         uuid not null references public.forum_posts(id) on delete cascade,
  anonymous_token text not null,
  vote_type       text not null check (vote_type in ('up','down')),
  unique (post_id, anonymous_token)
);

alter table public.forum_votes enable row level security;

create policy "Authenticated users can manage forum votes"
  on public.forum_votes for all
  to authenticated using (true) with check (true);

-- ─────────────────────────────────────────────────────────────
-- TABLE: forum_reports
-- ─────────────────────────────────────────────────────────────
create table if not exists public.forum_reports (
  id              uuid primary key default gen_random_uuid(),
  post_id         uuid references public.forum_posts(id) on delete cascade,
  reason          text not null,
  reporter_token  text not null,
  created_at      timestamptz not null default now()
);

alter table public.forum_reports enable row level security;

create policy "Admins can read forum reports"
  on public.forum_reports for select
  to authenticated using (is_admin(auth.uid()));

create policy "Authenticated users can report posts"
  on public.forum_reports for insert
  to authenticated with check (true);

-- ─────────────────────────────────────────────────────────────
-- TABLE: events
-- ─────────────────────────────────────────────────────────────
create table if not exists public.events (
  id                  uuid primary key default gen_random_uuid(),
  church_id           uuid references public.churches(id) on delete cascade,
  title               text not null,
  description         text,
  location            text,
  start_time          timestamptz not null,
  end_time            timestamptz not null,
  is_recurring        boolean not null default false,
  recurring_pattern   text,
  created_by          uuid references auth.users(id) on delete set null,
  registration_count  integer not null default 0,
  created_at          timestamptz not null default now()
);

alter table public.events enable row level security;

create policy "Church members can read events"
  on public.events for select
  to authenticated using (true);

create policy "Admins can insert events"
  on public.events for insert
  to authenticated with check (is_admin(auth.uid()));

create policy "Admins can update events"
  on public.events for update
  to authenticated using (is_admin(auth.uid()));

create policy "Admins can delete events"
  on public.events for delete
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: event_registrations
-- ─────────────────────────────────────────────────────────────
create table if not exists public.event_registrations (
  id          uuid primary key default gen_random_uuid(),
  event_id    uuid not null references public.events(id) on delete cascade,
  user_id     uuid not null references auth.users(id) on delete cascade,
  created_at  timestamptz not null default now(),
  unique (event_id, user_id)
);

alter table public.event_registrations enable row level security;

create policy "Users can see their own registrations"
  on public.event_registrations for select
  to authenticated using (auth.uid() = user_id);

create policy "Users can register for events"
  on public.event_registrations for insert
  to authenticated with check (auth.uid() = user_id);

create policy "Users can unregister"
  on public.event_registrations for delete
  to authenticated using (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────
-- TABLE: announcements
-- ─────────────────────────────────────────────────────────────
create table if not exists public.announcements (
  id          uuid primary key default gen_random_uuid(),
  church_id   uuid references public.churches(id) on delete cascade,
  admin_id    uuid references auth.users(id) on delete set null,
  title       text not null,
  content     text not null,
  media_urls  text[] not null default '{}',
  is_pinned   boolean not null default false,
  created_at  timestamptz not null default now()
);

alter table public.announcements enable row level security;

create policy "Church members can read announcements"
  on public.announcements for select
  to authenticated using (true);

create policy "Admins can insert announcements"
  on public.announcements for insert
  to authenticated with check (is_admin(auth.uid()));

create policy "Admins can update announcements"
  on public.announcements for update
  to authenticated using (is_admin(auth.uid()));

create policy "Admins can delete announcements"
  on public.announcements for delete
  to authenticated using (is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- TABLE: notifications
-- ─────────────────────────────────────────────────────────────
create table if not exists public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  type        text not null,
  title       text not null,
  body        text not null,
  data        jsonb not null default '{}',
  is_read     boolean not null default false,
  created_at  timestamptz not null default now()
);

alter table public.notifications enable row level security;

create policy "Users can read their own notifications"
  on public.notifications for select
  to authenticated using (auth.uid() = user_id);

create policy "Users can mark notifications as read"
  on public.notifications for update
  to authenticated using (auth.uid() = user_id);

create policy "Users can delete their notifications"
  on public.notifications for delete
  to authenticated using (auth.uid() = user_id);

-- Edge Functions / service role can insert notifications
-- (no insert policy for authenticated — Edge Functions use service_role key)

-- ─────────────────────────────────────────────────────────────
-- TABLE: fcm_tokens
-- ─────────────────────────────────────────────────────────────
create table if not exists public.fcm_tokens (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  token       text not null,
  platform    text not null check (platform in ('android','ios','web')),
  created_at  timestamptz not null default now(),
  unique (user_id, token)
);

alter table public.fcm_tokens enable row level security;

create policy "Users can manage their own FCM tokens"
  on public.fcm_tokens for all
  to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────
-- STORAGE BUCKETS
-- ─────────────────────────────────────────────────────────────
-- Run these separately in the Supabase Dashboard → Storage → New bucket
-- OR via the Management API / supabase CLI:
--
--   supabase storage create avatars --public
--   supabase storage create inspiration-media --public
--
-- After creating the buckets, apply these storage policies:

-- Avatar bucket policies
create policy "Avatar images are publicly accessible"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "Users can upload their own avatar"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Users can update their own avatar"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Users can delete their own avatar"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);

-- Inspiration media bucket policies
create policy "Inspiration media is publicly accessible"
  on storage.objects for select
  using (bucket_id = 'inspiration-media');

create policy "Admins can upload inspiration media"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'inspiration-media' and is_admin(auth.uid()));

-- ─────────────────────────────────────────────────────────────
-- REALTIME: enable for key tables
-- ─────────────────────────────────────────────────────────────
-- In the Supabase Dashboard → Database → Replication
-- OR run:
alter publication supabase_realtime add table public.forum_posts;
alter publication supabase_realtime add table public.notifications;
alter publication supabase_realtime add table public.inspirations;
alter publication supabase_realtime add table public.prayer_requests;
