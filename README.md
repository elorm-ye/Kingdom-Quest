# Kingdom Quest 

A comprehensive, cross-platform youth ministry solution built with **Flutter (Mobile)**, **Next.js (Web)**, and **Supabase (Backend)**. Kingdom Quest provides a safe, sacred space for church communities with support for multi-church architecture, prayer requests, petitions, a spiritual advice center, daily inspiration, community forums, and a robust admin dashboard.

---

## Platform Architecture

The Kingdom Quest platform consists of three main components:

1. **Mobile App (`/`)**: Built with Flutter 3.x, Riverpod, and GoRouter. Designed for both iOS and Android.
2. **Web App & Admin Panel (`/kingdom-quest-web/`)**: Built with Next.js 15, React, and Tailwind CSS. Acts as a member-facing PWA and a role-gated admin management portal.
3. **Backend**: Powered by Supabase (PostgreSQL, Auth, Realtime, Storage, Edge Functions).

## Key Features

### For Youth & Members
- **Authentication**: Email/password and Google OAuth support.
- **Prayer Requests**: Post, view, comment, and track prayer requests.
- **Community Forum**: Safe, anonymous discussions utilizing SHA-256 hashed identifiers to protect user privacy.
- **Advice Center**: Seek spiritual guidance directly from church elders.
- **Daily Inspiration**: Curated devotionals, verses, and testimonies.
- **Events Calendar**: View upcoming church events and RSVP.
- **Notifications**: Real-time alerts powered by Supabase Realtime and Firebase Cloud Messaging (FCM).

### For Admins (Role-gated)
- **Dashboard**: High-level statistics on platform engagement.
- **Moderation**: Ability to review reported forum posts and manage advice requests.
- **Content Publishing**: Create and schedule daily inspiration and global announcements.
- **User Management**: Assign roles and manage community members.

---

## Getting Started

### Prerequisites
- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Node.js**: v18+ [Install Node](https://nodejs.org/)
- **Supabase Account**: For backend deployment.

### 1. Supabase Backend Setup
1. Create a new Supabase project.
2. Run the SQL script found in `lib/core/supabase/supabase_schema.sql` in your Supabase SQL Editor to generate all tables, RLS policies, and triggers.
3. Obtain your `Project URL` and `Anon Key`.

### 2. Running the Flutter App (iOS / Android)
```bash
# From the root directory
flutter pub get

# Create a .env file and add your Supabase credentials:
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_ANON_KEY=your-anon-key

# Run the app
flutter run
```

### 3. Running the Next.js Web App
```bash
# Navigate to the web directory
cd kingdom-quest-web

# Install dependencies
npm install

# Create a .env.local file and add your Supabase credentials:
# NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

# Run the development server
npm run dev
```
Open `http://localhost:3000` in your browser.

---

## Design System

Both the Mobile and Web apps share a unified design token system to ensure strict brand continuity.

- **Primary**: Terracotta (`#B8614A`)
- **Accent**: Burnt Amber (`#C7784E`)
- **Secondary**: Olive Clay (`#7E7458`)
- **Background**: Sand (`#F1E9DC`)
- **Cards**: Linen (`#F8F1E8`)

**Typography**:
- Headers: Bricolage Grotesque
- Body: Schibsted Grotesk

---

## Security & Privacy

- **Row-Level Security (RLS)**: Strictly enforced on every PostgreSQL table via Supabase to prevent data leaks.
- **Anonymity**: Forum identity is preserved using a one-way SHA-256 hash (User ID + Server Salt) which rotates monthly, protecting users while preventing ban-evasion.

---

## Tech Stack Details

- **Mobile**: Flutter, Dart, Riverpod (State), GoRouter (Navigation), supabase_flutter.
- **Web**: Next.js (App Router), React, Tailwind CSS, @supabase/ssr.
- **Push Notifications**: Firebase Cloud Messaging (FCM).
