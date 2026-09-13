import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/church_feed_post.dart';
import '../../../shared/widgets/app_pop_scope.dart';
import '../../feed/presentation/widgets/church_feed_card.dart';

/// Admin screen for uploading Sunday and meeting photos and managing feed posts.
class AdminFeedScreen extends ConsumerStatefulWidget {
  const AdminFeedScreen({super.key});

  @override
  ConsumerState<AdminFeedScreen> createState() => _AdminFeedScreenState();
}

class _AdminFeedScreenState extends ConsumerState<AdminFeedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Form state
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Sunday Celebration Service');
  final _captionController = TextEditingController(
    text: 'A mighty outpouring of the Holy Spirit at today\'s service! Lives transformed and God glorified. 🙌🔥\n\n#SundayService #KingdomQuest #WorshipInSpirit',
  );
  final _urlInputController = TextEditingController();

  String _selectedMeetingType = 'Sunday Service';
  DateTime _selectedDate = DateTime.now();

  final List<String> _selectedUrls = [];
  final List<File> _selectedFiles = [];

  bool _isPublishing = false;

  final List<String> _meetingTypes = [
    'Sunday Service',
    'Youth Fellowship',
    'Midweek Service',
    'All-Night Vigil',
    'Special Program',
  ];

  // Preset church photos for quick testing & demo
  final List<Map<String, dynamic>> _samplePhotoPresets = [
    {
      'title': 'Sunday Worship',
      'url': 'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=800&q=80',
    },
    {
      'title': 'Preaching Word',
      'url': 'https://images.unsplash.com/photo-1519491050282-cf00c82424b4?w=800&q=80',
    },
    {
      'title': 'Choir Ministration',
      'url': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80',
    },
    {
      'title': 'Youth Fellowship',
      'url': 'https://images.unsplash.com/photo-1529070538774-1843cb3265df?w=800&q=80',
    },
    {
      'title': 'Prayer Circle',
      'url': 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _captionController.dispose();
    _urlInputController.dispose();
    super.dispose();
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          for (final xFile in picked) {
            _selectedFiles.add(File(xFile.path));
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open gallery: $e')),
        );
      }
    }
  }

  void _addPresetPhoto(String url) {
    if (!_selectedUrls.contains(url)) {
      setState(() => _selectedUrls.add(url));
    }
  }

  void _addCustomUrl() {
    final url = _urlInputController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _selectedUrls.add(url);
        _urlInputController.clear();
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _publishPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedUrls.isEmpty && _selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one picture for the meeting feed.'),
        ),
      );
      return;
    }

    setState(() => _isPublishing = true);

    try {
      await ref.read(feedPostsNotifierProvider.notifier).createPost(
        title: _titleController.text.trim(),
        caption: _captionController.text.trim(),
        meetingType: _selectedMeetingType,
        meetingDate: _selectedDate,
        imageUrls: _selectedUrls,
        localFiles: _selectedFiles,
      );

      if (mounted) {
        setState(() {
          _isPublishing = false;
          _selectedUrls.clear();
          _selectedFiles.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Meeting photos successfully published to the feed!'),
            backgroundColor: AppColors.sage,
          ),
        );

        // Switch to manage tab
        _tabController.animateTo(1);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPublishing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeletePost(ChurchFeedPost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Feed Post?'),
        content: Text('Are you sure you want to delete "${post.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.alert),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(feedPostsNotifierProvider.notifier).deletePost(post.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feed post deleted.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final asyncPosts = ref.watch(feedPostsNotifierProvider);

    return AppPopScope(
      fallbackRoute: '/admin',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/admin'),
          title: const Text('Meeting Photos & Feed'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.cloud_upload_outlined), text: 'Upload Photos'),
            Tab(icon: Icon(Icons.grid_view_rounded), text: 'Manage Feed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── TAB 1: UPLOAD PHOTOS ──────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meeting Title
                  Text(
                    'Meeting Title',
                    style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Sunday Divine Service',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Title is required' : null,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Meeting Type & Meeting Date row
                  Row(
                    children: [
                      // Meeting Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meeting Type',
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedMeetingType,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                              ),
                              items: _meetingTypes
                                  .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t, style: const TextStyle(fontSize: 13)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedMeetingType = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Meeting Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Meeting Date',
                              style: textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            InkWell(
                              onTap: _selectDate,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  prefixIcon: Icon(Icons.calendar_today_rounded, size: 18),
                                ),
                                child: Text(
                                  DateFormat('MMM d, yyyy').format(_selectedDate),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── PICTURE SELECTION SECTION ──────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Photos (${_selectedUrls.length + _selectedFiles.length})',
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      TextButton.icon(
                        onPressed: _pickImagesFromGallery,
                        icon: const Icon(Icons.photo_library_rounded, size: 18),
                        label: const Text('From Gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Selected thumbnails preview
                  if (_selectedUrls.isNotEmpty || _selectedFiles.isNotEmpty)
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ..._selectedFiles.map((f) => _fileThumbnail(f)),
                          ..._selectedUrls.map((u) => _urlThumbnail(u)),
                        ],
                      ),
                    )
                  else
                    InkWell(
                      onTap: _pickImagesFromGallery,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 32,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Tap to pick pictures from your device',
                              style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.md),

                  // Sample / Preset Photos bar for fast testing
                  Text(
                    'Quick Presets (Tap to add high-res church photos):',
                    style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: _samplePhotoPresets.map((preset) {
                      final url = preset['url'] as String;
                      final isAdded = _selectedUrls.contains(url);
                      return FilterChip(
                        label: Text(preset['title'] as String, style: const TextStyle(fontSize: 11)),
                        selected: isAdded,
                        onSelected: (_) => _addPresetPhoto(url),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Or Custom URL input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _urlInputController,
                          decoration: const InputDecoration(
                            hintText: 'Or paste image URL...',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton.filledTonal(
                        onPressed: _addCustomUrl,
                        icon: const Icon(Icons.add_link_rounded, size: 20),
                        tooltip: 'Add Image URL',
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Caption
                  Text(
                    'Caption & Highlights',
                    style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  TextFormField(
                    controller: _captionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share highlights from the message, worship, or fellowship...',
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Caption is required' : null,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Publish CTA
                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton.icon(
                      onPressed: _isPublishing ? null : _publishPost,
                      icon: _isPublishing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.publish_rounded),
                      label: Text(
                        _isPublishing ? 'Publishing Photos...' : 'Publish to Feed',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.massive),
                ],
              ),
            ),
          ),

          // ── TAB 2: MANAGE FEED ────────────────────────────────────────────
          asyncPosts.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (posts) {
              if (posts.isEmpty) {
                return Center(
                  child: Text(
                    'No posts published yet.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: posts.length,
                separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final formattedDate =
                      DateFormat('MMM d, yyyy').format(post.meetingDate);
                  final firstImage = post.imageUrls.firstOrNull ?? '';

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                            child: SizedBox(
                              width: 54,
                              height: 54,
                              child: firstImage.isNotEmpty
                                  ? (firstImage.startsWith('http')
                                      ? Image.network(
                                          firstImage,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                        )
                                      : Image.file(
                                          File(firstImage),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                        ))
                                  : const Icon(Icons.photo),
                            ),
                          ),
                          title: Text(
                            post.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            '${post.meetingType} • $formattedDate\n${post.imageUrls.length} photo(s) • ${post.likesCount} likes',
                            style: textTheme.bodySmall,
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.alert,
                            ),
                            tooltip: 'Delete post',
                            onPressed: () => _confirmDeletePost(post),
                          ),
                        ),
                        // Quick preview expand
                        ExpansionTile(
                          title: const Text('View Instagram Preview', style: TextStyle(fontSize: 12)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: ChurchFeedCard(post: post),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

  Widget _fileThumbnail(File file) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _selectedFiles.remove(file)),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _urlThumbnail(String url) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 10,
          child: GestureDetector(
            onTap: () => setState(() => _selectedUrls.remove(url)),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
