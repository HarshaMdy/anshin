// Lesson detail — Content Bible §12
// Renders lessons 1 and 2 as scrollable text screens with exact copy.
// Lesson 1 ends with a "Next lesson →" CTA; lesson 2 ends with "Back to Learn".
// Section headers inside the body are auto-detected (short lines, no terminal
// punctuation) and rendered at headingSmall weight for visual rhythm.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_learn.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';

class LessonDetailScreen extends StatelessWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // Resolve lesson content by id
    final isLesson1 = lessonId == '1';
    final title =
        isLesson1 ? StringsLearn.lesson1Title : StringsLearn.lesson2Title;
    final number =
        isLesson1 ? StringsLearn.lesson1Number : StringsLearn.lesson2Number;
    final readTime = isLesson1
        ? StringsLearn.lesson1ReadTime
        : StringsLearn.lesson2ReadTime;
    final body =
        isLesson1 ? StringsLearn.lesson1Body : StringsLearn.lesson2Body;
    final completionPoints = isLesson1
        ? StringsLearn.lesson1CompletionPoints
        : StringsLearn.lesson2CompletionPoints;
    final completionLabel = isLesson1
        ? StringsLearn.lesson1CompletionLabel
        : StringsLearn.lesson2CompletionLabel;

    // Split body into paragraphs; double newlines delimit them
    final paragraphs = body
        .split('\n\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.learnHome),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 48),
        children: [
          // ── Meta badges: number + read time ────────────────────────────
          Row(
            children: [
              _MetaBadge(label: number, color: AppColors.accentTeal),
              const SizedBox(width: 8),
              _MetaBadge(label: readTime, color: AppColors.accentGold),
            ],
          ),

          const SizedBox(height: 14),

          // ── Lesson title ────────────────────────────────────────────────
          Text(
            title,
            style:
                AppTypography.headingLarge.copyWith(color: textPrimary),
          ),

          const SizedBox(height: 28),

          // ── Body paragraphs ─────────────────────────────────────────────
          for (final para in paragraphs)
            _buildParagraph(para, textPrimary, textSecondary),

          const SizedBox(height: 44),

          // ── Completion section ──────────────────────────────────────────
          const Center(
            child: MascotWidget(
              emotion: MascotEmotion.proud,
              size: 80,
              breathe: true,
            ),
          ),

          const SizedBox(height: 16),

          // Points pill
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accentGold.withValues(alpha: 0.40),
                ),
              ),
              child: Text(
                completionPoints,
                style: AppTypography.caption.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Completion label
          Center(
            child: Text(
              completionLabel,
              style:
                  AppTypography.bodyMedium.copyWith(color: textSecondary),
            ),
          ),

          const SizedBox(height: 28),

          // ── CTA ─────────────────────────────────────────────────────────
          if (isLesson1)
            ElevatedButton(
              onPressed: () =>
                  context.push(AppRoutes.lessonDetailPath('2')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCoral,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                StringsLearn.lesson1NextButton,
                style: AppTypography.button.copyWith(color: Colors.white),
              ),
            )
          else
            OutlinedButton(
              onPressed: () => context.go(AppRoutes.learnHome),
              style: OutlinedButton.styleFrom(
                foregroundColor: textPrimary,
                minimumSize: const Size.fromHeight(52),
                side: BorderSide(
                    color: AppColors.accentTeal.withValues(alpha: 0.50)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                StringsLearn.lesson2BackButton,
                style: AppTypography.button.copyWith(color: textPrimary),
              ),
            ),
        ],
      ),
    );
  }

  // Detect section headers: short text that does not end with sentence-terminal
  // punctuation and is not a list item.  These are styled at headingSmall.
  Widget _buildParagraph(
      String text, Color textPrimary, Color textSecondary) {
    final isSectionHeader = text.length < 52 &&
        !text.endsWith('.') &&
        !text.endsWith(',') &&
        !text.endsWith(':') &&
        !text.startsWith('•');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: isSectionHeader
            ? AppTypography.headingSmall
                .copyWith(color: textPrimary)
                .copyWith(height: 1.3)
            : AppTypography.bodyLarge
                .copyWith(color: textSecondary)
                .copyWith(height: 1.65),
      ),
    );
  }
}

// ─── Meta badge (number / read time) ─────────────────────────────────────────

class _MetaBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
