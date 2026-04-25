// Lesson detail — Content Bible §12
// Renders lessons 1 and 2 as scrollable text screens with exact copy.
// "Mark as complete" shows a modal sheet with +10 points confirmation.
// Lesson 1 sheet: "Next lesson" → pushes lesson 2.
// Lesson 2 sheet: "Done" → pops back to UnderstandingTrackScreen.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_learn.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';

class LessonDetailScreen extends StatefulWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _isComplete = false;

  bool get _isLesson1 => widget.lessonId == '1';

  // Resolve lesson content
  String get _title =>
      _isLesson1 ? StringsLearn.lesson1Title : StringsLearn.lesson2Title;
  String get _number =>
      _isLesson1 ? StringsLearn.lesson1Number : StringsLearn.lesson2Number;
  String get _readTime =>
      _isLesson1 ? StringsLearn.lesson1ReadTime : StringsLearn.lesson2ReadTime;
  String get _body =>
      _isLesson1 ? StringsLearn.lesson1Body : StringsLearn.lesson2Body;
  String get _completionPoints => _isLesson1
      ? StringsLearn.lesson1CompletionPoints
      : StringsLearn.lesson2CompletionPoints;
  String get _completionLabel => _isLesson1
      ? StringsLearn.lesson1CompletionLabel
      : StringsLearn.lesson2CompletionLabel;

  void _markComplete() {
    setState(() => _isComplete = true);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CompletionSheet(
        points: _completionPoints,
        label: _completionLabel,
        isLesson1: _isLesson1,
        onNextLesson: _isLesson1
            ? () {
                Navigator.of(context).pop(); // close sheet
                context.push(AppRoutes.lessonDetailPath('2'));
              }
            : null,
        onDone: () {
          Navigator.of(context).pop(); // close sheet
          if (context.canPop()) context.pop(); // back to track screen
        },
      ),
    ).then((_) {
      // If user swiped the sheet away without tapping a button, reset state
      // so the button remains usable.
      if (mounted) setState(() => _isComplete = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // Split body text into paragraphs (double newline delimited)
    final paragraphs = _body
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
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.understandingTrack),
        ),
        title: Text(
          _title,
          style: AppTypography.headingSmall.copyWith(
            color: textPrimary,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 48),
        children: [
          // ── Small hopeful mascot — at the top ──────────────────────────
          const Center(
            child: MascotWidget(
              emotion: MascotEmotion.hopeful,
              size: 64,
              breathe: true,
            ),
          ),

          const SizedBox(height: 20),

          // ── Meta badges: number + read time ────────────────────────────
          Row(
            children: [
              _MetaBadge(label: _number, color: AppColors.accentTeal),
              const SizedBox(width: 8),
              _MetaBadge(label: _readTime, color: AppColors.accentGold),
            ],
          ),

          const SizedBox(height: 14),

          // ── Lesson title ────────────────────────────────────────────────
          Text(
            _title,
            style: AppTypography.headingLarge.copyWith(color: textPrimary),
          ),

          const SizedBox(height: 28),

          // ── Body paragraphs ─────────────────────────────────────────────
          for (final para in paragraphs)
            _buildParagraph(para, textPrimary, textSecondary),

          const SizedBox(height: 44),

          // ── Mark as complete ────────────────────────────────────────────
          // Full coral when active; muted after tap (sheet handles navigation).
          ElevatedButton(
            onPressed: _isComplete ? null : _markComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.accentCoral.withValues(alpha: 0.35),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
              textStyle: AppTypography.button,
            ),
            child: const Text('Mark as complete'),
          ),
        ],
      ),
    );
  }

  // Section headers: short lines that don't end with sentence punctuation.
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
                .copyWith(color: textPrimary, height: 1.3)
            : AppTypography.bodyLarge
                .copyWith(color: textSecondary, height: 1.65),
      ),
    );
  }
}

// ─── Completion modal bottom sheet ───────────────────────────────────────────

class _CompletionSheet extends StatelessWidget {
  final String points;
  final String label;
  final bool isLesson1;
  final VoidCallback? onNextLesson; // non-null only for lesson 1
  final VoidCallback onDone;

  const _CompletionSheet({
    required this.points,
    required this.label,
    required this.isLesson1,
    required this.onNextLesson,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        // Extra bottom padding for devices with home indicator
        MediaQuery.of(context).viewPadding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ─────────────────────────────────────────────────
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: textSecondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 28),

          // ── Proud mascot ────────────────────────────────────────────────
          const MascotWidget(
            emotion: MascotEmotion.proud,
            size: 80,
            breathe: true,
          ),

          const SizedBox(height: 16),

          // ── Points badge ─────────────────────────────────────────────────
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.accentGold.withValues(alpha: 0.40)),
            ),
            child: Text(
              points,
              style: AppTypography.caption.copyWith(
                color: AppColors.accentGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Completion label ─────────────────────────────────────────────
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: textSecondary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // ── Primary CTA ──────────────────────────────────────────────────
          // Lesson 1: "Next lesson" → push lesson 2
          // Lesson 2: "Done" → pop back to track list
          ElevatedButton(
            onPressed: isLesson1 ? onNextLesson : onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
              textStyle: AppTypography.button,
            ),
            child: Text(
              isLesson1
                  ? StringsLearn.lesson1NextButton
                  : StringsLearn.backToLearn,
            ),
          ),

          // Lesson 1: also offer a "skip for now" option
          if (isLesson1) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: onDone,
              style: TextButton.styleFrom(
                foregroundColor: textSecondary,
                minimumSize: const Size.fromHeight(44),
                textStyle: AppTypography.bodyMedium,
              ),
              child: const Text('Maybe later'),
            ),
          ],
        ],
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
