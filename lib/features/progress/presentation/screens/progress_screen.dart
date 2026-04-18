// Progress screen — Content Bible §11
// 7-day charts (mood line, anxiety bar) using fl_chart.
// Stats row (SOS, sessions, journal). Streak display.
// Free: 7 days. Premium: 30 days + rule-based insights.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_progress.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../data/progress_repository.dart';
import '../providers/progress_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    final window = ref.watch(windowDaysProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final progressAsync = ref.watch(progressDataProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        StringsProgress.tabLabel,
                        style: AppTypography.headingLarge
                            .copyWith(color: textPrimary),
                      ),
                    ),
                    _PeriodToggle(
                      selected: window,
                      isPremium: isPremium,
                      onSelect: (days) {
                        if (!isPremium && days == 30) {
                          context.push(AppRoutes.paywall);
                          return;
                        }
                        ref.read(windowDaysProvider.notifier).state = days;
                      },
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: progressAsync.when(
                data: (data) {
                  if (data == null) return const SizedBox.shrink();
                  return _ProgressBody(
                    data: data,
                    isPremium: isPremium,
                    surface: surface,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Period toggle  (7d / 30d)
// ─────────────────────────────────────────────────────────────────────────────

class _PeriodToggle extends StatelessWidget {
  final int selected;
  final bool isPremium;
  final ValueChanged<int> onSelect;
  final Color textSecondary;

  const _PeriodToggle({
    required this.selected,
    required this.isPremium,
    required this.onSelect,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Chip(label: '7d', selected: selected == 7, onTap: () => onSelect(7)),
          _Chip(
            label: '30d',
            selected: selected == 30,
            locked: !isPremium,
            onTap: () => onSelect(30),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    this.locked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentCoral : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.accentCoral,
              ),
            ),
            if (locked) ...[
              const SizedBox(width: 3),
              Icon(Icons.lock_outline,
                  size: 11,
                  color: selected
                      ? Colors.white
                      : AppColors.accentCoral.withValues(alpha: 0.7)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body — assembled from the ProgressData object
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressBody extends StatelessWidget {
  final ProgressData data;
  final bool isPremium;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _ProgressBody({
    required this.data,
    required this.isPremium,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Charts (only when enough data) ───────────────────────────────────
          if (data.hasEnoughData) ...[
            _MoodChartCard(
              data: data,
              surface: surface,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),
            _AnxietyChartCard(
              data: data,
              surface: surface,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),
          ] else ...[
            _InsufficientDataCard(
              surface: surface,
              borderColor: borderColor,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),
          ],

          // ── Stats row ─────────────────────────────────────────────────────────
          _StatsRow(
            data: data,
            surface: surface,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          // ── Streak ────────────────────────────────────────────────────────────
          _StreakCard(
            streak: data.streakDays,
            surface: surface,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),

          // ── Premium insights ──────────────────────────────────────────────────
          if (isPremium && data.insights.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Insights',
              style: AppTypography.headingSmall
                  .copyWith(color: textPrimary),
            ),
            const SizedBox(height: 12),
            for (final insight in data.insights) ...[
              _InsightCard(
                text: insight,
                surface: surface,
                borderColor: borderColor,
                textSecondary: textSecondary,
              ),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mood line chart
// ─────────────────────────────────────────────────────────────────────────────

class _MoodChartCard extends StatelessWidget {
  final ProgressData data;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _MoodChartCard({
    required this.data,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final spots = _buildSpots();
    final windowDays = data.windowDays;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              StringsProgress.moodChartLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: borderColor.withValues(alpha: 0.5),
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) => _bottomLabel(
                        value,
                        meta,
                        windowDays: windowDays,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (windowDays - 1).toDouble(),
                minY: 1,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.accentTeal,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, _, _, _) =>
                          FlDotCirclePainter(
                        radius: 3.5,
                        color: AppColors.accentTeal,
                        strokeWidth: 0,
                        strokeColor: Colors.transparent,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accentTeal.withValues(alpha: 0.06),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Struggling',
                  style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      color: textSecondary.withValues(alpha: 0.55)),
                ),
                Text(
                  'Great',
                  style: AppTypography.caption.copyWith(
                      fontSize: 10,
                      color: textSecondary.withValues(alpha: 0.55)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return data.checkins.map((c) {
      final d = _parseDate(c.date);
      final diff = today.difference(d).inDays;
      final x = (data.windowDays - 1 - diff).toDouble();
      return x >= 0 ? FlSpot(x, c.mood.toDouble()) : null;
    }).whereType<FlSpot>().toList();
  }

  static DateTime _parseDate(String s) {
    final p = s.split('-');
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Anxiety bar chart
// ─────────────────────────────────────────────────────────────────────────────

class _AnxietyChartCard extends StatelessWidget {
  final ProgressData data;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _AnxietyChartCard({
    required this.data,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final groups = _buildGroups();
    final windowDays = data.windowDays;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              StringsProgress.anxietyChartLabel,
              style: AppTypography.bodyMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                barGroups: groups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: borderColor.withValues(alpha: 0.5),
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) => _bottomLabel(
                        value,
                        meta,
                        windowDays: windowDays,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                maxY: 10,
                minY: 0,
                barTouchData: BarTouchData(enabled: false),
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: windowDays <= 7 ? 8 : 3,
                baselineY: 0,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Color legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                _LegendDot(color: AppColors.accentTeal, label: 'Low', textSecondary: textSecondary),
                const SizedBox(width: 12),
                _LegendDot(color: AppColors.accentGold, label: 'Moderate', textSecondary: textSecondary),
                const SizedBox(width: 12),
                _LegendDot(color: AppColors.accentCoral, label: 'High', textSecondary: textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final barWidth = data.windowDays <= 7 ? 16.0 : 7.0;

    return data.checkins.map((c) {
      final d = _parseDate(c.date);
      final diff = today.difference(d).inDays;
      final x = data.windowDays - 1 - diff;
      if (x < 0) return null;

      final color = c.anxiety >= 7
          ? AppColors.accentCoral
          : c.anxiety >= 4
              ? AppColors.accentGold
              : AppColors.accentTeal;

      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: c.anxiety.toDouble(),
            color: color,
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).whereType<BarChartGroupData>().toList();
  }

  static DateTime _parseDate(String s) {
    final p = s.split('-');
    return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final Color textSecondary;
  const _LegendDot(
      {required this.color,
      required this.label,
      required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
              fontSize: 10,
              color: textSecondary.withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared bottom-axis title widget
// ─────────────────────────────────────────────────────────────────────────────

Widget _bottomLabel(
  double value,
  TitleMeta meta, {
  required int windowDays,
  required Color color,
}) {
  final x = value.toInt();

  // Decide which positions to label
  if (windowDays <= 7) {
    if (x < 0 || x >= windowDays) return const SizedBox.shrink();
  } else {
    final show = x % 7 == 0 || x == windowDays - 1;
    if (!show) return const SizedBox.shrink();
  }

  final now = DateTime.now();
  final date = now.subtract(Duration(days: windowDays - 1 - x));

  String label;
  if (windowDays <= 7) {
    const abbr = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    label = abbr[(date.weekday - 1) % 7];
  } else {
    label = '${date.day}/${date.month}';
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(
      label,
      style: TextStyle(
        fontSize: 10,
        color: color.withValues(alpha: 0.7),
        fontFamily: 'PlusJakartaSans',
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats row
// ─────────────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ProgressData data;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _StatsRow({
    required this.data,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _StatTile(
            count: data.sosCount,
            label: StringsProgress.statsSosLabel,
            color: AppColors.accentCoral,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _Divider(borderColor: borderColor),
          _StatTile(
            count: data.sessionCount,
            label: StringsProgress.statsSessionsLabel,
            color: AppColors.accentTeal,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          _Divider(borderColor: borderColor),
          _StatTile(
            count: data.journalCount,
            label: StringsProgress.statsJournalLabel,
            color: AppColors.accentGold,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color textPrimary;
  final Color textSecondary;

  const _StatTile({
    required this.count,
    required this.label,
    required this.color,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        child: Column(
          children: [
            Text(
              '$count',
              style: AppTypography.headingMedium.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                  color: textSecondary, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color borderColor;
  const _Divider({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: VerticalDivider(
        color: borderColor,
        thickness: 1,
        width: 1,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak card
// ─────────────────────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  final int streak;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _StreakCard({
    required this.streak,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  String get _message {
    if (streak == 0) return StringsProgress.streakZero;
    if (streak == 1) return StringsProgress.streakOne;
    if (streak == 7) return StringsProgress.streakSeven;
    if (streak >= 30) return StringsProgress.streakThirty;
    return StringsProgress.streakDays(streak);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: streak > 0
              ? AppColors.accentGold.withValues(alpha: 0.35)
              : borderColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: streak > 0
                ? AppColors.accentGold
                : textSecondary.withValues(alpha: 0.3),
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (streak > 0)
                  Text(
                    '$streak',
                    style: AppTypography.headingSmall
                        .copyWith(color: AppColors.accentGold),
                  ),
                Text(
                  _message,
                  style: AppTypography.bodyMedium
                      .copyWith(color: streak > 0 ? textPrimary : textSecondary),
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
// Insight card (premium)
// ─────────────────────────────────────────────────────────────────────────────

class _InsightCard extends StatelessWidget {
  final String text;
  final Color surface;
  final Color borderColor;
  final Color textSecondary;

  const _InsightCard({
    required this.text,
    required this.surface,
    required this.borderColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accentTeal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accentTeal.withValues(alpha: 0.25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline,
              color: AppColors.accentTeal, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium
                  .copyWith(color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Insufficient data card
// ─────────────────────────────────────────────────────────────────────────────

class _InsufficientDataCard extends StatelessWidget {
  final Color surface;
  final Color borderColor;
  final Color textSecondary;

  const _InsufficientDataCard({
    required this.surface,
    required this.borderColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 40,
            color: textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            StringsProgress.insufficientDataBody,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}
