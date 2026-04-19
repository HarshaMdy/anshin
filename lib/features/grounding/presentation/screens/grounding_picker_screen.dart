// Grounding technique picker — Content Bible §7
// Four techniques as cards; Five Senses is free, others require hasPremiumAccess.
// Tapping an accessible card navigates to GroundingSessionScreen.
// Tapping a locked card pushes the paywall.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../domain/grounding_technique.dart';

class GroundingPickerScreen extends ConsumerWidget {
  const GroundingPickerScreen({super.key});

  void _onTap(
    BuildContext context,
    GroundingTechnique technique,
    bool isAccessible,
  ) {
    if (!isAccessible) {
      context.push(AppRoutes.paywall);
      return;
    }
    context.push(AppRoutes.groundingSessionPath(technique.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // isPremiumProvider combines RC entitlements + Firestore subscriptionStatus
    final hasPremium = ref.watch(isPremiumProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: GroundingTechnique.all.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final technique = GroundingTechnique.all[index];
          final isAccessible = technique.isFree || hasPremium;

          return _TechniqueCard(
            technique: technique,
            isAccessible: isAccessible,
            onTap: () => _onTap(context, technique, isAccessible),
          );
        },
      ),
    );
  }
}

// ─── Technique card ───────────────────────────────────────────────────────────

class _TechniqueCard extends StatelessWidget {
  final GroundingTechnique technique;
  final bool isAccessible;
  final VoidCallback onTap;

  const _TechniqueCard({
    required this.technique,
    required this.isAccessible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    // steps[0] is intro; the numbered prompts are steps[1..N]
    final promptCount = technique.steps.length - 1;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Text block ─────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + badge row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            technique.title,
                            style: AppTypography.headingSmall
                                .copyWith(color: textPrimary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Badge(
                            isFree: technique.isFree,
                            isAccessible: isAccessible),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Intro text — short description
                    Text(
                      technique.steps[0],
                      style: AppTypography.bodyMedium
                          .copyWith(color: textSecondary),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Step count pill
                    _StepCountPill(
                      count: promptCount,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),

              // ── Right icon: lock if inaccessible ──────────────────────────
              if (!isAccessible) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.lock_outline,
                    color: textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FREE / Premium badge ─────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final bool isFree;
  final bool isAccessible;

  const _Badge({required this.isFree, required this.isAccessible});

  @override
  Widget build(BuildContext context) {
    if (isFree) {
      return _Chip(label: 'Free', color: AppColors.accentTeal);
    }
    if (isAccessible) {
      return const SizedBox.shrink(); // Premium user — already unlocked
    }
    return _Chip(label: 'Premium', color: AppColors.accentCoral);
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Step count pill ──────────────────────────────────────────────────────────

class _StepCountPill extends StatelessWidget {
  final int count;
  final Color textSecondary;

  const _StepCountPill({required this.count, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.list_outlined, size: 14, color: textSecondary),
        const SizedBox(width: 4),
        Text(
          '$count steps',
          style: AppTypography.caption.copyWith(color: textSecondary),
        ),
      ],
    );
  }
}
