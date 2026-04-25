// Daily check-in screen — Content Bible §10
// Mood 5-mascot scale (mascot SVG expressions), anxiety 1-10 slider, optional
// tags, save → SQLite + Firestore.  Theme-adaptive (follows user theme).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_checkin.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/checkin_provider.dart';

class CheckinScreen extends ConsumerStatefulWidget {
  const CheckinScreen({super.key});

  @override
  ConsumerState<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends ConsumerState<CheckinScreen> {
  int? _selectedMood; // 1–5; null = nothing chosen yet
  double _anxietyValue = 5.0; // 1–10
  final Set<String> _selectedTags = {};

  Future<void> _save() async {
    final mood = _selectedMood;
    if (mood == null) return;

    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return;

    await ref.read(checkinNotifierProvider.notifier).save(
          auth.user.userId,
          mood,
          _anxietyValue.round(),
          _selectedTags.toList(),
        );

    if (mounted) {
      context.canPop() ? context.pop() : context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final saving =
        ref.watch(checkinNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Calm mascot above heading ─────────────────────────────────
              const Center(
                child: MascotWidget(
                  emotion: MascotEmotion.calm,
                  size: 72,
                  breathe: true,
                ),
              ),

              const SizedBox(height: 16),

              // ── Heading ───────────────────────────────────────────────────
              Text(
                StringsCheckin.heading,
                style: AppTypography.headingLarge.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 36),

              // ── Mood scale ────────────────────────────────────────────────
              _MoodRow(
                selectedMood: _selectedMood,
                onSelect: (m) => setState(() => _selectedMood = m),
                textSecondary: textSecondary,
              ),

              const SizedBox(height: 36),

              // ── Anxiety slider ────────────────────────────────────────────
              _AnxietySection(
                value: _anxietyValue,
                onChanged: (v) => setState(() => _anxietyValue = v),
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              const SizedBox(height: 36),

              // ── Tags ──────────────────────────────────────────────────────
              _TagsSection(
                selectedTags: _selectedTags,
                onToggle: (tag) => setState(() {
                  if (_selectedTags.contains(tag)) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                }),
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),

              const SizedBox(height: 52),

              // ── Save button ───────────────────────────────────────────────
              ElevatedButton(
                onPressed:
                    (_selectedMood != null && !saving) ? _save : null,
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
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(StringsCheckin.saveButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Mood scale — mascot SVG expressions
// ═════════════════════════════════════════════════════════════════════════════

class _MoodRow extends StatelessWidget {
  final int? selectedMood;
  final ValueChanged<int> onSelect;
  final Color textSecondary;

  const _MoodRow({
    required this.selectedMood,
    required this.onSelect,
    required this.textSecondary,
  });

  // 5 mascot emotions mapped to the mood scale 1–5
  static const List<MascotEmotion> _emotions = [
    MascotEmotion.checkin1,  // Struggling
    MascotEmotion.checkin2,  // Rough
    MascotEmotion.checkin3,  // Okay
    MascotEmotion.checkin4,  // Good
    MascotEmotion.checkin5,  // Great
  ];

  static const List<String> _labels = [
    StringsCheckin.mood1Label,
    StringsCheckin.mood2Label,
    StringsCheckin.mood3Label,
    StringsCheckin.mood4Label,
    StringsCheckin.mood5Label,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 5; i++)
          _MoodMascot(
            mood: i + 1,
            emotion: _emotions[i],
            label: _labels[i],
            isSelected: selectedMood == i + 1,
            onTap: () => onSelect(i + 1),
            textSecondary: textSecondary,
          ),
      ],
    );
  }
}

class _MoodMascot extends StatelessWidget {
  final int mood;
  final MascotEmotion emotion;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color textSecondary;

  const _MoodMascot({
    required this.mood,
    required this.emotion,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: isSelected ? '$label, selected' : label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Coral circle behind mascot when selected + scale 1.15x
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.accentCoral.withValues(alpha: 0.18)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentCoral
                        : textSecondary.withValues(alpha: 0.20),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: MascotWidget(
                    emotion: emotion,
                    size: 38,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                color: isSelected ? AppColors.accentCoral : textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Anxiety slider
// ═════════════════════════════════════════════════════════════════════════════

class _AnxietySection extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color textPrimary;
  final Color textSecondary;

  const _AnxietySection({
    required this.value,
    required this.onChanged,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label + current value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringsCheckin.anxietySliderLabel,
              style: AppTypography.bodyLarge.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value.round().toString(),
              style: AppTypography.headingSmall
                  .copyWith(color: AppColors.accentCoral),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.accentCoral,
            inactiveTrackColor:
                AppColors.accentCoral.withValues(alpha: 0.18),
            thumbColor: AppColors.accentCoral,
            overlayColor: AppColors.accentCoral.withValues(alpha: 0.12),
            trackHeight: 3,
          ),
          child: Slider(
            value: value,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),

        // Low / High end labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringsCheckin.anxietyLow,
                style: AppTypography.caption.copyWith(color: textSecondary),
              ),
              Text(
                StringsCheckin.anxietyHigh,
                style: AppTypography.caption.copyWith(color: textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Tag chips
// ═════════════════════════════════════════════════════════════════════════════

class _TagsSection extends StatelessWidget {
  final Set<String> selectedTags;
  final ValueChanged<String> onToggle;
  final Color textPrimary;
  final Color textSecondary;

  const _TagsSection({
    required this.selectedTags,
    required this.onToggle,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          StringsCheckin.tagsLabel,
          style: AppTypography.bodyLarge.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in StringsCheckin.allTags)
              _TagChip(
                label: tag,
                selected: selectedTags.contains(tag),
                onTap: () => onToggle(tag),
                textSecondary: textSecondary,
              ),
          ],
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color textSecondary;

  const _TagChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '$label, selected' : label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accentCoral.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? AppColors.accentCoral
                  : textSecondary.withValues(alpha: 0.30),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: selected ? AppColors.accentCoral : textSecondary,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
