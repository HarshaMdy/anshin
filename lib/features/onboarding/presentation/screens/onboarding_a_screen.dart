// Onboarding screen A — "What brings you to Anshin?" — Content Bible §3a
// Single-select from 5 options. Continue routes to screen B.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_onboarding.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../providers/onboarding_provider.dart';

class OnboardingAScreen extends ConsumerStatefulWidget {
  const OnboardingAScreen({super.key});

  @override
  ConsumerState<OnboardingAScreen> createState() => _OnboardingAScreenState();
}

class _OnboardingAScreenState extends ConsumerState<OnboardingAScreen> {
  String? _selected;

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
              context.canPop() ? context.pop() : context.go(AppRoutes.gate),
        ),
        title: _StepIndicator(step: 1, textSecondary: textSecondary),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: MascotWidget(
                        emotion: MascotEmotion.hopeful,
                        size: 80,
                        breathe: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      StringsOnboarding.screen1Heading,
                      style: AppTypography.headingLarge
                          .copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 28),
                    for (final option in StringsOnboarding.screen1Options) ...[
                      _OptionTile(
                        label: option,
                        selected: _selected == option,
                        onTap: () => setState(() => _selected = option),
                        surface: surface,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),

            // ── Continue button ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () {
                        ref
                            .read(onboardingNotifierProvider.notifier)
                            .setAnxietyType(_selected!);
                        context.push(AppRoutes.onboardingB);
                      },
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
                child: Text(StringsOnboarding.continueButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step indicator  (1 of 3, 2 of 3, 3 of 3)
// ─────────────────────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int step; // 1, 2, or 3
  final Color textSecondary;
  const _StepIndicator({required this.step, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final active = i < step;
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 5 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == step - 1 ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: active
                  ? AppColors.accentCoral
                  : textSecondary.withValues(alpha: 0.20),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared option tile (single-select)
// ─────────────────────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accentCoral.withValues(alpha: 0.07)
              : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accentCoral : borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AppColors.accentCoral
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? AppColors.accentCoral
                      : borderColor,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check,
                      size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  color: selected
                      ? AppColors.accentCoral
                      : textPrimary,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
