// Home screen — Task 12 adds greeting + today card (check-in state).
// Full home layout (SOS button, tool cards, etc.) is built in later tasks.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_home.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../activity_log/presentation/providers/activity_log_provider.dart';
import '../../../daily/presentation/providers/checkin_provider.dart';
import '../../../journal/presentation/providers/journal_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // ── Time-based greeting ───────────────────────────────────────────────────

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return StringsHome.greetingMorning;
    if (h < 17) return StringsHome.greetingAfternoon;
    if (h < 22) return StringsHome.greetingEvening;
    return StringsHome.greetingLateNight;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger background sync for any unsynced local rows
    ref.watch(activityLogSyncProvider);
    ref.watch(checkinSyncProvider);
    ref.watch(journalSyncProvider);
    // Associate Firebase userId with RevenueCat customer record
    ref.watch(rcIdentityProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final checkinAsync = ref.watch(todayCheckinProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Greeting ──────────────────────────────────────────────────
              Text(
                _greeting(),
                style: AppTypography.headingLarge
                    .copyWith(color: textPrimary),
              ),

              const SizedBox(height: 20),

              // ── Today card (check-in state) ───────────────────────────────
              checkinAsync.when(
                data: (checkin) => _TodayCard(
                  checkin: checkin,
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                loading: () => _TodayCard(
                  checkin: null,
                  surface: surface,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  isLoading: true,
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 32),

              // ── Remaining home content (added in later tasks) ─────────────
              Center(
                child: Text(
                  'Home',
                  style: AppTypography.bodyMedium
                      .copyWith(color: textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Today card
// ═════════════════════════════════════════════════════════════════════════════

class _TodayCard extends StatelessWidget {
  final DailyCheckinRow? checkin;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final bool isLoading;

  const _TodayCard({
    required this.checkin,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // ── Loading skeleton ───────────────────────────────────────────────────
    if (isLoading) {
      return Container(
        height: 64,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
      );
    }

    // ── Not yet checked in ─────────────────────────────────────────────────
    if (checkin == null) {
      return Material(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push(AppRoutes.checkin),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.accentCoral,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    StringsHome.todayNoCheckin,
                    style: AppTypography.bodyLarge
                        .copyWith(color: textPrimary),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: textSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Checked in — show pill + contextual suggestion ─────────────────────
    final String suggestion;
    final String actionRoute;
    final IconData actionIcon;
    final anxiety = checkin!.anxiety;

    if (anxiety >= 7) {
      suggestion = StringsHome.todayHighAnxiety;
      actionRoute = AppRoutes.breathingPicker;
      actionIcon = Icons.air_outlined;
    } else if (anxiety >= 4) {
      suggestion = StringsHome.todayModerateAnxiety;
      actionRoute = AppRoutes.groundingPicker;
      actionIcon = Icons.self_improvement_outlined;
    } else {
      suggestion = StringsHome.todayLowAnxiety;
      actionRoute = AppRoutes.journalEntry;
      actionIcon = Icons.edit_outlined;
    }

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(actionRoute),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentTeal.withValues(alpha: 0.45),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✓ Checked in pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentTeal.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  StringsHome.checkedInPill,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.accentTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Contextual suggestion text
              Text(
                suggestion,
                style: AppTypography.bodyMedium
                    .copyWith(color: textSecondary),
              ),

              const SizedBox(height: 10),

              // Subtle action indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(actionIcon,
                      color: AppColors.accentCoral, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    "Let's try it",
                    style: AppTypography.caption.copyWith(
                      color: AppColors.accentCoral,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
