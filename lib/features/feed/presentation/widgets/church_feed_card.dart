import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/feature_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/church_feed_post.dart';
import 'image_viewer_screen.dart';

/// An Instagram-styled feed card for Sunday services and church meetings.
class ChurchFeedCard extends ConsumerStatefulWidget {
  final ChurchFeedPost post;
  final VoidCallback? onCommentsTap;

  const ChurchFeedCard({
    super.key,
    required this.post,
    this.onCommentsTap,
  });

  @override
  ConsumerState<ChurchFeedCard> createState() => _ChurchFeedCardState();
}

class _ChurchFeedCardState extends ConsumerState<ChurchFeedCard>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _isSaved = false;
  bool _isExpanded = false;
  bool _showHeartAnim = false;

  late final AnimationController _heartAnimController;
  late final Animation<double> _heartScaleAnimation;
  late final Animation<double> _heartOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
    ]).animate(_heartAnimController);

    _heartOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_heartAnimController);
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _triggerDoubleTapLike() {
    HapticFeedback.mediumImpact();
    if (!widget.post.isLiked) {
      ref.read(feedPostsNotifierProvider.notifier).toggleLike(widget.post.id);
    }
    setState(() => _showHeartAnim = true);
    _heartAnimController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() => _showHeartAnim = false);
      }
    });
  }

  void _openFullScreen(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(
          imageUrls: widget.post.imageUrls,
          initialIndex: index,
          title: widget.post.title,
          caption: widget.post.caption,
        ),
      ),
    );
  }

  void _showCommentsModal() {
    final theme = Theme.of(context);
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sunday Fellowship Reactions',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Share an encouraging word or praise testimony for this service',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  _amenChip('🙌 Amen!', commentCtrl),
                  const SizedBox(width: AppSpacing.sm),
                  _amenChip('🔥 Powerful!', commentCtrl),
                  const SizedBox(width: AppSpacing.sm),
                  _amenChip('❤️ Blessed!', commentCtrl),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentCtrl,
                      decoration: InputDecoration(
                        hintText: 'Add an encouraging comment...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: () {
                      if (commentCtrl.text.trim().isNotEmpty) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment shared with the church!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.send_rounded, size: 18),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _amenChip(String text, TextEditingController ctrl) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 12)),
      padding: EdgeInsets.zero,
      onPressed: () {
        ctrl.text = text;
      },
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, _) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, _, error) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: Icon(Icons.photo_outlined, size: 40, color: Colors.grey),
          ),
        ),
      );
    } else {
      final file = File(url);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: Icon(Icons.photo_outlined, size: 40, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final post = widget.post;
    final formattedDate = DateFormat('EEEE, MMM d').format(post.meetingDate);
    final hasMultipleImages = post.imageUrls.length > 1;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      clipBehavior: Clip.antiAlias,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER: Church / Meeting Info ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            child: Row(
              children: [
                // Story-style avatar with gradient ring
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.terracotta,
                        AppColors.burntAmber,
                        AppColors.glow,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: colorScheme.surface,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        post.authorName.isNotEmpty
                            ? post.authorName[0].toUpperCase()
                            : 'C',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                // Title and meeting tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.title,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.terracotta,
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.meetingType,
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            formattedDate,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // More / Share menu
                IconButton(
                  icon: const Icon(Icons.more_horiz_rounded, size: 20),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.fullscreen_rounded),
                              title: const Text('View Full Screen'),
                              onTap: () {
                                Navigator.pop(ctx);
                                _openFullScreen(_currentImageIndex);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.share_outlined),
                              title: const Text('Share Meeting Photos'),
                              onTap: () {
                                Navigator.pop(ctx);
                                Clipboard.setData(ClipboardData(
                                  text: '${post.title} - ${post.caption}',
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post details copied to clipboard!')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ── MEDIA CAROUSEL (INSTAGRAM FEED STYLE) ─────────────────────────
          GestureDetector(
            onDoubleTap: _triggerDoubleTapLike,
            onTap: () => _openFullScreen(_currentImageIndex),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.05, // Crisp near-square aspect ratio
                  child: post.imageUrls.isEmpty
                      ? Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.church_rounded, size: 50, color: Colors.grey),
                          ),
                        )
                      : PageView.builder(
                          itemCount: post.imageUrls.length,
                          onPageChanged: (idx) {
                            setState(() => _currentImageIndex = idx);
                          },
                          itemBuilder: (context, index) {
                            return _buildImage(post.imageUrls[index]);
                          },
                        ),
                ),

                // Multi-photo indicator badge (top right, e.g. 1/3)
                if (hasMultipleImages)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${post.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Animated double-tap heart
                if (_showHeartAnim)
                  FadeTransition(
                    opacity: _heartOpacityAnimation,
                    child: ScaleTransition(
                      scale: _heartScaleAnimation,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 96,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── ACTION BUTTONS BAR ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                // Heart / Like
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: post.isLiked ? AppColors.alert : colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(feedPostsNotifierProvider.notifier).toggleLike(post.id);
                  },
                ),
                // Comment / Reaction
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: colorScheme.onSurface,
                    size: 22,
                  ),
                  onPressed: widget.onCommentsTap ?? _showCommentsModal,
                ),
                // Share
                IconButton(
                  icon: Icon(
                    Icons.send_outlined,
                    color: colorScheme.onSurface,
                    size: 22,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: '${post.title} photos: ${post.imageUrls.firstOrNull ?? ""}',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo link copied to clipboard!')),
                    );
                  },
                ),
                const Spacer(),
                // Carousel dots indicator in the middle/trailing
                if (hasMultipleImages)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      post.imageUrls.length,
                      (dotIdx) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: _currentImageIndex == dotIdx ? 7 : 5,
                        height: _currentImageIndex == dotIdx ? 7 : 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == dotIdx
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                const Spacer(),
                // Bookmark / Save
                IconButton(
                  icon: Icon(
                    _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: _isSaved ? colorScheme.primary : colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() => _isSaved = !_isSaved);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isSaved ? 'Saved to your church memories' : 'Removed from saved'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ── LIKES & CAPTION BLOCK ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Likes count
                if (post.likesCount > 0)
                  Text(
                    '${post.likesCount} ${post.likesCount == 1 ? "like" : "likes"}',
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 3),

                // Caption with expandable toggle
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text: '${post.authorName} ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: _isExpanded || post.caption.length <= 90
                            ? post.caption
                            : '${post.caption.substring(0, 90)}... ',
                      ),
                    ],
                  ),
                ),

                if (post.caption.length > 90)
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _isExpanded ? 'Show less' : 'more',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.xs),

                // View comments prompt
                GestureDetector(
                  onTap: widget.onCommentsTap ?? _showCommentsModal,
                  child: Text(
                    'View all reactions & amens',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
