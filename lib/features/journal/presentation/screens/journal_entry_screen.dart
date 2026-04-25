// Journal entry flow — Content Bible §9
// 6 steps: mood picker → accomplishments → release → gratitude → notes → completion.
// AES-256 encrypted before saving; free users capped at 30 entries.
//
// Completion step:
//   • shows a live preview of the shareable card (RepaintBoundary)
//   • share button captures the card at 3.6× → 1080×1080 PNG via
//     RepaintBoundary.toImage(), writes to temp dir, shares via ShareXFiles
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/strings_journal.dart';
import '../../../../core/constants/strings_mascot.dart';
import '../../../../core/constants/strings_share.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_share_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Step enum
// ─────────────────────────────────────────────────────────────────────────────

enum _JournalStep { mood, accomplishments, release, gratitude, notes, completion }

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  _JournalStep _step = _JournalStep.mood;

  // Field state
  String? _mood;
  final _accomplishmentsCtrl = TextEditingController();
  final _releaseCtrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // Completion state
  String? _savedInsight;
  bool _isSharing = false;

  // Key for the RepaintBoundary wrapping the share card
  final GlobalKey _shareCardKey = GlobalKey();

  @override
  void dispose() {
    _accomplishmentsCtrl.dispose();
    _releaseCtrl.dispose();
    _gratitudeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _next() {
    final steps = _JournalStep.values;
    final idx = steps.indexOf(_step);
    if (idx < steps.length - 1) {
      setState(() => _step = steps[idx + 1]);
    }
  }

  void _back() {
    final steps = _JournalStep.values;
    final idx = steps.indexOf(_step);
    if (idx > 0) {
      setState(() => _step = steps[idx - 1]);
    } else {
      context.canPop() ? context.pop() : context.go(AppRoutes.journalHome);
    }
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    final mood = _mood;
    if (mood == null) return;

    final insights   = StringsJournal.completionInsights;
    final insight    = insights[DateTime.now().millisecond % insights.length];
    // Read the calendar-selected date (set before navigation from the home
    // screen when the user taps a specific past date).  null → today.
    final entryDate  = ref.read(journalEntryDateProvider);

    await ref.read(journalNotifierProvider.notifier).save(
          mood: mood,
          accomplishments: _accomplishmentsCtrl.text,
          release: _releaseCtrl.text,
          gratitude: _gratitudeCtrl.text,
          notes: _notesCtrl.text,
          entryDate: entryDate,
        );

    // Clear the entry date so it doesn't leak into a subsequent new entry.
    ref.read(journalEntryDateProvider.notifier).state = null;

    if (mounted) {
      setState(() {
        _savedInsight = insight;
        _step = _JournalStep.completion;
      });
    }
  }

  // ── Share — capture card image and share via system sheet ──────────────────

  Future<void> _share() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await _captureAndShare();
    } catch (_) {
      // Fallback: share text if image capture fails
      if (mounted) await Share.share(StringsShare.journalCardText);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _captureAndShare() async {
    final context = _shareCardKey.currentContext;
    if (context == null) {
      await Share.share(StringsShare.journalCardText);
      return;
    }

    final boundary =
        context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      await Share.share(StringsShare.journalCardText);
      return;
    }

    // Render to image — pixelRatio 3.6 turns 300 dp → 1080 px
    final ui.Image image =
        await boundary.toImage(pixelRatio: JournalShareCard.capturePixelRatio);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) {
      await Share.share(StringsShare.journalCardText);
      return;
    }

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    // Write to temp file
    final Directory tempDir = await getTemporaryDirectory();
    final File file =
        File('${tempDir.path}/anshin_journal_card.png');
    await file.writeAsBytes(pngBytes, flush: true);

    // Open system share sheet with the PNG
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: StringsShare.journalCardText,
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    final saving = ref.watch(journalNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: bg,
      appBar: _step == _JournalStep.completion
          ? null
          : AppBar(
              backgroundColor: bg,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Go back',
                onPressed: _back,
              ),
              title: _ProgressDots(step: _step),
              centerTitle: true,
            ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _buildStep(
            isDark: isDark,
            bg: bg,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            surface: surface,
            borderColor: borderColor,
            saving: saving,
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required bool isDark,
    required Color bg,
    required Color textPrimary,
    required Color textSecondary,
    required Color surface,
    required Color borderColor,
    required bool saving,
  }) {
    switch (_step) {
      case _JournalStep.mood:
        return _MoodStep(
          key: const ValueKey('mood'),
          selectedMood: _mood,
          onSelect: (m) => setState(() => _mood = m),
          onNext: _mood != null ? _next : null,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          surface: surface,
          borderColor: borderColor,
        );
      case _JournalStep.accomplishments:
        return _TextStep(
          key: const ValueKey('accomplishments'),
          heading: StringsJournal.accomplishmentsHeading,
          subtext: StringsJournal.accomplishmentsSub,
          controller: _accomplishmentsCtrl,
          onNext: _next,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          surface: surface,
          borderColor: borderColor,
          buttonLabel: StringsJournal.buttonContinue,
        );
      case _JournalStep.release:
        return _TextStep(
          key: const ValueKey('release'),
          heading: StringsJournal.releaseHeading,
          subtext: StringsJournal.releaseSub,
          controller: _releaseCtrl,
          onNext: _next,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          surface: surface,
          borderColor: borderColor,
          buttonLabel: StringsJournal.buttonContinue,
        );
      case _JournalStep.gratitude:
        return _TextStep(
          key: const ValueKey('gratitude'),
          heading: StringsJournal.gratitudeHeading,
          subtext: StringsJournal.gratitudeSub,
          controller: _gratitudeCtrl,
          onNext: _next,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          surface: surface,
          borderColor: borderColor,
          buttonLabel: StringsJournal.buttonContinue,
        );
      case _JournalStep.notes:
        return _TextStep(
          key: const ValueKey('notes'),
          heading: StringsJournal.notesHeading,
          subtext: StringsJournal.notesSub,
          controller: _notesCtrl,
          onNext: saving ? null : _save,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          surface: surface,
          borderColor: borderColor,
          buttonLabel: StringsJournal.buttonFinish,
          isOptional: true,
          isSaving: saving,
        );
      case _JournalStep.completion:
        return _CompletionStep(
          key: const ValueKey('completion'),
          insight: _savedInsight ?? StringsJournal.completionInsights.first,
          mood: _mood,
          shareCardKey: _shareCardKey,
          isSharing: _isSharing,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          onDone: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.journalHome),
          onShare: _share,
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress dots
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressDots extends StatelessWidget {
  final _JournalStep step;
  const _ProgressDots({required this.step});

  @override
  Widget build(BuildContext context) {
    const total = 5;
    final current = step.index;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == current ? 18 : 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: i <= current
                  ? AppColors.accentCoral
                  : AppColors.accentCoral.withValues(alpha: 0.25),
            ),
          ),
          if (i < total - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — Mood picker
// ─────────────────────────────────────────────────────────────────────────────

class _MoodStep extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color borderColor;

  const _MoodStep({
    super.key,
    required this.selectedMood,
    required this.onSelect,
    required this.onNext,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.borderColor,
  });

  static const List<MascotEmotion> _emotions = [
    MascotEmotion.calm,
    MascotEmotion.anxious,
    MascotEmotion.panicked,
    MascotEmotion.sad,
    MascotEmotion.tired,
    MascotEmotion.overwhelmed,
    MascotEmotion.hopeful,
    MascotEmotion.relieved,
    MascotEmotion.grateful,
    MascotEmotion.frustrated,
    MascotEmotion.numb,
    MascotEmotion.proud,
  ];

  @override
  Widget build(BuildContext context) {
    final labels = StringsMascot.allLabels;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            StringsJournal.moodPickerHeading,
            style: AppTypography.headingLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 28),

          // 3 × 4 grid — 72dp circles, 56dp SVG inside, 16dp/20dp gaps
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              // Fixed extent: 72 (circle) + 6 (gap) + ~18 (label) + headroom
              mainAxisExtent: 104,
            ),
            itemCount: _emotions.length,
            itemBuilder: (context, i) {
              final label = labels[i];
              final selected = selectedMood == label;

              return Semantics(
                button: true,
                selected: selected,
                label: selected ? '$label, selected' : label,
                child: GestureDetector(
                  onTap: () => onSelect(label),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Scale animation wraps the circle so the border
                      // scales with it rather than the SVG independently.
                      AnimatedScale(
                        scale: selected ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 72,
                          height: 72,
                          // alignment centers the SVG within the circle
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // White unselected, 10% coral tint selected
                            color: selected
                                ? AppColors.accentCoral.withValues(alpha: 0.10)
                                : surface,
                            border: Border.all(
                              color: selected
                                  ? AppColors.accentCoral   // 2dp coral
                                  : borderColor,            // 1dp #E8E2D9
                              width: selected ? 2.0 : 1.0,
                            ),
                          ),
                          child: SvgPicture.asset(
                            _emotions[i].assetPath,
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 12,
                          color: selected
                              ? AppColors.accentCoral
                              : textSecondary,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 36),

          // Continue — full coral when a mood is selected, muted otherwise
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.accentCoral.withValues(alpha: 0.35),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle: AppTypography.button,
              elevation: 0,
            ),
            child: Text(StringsJournal.buttonContinue),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Steps 2–5 — Text input steps
// ─────────────────────────────────────────────────────────────────────────────

class _TextStep extends StatelessWidget {
  final String heading;
  final String subtext;
  final TextEditingController controller;
  final VoidCallback? onNext;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color borderColor;
  final String buttonLabel;
  final bool isOptional;
  final bool isSaving;

  const _TextStep({
    super.key,
    required this.heading,
    required this.subtext,
    required this.controller,
    required this.onNext,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.borderColor,
    required this.buttonLabel,
    this.isOptional = false,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            style: AppTypography.headingLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            subtext,
            style: AppTypography.bodyMedium.copyWith(color: textSecondary),
          ),
          const SizedBox(height: 28),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              maxLines: 7,
              minLines: 5,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: isOptional ? 'Optional…' : 'Write here…',
                hintStyle: AppTypography.bodyMedium
                    .copyWith(color: textSecondary.withValues(alpha: 0.5)),
              ),
              style: AppTypography.bodyMedium.copyWith(color: textPrimary),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: isSaving ? null : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.accentCoral.withValues(alpha: 0.35),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle: AppTypography.button,
              elevation: 0,
            ),
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 6 — Completion
// ─────────────────────────────────────────────────────────────────────────────

class _CompletionStep extends StatelessWidget {
  final String insight;
  final String? mood;
  final GlobalKey shareCardKey;
  final bool isSharing;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onDone;
  final VoidCallback onShare;

  const _CompletionStep({
    super.key,
    required this.insight,
    required this.mood,
    required this.shareCardKey,
    required this.isSharing,
    required this.textPrimary,
    required this.textSecondary,
    required this.onDone,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve the user's mood → mascot emotion for the share card
    final emotion = mood != null
        ? MascotEmotionAsset.fromLabel(mood!)
        : MascotEmotion.calm;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Celebration mascot ─────────────────────────────────────────
          const Center(
            child: MascotWidget(
              emotion: MascotEmotion.proud,
              size: 90,
              breathe: true,
            ),
          ),

          const SizedBox(height: 20),

          // ── Points pill ────────────────────────────────────────────────
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.40)),
              ),
              child: Text(
                StringsJournal.completionPoints,
                style: AppTypography.caption.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ── Saved heading ──────────────────────────────────────────────
          Text(
            StringsJournal.completionSaved,
            textAlign: TextAlign.center,
            style:
                AppTypography.headingMedium.copyWith(color: textPrimary),
          ),

          const SizedBox(height: 10),

          // ── Insight ────────────────────────────────────────────────────
          Text(
            insight,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: textSecondary),
          ),

          const SizedBox(height: 28),

          // ── Share card preview ─────────────────────────────────────────
          // Wrapped in RepaintBoundary so toImage() captures only this card.
          // ClipRRect gives the on-screen preview a matching corner radius.
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: RepaintBoundary(
                key: shareCardKey,
                child: JournalShareCard(emotion: emotion),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Share button ───────────────────────────────────────────────
          OutlinedButton.icon(
            onPressed: isSharing ? null : onShare,
            icon: isSharing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: AppColors.accentCoral,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.share_outlined, size: 18),
            label: Text(isSharing
                ? 'Preparing…'
                : StringsJournal.completionShare),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentCoral,
              side: BorderSide(
                  color: AppColors.accentCoral.withValues(alpha: 0.5)),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle: AppTypography.button,
            ),
          ),

          const SizedBox(height: 12),

          // ── Done button ────────────────────────────────────────────────
          ElevatedButton(
            onPressed: onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              textStyle: AppTypography.button,
              elevation: 0,
            ),
            child: Text(StringsJournal.completionDone),
          ),
        ],
      ),
    );
  }
}
