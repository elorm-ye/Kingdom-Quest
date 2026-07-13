import 'dart:math';
import '../models/models.dart';

/// Mock data service providing realistic sample data for all modules.
/// This will be replaced with actual Supabase API calls in production.

class MockDataService {
  static final _random = Random();

  // ─────────────────────────────────────────────
  // BIBLE VERSES
  // ─────────────────────────────────────────────

  static const List<Map<String, String>> bibleVerses = [
    {
      'text': '"Seek first his kingdom, and all these things will be given to you."',
      'reference': 'Matthew 6:33',
    },
    {
      'text': '"For I know the plans I have for you, declares the Lord, plans to prosper you."',
      'reference': 'Jeremiah 29:11',
    },
    {
      'text': '"I can do all things through Christ who strengthens me."',
      'reference': 'Philippians 4:13',
    },
    {
      'text': '"The Lord is my shepherd; I shall not want."',
      'reference': 'Psalm 23:1',
    },
    {
      'text': '"Trust in the Lord with all your heart and lean not on your own understanding."',
      'reference': 'Proverbs 3:5',
    },
    {
      'text': '"Be strong and courageous. Do not be afraid; for the Lord your God will be with you."',
      'reference': 'Joshua 1:9',
    },
    {
      'text': '"Cast all your anxiety on him because he cares for you."',
      'reference': '1 Peter 5:7',
    },
    {
      'text': '"The Lord is close to the brokenhearted and saves those who are crushed in spirit."',
      'reference': 'Psalm 34:18',
    },
  ];

