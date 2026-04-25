// Grounding technique picker — Content Bible §7
// Four techniques as cards; Five Senses is free, others require hasPremiumAccess.
// Tapping an accessible card navigates to GroundingSessionScreen.
// Tapping a locked card pushes the paywall.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/scene_painter.dart';
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
          tooltip: 'Go back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: GroundingTechnique.all.length + 1, // +1 for hero
        separatorBuilder: (_, i) => i == 0
            ? const SizedBox(height: 16)
            : const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _GroundingHero();
          }
          final technique = GroundingTechnique.all[index - 1];
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

// ─── Hero section ─────────────────────────────────────────────────────────────

class _GroundingHero extends StatelessWidget {
  const _GroundingHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: groundGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const CustomPaint(painter: RiverScenePainter()),
            const Center(
              child: MascotWidget(
                emotion: MascotEmotion.grounded,
                size: 110,
                breathe: true,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xAA0E3040)],
                  ),
                ),
                child: const Text(
                  'Choose a grounding technique',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
          ],
        ),
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

  // Distinct accent colour per technique index
  static const List<Color> _accents = [
    AppColors.accentTeal,      // Five Senses (free)
    Color(0xFF7090C0),         // Body Scan — calm blue
    AppColors.accentCoral,     // Cold Water — coral
    AppColors.accentGold,      // Movement Reset — gold
  ];

  // Representative icon per technique ID
  static const Map<String, IconData> _icons = {
    'fiveSenses': Icons.visibility_outlined,       // eyes / seeing
    'bodyScan':   Icons.accessibility_new_outlined,// body figure
    'coldWater':  Icons.water_drop_outlined,       // water
    'movement':   Icons.directions_walk_outlined,  // walking
  };

  // Approximate session duration label per technique ID
  static const Map<String, String> _durations = {
    'fiveSenses': '~3 min',
    'bodyScan':   '~5 min',
    'coldWater':  '~2 min',
    'movement':   '~3 min',
  };

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
    final idx = GroundingTechnique.all.indexOf(technique);
    final accent = idx >= 0 && idx < _accents.length
        ? _accents[idx]
        : AppColors.accentTeal;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            // No borderRadius here — Material above already clips to rounded rect.
            // Non-uniform border widths (left=4, others=1) are only valid without
            // borderRadius; combining them throws in debug and aborts the paint pass.
            border: Border(
              left:   BorderSide(color: accent, width: 4),
              top:    BorderSide(color: borderColor, width: 1),
              right:  BorderSide(color: borderColor, width: 1),
              bottom: BorderSide(color: borderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Technique icon circle ─────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.12),
                ),
                child: Icon(
                  _icons[technique.id] ?? Icons.spa_outlined,
                  color: accent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

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
                          isAccessible: isAccessible,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Intro text — short description
                    Text(
                      technique.steps[0],
                      style: AppTypography.bodyMedium
                          .copyWith(color: textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // ── Stats footer: step count + duration ─────────────────
                    Row(
                      children: [
                        Icon(
                          Icons.format_list_numbered,
                          size: 12,
                          color: textSecondary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$promptCount steps',
                          style: AppTypography.caption.copyWith(
                            color: textSecondary.withValues(alpha: 0.65),
                          ),
                        ),
                        if (_durations.containsKey(technique.id)) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '·',
                              style: AppTypography.caption.copyWith(
                                color: textSecondary.withValues(alpha: 0.40),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.schedule_outlined,
                            size: 12,
                            color: textSecondary.withValues(alpha: 0.65),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _durations[technique.id]!,
                            style: AppTypography.caption.copyWith(
                              color: textSecondary.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ],
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

