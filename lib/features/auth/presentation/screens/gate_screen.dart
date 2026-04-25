// First-launch decision gate — Content Bible §2
// Two paths: "I need help right now" (→ SOS) or "I have a moment to set up" (→ onboarding).
// No back button — this is the entry point after anonymous sign-in.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_gate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/scene_painter.dart';
import '../../../../routing/app_routes.dart';

class GateScreen extends ConsumerWidget {
  const GateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 2),

                    // ── Mascot — welcoming calm pose ──────────────────────────
                    const Center(
                      child: MascotWidget(
                        emotion: MascotEmotion.calm,
                        size: 96,
                        breathe: true,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Heading ───────────────────────────────────────────────
                    Text(
                      StringsGate.heading,
                      style: AppTypography.headingLarge
                          .copyWith(color: textPrimary, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      StringsGate.sub,
                      style: AppTypography.bodyMedium
                          .copyWith(color: textSecondary),
                      textAlign: TextAlign.center,
                    ),

                    const Spacer(flex: 3),

                    // ── "I need help right now" — pulsing coral border ────────
                    _PulsingGateCard(
                      title: StringsGate.ctaNeedHelp,
                      subtitle: StringsGate.ctaNeedHelpSub,
                      icon: Icons.emergency_outlined,
                      accentColor: AppColors.accentCoral,
                      surface: surface,
                      onTap: () => context.go(AppRoutes.sos),
                      pulse: true,
                    ),

                    const SizedBox(height: 16),

                    // ── "I have a moment to set up" ───────────────────────────
                    _PulsingGateCard(
                      title: StringsGate.ctaSetup,
                      subtitle: StringsGate.ctaSetupSub,
                      icon: Icons.tune_outlined,
                      accentColor: AppColors.accentTeal,
                      surface: surface,
                      onTap: () => context.go(AppRoutes.onboardingA),
                      pulse: false,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // ── Forest floor footer strip ─────────────────────────────────────
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: morningForestGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const CustomPaint(painter: ForestFloorPainter()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gate option card — with optional slow pulsing border
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingGateCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color surface;
  final VoidCallback onTap;
  final bool pulse;

  const _PulsingGateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.surface,
    required this.onTap,
    required this.pulse,
  });

  @override
  State<_PulsingGateCard> createState() => _PulsingGateCardState();
}

class _PulsingGateCardState extends State<_PulsingGateCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _ctrl;
  Animation<double>? _anim;

  @override
  void initState() {
    super.initState();
    if (widget.pulse) {
      _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000),
      )..repeat(reverse: true);
      _anim = Tween<double>(begin: 0.35, end: 0.80)
          .animate(CurvedAnimation(parent: _ctrl!, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _ctrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget card(double alpha) {
      return Material(
        color: widget.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: widget.accentColor.withValues(alpha: alpha),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.accentColor.withValues(alpha: 0.10),
                  ),
                  child: Icon(widget.icon, color: widget.accentColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.bodyLarge.copyWith(
                          color: widget.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: AppTypography.caption.copyWith(
                          color: widget.accentColor.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: widget.accentColor.withValues(alpha: 0.50),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_anim == null) return card(0.40);

    return AnimatedBuilder(
      animation: _anim!,
      builder: (context, _) => card(_anim!.value),
    );
  }
}
