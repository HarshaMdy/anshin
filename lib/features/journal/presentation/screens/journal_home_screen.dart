// Journal home — Content Bible §9
// Monthly swipeable calendar with tappable entry-day dots + scrollable entry list.
// • Tapping a date that has entries  → filters the list to show only that day.
// • Tapping a date that has no entry → opens the new-entry flow.
// • Calendar height is computed per month so 6-row months never overflow.
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

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

const List<String> _kMonthsFull = [
  'January', 'February', 'March',    'April',   'May',      'June',
  'July',    'August',   'September','October', 'November', 'December',
];

/// Formats a date as "April 19" — no external dependency required.
String _formatDate(DateTime dt) => '${_kMonthsFull[dt.month - 1]} ${dt.day}';

// ─────────────────────────────────────────────────────────────────────────────

class JournalHomeScreen extends ConsumerWidget {
  const JournalHomeScreen({super.key});

  // ── Date-tap handler ────────────────────────────────────────────────────────
  // Called when the user taps a day cell in the calendar.
  // • hasEntry  → update selection so the list filters; no push needed.
  // • !hasEntry → go straight to the entry creation flow (if allowed).
  void _handleDateTap(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    bool hasEntry,
    AsyncValue<bool> canCreateAsync,
  ) {
    final current = ref.read(journalSelectedDateProvider);
    // Tapping the already-selected date deselects it (toggle).
    if (current != null &&
        current.year  == date.year  &&
        current.month == date.month &&
        current.day   == date.day) {
      ref.read(journalSelectedDateProvider.notifier).state = null;
      return;
    }

    ref.read(journalSelectedDateProvider.notifier).state = date;

    if (!hasEntry) {
      final canCreate = canCreateAsync.valueOrNull ?? false;
      if (canCreate) {
        // Pass the selected date so the new entry is timestamped correctly
        // even when the user writes from a previous month's calendar date.
        ref.read(journalEntryDateProvider.notifier).state = date;
        context.push(AppRoutes.journalEntry);
      }
    }
    // If has entry, the list below auto-filters — nothing else to do.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger background sync on tab open.
    ref.watch(journalSyncProvider);

    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final bg            = isDark ? AppColors.darkBackground  : AppColors.lightBackground;
    final textPrimary   = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface       = isDark ? AppColors.darkSurface     : AppColors.lightSurface;
    final borderColor   = isDark ? AppColors.darkCardBorder  : AppColors.lightCardBorder;

    final entriesAsync    = ref.watch(journalEntriesForDateProvider);
    final canCreateAsync  = ref.watch(canCreateJournalEntryProvider);
    final selectedDate    = ref.watch(journalSelectedDateProvider);

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
                  style: AppTypography.headingLarge.copyWith(color: textPrimary),
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
                  onDateTap: (date, hasEntry) => _handleDateTap(
                    context, ref, date, hasEntry, canCreateAsync,
                  ),
                ),
              ),
            ),

            // ── Selected-date chip (shown when a date is active) ──────────────
            SliverToBoxAdapter(
              child: selectedDate == null
                  ? const SizedBox.shrink()
                  : _SelectedDateChip(
                      date: selectedDate,
                      textPrimary: textPrimary,
                      onClear: () =>
                          ref.read(journalSelectedDateProvider.notifier).state = null,
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
                        onWrite: () {
                          final canCreate = canCreateAsync.valueOrNull ?? false;
                          if (canCreate) context.push(AppRoutes.journalEntry);
                        },
                        textSecondary: textSecondary,
                        textPrimary: textPrimary,
                        surface: surface,
                        borderColor: borderColor,
                        isDateFiltered: selectedDate != null,
                        filteredDate: selectedDate,
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
              error: (_, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar strip — swipeable monthly view
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarStrip extends ConsumerStatefulWidget {
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final void Function(DateTime date, bool hasEntry) onDateTap;

  const _CalendarStrip({
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onDateTap,
  });

  @override
  ConsumerState<_CalendarStrip> createState() => _CalendarStripState();
}

class _CalendarStripState extends ConsumerState<_CalendarStrip> {
  late final PageController _pageCtrl;
  static const int _totalMonths = 24;
  static const int _initialPage = _totalMonths - 1; // current month

  // A single safe height that fits any month regardless of row count.
  // Worst case = 6-row month (e.g. March 2026, offset=6, 37 cells):
  //   padding(32) + monthLabel(30) + gap(10) + dayHeaders(20) + gap(6)
  //   + grid(6×34 + 5×2 = 214) + buffer(28) = 340
  // 5-row months fit with ~36 px of extra space at the bottom — acceptable.
  static const double _kHeight = 340.0;

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
    final now  = DateTime.now();
    final diff = _initialPage - page;
    return DateTime(now.year, now.month - diff);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kHeight,
      decoration: BoxDecoration(
        color: widget.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.borderColor),
      ),
      // ClipRRect keeps the PageView content inside the rounded corners.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: PageView.builder(
          controller: _pageCtrl,
          itemCount: _totalMonths,
          onPageChanged: (page) {
            ref.read(journalMonthProvider.notifier).state = _monthForPage(page);
            // Clear date selection when the user swipes to a different month.
            ref.read(journalSelectedDateProvider.notifier).state = null;
          },
          itemBuilder: (context, page) => _MonthCalendar(
            month: _monthForPage(page),
            textPrimary: widget.textPrimary,
            textSecondary: widget.textSecondary,
            onDateTap: widget.onDateTap,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Month calendar — one page of the PageView
// ─────────────────────────────────────────────────────────────────────────────

class _MonthCalendar extends ConsumerWidget {
  final DateTime month;
  final Color textPrimary;
  final Color textSecondary;
  final void Function(DateTime date, bool hasEntry) onDateTap;

  const _MonthCalendar({
    required this.month,
    required this.textPrimary,
    required this.textSecondary,
    required this.onDateTap,
  });

  static const List<String> _dayLabels = [
    'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesForMonthProvider);
    // Build a set of days that have at least one entry.
    final entryDays = entriesAsync.whenOrNull(
          data: (rows) => rows.map((r) => r.createdAt.day).toSet(),
        ) ??
        <int>{};

    final selectedDate = ref.watch(journalSelectedDateProvider);
    // The selected day within this month (null if a different month is active).
    final selectedDay = (selectedDate?.year  == month.year &&
                         selectedDate?.month == month.month)
        ? selectedDate?.day
        : null;

    final firstDay    = DateTime(month.year, month.month, 1);
    final offset      = (firstDay.weekday - 1) % 7; // Monday = 0
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final today       = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Month / year header ────────────────────────────────────────────
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
              Icon(
                Icons.swipe_outlined,
                size: 16,
                color: textSecondary.withValues(alpha: 0.35),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Day-of-week headers ────────────────────────────────────────────
          Row(
            children: _dayLabels
                .map((d) => Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: AppTypography.caption.copyWith(
                          color: textSecondary.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 6),

          // ── Day grid ───────────────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              mainAxisExtent: 34, // fixed row height — must match _heightForMonth
            ),
            itemCount: offset + daysInMonth,
            itemBuilder: (context, i) {
              if (i < offset) return const SizedBox.shrink();

              final day      = i - offset + 1;
              final date     = DateTime(month.year, month.month, day);
              final hasEntry = entryDays.contains(day);
              final isToday  = today.year  == month.year  &&
                               today.month == month.month &&
                               today.day   == day;
              final isSelected = selectedDay == day;
              // Disable future dates — can't journal tomorrow.
              final isFuture = date.isAfter(today);

              return Semantics(
                button: !isFuture,
                enabled: !isFuture,
                selected: isSelected,
                label: isSelected
                    ? 'Selected: $day ${_kMonthsFull[month.month - 1]}'
                    : isFuture
                        ? '$day ${_kMonthsFull[month.month - 1]}, future date'
                        : hasEntry
                            ? '$day ${_kMonthsFull[month.month - 1]}, has entry'
                            : '$day ${_kMonthsFull[month.month - 1]}',
                child: GestureDetector(
                  onTap: isFuture ? null : () => onDateTap(date, hasEntry),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Day number with coral circle when selected.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.accentCoral
                            : isToday
                                ? AppColors.accentCoral.withValues(alpha: 0.12)
                                : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          textAlign: TextAlign.center,
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                    ? AppColors.accentCoral
                                    : isFuture
                                        ? textPrimary.withValues(alpha: 0.22)
                                        : textPrimary.withValues(alpha: 0.85),
                            fontWeight: (isSelected || isToday)
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    // Gold star on days that have at least one entry.
                    if (hasEntry)
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.accentGold,
                        size: 8,
                      ),
                  ],
                ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthLabel(DateTime dt) =>
      '${_kMonthsFull[dt.month - 1]} ${dt.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Selected-date chip — appears below the calendar when a date is active
// ─────────────────────────────────────────────────────────────────────────────

class _SelectedDateChip extends StatelessWidget {
  final DateTime date;
  final Color textPrimary;
  final VoidCallback onClear;

  const _SelectedDateChip({
    required this.date,
    required this.textPrimary,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final label = _formatDate(date); // e.g. "April 19"

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentCoral.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.accentCoral.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 13, color: AppColors.accentCoral),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accentCoral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: 'Clear date filter',
                  child: GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close_rounded,
                        size: 14, color: AppColors.accentCoral),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
        border:
            Border.all(color: AppColors.accentCoral.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline,
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
  final bool isDateFiltered;
  final DateTime? filteredDate;

  const _EmptyState({
    required this.onWrite,
    required this.textSecondary,
    required this.textPrimary,
    required this.surface,
    required this.borderColor,
    this.isDateFiltered = false,
    this.filteredDate,
  });

  @override
  Widget build(BuildContext context) {
    final body = isDateFiltered && filteredDate != null
        ? 'No entries for ${_formatDate(filteredDate!)}.\nTap the ✏️ button to write one.'
        : StringsJournal.emptyStateBody;

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
              body,
              textAlign: TextAlign.center,
              style:
                  AppTypography.bodyMedium.copyWith(color: textSecondary),
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
              child: Text(isDateFiltered
                  ? 'Write entry'
                  : StringsJournal.emptyStateCta),
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
    final dt        = entry.createdAt;
    final dateLabel = '${_monthShort(dt.month)} ${dt.day}, ${dt.year}';

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
