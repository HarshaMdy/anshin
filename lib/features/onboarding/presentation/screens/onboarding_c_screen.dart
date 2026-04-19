// Onboarding screen C — Daily check-in reminder — Content Bible §3c
// User can set a time (showTimePicker) or skip.
// Tapping "Set reminder" or "Not right now" calls notifier.complete() which:
//   1. Writes answers + reminder pref to Firestore
//   2. Sets SharedPreferences 'anshin_onboarding_complete' = true
//   3. Calls auth.refresh() — router redirect fires → /home
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_onboarding.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingCScreen extends ConsumerStatefulWidget {
  const OnboardingCScreen({super.key});

  @override
  ConsumerState<OnboardingCScreen> createState() => _OnboardingCScreenState();
}

class _OnboardingCScreenState extends ConsumerState<OnboardingCScreen> {
  TimeOfDay? _reminderTime;
  bool _saving = false;

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 20, minute: 0),
      helpText: 'Choose your reminder time',
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _reminderTime = picked);
    }
  }

  Future<void> _complete({required bool withReminder}) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth is! AuthAuthenticated) return;

    setState(() => _saving = true);
    try {
      final timeStr = withReminder && _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:'
            '${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : '20:00';

      await ref.read(onboardingNotifierProvider.notifier).complete(
            userId: auth.user.userId,
            reminderEnabled: withReminder && _reminderTime != null,
            reminderTime: timeStr,
          );

      // Router redirect fires automatically after auth.refresh() inside complete().
      // If somehow still mounted and not redirected, nudge to home.
      if (mounted) context.go(AppRoutes.home);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _saving
              ? null
              : () => context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.onboardingB),
        ),
        title: _StepIndicator(textSecondary: textSecondary),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Heading ────────────────────────────────────────────────────
              Text(
                StringsOnboarding.screen3Heading,
                style: AppTypography.headingLarge
                    .copyWith(color: textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                StringsOnboarding.screen3Sub,
                style: AppTypography.bodyMedium
                    .copyWith(color: textSecondary),
              ),

              const SizedBox(height: 40),

              // ── Mascot — hopeful when time set, calm otherwise ──────────────
              Center(
                child: MascotWidget(
                  emotion: _reminderTime != null
                      ? MascotEmotion.hopeful
                      : MascotEmotion.calm,
                  size: 90,
                  breathe: true,
                ),
              ),

              const SizedBox(height: 28),

              // ── Time display (after picking) ──────────────────────────────
              if (_reminderTime != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.accentTeal.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time_outlined,
                          color: AppColors.accentTeal, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_reminderTime!),
                        style: AppTypography.headingSmall.copyWith(
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // ── Set / change reminder button ───────────────────────────────
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickTime,
                icon: const Icon(Icons.access_time_outlined, size: 18),
                label: Text(
                  _reminderTime == null
                      ? StringsOnboarding.screen3SetButton
                      : 'Change time',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentTeal,
                  side: BorderSide(
                    color: AppColors.accentTeal.withValues(alpha: 0.5),
                  ),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: AppTypography.button,
                ),
              ),

              const Spacer(),

              // ── Confirm with reminder ─────────────────────────────────────
              if (_reminderTime != null)
                ElevatedButton(
                  onPressed:
                      _saving ? null : () => _complete(withReminder: true),
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
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("I'm all set"),
                ),

              if (_reminderTime != null) const SizedBox(height: 12),

              // ── Skip / not right now ──────────────────────────────────────
              TextButton(
                onPressed:
                    _saving ? null : () => _complete(withReminder: false),
                style: TextButton.styleFrom(
                  foregroundColor: textSecondary,
                  minimumSize: const Size(double.infinity, 48),
                  textStyle: AppTypography.bodyMedium,
                ),
                child: _saving && _reminderTime == null
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(StringsOnboarding.screen3SkipButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Step indicator — step 3 of 3
// ─────────────────────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final Color textSecondary;
  const _StepIndicator({required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 5 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == 2 ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.accentCoral,
            ),
          ),
        );
      }),
    );
  }
}