  static Map<String, String> getDailyVerse() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return bibleVerses[dayOfYear % bibleVerses.length];
  }

  // ─────────────────────────────────────────────
  // MOCK USER
  // ─────────────────────────────────────────────

  static UserModel get currentUser => UserModel(
    id: 'user_001',
    email: 'youth@kingdomquest.app',
    displayName: 'David',
    avatarUrl: null,
    role: UserRole.member,
    churchId: 'church_001',
    gender: Gender.male,
    bio: 'A passionate youth member seeking spiritual growth',
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
  );

  // ─────────────────────────────────────────────
  // PRAYER REQUESTS
  // ─────────────────────────────────────────────

  static List<PrayerRequest> get prayerRequests => [
    PrayerRequest(
      id: 'pr_001',
      userId: 'user_001',
      title: 'Healing for my grandmother',
      description: 'My grandmother has been sick for weeks. Please pray for her recovery and strength for our family.',
      category: PrayerCategory.healing,
      isAnonymous: false,
      submitterName: 'David',
      status: PrayerStatus.praying,
      prayerCount: 24,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      responses: [
        PrayerResponse(
          id: 'resp_001',
          prayerRequestId: 'pr_001',
          adminId: 'admin_001',
          adminName: 'Pastor James',
          message: 'We are praying with you, David. God is the ultimate healer. Stay strong in faith.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    PrayerRequest(
      id: 'pr_002',
      title: 'Guidance for exams',
      description: 'I have important exams coming up. Please pray that God gives me wisdom and clarity.',
      category: PrayerCategory.education,
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Sister',
      status: PrayerStatus.pending,
      prayerCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PrayerRequest(
      id: 'pr_003',
      userId: 'user_003',
      title: 'Family restoration',
      description: 'My parents are going through a tough time. Please pray for peace and unity in my home.',
      category: PrayerCategory.family,
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Brother',
      status: PrayerStatus.pending,
      prayerCount: 32,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    PrayerRequest(
      id: 'pr_004',
      userId: 'user_004',
      title: 'Thankful for answered prayers',
      description: 'God has been so faithful. I got the job I was praying for! Thank you for your prayers, church family.',
      category: PrayerCategory.thanksgiving,
      isAnonymous: false,
      submitterName: 'Grace',
      status: PrayerStatus.answered,
      prayerCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PrayerRequest(
      id: 'pr_005',
      title: 'Financial breakthrough',
      description: 'I need God\'s provision for my tuition fees. Trusting Him to make a way.',
      category: PrayerCategory.financial,
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: PrayerStatus.praying,
      prayerCount: 19,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  // ─────────────────────────────────────────────
  // PETITIONS
  // ─────────────────────────────────────────────

  static List<Petition> get petitions => [
    Petition(
      id: 'pet_001',
      userId: 'user_001',
      subject: 'Youth service time change',
      description: 'Could we consider moving the youth service to Saturday evenings? Many of us have morning commitments on Sundays.',
      isAnonymous: false,
      submitterName: 'David',
      status: PetitionStatus.underReview,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Petition(
      id: 'pet_002',
      subject: 'More worship instruments',
      description: 'It would be great to add a keyboard and bass guitar to our worship team setup.',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: PetitionStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Petition(
      id: 'pet_003',
      userId: 'user_005',
      subject: 'Bible study materials',
      description: 'Can we get study guides and workbooks for the current sermon series?',
      isAnonymous: false,
      submitterName: 'Sarah',
      status: PetitionStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ─────────────────────────────────────────────
  // ADVICE REQUESTS
  // ─────────────────────────────────────────────

  static List<AdviceRequest> get adviceRequests => [
    AdviceRequest(
      id: 'adv_001',
      title: 'How to handle peer pressure',
      description: 'I\'m struggling with peer pressure at school. My friends want me to do things I know are wrong. How do I stay strong?',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Brother',
      status: AdviceStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      responses: [
        AdviceResponse(
          id: 'advr_001',
          adviceRequestId: 'adv_001',
          adminId: 'admin_001',
          adminName: 'Pastor James',
          message: 'It takes courage to stand firm. Remember, true friends will respect your values. Surround yourself with people who uplift you.',
          bibleReferences: ['1 Corinthians 15:33', 'Proverbs 13:20', 'Romans 12:2'],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    AdviceRequest(
      id: 'adv_002',
      title: 'Dealing with doubt',
      description: 'Sometimes I have doubts about my faith. Is it normal? How can I strengthen my belief?',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Sister',
      status: AdviceStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AdviceRequest(
      id: 'adv_003',
      title: 'Forgiving someone who hurt me',
      description: 'A close friend betrayed my trust and I\'m finding it hard to forgive them. What does the Bible say about this?',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: AdviceStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  // ─────────────────────────────────────────────
  // INSPIRATIONS
  // ─────────────────────────────────────────────

  static List<Inspiration> get inspirations => [
    Inspiration(
      id: 'insp_001',
      adminId: 'admin_001',
      adminName: 'Pastor James',
      title: 'Start here. The rest can wait.',
      content: 'Whatever you\'re carrying — you don\'t have to hold it alone. No pressure. Come back when you\'re ready. This stays between you and the team.',
      type: InspirationType.motivation,
      bibleReference: 'Matthew 6:33',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      likeCount: 47,
      commentCount: 12,
      isLikedByUser: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Inspiration(
      id: 'insp_002',
      adminId: 'admin_002',
      adminName: 'Minister Ruth',
      title: 'Weekly Faith Challenge',
      content: 'This week\'s challenge: Perform one random act of kindness each day without telling anyone. Let your light shine through your actions.',
      type: InspirationType.challenge,
      bibleReference: 'Matthew 5:16',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      likeCount: 63,
      commentCount: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Inspiration(
      id: 'insp_003',
      adminId: 'admin_001',
      adminName: 'Pastor James',
      title: 'Morning Devotional',
      content: 'God\'s mercies are new every morning. No matter what happened yesterday, today is a fresh start. Embrace the grace that awaits you.',
      type: InspirationType.devotional,
      bibleReference: 'Lamentations 3:22-23',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      likeCount: 89,
      commentCount: 31,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ─────────────────────────────────────────────
  // FORUM POSTS
  // ─────────────────────────────────────────────

  static List<ForumPost> get forumPosts => [
    ForumPost(
      id: 'fp_001',
      title: 'How do you deal with anxiety as a Christian?',
      content: 'I\'ve been dealing with anxiety lately and I know the Bible says not to worry, but it\'s easier said than done. What are some practical things you do?',
      displayName: 'Anonymous Brother',
      likeCount: 34,
      commentCount: 18,
      voteScore: 42,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ForumPost(
      id: 'fp_002',
      title: 'Anyone else struggling with consistency in prayer?',
      content: 'I start strong but after a few days, I fall off. Any tips on building a consistent prayer life?',
      displayName: 'Anonymous Sister',
      likeCount: 56,
      commentCount: 24,
      voteScore: 61,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    ForumPost(
      id: 'fp_003',
      title: 'Feeling distant from God',
      content: 'I used to feel so close to God but lately everything feels dry. I go to church, read my Bible, but something feels off. Can anyone relate?',
      displayName: 'Anonymous Member',
      likeCount: 78,
      commentCount: 35,
      voteScore: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ForumPost(
      id: 'fp_004',
      title: 'Testimony: God answered my impossible prayer!',
      content: 'I just want to share that God showed up for me in an incredible way. I was about to lose my scholarship, but everything worked out. God is faithful!',
      displayName: 'Anonymous Sister',
      likeCount: 102,
      commentCount: 42,
      voteScore: 115,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ─────────────────────────────────────────────
  // EVENTS
  // ─────────────────────────────────────────────

  static List<ChurchEvent> get events => [
    ChurchEvent(
      id: 'ev_001',
      title: 'Youth Sunday Service',
      description: 'Join us for an uplifting worship experience designed for the youth. Come as you are!',
      location: 'Main Auditorium',
      startTime: _nextSunday().add(const Duration(hours: 9)),
      endTime: _nextSunday().add(const Duration(hours: 12)),
      isRecurring: true,
      recurringPattern: 'Weekly',
      createdBy: 'admin_001',
      registrationCount: 85,
      isRegistered: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    ChurchEvent(
      id: 'ev_002',
      title: 'Prayer Night',
      description: 'A night of deep prayer and intercession. Bring your burdens and let\'s pray together.',
      location: 'Chapel',
      startTime: _nextFriday().add(const Duration(hours: 19)),
      endTime: _nextFriday().add(const Duration(hours: 21)),
      isRecurring: true,
      recurringPattern: 'Monthly',
      createdBy: 'admin_001',
      registrationCount: 42,
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
    ChurchEvent(
      id: 'ev_003',
      title: 'Youth Conference 2026',
      description: 'Our annual youth conference themed "Arise & Shine". 3 days of worship, teaching, and fellowship.',
      location: 'Conference Center',
      startTime: DateTime.now().add(const Duration(days: 21)),
      endTime: DateTime.now().add(const Duration(days: 23)),
      createdBy: 'admin_001',
      registrationCount: 156,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ChurchEvent(
      id: 'ev_004',
      title: 'Bible Study Group',
      description: 'Studying the book of Romans together. All levels welcome!',
      location: 'Room 204',
      startTime: _nextWednesday().add(const Duration(hours: 18)),
      endTime: _nextWednesday().add(const Duration(hours: 19, minutes: 30)),
      isRecurring: true,
      recurringPattern: 'Weekly',
      createdBy: 'admin_002',
      registrationCount: 28,
      isRegistered: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  // ─────────────────────────────────────────────
  // ANNOUNCEMENTS
  // ─────────────────────────────────────────────

  static List<Announcement> get announcements => [
    Announcement(
      id: 'ann_001',
      adminId: 'admin_001',
      adminName: 'Pastor James',
      title: 'Youth Conference Registration Open!',
      content: 'Registration for the 2026 Youth Conference is now open. Early bird discount available until July 31st.',
      isPinned: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Announcement(
      id: 'ann_002',
      adminId: 'admin_002',
      adminName: 'Minister Ruth',
      title: 'New Bible Study Series',
      content: 'Starting next Wednesday, we begin a new study on the book of Romans. Materials will be provided.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // ─────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────

  static List<AppNotification> get notifications => [
    AppNotification(
      id: 'notif_001',
      userId: 'user_001',
      type: 'prayer_response',
      title: 'Prayer Request Response',
      body: 'Pastor James responded to your prayer request.',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 'notif_002',
      userId: 'user_001',
      type: 'inspiration',
      title: 'New Daily Inspiration',
      body: 'Start here. The rest can wait.',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'notif_003',
      userId: 'user_001',
      type: 'announcement',
      title: 'Church Announcement',
      body: 'Youth Conference Registration Open!',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppNotification(
      id: 'notif_004',
      userId: 'user_001',
      type: 'event_reminder',
      title: 'Event Reminder',
      body: 'Bible Study Group starts in 2 hours.',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ─────────────────────────────────────────────
  // HELPER METHODS
  // ─────────────────────────────────────────────

  static DateTime _nextSunday() {
    final now = DateTime.now();
    final daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
    return DateTime(now.year, now.month, now.day + (daysUntilSunday == 0 ? 7 : daysUntilSunday));
  }

  static DateTime _nextFriday() {
    final now = DateTime.now();
    final daysUntilFriday = (DateTime.friday - now.weekday) % 7;
    return DateTime(now.year, now.month, now.day + (daysUntilFriday == 0 ? 7 : daysUntilFriday));
  }

  static DateTime _nextWednesday() {
    final now = DateTime.now();
    final daysUntilWednesday = (DateTime.wednesday - now.weekday) % 7;
    return DateTime(now.year, now.month, now.day + (daysUntilWednesday == 0 ? 7 : daysUntilWednesday));
  }
}
