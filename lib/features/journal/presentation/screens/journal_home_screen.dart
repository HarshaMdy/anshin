// Journal home — Content Bible §9
// Monthly swipeable calendar with entry-day dots + scrollable entry list.
// FAB writes new entry; free cap banner shows when user has hit 30 entries.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_journal.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../providers/journal_provider.dart';

class JournalHomeScreen extends ConsumerWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger background sync on tab open
    ref.watch(journalSyncProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    final entriesAsync = ref.watch(journalEntriesProvider);
    final canCreateAsync = ref.watch(canCreateJournalEntryProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Text(
                  StringsJournal.header,
                  style: AppTypography.headingLarge
                      .copyWith(color: textPrimary),
                ),
              ),
            ),

            // ── Calendar ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _CalendarStrip(
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ),
            ),

            // ── Free cap banner ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: canCreateAsync.when(
                data: (canCreate) => canCreate
                    ? const SizedBox.shrink()
                    : _CapBanner(textSecondary: textSecondary),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),

            // ── Entry list ────────────────────────────────────────────────────
            entriesAsync.when(
              data: (entries) => entries.isEmpty
                  ? SliverFillRemaining(
                      child: _EmptyState(
                        onWrite: () => _tryWrite(context, canCreateAsync),
                        textSecondary: textSecondary,
                        textPrimary: textPrimary,
                        surface: surface,
                        borderColor: borderColor,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _EntryTile(
                            entry: entries[i],
                            surface: surface,
                            borderColor: borderColor,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            onTap: () => context.push(
                              AppRoutes.journalDetailPath(entries[i].uuid),
                            ),
                          ),
                          childCount: entries.length,
                        ),
                      ),
                    ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),
          ],
        ),
      ),
      floatingActionButton: canCreateAsync.when(
        data: (canCreate) => canCreate
            ? FloatingActionButton(
                onPressed: () => context.push(AppRoutes.journalEntry),
                backgroundColor: AppColors.accentCoral,
                foregroundColor: Colors.white,
                child: const Icon(Icons.edit_outlined),
              )
            : null,
        loading: () => null,
        error: (_, _) => null,
      ),
    );
  }

  void _tryWrite(
    BuildContext context,
    AsyncValue<bool> canCreateAsync,
  ) {
    final canCreate = canCreateAsync.valueOrNull ?? false;
    if (canCreate) context.push(AppRoutes.journalEntry);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar strip — swipeable monthly view
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarStrip extends ConsumerStatefulWidget {
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _CalendarStrip({
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  ConsumerState<_CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends ConsumerState<_CalendarStrip> {
  late final PageController _pageCtrl;
  static const int _totalMonths = 24; // 24 months back from today
  static const int _initialPage = _totalMonths - 1; // start at current month

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    final now = DateTime.now();
    final diff = _initialPage - page;
    return DateTime(now.year, now.month - diff);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: widget.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.borderColor),
      ),
      child: PageView.builder(
        controller: _pageCtrl,
        itemCount: _totalMonths,
        onPageChanged: (page) {
          ref.read(journalMonthProvider.notifier).state = _monthForPage(page);
        },
        itemBuilder: (context, page) {
          final month = _monthForPage(page);
          return _MonthCalendar(
            month: month,
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
          );
        },
      ),
    );
  }
}

class _MonthCalendar extends ConsumerWidget {
  final DateTime month;
  final Color textPrimary;
  final Color textSecondary;

  const _MonthCalendar({
    required this.month,
    required this.textPrimary,
    required this.textSecondary,
  });

  static const List<String> _dayHeaders = [
    'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesForMonthProvider);
    final entryDays = entriesAsync.whenOrNull(
          data: (rows) => rows.map((r) => r.createdAt.day).toSet(),
        ) ??
        {};

    final firstDay = DateTime(month.year, month.month, 1);
    // Monday-based weekday offset (Mon=1→0, Sun=7→6)
    final offset = (firstDay.weekday - 1) % 7;
    final daysInMonth =
        DateTime(month.year, month.month + 1, 0).day;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Month/year header + nav arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _monthLabel(month),
                style: AppTypography.bodyLarge.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => PageStorage.maybeOf(context),
                    // handled by PageView swipe; arrows are visual hints only
                  ),
                  Icon(Icons.swipe_outlined,
                      size: 18, color: textSecondary.withValues(alpha: 0.4)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Day-of-week headers
          Row(
            children: _dayHeaders.map((d) => Expanded(
              child: Text(
                d,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: textSecondary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Day grid
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: offset + daysInMonth,
              itemBuilder: (context, i) {
                if (i < offset) return const SizedBox.shrink();
                final day = i - offset + 1;
                final hasEntry = entryDays.contains(day);
                final isToday = DateTime.now().year == month.year &&
                    DateTime.now().month == month.month &&
                    DateTime.now().day == day;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: isToday
                            ? AppColors.accentCoral
                            : textPrimary.withValues(alpha: 0.85),
                        fontWeight: isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    if (hasEntry)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentTeal,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _monthLabel(DateTime dt) => '${_months[dt.month - 1]} ${dt.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Free-cap banner
// ─────────────────────────────────────────────────────────────────────────────

class _CapBanner extends StatelessWidget {
  final Color textSecondary;
  const _CapBanner({required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentCoral.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.accentCoral.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline,
              color: AppColors.accentCoral, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "You've reached the 30-entry limit on the free plan.",
              style: AppTypography.bodyMedium.copyWith(
                color: textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.push(AppRoutes.paywall),
            child: Text(
              'Upgrade',
              style: AppTypography.caption.copyWith(
                color: AppColors.accentCoral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onWrite;
  final Color textSecondary;
  final Color textPrimary;
  final Color surface;
  final Color borderColor;

  const _EmptyState({
    required this.onWrite,
    required this.textSecondary,
    required this.textPrimary,
    required this.surface,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotWidget(
              emotion: MascotEmotion.holdingPen,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              StringsJournal.emptyStateBody,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: textSecondary),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onWrite,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCoral,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: AppTypography.button,
                elevation: 0,
              ),
              child: Text(StringsJournal.emptyStateCta),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry tile
// ─────────────────────────────────────────────────────────────────────────────

class _EntryTile extends StatelessWidget {
  final JournalEntryRow entry;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _EntryTile({
    required this.entry,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dt = entry.createdAt;
    final dateLabel =
        '${_monthShort(dt.month)} ${dt.day}, ${dt.year}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.mood,
                        style: AppTypography.bodyLarge.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateLabel,
                        style: AppTypography.caption
                            .copyWith(color: textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: textSecondary.withValues(alpha: 0.5), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  String _monthShort(int month) => _monthNames[month - 1];
}
