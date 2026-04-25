// Breathing pattern picker — PRD §3.x / Content Bible §6
// Box is free; 4-7-8, Physiological sigh, Coherent require hasPremiumAccess.
// Selecting an accessible pattern saves preference to Firestore and pops.
// Selecting a locked pattern routes to the paywall.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/scene_painter.dart';
import '../../../../routing/app_routes.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../../domain/breathing_pattern.dart';
import '../providers/breathing_provider.dart';

class BreathingPickerScreen extends ConsumerWidget {
  const BreathingPickerScreen({super.key});

  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    BreathingPattern pattern,
    bool isAccessible,
  ) async {
    if (!isAccessible) {
      context.push(AppRoutes.paywall);
      return;
    }

    await ref
        .read(breathingPreferenceNotifierProvider.notifier)
        .save(pattern.id);

    if (context.mounted) {
      context.push(AppRoutes.breathingSessionPath(pattern.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patterns = ref.watch(breathingPatternsProvider);
    final selectedId = ref.watch(selectedPatternIdProvider);

    // isPremiumProvider combines RC entitlements + Firestore subscriptionStatus
    final hasPremium = ref.watch(isPremiumProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRoutes.home),
        ),
        title: null,
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: patterns.length + 1, // +1 for hero
        separatorBuilder: (_, i) => i == 0
            ? const SizedBox(height: 16)
            : const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _BreathingHero();
          }
          final pattern = patterns[index - 1];
          final isAccessible = pattern.isFree || hasPremium;
          final isSelected = pattern.id == selectedId;

          return _PatternCard(
            pattern: pattern,
            isAccessible: isAccessible,
            isSelected: isSelected,
            onTap: () => _onTap(context, ref, pattern, isAccessible),
          );
        },
      ),
    );
  }
}

// ─── Hero section ─────────────────────────────────────────────────────────────

class _BreathingHero extends StatelessWidget {
  const _BreathingHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: breatheGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Forest scene
            const CustomPaint(painter: ForestScenePainter()),
            // Mascot centered
            const Center(
              child: MascotWidget(
                emotion: MascotEmotion.breathing,
                size: 110,
                breathe: true,
              ),
            ),
            // Title overlay at bottom
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
                    colors: [Colors.transparent, Color(0xAA1A3D2A)],
                  ),
                ),
                child: const Text(
                  'Choose a breathing pattern',
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

// ─── Pattern card ─────────────────────────────────────────────────────────────

// Maps pattern id to a left accent colour
Color _patternAccent(String id) => switch (id) {
      'box'      => AppColors.accentTeal,
      '478'      => const Color(0xFF7090C0), // calm blue
      'sigh'     => AppColors.accentCoral,
      'coherent' => AppColors.accentGold,
      _          => AppColors.accentTeal,
    };

// Maps pattern id to a representative icon shown in the icon circle
IconData _patternIcon(String id) => switch (id) {
      'box'      => Icons.crop_square_rounded, // the "box" shape
      '478'      => Icons.bedtime_outlined,    // rest / sleep association
      'sigh'     => Icons.air,                 // airflow / breath
      'coherent' => Icons.favorite_border,     // heart-rate variability
      _          => Icons.air,
    };

class _PatternCard extends StatelessWidget {
  final BreathingPattern pattern;
  final bool isAccessible;
  final bool isSelected;
  final VoidCallback onTap;

  const _PatternCard({
    required this.pattern,
    required this.isAccessible,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isSelected
        ? AppColors.accentCoral
        : isDark
            ? AppColors.darkCardBorder
            : AppColors.lightCardBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = _patternAccent(pattern.id);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            // No borderRadius here — Material above already clips to rounded rect.
            // Non-uniform border widths (left=4, others=1) are only valid without
            // borderRadius; combining them throws in debug and aborts the paint pass.
            border: Border(
              left:   BorderSide(color: accent, width: 4),
              top:    BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
              right:  BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
              bottom: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
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
                  _patternIcon(pattern.id),
                  color: accent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              // ── Text block ───────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + badge row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pattern.name,
                            style: AppTypography.headingSmall
                                .copyWith(color: textPrimary),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Badge(isFree: pattern.isFree, isAccessible: isAccessible),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      pattern.description,
                      style: AppTypography.bodyMedium
                          .copyWith(color: textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Phase pills — e.g. [In 4s] [Hold 4s] [Out 4s] [Hold 4s]
                    _PhasePills(phases: pattern.phases),

                    const SizedBox(height: 8),

                    // ── Stats footer: cycle length + session length ──────────
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 12,
                          color: textSecondary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${pattern.cycleDuration}s cycle  ·  5 min session',
                          style: AppTypography.caption.copyWith(
                            color: textSecondary.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Right icon: checkmark (selected) or lock (inaccessible) ──
              if (isSelected || !isAccessible) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.accentCoral,
                          size: 24,
                        )
                      : Icon(
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
      return _Chip(
        label: 'Free',
        color: AppColors.accentTeal,
      );
    }
    if (isAccessible) {
      // Premium user — already unlocked, no badge needed
      return const SizedBox.shrink();
    }
    return _Chip(
      label: 'Premium',
      color: AppColors.accentCoral,
    );
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

// ─── Phase duration pills ─────────────────────────────────────────────────────

class _PhasePills extends StatelessWidget {
  final List<BreathingPhase> phases;

  const _PhasePills({required this.phases});

  static Color _phaseColor(BreathingPhaseType type) => switch (type) {
        BreathingPhaseType.inhale  => AppColors.accentCoral,
        BreathingPhaseType.holdIn  => AppColors.accentGold,
        BreathingPhaseType.exhale  => AppColors.accentTeal,
        BreathingPhaseType.holdOut => AppColors.accentGold,
      };

  static String _phaseLabel(BreathingPhaseType type, int index) =>
      switch (type) {
        BreathingPhaseType.inhale  => index == 0 ? 'In' : 'In+',
        BreathingPhaseType.holdIn  => 'Hold',
        BreathingPhaseType.exhale  => 'Out',
        BreathingPhaseType.holdOut => 'Hold',
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        for (var i = 0; i < phases.length; i++)
          _PhasePill(
            label: _phaseLabel(phases[i].type, i),
            duration: phases[i].durationSeconds,
            color: _phaseColor(phases[i].type),
          ),
      ],
    );
  }
}

class _PhasePill extends StatelessWidget {
  final String label;
  final int duration;
  final Color color;

  const _PhasePill({
    required this.label,
    required this.duration,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label ${duration}s',
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
