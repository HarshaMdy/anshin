// PRD §3.1 — SOS active screen
// Override 2: always dark regardless of user theme
// Box breathing 4-4-4-4 (inhale 4s → hold 4s → exhale 4s → hold 4s = 16s cycle)
// Task 8: TTS voice cues synced to phase changes + haptic feedback
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_sos.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen>
    with SingleTickerProviderStateMixin {
  // ── Animation constants ────────────────────────────────────────────────────

  // Each phase is 4 s; full box cycle = 16 s
  static const Duration _cycleDuration = Duration(seconds: 16);

  // Circle radius: grows from _minR to _maxR (diameter 170 → 290 dp)
  static const double _minR = 85;
  static const double _maxR = 145;

  // ── Phase table ───────────────────────────────────────────────────────────

  static const List<String> _phaseLabels = [
    StringsSos.phaseInhale,           // 0 – 25 %
    StringsSos.phaseHoldAfterInhale,  // 25 – 50 %
    StringsSos.phaseExhale,           // 50 – 75 %
    StringsSos.phaseHoldAfterExhale,  // 75 – 100 %
  ];

  // ── State ─────────────────────────────────────────────────────────────────

  late final AnimationController _controller;
  late final Animation<double> _radiusAnim;

  // Tracks the last-fired phase index so we fire exactly once per transition
  int _lastPhaseIndex = -1;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _cycleDuration)
      ..repeat();

    // TweenSequence: 4 equal weights → each phase occupies 25% of the 16 s cycle
    _radiusAnim = TweenSequence<double>([
      // Phase 0 — Inhale: circle expands
      TweenSequenceItem(
        tween: Tween(begin: _minR, end: _maxR)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      // Phase 1 — Hold (after inhale): circle stays large
      TweenSequenceItem(tween: ConstantTween(_maxR), weight: 1),
      // Phase 2 — Exhale: circle contracts
      TweenSequenceItem(
        tween: Tween(begin: _maxR, end: _minR)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      // Phase 3 — Hold (after exhale): circle stays small
      TweenSequenceItem(tween: ConstantTween(_minR), weight: 1),
    ]).animate(_controller);

    // Wire phase-change detector on every animation tick
    _controller.addListener(_onTick);

    // Init TTS; once ready, speak the opening instruction + fire haptic
    ref.read(voiceServiceProvider).init().then((_) {
      if (!mounted) return;
      _onPhaseChange(0); // "Breathe in"
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.dispose();
    // Stop any in-progress speech so audio doesn't leak after screen closes
    ref.read(voiceServiceProvider).stop();
    super.dispose();
  }

  // ── Phase-change detection ────────────────────────────────────────────────

  int _currentPhaseIndex() {
    final v = _controller.value;
    if (v < 0.25) return 0;
    if (v < 0.50) return 1;
    if (v < 0.75) return 2;
    return 3;
  }

  void _onTick() {
    final idx = _currentPhaseIndex();
    if (idx == _lastPhaseIndex) return; // same phase — nothing to do
    _lastPhaseIndex = idx;
    _onPhaseChange(idx);
  }

  void _onPhaseChange(int phaseIndex) {
    final auth = ref.read(authProvider).valueOrNull;

    // Default ON — voice guidance is critical in an SOS moment
    final voiceCues =
        auth is AuthAuthenticated ? auth.user.settings.voiceCues : true;
    final hapticOn =
        auth is AuthAuthenticated ? auth.user.settings.hapticOn : true;

    if (hapticOn) HapticFeedback.mediumImpact();
    if (voiceCues) {
      ref.read(voiceServiceProvider).speak(_phaseLabels[phaseIndex]);
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  // ── UI helpers ────────────────────────────────────────────────────────────

  /// Current phase label — derived directly from controller progress
  String get _phaseLabel => _phaseLabels[_currentPhaseIndex()];

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Override 2: force dark regardless of the user's chosen theme
      data: AppTheme.dark(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // white status-bar icons on dark bg
        child: Scaffold(
          backgroundColor: AppColors.sosBackground,
          body: Stack(
            children: [
              // ── Breathing circle + phase instruction ───────────────────
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final r = _radiusAnim.value;
                    // glowFactor: 0.0 at min radius → 1.0 at max radius
                    final gf = (r - _minR) / (_maxR - _minR);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Breathing circle ───────────────────────────
                        Container(
                          width: r * 2,
                          height: r * 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.accentCoral
                                .withValues(alpha: 0.08 + gf * 0.10),
                            border: Border.all(
                              color: AppColors.accentCoral
                                  .withValues(alpha: 0.45 + gf * 0.40),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCoral
                                    .withValues(alpha: 0.10 + gf * 0.22),
                                blurRadius: 24 + gf * 48,
                                spreadRadius: gf * 14,
                              ),
                              BoxShadow(
                                color: AppColors.accentCoral
                                    .withValues(alpha: 0.04 + gf * 0.06),
                                blurRadius: 60 + gf * 40,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 52),

                        // ── Phase text — cross-fades on each phase change
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, anim) =>
                              FadeTransition(opacity: anim, child: child),
                          child: Text(
                            _phaseLabel,
                            key: ValueKey(_phaseLabel),
                            style: AppTypography.sosInstruction
                                .copyWith(color: AppColors.sosTextPrimary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── Close button — tiny X top right ───────────────────────
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, right: 4),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                        color: AppColors.sosTextSecondary,
                      ),
                      tooltip: 'Close',
                      onPressed: _close,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
