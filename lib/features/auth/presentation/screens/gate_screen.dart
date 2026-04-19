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
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // ── Mascot — welcoming calm pose ────────────────────────────────
              const Center(
                child: MascotWidget(
                  emotion: MascotEmotion.calm,
                  size: 96,
                  breathe: true,
                ),
              ),

              const SizedBox(height: 28),

              // ── Heading ─────────────────────────────────────────────────────
              Text(
                StringsGate.heading,
                style: AppTypography.headingLarge
                    .copyWith(color: textPrimary),
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

              // ── "I need help right now" ─────────────────────────────────────
              _GateCard(
                title: StringsGate.ctaNeedHelp,
                subtitle: StringsGate.ctaNeedHelpSub,
                icon: Icons.emergency_outlined,
                accentColor: AppColors.accentCoral,
                surface: surface,
                borderColor: borderColor,
                onTap: () => context.go(AppRoutes.sos),
              ),

              const SizedBox(height: 16),

              // ── "I have a moment to set up" ─────────────────────────────────
              _GateCard(
                title: StringsGate.ctaSetup,
                subtitle: StringsGate.ctaSetupSub,
                icon: Icons.tune_outlined,
                accentColor: AppColors.accentTeal,
                surface: surface,
                borderColor: borderColor,
                onTap: () => context.go(AppRoutes.onboardingA),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gate option card
// ─────────────────────────────────────────────────────────────────────────────

class _GateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color surface;
  final Color borderColor;
  final VoidCallback onTap;

  const _GateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.surface,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.40),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.10),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: accentColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: accentColor.withValues(alpha: 0.50),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
