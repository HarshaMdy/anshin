// Learn home — Content Bible §12
// Three shelf banner cards (Understanding, Short-term, Long-term).
// Tapping the Understanding banner pushes UnderstandingTrackScreen.
// Short-term and Long-term are coming-soon, not yet tappable.
//
// UnderstandingTrackScreen lives in this same file so it can share the
// private helper widgets (_LessonData, _TrackBannerCard, _LessonCard, _Chip).
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_learn.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/scene_painter.dart';
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

// ─── Understanding shelf catalogue (shared by both screens) ──────────────────

const List<_LessonData> _understandingLessons = [
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

// ═════════════════════════════════════════════════════════════════════════════
// SCREEN 1 — Learn Home (3 banner cards only)
// ═════════════════════════════════════════════════════════════════════════════

class LearnHomeScreen extends StatelessWidget {
  const LearnHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          children: [
            // ── Page heading ──────────────────────────────────────────────
            Text(
              'Learn',
              style: AppTypography.headingLarge.copyWith(color: textPrimary),
            ),

            const SizedBox(height: 28),

            // ── Shelf 1 — Understanding (tappable) ────────────────────────
            _TrackBannerCard(
              title: StringsLearn.shelf1Title,
              subtitle: StringsLearn.shelf1Sub,
              emotion: MascotEmotion.readingBook,
              lessonsDone: _understandingLessons.where((l) => l.isFree).length,
              totalLessons: _understandingLessons.length,
              onTap: () => context.push(AppRoutes.understandingTrack),
            ),

            const SizedBox(height: 16),

            // ── Shelf 2 — Short-term skills (coming soon) ─────────────────
            _TrackBannerCard(
              title: StringsLearn.shelf2Title,
              subtitle: StringsLearn.shelf2Sub,
              emotion: MascotEmotion.breathing,
              lessonsDone: 0,
              totalLessons: 0,
              comingSoon: true,
            ),

            const SizedBox(height: 16),

            // ── Shelf 3 — Long-term growth (coming soon) ──────────────────
            _TrackBannerCard(
              title: StringsLearn.shelf3Title,
              subtitle: StringsLearn.shelf3Sub,
              emotion: MascotEmotion.hopeful,
              lessonsDone: 0,
              totalLessons: 0,
              comingSoon: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SCREEN 2 — Understanding track lesson list
// ═════════════════════════════════════════════════════════════════════════════

class UnderstandingTrackScreen extends StatelessWidget {
  const UnderstandingTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.learnHome),
        ),
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: null, // clean — track name is in the banner card
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        children: [
          // ── Smaller banner (160dp) ────────────────────────────────────
          _TrackBannerCard(
            title: StringsLearn.shelf1Title,
            subtitle: StringsLearn.shelf1Sub,
            emotion: MascotEmotion.readingBook,
            lessonsDone: _understandingLessons.where((l) => l.isFree).length,
            totalLessons: _understandingLessons.length,
            height: 160,
          ),

          const SizedBox(height: 16),

          // ── 6 lesson cards ────────────────────────────────────────────
          for (final lesson in _understandingLessons) ...[
            _LessonCard(
              lesson: lesson,
              onTap: lesson.isFree
                  ? () => context.push(AppRoutes.lessonDetailPath(lesson.id))
                  : null,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// ─── Track banner card ────────────────────────────────────────────────────────

class _TrackBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final MascotEmotion emotion;
  final int lessonsDone;
  final int totalLessons;
  final bool comingSoon;
  final double height;
  final VoidCallback? onTap; // null = not tappable

  const _TrackBannerCard({
    required this.title,
    required this.subtitle,
    required this.emotion,
    required this.lessonsDone,
    required this.totalLessons,
    this.comingSoon = false,
    this.height = 140,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.08),
          child: SizedBox(
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Meadow gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: meadowGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Meadow scene
                const CustomPaint(painter: MeadowScenePainter()),
                // Mascot on the right
                Positioned(
                  right: 16,
                  bottom: 0,
                  child: MascotWidget(emotion: emotion, size: 88),
                ),
                // Text on the left
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  right: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 12,
                          fontFamily: 'PlusJakartaSans',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!comingSoon && totalLessons > 0) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: lessonsDone / totalLessons,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$lessonsDone / $totalLessons lessons free',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 11,
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Chevron hint for tappable banners
                if (onTap != null)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white.withValues(alpha: 0.65),
                      size: 22,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
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
                          Text('·',
                              style: AppTypography.caption
                                  .copyWith(color: textSecondary)),
                          const SizedBox(width: 6),
                          Text(
                            lesson.readTime!,
                            style: AppTypography.caption
                                .copyWith(color: textSecondary),
                          ),
                        ],
                        const Spacer(),
                        if (lesson.isFree)
                          _Chip(label: 'Free', color: AppColors.accentTeal)
                        else
                          _Chip(label: 'Coming soon', color: textSecondary),
                      ],
                    ),
                    const SizedBox(height: 8),
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
