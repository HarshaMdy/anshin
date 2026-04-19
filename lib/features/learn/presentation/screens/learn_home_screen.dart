// Learn home — Content Bible §12
// Three shelves: Understanding (6 lessons, 2 free), Short-term skills (coming soon),
// Long-term growth (coming soon).  Tapping a free lesson pushes LessonDetailScreen.
// Tapping a locked card shows the in-card "coming soon" state — no navigation.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_learn.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';

// ─── Lesson data model ────────────────────────────────────────────────────────

class _LessonData {
  final String id;
  final String number;
  final String title;
  final String? readTime;
  final bool isFree;

  const _LessonData({
    required this.id,
    required this.number,
    required this.title,
    this.readTime,
    required this.isFree,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class LearnHomeScreen extends StatelessWidget {
  const LearnHomeScreen({super.key});

  static const List<_LessonData> _shelf1 = [
    _LessonData(
      id: '1',
      number: StringsLearn.lesson1Number,
      title: StringsLearn.lesson1Title,
      readTime: StringsLearn.lesson1ReadTime,
      isFree: true,
    ),
    _LessonData(
      id: '2',
      number: StringsLearn.lesson2Number,
      title: StringsLearn.lesson2Title,
      readTime: StringsLearn.lesson2ReadTime,
      isFree: true,
    ),
    _LessonData(
      id: '3',
      number: StringsLearn.lesson3Number,
      title: StringsLearn.lesson3Title,
      isFree: false,
    ),
    _LessonData(
      id: '4',
      number: StringsLearn.lesson4Number,
      title: StringsLearn.lesson4Title,
      isFree: false,
    ),
    _LessonData(
      id: '5',
      number: StringsLearn.lesson5Number,
      title: StringsLearn.lesson5Title,
      isFree: false,
    ),
    _LessonData(
      id: '6',
      number: StringsLearn.lesson6Number,
      title: StringsLearn.lesson6Title,
      isFree: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          children: [
            // ── Page heading ────────────────────────────────────────────────
            Text(
              'Learn',
              style: AppTypography.headingLarge
                  .copyWith(color: textPrimary),
            ),

            const SizedBox(height: 28),

            // ── Shelf 1 — Understanding ─────────────────────────────────────
            _ShelfHeader(
              title: StringsLearn.shelf1Title,
              subtitle: StringsLearn.shelf1Sub,
            ),
            const SizedBox(height: 12),
            for (final lesson in _shelf1) ...[
              _LessonCard(
                lesson: lesson,
                onTap: lesson.isFree
                    ? () => context
                        .push(AppRoutes.lessonDetailPath(lesson.id))
                    : null,
              ),
              const SizedBox(height: 10),
            ],

            const SizedBox(height: 20),

            // ── Shelf 2 — Short-term skills ─────────────────────────────────
            _ShelfHeader(
              title: StringsLearn.shelf2Title,
              subtitle: StringsLearn.shelf2Sub,
            ),
            const SizedBox(height: 12),
            const _ComingSoonBanner(),

            const SizedBox(height: 20),

            // ── Shelf 3 — Long-term growth ──────────────────────────────────
            _ShelfHeader(
              title: StringsLearn.shelf3Title,
              subtitle: StringsLearn.shelf3Sub,
            ),
            const SizedBox(height: 12),
            const _ComingSoonBanner(),
          ],
        ),
      ),
    );
  }
}

// ─── Shelf header ─────────────────────────────────────────────────────────────

class _ShelfHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ShelfHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              AppTypography.headingSmall.copyWith(color: textPrimary),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(color: textSecondary),
        ),
      ],
    );
  }
}

// ─── Lesson card ──────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final _LessonData lesson;
  final VoidCallback? onTap; // null = locked / coming soon

  const _LessonCard({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final isLocked = onTap == null;

    return Material(
      color: isLocked ? bg.withValues(alpha: 0.55) : bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Text block ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number · read time + badge
                    Row(
                      children: [
                        Text(
                          lesson.number,
                          style: AppTypography.caption
                              .copyWith(color: textSecondary),
                        ),
                        if (lesson.readTime != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '·',
                            style: AppTypography.caption
                                .copyWith(color: textSecondary),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            lesson.readTime!,
                            style: AppTypography.caption
                                .copyWith(color: textSecondary),
                          ),
                        ],
                        const Spacer(),
                        if (lesson.isFree)
                          _Chip(
                            label: 'Free',
                            color: AppColors.accentTeal,
                          )
                        else
                          _Chip(
                            label: 'Coming soon',
                            color: textSecondary,
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      lesson.title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: isLocked ? textSecondary : textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Right icon ─────────────────────────────────────────────
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: isLocked
                    ? Icon(Icons.lock_outline,
                        color: textSecondary, size: 18)
                    : Icon(Icons.chevron_right,
                        color: textSecondary, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small chip label ─────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Coming-soon banner (shelves 2 & 3) ──────────────────────────────────────

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_top_outlined,
            color: textSecondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            'Lessons coming in a future update.',
            style: AppTypography.bodyMedium.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}
