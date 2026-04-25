// Home screen — Content Bible §4 / Runbook Override 4
// Layout (top → bottom):
//   • Time-based greeting
//   • Today card  (check-in state — from Task 12)
//   • SOS button  (prominent, coral, pulsing, always visible)
//   • 6 section cards in a 2-column grid with illustrated scene backgrounds
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
  final MascotEmotion hero; // hero/scene SVG variant used as card background

  const _Section({
    required this.title,
    required this.sub,
    required this.route,
    required this.hero,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const List<_Section> _sections = [
    _Section(
      title: StringsHome.cardBreatheTitle,
      sub: StringsHome.cardBreatheSub,
      route: AppRoutes.breathingPicker,
      hero: MascotEmotion.breatheHero,
    ),
    _Section(
      title: StringsHome.cardGroundTitle,
      sub: StringsHome.cardGroundSub,
      route: AppRoutes.groundingPicker,
      hero: MascotEmotion.groundHero,
    ),
    _Section(
      title: StringsHome.cardJournalTitle,
      sub: StringsHome.cardJournalSub,
      route: AppRoutes.journalHome,
      hero: MascotEmotion.journalHero,
    ),
    _Section(
      title: StringsHome.cardLearnTitle,
      sub: StringsHome.cardLearnSub,
      route: AppRoutes.learnHome,
      hero: MascotEmotion.learnHero,
    ),
    _Section(
      title: StringsHome.cardVisualizeTitle,
      sub: StringsHome.cardVisualizeSub,
      route: AppRoutes.visualizeHome,
      hero: MascotEmotion.visualizeHero,
    ),
    _Section(
      title: StringsHome.cardSleepTitle,
      sub: StringsHome.cardSleepSub,
      route: AppRoutes.sleepHome,
      hero: MascotEmotion.sleepHero,
    ),
  ];

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return StringsHome.greetingMorning;
    if (h < 17) return StringsHome.greetingAfternoon;
    if (h < 22) return StringsHome.greetingEvening;
    return StringsHome.greetingLateNight;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(activityLogSyncProvider);
    ref.watch(checkinSyncProvider);
    ref.watch(journalSyncProvider);
    ref.watch(rcIdentityProvider);
    ref.watch(notificationSetupProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final checkinAsync = ref.watch(todayCheckinProvider);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // ── Scrollable content ─────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Greeting ──────────────────────────────────────────
                  Text(
                    _greeting(),
                    style: AppTypography.headingLarge.copyWith(
                      color: textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
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
                    loading: () => _TodayCardSkeleton(
                      isDark: isDark,
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
                      mainAxisExtent: 178,
                    ),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final s = _sections[index];
                      return _SectionCard(
                        section: s,
                        onTap: () => context.push(s.route),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── SOS button — pinned above NavigationBar ─────────────────────
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
// SOS button — coral, pulsing
// ═════════════════════════════════════════════════════════════════════════════

class _SosButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SosButton({required this.onTap});

  @override
  State<_SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<_SosButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.00, end: 1.025).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: Material(
        color: AppColors.accentCoral,
        borderRadius: BorderRadius.circular(16),
        elevation: 6,
        shadowColor: AppColors.accentCoral.withValues(alpha: 0.45),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.crisis_alert_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 14),
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
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Illustrated section card
// ═════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final _Section section;
  final VoidCallback onTap;

  const _SectionCard({required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: section.title,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.14),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Hero SVG — full scene background ─────────────────────
                SvgPicture.asset(
                  section.hero.assetPath,
                  fit: BoxFit.cover,
                  semanticsLabel: '',
                ),

                // ── Bottom gradient overlay for text readability ──────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.52),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.title,
                          style: AppTypography.headingSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          section.sub,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.80),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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

// ═════════════════════════════════════════════════════════════════════════════
// Today card
// ═════════════════════════════════════════════════════════════════════════════

class _TodayCardSkeleton extends StatefulWidget {
  final bool isDark;
  const _TodayCardSkeleton({required this.isDark});

  @override
  State<_TodayCardSkeleton> createState() => _TodayCardSkeletonState();
}

class _TodayCardSkeletonState extends State<_TodayCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final shimmer = widget.isDark
        ? AppColors.darkCardBorder
        : AppColors.lightCardBorder;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Container(
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _anim.value * 2, 0),
              end: Alignment(1.0 + _anim.value * 2, 0),
              colors: [base, shimmer, base],
            ),
          ),
        );
      },
    );
  }
}

class _TodayCard extends StatelessWidget {
  final DailyCheckinRow? checkin;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _TodayCard({
    required this.checkin,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
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
              border: Border(
                left: BorderSide(
                  color: AppColors.accentCoral.withValues(alpha: 0.60),
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                    style:
                        AppTypography.bodyLarge.copyWith(color: textPrimary),
                  ),
                ),
                // Small calm mascot
                SvgPicture.asset(
                  MascotEmotion.calm.assetPath,
                  width: 32,
                  height: 32,
                  semanticsLabel: 'Anshin mascot',
                ),
                const SizedBox(width: 8),
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
            border: Border(
              left: BorderSide(
                color: AppColors.accentTeal.withValues(alpha: 0.70),
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
              const SizedBox(width: 12),
              // Small calm mascot on right
              SvgPicture.asset(
                MascotEmotion.calm.assetPath,
                width: 32,
                height: 32,
                semanticsLabel: 'Anshin mascot',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
