# Kingdom Quest — Mobile App

A Flutter-based youth ministry app with multi-church support, prayer requests, petitions, advice center, daily inspiration, Bible study, and admin dashboard — built with Supabase backend and designed for iOS/Android.

##  Getting Started

### Prerequisites

- **Flutter 3.x SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Android Studio or VS Code**
- **Android device or emulator**

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd kingdom_quest

# Install dependencies
flutter pub get

# Run the app
flutter run
```

##  Project Structure

```
kingdom_quest/
├── lib/
│   ├── main.dart                  # App entry point
│   ├── core/                      # Core utilities
│   │   ├── theme/                 # Design system & themes
│   │   ├── providers/             # Riverpod providers
│   │   ├── router/                # GoRouter navigation
│   │   └── supabase/              # Supabase client
│   ├── features/                  # App features
│   │   ├── auth/                  # Authentication
│   │   ├── dashboard/             # Dashboard overview
│   │   ├── prayer_requests/       # Prayer requests
│   │   ├── petitions/             # Petitions with voting
│   │   ├── advice/                # Ask-an-elder advice
│   │   ├── daily_inspiration/     # Daily verse + devotional
│   │   ├── community_forum/       # Forum with posts/replies
│   │   ├── events/                # Events calendar & RSVPs
│   │   ├── notifications/         # Notification center
│   │   ├── profile/               # User profile & settings
│   │   └── admin/                 # Admin dashboard
│   └── shared/                    # Shared components
│       ├── widgets/
│       ├── models/
│       └── services/
├── assets/                        # Images, icons, fonts
├── pubspec.yaml                   # Dependencies
└── README.md                      # This file
```

##  Key Features

### For Youth & Members
- **Authentication**: Email/password, Google sign-in, magic links
- **Dashboard**: Quick stats + quick actions
- **Prayer Requests**: Post, view, comment, mark answered
- **Petitions**: Read, upvote, sign, track status
- **Advice Center**: Submit anonymous questions, get pastor replies
- **Daily Inspiration**: Verse + devotional (published by admin)
- **Community Forum**: Post topics, reply, report abuse
- **Events Calendar**: View events, RSVP, get reminders
- **Notifications**: Real-time alerts for new content
- **User Profile**: Manage settings, view activity, change password

### Admin Features (Admin Role)
- **Admin Dashboard**: Stats overview, quick actions
- **Prayer Management**: View, respond, mark answered
- **Petition Management**: Update status, respond to petitioners
- **Advice Moderation**: Respond to questions, close discussions
- **Content Publishing**: Create and schedule daily inspiration
- **Forum Moderation**: View reports, remove posts
- **User Management**: View members, assign roles

##  Tech Stack

- **Framework**: [Flutter 3.x](https://flutter.dev/)
- **Language**: [Dart 3.x](https://dart.dev/)
- **State Management**: [Riverpod 3.x](https://riverpod.dev/)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Backend**: [Supabase](https://supabase.com/)
  - Auth (email, Google OAuth, magic links)
  - PostgreSQL database
  - Realtime subscriptions
  - Storage
  - Edge Functions (for notifications, moderation, etc.)
- **Push Notifications**: [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- **Icons**: [Font Awesome Flutter](https://pub.dev/packages/font_awesome_flutter)
- **Design**: Custom design tokens + Material 3

##  Contributing

1. Create a feature branch: `git checkout -b feature/new-feature`
2. Make your changes
3. Test thoroughly on Android emulator or device
4. Run `flutter format .`
5. Commit: `git commit -m "feat: add new feature"`
6. Push: `git push origin feature/new-feature`
7. Create a pull request

### Coding Standards
- Use Riverpod providers for state management
- Follow the existing folder structure
- Keep UI components reusable
- Add type hints and comments where needed
- Test all new functionality

##  Design System

### Color Palette
- **Primary**: Terracotta (#B8614A)
- **Accent**: Burnt Amber (#C7784E)
- **Secondary**: Olive Clay (#7E7458)
- **Background**: Sand (#F1E9DC)
- **Cards**: Linen (#F8F1E8)

### Typography
- **Display**: Bricolage Grotesque (400/500/600/700)
- **Body**: Schibsted Grotesk (400/500/600)
- **Caption**: Mono uppercase (14px)

### Spacing
- 4px base grid
- Steps: 4, 8, 12, 16, 24, 32, 48, 64
- Border radii: 12px (buttons), 16px (cards), 24px (sections)

##  Feature Modules

### Auth Module
- Screens: Login, Register, Forgot Password, Verify Email, Reset Password
- Providers: `AuthServiceProvider`, `AuthProvider`
- Flow: Email/password or Google sign-in → verify email → magic link → auto-redirect

### Dashboard Module
- Screens: Dashboard Overview
- Providers: `DashboardProvider`
- Widgets: Stat cards, quick action buttons

### Prayer Requests Module
- Screens: Prayer List, New Prayer Request, Prayer Detail
- Providers: `PrayerRequestServiceProvider`, `PrayerListProvider`
- Features: Create, view, comment, mark answered, filter by church

### Petitions Module
- Screens: Petition List, Petition Detail
- Providers: `PetitionServiceProvider`
- Features: View, upvote, sign petition, track status

### Advice Center Module
- Screens: Advice List, New Advice, Advice Detail
- Providers: `AdviceServiceProvider`
- Features: Anonymous questions, pastor replies, moderation

### Daily Inspiration Module
- Screens: Daily Inspiration
- Providers: `DailyInspirationProvider`
- Features: Verse of the day, devotional, sharing

### Community Forum Module
- Screens: Forum List, New Post, Post Detail
- Providers: `ForumServiceProvider`
- Features: Post topics, replies, reporting

### Events Module
- Screens: Events List, Event Detail, RSVP
- Providers: `EventServiceProvider`
- Features: Event calendar, RSVP tracking

### Notifications Module
- Screens: Notification List
- Providers: `NotificationServiceProvider`
- Features: Real-time notifications, mark as read

### Profile & Settings Module
- Screens: Profile, Edit Profile, Change Password, Logout
- Providers: `ProfileServiceProvider`
- Features: User info, password change, delete account

### Admin Dashboard Module
- Screens: Admin Dashboard, User Management, Prayer Management, etc.
- Providers: Admin service providers
- Features: Full admin control over all features

##  Supabase Integration

### Database Schema (Simplified)
```sql
-- users table (managed by Supabase Auth)
-- profiles: link to auth.users
create table profiles (
    id uuid references auth.users primary key,
    church_id uuid references churches(id) on delete set null,
    role text default 'member' check (role in ('member', 'elder', 'admin')),
    full_name text,
    avatar_url text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- churches
create table churches (
    id uuid default uuid_generate_v4() primary key,
    name text not null,
    created_at timestamp with time zone default timezone('utc'::text, now
