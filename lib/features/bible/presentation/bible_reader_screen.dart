import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/feature_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/bible_models.dart';
import '../../../shared/services/bible_service.dart';
import '../../../shared/widgets/app_pop_scope.dart';

class BibleReaderScreen extends ConsumerStatefulWidget {
  const BibleReaderScreen({super.key});

  @override
  ConsumerState<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends ConsumerState<BibleReaderScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<BibleVerse> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final results = BibleService.search(query);
    setState(() => _searchResults = results);
  }

  void _selectBookAndChapter(BibleBook book, int chapterNum) {
    ref.read(bibleSelectedBookProvider.notifier).state = book;
    ref.read(bibleSelectedChapterNumberProvider.notifier).state = chapterNum;
    ref.read(gamificationNotifierProvider.notifier).recordDailyAction(
          bibleReading: true,
          bonusXp: 10,
        );
  }

  void _nextChapter(BibleBook book, int currentChapter) {
    if (currentChapter < book.chaptersCount) {
      ref.read(bibleSelectedChapterNumberProvider.notifier).state = currentChapter + 1;
    } else {
      final currentIdx = BibleService.books.indexOf(book);
      if (currentIdx < BibleService.books.length - 1) {
        final nextBook = BibleService.books[currentIdx + 1];
        ref.read(bibleSelectedBookProvider.notifier).state = nextBook;
        ref.read(bibleSelectedChapterNumberProvider.notifier).state = 1;
      }
    }
  }

  void _previousChapter(BibleBook book, int currentChapter) {
    if (currentChapter > 1) {
      ref.read(bibleSelectedChapterNumberProvider.notifier).state = currentChapter - 1;
    } else {
      final currentIdx = BibleService.books.indexOf(book);
      if (currentIdx > 0) {
        final prevBook = BibleService.books[currentIdx - 1];
        ref.read(bibleSelectedBookProvider.notifier).state = prevBook;
        ref.read(bibleSelectedChapterNumberProvider.notifier).state = prevBook.chaptersCount;
      }
    }
  }

  void _openBookChapterPicker(BuildContext context, BibleBook currentBook) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _BookChapterPickerModal(
          currentBook: currentBook,
          onSelect: (selectedBook, selectedChapter) {
            Navigator.pop(ctx);
            _selectBookAndChapter(selectedBook, selectedChapter);
          },
        );
      },
    );
  }

  void _showVerseActions(BuildContext context, BibleVerse verse) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.terracotta.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        verse.reference,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '"${verse.text}"',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const Divider(height: 24),
                ListTile(
                  leading: const Icon(Icons.copy_rounded, color: AppColors.terracotta),
                  title: const Text('Copy Verse'),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: '${verse.text} (${verse.reference})'),
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied verse to clipboard')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit_note_rounded, color: AppColors.burntAmber),
                  title: const Text('Write Reflection / Sermon Note'),
                  subtitle: const Text('Save thoughts linked to this verse'),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/notes', extra: verse.reference);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.auto_stories_rounded, color: AppColors.sage),
                  title: const Text('Explore Youth Reading Plans'),
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/reading-plans');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = ref.watch(bibleSelectedBookProvider);
    final chapterNum = ref.watch(bibleSelectedChapterNumberProvider);
    final fontSize = ref.watch(bibleFontSizeProvider);
    final chapter = ref.watch(bibleCurrentChapterProvider);

    return AppPopScope(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(fallbackRoute: '/home'),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search scriptures, peace, joy...',
                    border: InputBorder.none,
                  ),
                  onChanged: _performSearch,
                )
              : GestureDetector(
                  onTap: () => _openBookChapterPicker(context, book),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          '${book.name} $chapterNum',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_drop_down, size: 24),
                    ],
                  ),
                ),
          actions: [
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                    _searchResults = [];
                  });
                },
              )
            else ...[
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search Bible',
                onPressed: () => setState(() => _isSearching = true),
              ),
              PopupMenuButton<double>(
                icon: const Icon(Icons.format_size),
                tooltip: 'Font Size',
                onSelected: (size) => ref.read(bibleFontSizeProvider.notifier).state = size,
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 15.0, child: Text('Small text')),
                  const PopupMenuItem(value: 17.0, child: Text('Normal text')),
                  const PopupMenuItem(value: 20.0, child: Text('Large text')),
                  const PopupMenuItem(value: 24.0, child: Text('Extra large text')),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.menu_book_rounded),
                tooltip: 'Youth Reading Plans',
                onPressed: () => context.push('/reading-plans'),
              ),
            ],
          ],
        ),
        body: _isSearching
            ? _buildSearchResults(theme)
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${book.testament == "OT" ? "Old Testament" : "New Testament"} • ${book.category}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Chapter $chapterNum of ${book.chaptersCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.lg,
                      ),
                      itemCount: chapter.verses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, idx) {
                        final verse = chapter.verses[idx];
                        return InkWell(
                          onTap: () => _showVerseActions(context, verse),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.top,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        '${verse.number}',
                                        style: TextStyle(
                                          fontSize: fontSize * 0.75,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.terracotta,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: verse.text,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: fontSize,
                                      height: 1.6,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: theme.dividerColor.withAlpha(40),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _previousChapter(book, chapterNum),
                            icon: const Icon(Icons.chevron_left),
                            label: const Text('Prev'),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.terracotta,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _openBookChapterPicker(context, book),
                            icon: const Icon(Icons.list_rounded),
                            label: const Text('Chapters'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => _nextChapter(book, chapterNum),
                            icon: const Icon(Icons.chevron_right),
                            label: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search, size: 48, color: AppColors.muted),
              const SizedBox(height: 16),
              Text(
                'Type a keyword to search scriptures',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'e.g. peace, love, conqueror, wisdom, prayer',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'No verses found matching "${_searchController.text}". Try another query!',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.xl),
      itemCount: _searchResults.length,
      itemBuilder: (ctx, idx) {
        final verse = _searchResults[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor.withAlpha(50)),
          ),
          child: ListTile(
            title: Text(
              verse.reference,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.terracotta,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                verse.text,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () {
              final parts = verse.reference.split(' ');
              final bookName = parts[0];
              final chapterNumber = int.tryParse(parts[1].split(':')[0]) ?? 1;
              final foundBook = BibleService.books.firstWhere(
                (b) => b.name.toLowerCase() == bookName.toLowerCase(),
                orElse: () => BibleService.books.first,
              );
              _selectBookAndChapter(foundBook, chapterNumber);
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
        );
      },
    );
  }
}

class _BookChapterPickerModal extends StatefulWidget {
  final BibleBook currentBook;
  final void Function(BibleBook book, int chapter) onSelect;

  const _BookChapterPickerModal({
    required this.currentBook,
    required this.onSelect,
  });

  @override
  State<_BookChapterPickerModal> createState() => _BookChapterPickerModalState();
}

class _BookChapterPickerModalState extends State<_BookChapterPickerModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BibleBook _selectedBook;
  bool _choosingChapter = false;

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.currentBook;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.currentBook.testament == 'NT' ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _choosingChapter
                      ? '${_selectedBook.name} — Select Chapter'
                      : 'Select Bible Book',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_choosingChapter)
                  TextButton.icon(
                    onPressed: () => setState(() => _choosingChapter = false),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Books'),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          if (!_choosingChapter) ...[
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.terracotta,
              labelColor: AppColors.terracotta,
              tabs: const [
                Tab(text: 'Old Testament (39)'),
                Tab(text: 'New Testament (27)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBooksList(
                    BibleService.books.where((b) => b.testament == 'OT').toList(),
                  ),
                  _buildBooksList(
                    BibleService.books.where((b) => b.testament == 'NT').toList(),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Divider(height: 1),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.xl),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: _selectedBook.chaptersCount,
                itemBuilder: (ctx, idx) {
                  final ch = idx + 1;
                  return InkWell(
                    onTap: () => widget.onSelect(_selectedBook, ch),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.dividerColor.withAlpha(40),
                        ),
                      ),
                      child: Text(
                        '$ch',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBooksList(List<BibleBook> books) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: books.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (ctx, idx) {
        final book = books[idx];
        final isSelected = book.id == _selectedBook.id;
        return ListTile(
          title: Text(
            book.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.terracotta : null,
            ),
          ),
          subtitle: Text(
            '${book.category} • ${book.chaptersCount} chapters',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            book.abbreviation,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.muted,
            ),
          ),
          onTap: () {
            setState(() {
              _selectedBook = book;
              _choosingChapter = true;
            });
          },
        );
      },
    );
  }
}
