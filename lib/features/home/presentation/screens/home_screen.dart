// Home screen — Content Bible §4 / Runbook Override 4
// Layout (top → bottom):
//   • Time-based greeting
//   • Today card  (check-in state — from Task 12)
//   • SOS button  (prominent, always visible)
//   • 6 section cards in a 2-column grid:
//       Breathe · Ground · Journal · Learn · Visualize · Sleep
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_home.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/notification_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../../../activity_log/presentation/providers/activity_log_provider.dart';
import '../../../daily/presentation/providers/checkin_provider.dart';
import '../../../journal/presentation/providers/journal_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

// ─── Section card data ────────────────────────────────────────────────────────

class _Section {
  final String title;
  final String sub;
  final String route;
  final MascotEmotion emotion;
  final Color accent;

  const _Section({
    required this.title,
    required this.sub,
    required this.route,
    required this.emotion,
    required this.accent,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Six section cards — order and content from Content Bible §4
  static const List<_Section> _sections = [
    _Section(
      title: StringsHome.cardBreatheTitle,
      sub: StringsHome.cardBreatheSub,
      route: AppRoutes.breathingPicker,
      emotion: MascotEmotion.breathing,
      accent: AppColors.accentCoral,
    ),
    _Section(
      title: StringsHome.cardGroundTitle,
      sub: StringsHome.cardGroundSub,
      route: AppRoutes.groundingPicker,
      emotion: MascotEmotion.grounded,
      accent: AppColors.accentTeal,
    ),
    _Section(
      title: StringsHome.cardJournalTitle,
      sub: StringsHome.cardJournalSub,
      route: AppRoutes.journalHome,
      emotion: MascotEmotion.holdingPen,
      accent: AppColors.accentGold,
    ),
    _Section(
      title: StringsHome.cardLearnTitle,
      sub: StringsHome.cardLearnSub,
      route: AppRoutes.learnHome,
      emotion: MascotEmotion.readingBook,
      accent: AppColors.accentTeal,
    ),
    _Section(
      title: StringsHome.cardVisualizeTitle,
      sub: StringsHome.cardVisualizeSub,
      route: AppRoutes.visualizeHome,
      emotion: MascotEmotion.eyesClosed,
      accent: AppColors.accentCoral,
    ),
    _Section(
      title: StringsHome.cardSleepTitle,
      sub: StringsHome.cardSleepSub,
      route: AppRoutes.sleepHome,
      emotion: MascotEmotion.sleeping,
      accent: AppColors.accentGold,
    ),
  ];

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
    // Background side-effects: sync + RC identity + notification setup
    ref.watch(activityLogSyncProvider);
    ref.watch(checkinSyncProvider);
    ref.watch(journalSyncProvider);
    ref.watch(rcIdentityProvider);
    ref.watch(notificationSetupProvider);

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

    // The SOS button must stay pinned above the NavigationBar regardless of
    // scroll position.  floatingActionButton can't be used for full-width card
    // widgets because Scaffold gives it unconstrained (0→∞) height — even
    // SizedBox(width) only bounds one axis and Material fills the other.
    // Using Stack + Positioned(left/right/bottom) inside the body constrains
    // ALL four edges so the card sizes itself by content height only.
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              // Bottom padding reserves room so the last card is never hidden
              // behind the pinned SOS button (button ≈ 72 px + 20 gap + 20 margin).
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Greeting ──────────────────────────────────────────
                  Text(
                    _greeting(),
                    style: AppTypography.headingLarge
                        .copyWith(color: textPrimary),
                  ),

                  const SizedBox(height: 20),

                  // ── Today card ────────────────────────────────────────
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

                  const SizedBox(height: 28),

                  // ── Section cards (2-column grid) ─────────────────────
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final s = _sections[index];
                      return _SectionCard(
                        section: s,
                        surface: surface,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        onTap: () => context.push(s.route),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── SOS button — pinned above NavigationBar ─────────────────────
          // Positioned(left, right, bottom) gives an explicit width
          // (screenWidth − 40) and anchors height to content only.
          // bottom: 20 sits inside the body which already ends at the top
          // of the NavigationBar, so the button floats 20 dp above it.
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _SosButton(onTap: () => context.push(AppRoutes.sos)),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SOS button
// ═════════════════════════════════════════════════════════════════════════════

class _SosButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SosButton({required this.onTap});

  // Fully-opaque backgrounds — no content bleeds through while scrolling.
  // Light: Material Red 700 — vivid, universally recognisable emergency red.
  // Dark:  Material Red 800 — slightly deeper so it doesn't wash out on dark bg.
  static const Color _redLight = Color(0xFFD32F2F); // Red 700
  static const Color _redDark  = Color(0xFFC62828); // Red 800

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? _redDark : _redLight;

    return Material(
      // Fully opaque: no transparency, so scrolling content never shows through.
      color: bg,
      borderRadius: BorderRadius.circular(16),
      elevation: 6,
      shadowColor: bg.withValues(alpha: 0.45),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.white.withValues(alpha: 0.18),
        highlightColor: Colors.white.withValues(alpha: 0.10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Left: crisis icon
              const Icon(
                Icons.crisis_alert_rounded,
                color: Colors.white,
                size: 30,
              ),

              const SizedBox(width: 14),

              // Centre: label + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringsHome.sosButtonLabel,
                      style: AppTypography.headingSmall.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      StringsHome.firstLaunchPrimary,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),

              // Right: forward arrow
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Section card
// ═════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final _Section section;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  const _SectionCard({
    required this.section,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mascot contextual variant
              SvgPicture.asset(
                section.emotion.assetPath,
                width: 72,
                height: 72,
              ),

              const Spacer(),

              // Title
              Text(
                section.title,
                style: AppTypography.headingSmall
                    .copyWith(color: textPrimary),
              ),

              const SizedBox(height: 3),

              // Sublabel
              Text(
                section.sub,
                style: AppTypography.caption
                    .copyWith(color: textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Today card  (unchanged from Task 12)
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
    // ── Loading skeleton ─────────────────────────────────────────────────
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

    // ── Not yet checked in ───────────────────────────────────────────────
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
                const Icon(
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

    // ── Checked in — contextual suggestion ──────────────────────────────
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
              // ✓ Checked-in pill
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

              Text(
                suggestion,
                style: AppTypography.bodyMedium
                    .copyWith(color: textSecondary),
              ),

              const SizedBox(height: 10),

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
