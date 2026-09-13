import '../models/models.dart';

/// Mock data service providing realistic sample data for all modules.
/// This will be replaced with actual Supabase API calls in production.

class MockDataService {
  // ─────────────────────────────────────────────
  // BIBLE VERSES
  // ─────────────────────────────────────────────

  static const List<Map<String, String>> bibleVerses = [
    {
      'text':
          '"Seek first his kingdom, and all these things will be given to you."',
      'reference': 'Matthew 6:33',
    },
    {
      'text':
          '"For I know the plans I have for you, declares the Lord, plans to prosper you."',
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
      'text':
          '"Trust in the Lord with all your heart and lean not on your own understanding."',
      'reference': 'Proverbs 3:5',
    },
    {
      'text':
          '"Be strong and courageous. Do not be afraid; for the Lord your God will be with you."',
      'reference': 'Joshua 1:9',
    },
    {
      'text': '"Cast all your anxiety on him because he cares for you."',
      'reference': '1 Peter 5:7',
    },
    {
      'text':
          '"The Lord is close to the brokenhearted and saves those who are crushed in spirit."',
      'reference': 'Psalm 34:18',
    },
  ];

  static Map<String, String> getDailyVerse() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    return bibleVerses[dayOfYear % bibleVerses.length];
  }

  // ─────────────────────────────────────────────
  // MOCK USER & CHURCH PROFILE
  // ─────────────────────────────────────────────

  static UserModel currentUser = UserModel(
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

  static UserModel adminUser = UserModel(
    id: 'admin_001',
    email: 'pastor.james@kingdomquest.app',
    displayName: 'Pastor James',
    avatarUrl: null,
    role: UserRole.admin,
    churchId: 'church_001',
    gender: Gender.male,
    bio: 'Senior Pastor & Administrator',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
  );

  static Map<String, String> churchProfile = {
    'name': 'Kingdom Quest Youth',
    'denomination': 'International Central Gospel Church (ICGC)',
    'motto': 'Raising Leaders, Shaping Vision, Influencing Society Through Christ',
    'pastor': 'Pastor James',
    'location': 'Christ Temple, Abossey Okai, Accra',
    'phone': '+233 30 268 8000',
    'email': 'youth@kingdomquest.app',
    'serviceTimes': 'Sunday: 9:00 AM - 12:00 PM\nWednesday: 6:00 PM - 7:30 PM\nFriday: 7:00 PM - 9:00 PM',
  };

  // ─────────────────────────────────────────────
  // PRAYER REQUESTS
  // ─────────────────────────────────────────────

  static final List<PrayerRequest> _prayerRequestsList = [
    PrayerRequest(
      id: 'pr_001',
      userId: 'user_001',
      title: 'Healing for my grandmother',
      description:
          'My grandmother has been sick for weeks. Please pray for her recovery and strength for our family.',
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
          message:
              'We are praying with you, David. God is the ultimate healer. Stay strong in faith.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
    PrayerRequest(
      id: 'pr_002',
      title: 'Guidance for exams',
      description:
          'I have important exams coming up. Please pray that God gives me wisdom and clarity.',
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
      description:
          'My parents are going through a tough time. Please pray for peace and unity in my home.',
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
      description:
          'God has been so faithful. I got the job I was praying for! Thank you for your prayers, church family.',
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
      description:
          'I need God\'s provision for my tuition fees. Trusting Him to make a way.',
      category: PrayerCategory.financial,
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: PrayerStatus.praying,
      prayerCount: 19,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  static List<PrayerRequest> get prayerRequests => _prayerRequestsList;
  static void addPrayerRequest(PrayerRequest r) => _prayerRequestsList.insert(0, r);

  // ─────────────────────────────────────────────
  // PETITIONS
  // ─────────────────────────────────────────────

  static final List<Petition> _petitionsList = [
    Petition(
      id: 'pet_001',
      userId: 'user_001',
      subject: 'Youth service time change',
      description:
          'Could we consider moving the youth service to Saturday evenings? Many of us have morning commitments on Sundays.',
      isAnonymous: false,
      submitterName: 'David',
      status: PetitionStatus.underReview,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Petition(
      id: 'pet_002',
      subject: 'More worship instruments',
      description:
          'It would be great to add a keyboard and bass guitar to our worship team setup.',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: PetitionStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Petition(
      id: 'pet_003',
      userId: 'user_005',
      subject: 'Bible study materials',
      description:
          'Can we get study guides and workbooks for the current sermon series?',
      isAnonymous: false,
      submitterName: 'Sarah',
      status: PetitionStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static List<Petition> get petitions => _petitionsList;
  static void addPetition(Petition p) => _petitionsList.insert(0, p);

  // ─────────────────────────────────────────────
  // ADVICE REQUESTS
  // ─────────────────────────────────────────────

  static final List<AdviceRequest> _adviceRequestsList = [
    AdviceRequest(
      id: 'adv_001',
      title: 'How to handle peer pressure',
      description:
          'I\'m struggling with peer pressure at school. My friends want me to do things I know are wrong. How do I stay strong?',
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
          message:
              'It takes courage to stand firm. Remember, true friends will respect your values. Surround yourself with people who uplift you.',
          bibleReferences: [
            '1 Corinthians 15:33',
            'Proverbs 13:20',
            'Romans 12:2',
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    AdviceRequest(
      id: 'adv_002',
      title: 'Dealing with doubt',
      description:
          'Sometimes I have doubts about my faith. Is it normal? How can I strengthen my belief?',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Sister',
      status: AdviceStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AdviceRequest(
      id: 'adv_003',
      title: 'Forgiving someone who hurt me',
      description:
          'A close friend betrayed my trust and I\'m finding it hard to forgive them. What does the Bible say about this?',
      isAnonymous: true,
      anonymousDisplayName: 'Anonymous Member',
      status: AdviceStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  static List<AdviceRequest> get adviceRequests => _adviceRequestsList;
  static void addAdviceRequest(AdviceRequest a) => _adviceRequestsList.insert(0, a);

  // ─────────────────────────────────────────────
  // INSPIRATIONS
  // ─────────────────────────────────────────────

  static List<Inspiration> get inspirations => [
    Inspiration(
      id: 'insp_001',
      adminId: 'admin_001',
      adminName: 'Pastor James',
      title: 'Start here. The rest can wait.',
      content:
          'Whatever you\'re carrying — you don\'t have to hold it alone. No pressure. Come back when you\'re ready. This stays between you and the team.',
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
      content:
          'This week\'s challenge: Perform one random act of kindness each day without telling anyone. Let your light shine through your actions.',
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
      content:
          'God\'s mercies are new every morning. No matter what happened yesterday, today is a fresh start. Embrace the grace that awaits you.',
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
      content:
          'I\'ve been dealing with anxiety lately and I know the Bible says not to worry, but it\'s easier said than done. What are some practical things you do?',
      displayName: 'Anonymous Brother',
      likeCount: 34,
      commentCount: 18,
      voteScore: 42,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ForumPost(
      id: 'fp_002',
      title: 'Anyone else struggling with consistency in prayer?',
      content:
          'I start strong but after a few days, I fall off. Any tips on building a consistent prayer life?',
      displayName: 'Anonymous Sister',
      likeCount: 56,
      commentCount: 24,
      voteScore: 61,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    ForumPost(
      id: 'fp_003',
      title: 'Feeling distant from God',
      content:
          'I used to feel so close to God but lately everything feels dry. I go to church, read my Bible, but something feels off. Can anyone relate?',
      displayName: 'Anonymous Member',
      likeCount: 78,
      commentCount: 35,
      voteScore: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ForumPost(
      id: 'fp_004',
      title: 'Testimony: God answered my impossible prayer!',
      content:
          'I just want to share that God showed up for me in an incredible way. I was about to lose my scholarship, but everything worked out. God is faithful!',
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

  static final List<ChurchEvent> _eventsList = [
    ChurchEvent(
      id: 'ev_001',
      title: 'Youth Sunday Service',
      description:
          'Join us for an uplifting worship experience designed for the youth. Come as you are!',
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
      description:
          'A night of deep prayer and intercession. Bring your burdens and let\'s pray together.',
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
      description:
          'Our annual youth conference themed "Arise & Shine". 3 days of worship, teaching, and fellowship.',
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

  static List<ChurchEvent> get events => _eventsList;
  static void addEvent(ChurchEvent e) => _eventsList.insert(0, e);
  static void toggleEventRegistration(String eventId) {
    final idx = _eventsList.indexWhere((e) => e.id == eventId);
    if (idx != -1) {
      final e = _eventsList[idx];
      final newRegistered = !e.isRegistered;
      final newCount = newRegistered ? e.registrationCount + 1 : (e.registrationCount > 0 ? e.registrationCount - 1 : 0);
      _eventsList[idx] = e.copyWith(isRegistered: newRegistered, registrationCount: newCount);
    }
  }

  // ─────────────────────────────────────────────
  // ANNOUNCEMENTS
  // ─────────────────────────────────────────────

  static final List<Announcement> _announcementsList = [
    Announcement(
      id: 'ann_001',
      adminId: 'admin_001',
      adminName: 'Pastor James',
      title: 'Youth Conference Registration Open!',
      content:
          'Registration for the 2026 Youth Conference is now open. Early bird discount available until July 31st.',
      isPinned: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Announcement(
      id: 'ann_002',
      adminId: 'admin_002',
      adminName: 'Minister Ruth',
      title: 'New Bible Study Series',
      content:
          'Starting next Wednesday, we begin a new study on the book of Romans. Materials will be provided.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static List<Announcement> get announcements => _announcementsList;
  static void addAnnouncement(Announcement a) => _announcementsList.insert(0, a);

  // ─────────────────────────────────────────────
  // SERMON NOTES
  // ─────────────────────────────────────────────

  static List<SermonNote> get sermonNotes => [
    SermonNote(
      id: 'sn_001',
      adminId: 'admin_001',
      churchId: 'church_001',
      title: 'Walking by Faith, Not by Sight',
      preacherName: 'Pastor James',
      scriptureReference: '2 Corinthians 5:7',
      content:
          'In today\'s sermon, we explored what it truly means to walk by faith. Faith is not the absence of doubt — it is choosing to trust God despite the uncertainty. Pastor James shared three practical steps: (1) Start each day in prayer, (2) Remember God\'s past faithfulness, and (3) Surround yourself with believers who encourage you.',
      sermonDate: DateTime.now().subtract(const Duration(days: 1)),
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    SermonNote(
      id: 'sn_002',
      adminId: 'admin_002',
      churchId: 'church_001',
      title: 'The Power of Forgiveness',
      preacherName: 'Minister Ruth',
      scriptureReference: 'Ephesians 4:31-32',
      content:
          'Minister Ruth reminded us that forgiveness is not a feeling — it is a decision. Holding onto bitterness only poisons our own hearts. Key takeaway: Forgiveness sets YOU free. It doesn\'t mean condoning what happened, it means releasing the hold it has on your life.',
      sermonDate: DateTime.now().subtract(const Duration(days: 8)),
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    SermonNote(
      id: 'sn_003',
      adminId: 'admin_001',
      churchId: 'church_001',
      title: 'Purpose in the Wilderness',
      preacherName: 'Pastor James',
      scriptureReference: 'Deuteronomy 8:2-3',
      content:
          'Sometimes God leads us through the wilderness not to punish us, but to prepare us. The Israelites spent 40 years in the desert, and every moment had purpose. If you\'re in a season that feels dry, trust that God is shaping your character for what\'s ahead.',
      sermonDate: DateTime.now().subtract(const Duration(days: 15)),
      publishedAt: DateTime.now().subtract(const Duration(days: 14)),
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
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
  // SUNDAY & MEETING FEED POSTS (INSTAGRAM FEED)
  // ─────────────────────────────────────────────

  static final List<ChurchFeedPost> _feedPostsList = [
    ChurchFeedPost(
      id: 'feed_001',
      churchId: 'church_001',
      title: 'Sunday Celebration Service',
      caption:
          'What a glorious Sunday in God\'s presence! The choir led us into deep worship, and Pastor James delivered a transformative message on "Walking in Dominion". Praise God for the new souls won today! 🙌🔥✨\n\n#SundayService #KingdomQuest #WorshipInSpirit #SundayMoments',
      imageUrls: [
        'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=800&q=80',
        'https://images.unsplash.com/photo-1519491050282-cf00c82424b4?w=800&q=80',
        'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80',
      ],
      meetingDate: DateTime.now().subtract(Duration(days: (DateTime.now().weekday % 7))),
      meetingType: 'Sunday Service',
      authorName: 'ICGC Media Ministry',
      authorAvatarUrl: null,
      likesCount: 84,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ChurchFeedPost(
      id: 'feed_002',
      churchId: 'church_001',
      title: 'Youth Ablaze Encounter',
      caption:
          'Friday night was absolutely electrifying at Youth Ablaze! Passionate worship, impactful peer sharing, and a heart for revival. God is stirring something mighty among our young people! ⚡🙏❤️\n\n#YouthAblaze #NextGenLeaders #FaithOnFire',
      imageUrls: [
        'https://images.unsplash.com/photo-1529070538774-1843cb3265df?w=800&q=80',
        'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800&q=80',
      ],
      meetingDate: DateTime.now().subtract(const Duration(days: 2)),
      meetingType: 'Youth Fellowship',
      authorName: 'Kingdom Quest Youth',
      authorAvatarUrl: null,
      likesCount: 56,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChurchFeedPost(
      id: 'feed_003',
      churchId: 'church_001',
      title: 'Midweek Communion & Intercession',
      caption:
          'Breaking bread together as one family. A powerful evening of prayer, breaking strongholds, and experiencing peace that surpasses understanding. See you this coming Sunday! 🍞🍷✨\n\n#MidweekService #Communion #PrayerBreakthrough',
      imageUrls: [
        'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=800&q=80',
      ],
      meetingDate: DateTime.now().subtract(const Duration(days: 4)),
      meetingType: 'Midweek Service',
      authorName: 'Pastor James',
      authorAvatarUrl: null,
      likesCount: 42,
      isLiked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  static List<ChurchFeedPost> get feedPosts => _feedPostsList;

  static void addFeedPost(ChurchFeedPost post) {
    _feedPostsList.insert(0, post);
  }

  static void toggleFeedPostLike(String id) {
    final idx = _feedPostsList.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final post = _feedPostsList[idx];
      final newLiked = !post.isLiked;
      final newCount = newLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0);
      _feedPostsList[idx] = post.copyWith(isLiked: newLiked, likesCount: newCount);
    }
  }

  static void deleteFeedPost(String id) {
    _feedPostsList.removeWhere((p) => p.id == id);
  }

  // ─────────────────────────────────────────────
  // TESTIMONIES & ANSWERED PRAYERS
  // ─────────────────────────────────────────────
  static final List<Testimony> _testimoniesList = [
    Testimony(
      id: 'testimony_1',
      title: 'Healed from chronic migraines during all-night prayer!',
      story: 'For over eight months I suffered from severe debilitating migraines. During our youth all-night vigil, Pastor prayed for us and the power of God filled the room. Since that night two weeks ago, I have been completely symptom-free and peaceful! Jesus is truly our Healer!',
      authorName: 'Emmanuel K.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Healing',
      amenCount: 24,
      praiseCount: 18,
      heartCount: 15,
    ),
    Testimony(
      id: 'testimony_2',
      title: 'Full tuition fee cleared just 48 hours before deadline',
      story: 'I was on the verge of deferring my semester because my family lacked the remaining tuition balance. I brought this to our Wednesday prayer meeting. The next evening, a scholarship foundation I had applied to 6 months ago emailed notifying me of a full grant! To God be the glory!',
      authorName: 'Grace A.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      category: 'Provision',
      amenCount: 38,
      praiseCount: 31,
      heartCount: 22,
    ),
    Testimony(
      id: 'testimony_3',
      title: 'Overcame severe panic attacks before my final exams',
      story: 'Whenever exam season arrived, fear and panic would paralyze me. Following the "Overcoming Anxiety" reading plan and memorizing Philippians 4:6-7 gave me stillness and sharp focus. I wrote my finals with total clarity and peace!',
      authorName: 'David K.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Academics',
      amenCount: 19,
      praiseCount: 14,
      heartCount: 11,
    ),
    Testimony(
      id: 'testimony_4',
      title: 'My older brother surrendered his life to Christ',
      story: 'My brother resisted church and conversations about faith for four years. Last Sunday he agreed to join me for youth service and responded when the altar call was given with tears. God answers persevering prayer!',
      authorName: 'Sarah M.',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      category: 'Faith',
      amenCount: 45,
      praiseCount: 40,
      heartCount: 33,
    ),
  ];

  static List<Testimony> get testimonies => _testimoniesList;

  static void addTestimony(Testimony testimony) {
    _testimoniesList.insert(0, testimony);
  }

  static void reactToTestimony(String id, String reactionType) {
    final idx = _testimoniesList.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final t = _testimoniesList[idx];
      final currentReactions = List<String>.from(t.userReactions);
      final hasReacted = currentReactions.contains(reactionType);

      int amen = t.amenCount;
      int praise = t.praiseCount;
      int heart = t.heartCount;

      if (hasReacted) {
        currentReactions.remove(reactionType);
        if (reactionType == 'amen' && amen > 0) amen--;
        if (reactionType == 'praise' && praise > 0) praise--;
        if (reactionType == 'heart' && heart > 0) heart--;
      } else {
        currentReactions.add(reactionType);
        if (reactionType == 'amen') amen++;
        if (reactionType == 'praise') praise++;
        if (reactionType == 'heart') heart++;
      }

      _testimoniesList[idx] = t.copyWith(
        amenCount: amen,
        praiseCount: praise,
        heartCount: heart,
        userReactions: currentReactions,
      );
    }
  }

  // ─────────────────────────────────────────────
  // PERSONAL SERMON NOTES & DEVOTIONAL JOURNAL
  // ─────────────────────────────────────────────
  static final List<PersonalNote> _personalNotesList = [
    PersonalNote(
      id: 'note_1',
      title: 'Walking in Kingdom Authority',
      content: 'Key insights from Sunday Service:\n• Luke 10:19 — Jesus gave us authority to trample on scorpions and over all power of the enemy.\n• Authority is not our own muscle; it is our standing in Christ.\n• Real impact starts in the prayer secret place before public manifestation.\n• Action: Daily declare scripture over my fears and decisions.',
      scriptureReferences: ['Luke 10:19', 'Ephesians 6:10'],
      linkedSermonTitle: 'Standing Firm in Spiritual Warfare',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      colorIndex: 0,
    ),
    PersonalNote(
      id: 'note_2',
      title: 'The Posture of a True Servant',
      content: 'Reflections on leadership:\n• True greatness in the Kingdom is measured by how humbly we serve others.\n• Avoid comparison; run the race set specifically before you.\n• "Let nothing be done through selfish ambition or conceit..." Philippians 2:3.',
      scriptureReferences: ['Philippians 2:3-5', 'Mark 10:45'],
      linkedSermonTitle: 'Leading Like the Master',
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
      colorIndex: 2,
    ),
  ];

  static List<PersonalNote> get personalNotes => _personalNotesList;

  static void addPersonalNote(PersonalNote note) {
    _personalNotesList.insert(0, note);
  }

  static void updatePersonalNote(PersonalNote note) {
    final idx = _personalNotesList.indexWhere((n) => n.id == note.id);
    if (idx != -1) {
      _personalNotesList[idx] = note;
    }
  }

  static void deletePersonalNote(String id) {
    _personalNotesList.removeWhere((n) => n.id == id);
  }

  static DateTime _nextSunday() {
    final now = DateTime.now();
    final daysUntilSunday = (DateTime.sunday - now.weekday) % 7;
    return DateTime(
      now.year,
      now.month,
      now.day + (daysUntilSunday == 0 ? 7 : daysUntilSunday),
    );
  }

  static DateTime _nextFriday() {
    final now = DateTime.now();
    final daysUntilFriday = (DateTime.friday - now.weekday) % 7;
    return DateTime(
      now.year,
      now.month,
      now.day + (daysUntilFriday == 0 ? 7 : daysUntilFriday),
    );
  }

  static DateTime _nextWednesday() {
    final now = DateTime.now();
    final daysUntilWednesday = (DateTime.wednesday - now.weekday) % 7;
    return DateTime(
      now.year,
      now.month,
      now.day + (daysUntilWednesday == 0 ? 7 : daysUntilWednesday),
    );
  }
}
