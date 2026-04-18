// PRD §3.1 + Content Bible §5 — SOS active screen
// Override 2: always dark regardless of user theme
// Box breathing 4-4-4-4  |  60-sec grounding prompt  |  90-sec feelings check
import 'dart:async';

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

// ── Prompt state machine ──────────────────────────────────────────────────────

enum _SosPhase {
  breathing,   // default — circle animating, no overlay
  prompt60s,   // "Want to try a grounding exercise?"
  prompt90s,   // "How are you feeling?"
  transition,  // "Let's try something different." (1.5 s before routing)
}

// ── Screen ────────────────────────────────────────────────────────────────────

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen>
    with SingleTickerProviderStateMixin {
  // ── Animation constants ──────────────────────────────────────────────────

  static const Duration _cycleDuration = Duration(seconds: 16);
  static const double _minR = 85;
  static const double _maxR = 145;

  static const List<String> _phaseLabels = [
    StringsSos.phaseInhale,
    StringsSos.phaseHoldAfterInhale,
    StringsSos.phaseExhale,
    StringsSos.phaseHoldAfterExhale,
  ];

  // ── State ────────────────────────────────────────────────────────────────

  late final AnimationController _controller;
  late final Animation<double> _radiusAnim;
  int _lastPhaseIndex = -1;

  _SosPhase _sosPhase = _SosPhase.breathing;
  Timer? _timer60s;
  Timer? _timer90s;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _cycleDuration)
      ..repeat();

    _radiusAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: _minR, end: _maxR)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(tween: ConstantTween(_maxR), weight: 1),
      TweenSequenceItem(
        tween: Tween(begin: _maxR, end: _minR)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(tween: ConstantTween(_minR), weight: 1),
    ]).animate(_controller);

    _controller.addListener(_onTick);

    // 60-sec: offer grounding
    _timer60s = Timer(
      const Duration(seconds: 60),
      () { if (mounted) setState(() => _sosPhase = _SosPhase.prompt60s); },
    );

    // 90-sec: feelings check (fires regardless of 60s outcome unless navigated away)
    _timer90s = Timer(
      const Duration(seconds: 90),
      () { if (mounted) setState(() => _sosPhase = _SosPhase.prompt90s); },
    );

    // Init TTS; speak first instruction once ready
    ref.read(voiceServiceProvider).init().then((_) {
      if (!mounted) return;
      _firePhaseAV(0);
    });
  }

  @override
  void dispose() {
    _timer60s?.cancel();
    _timer90s?.cancel();
    _controller.removeListener(_onTick);
    _controller.dispose();
    ref.read(voiceServiceProvider).stop();
    super.dispose();
  }

  // ── Phase-change detection ───────────────────────────────────────────────

  int _currentPhaseIndex() {
    final v = _controller.value;
    if (v < 0.25) return 0;
    if (v < 0.50) return 1;
    if (v < 0.75) return 2;
    return 3;
  }

  void _onTick() {
    final idx = _currentPhaseIndex();
    if (idx == _lastPhaseIndex) return;
    _lastPhaseIndex = idx;
    // Pause A/V cues while the user is reading a prompt
    if (_sosPhase == _SosPhase.breathing) _firePhaseAV(idx);
  }

  void _firePhaseAV(int idx) {
    final auth = ref.read(authProvider).valueOrNull;
    final voiceCues =
        auth is AuthAuthenticated ? auth.user.settings.voiceCues : true;
    final hapticOn =
        auth is AuthAuthenticated ? auth.user.settings.hapticOn : true;

    if (hapticOn) HapticFeedback.mediumImpact();
    if (voiceCues) ref.read(voiceServiceProvider).speak(_phaseLabels[idx]);
  }

  // ── Navigation helper ────────────────────────────────────────────────────

  /// Cancel pending timers, stop audio, then navigate.
  void _navigateAway(String route) {
    _timer60s?.cancel();
    _timer90s?.cancel();
    ref.read(voiceServiceProvider).stop();
    context.go(route);
  }

  // ── Close ────────────────────────────────────────────────────────────────

  /// X button always goes to post-session — not directly to home.
  void _close() => _navigateAway(AppRoutes.postSession);

  // ── 60-sec prompt handlers ───────────────────────────────────────────────

  void _on60sYes() {
    _timer90s?.cancel();
    _navigateAway(AppRoutes.groundingPicker);
  }

  void _on60sKeepBreathing() =>
      setState(() => _sosPhase = _SosPhase.breathing);

  // ── 90-sec prompt handlers ───────────────────────────────────────────────

  void _on90sBetter() => _navigateAway(AppRoutes.postSession);

  void _on90sSame() => _navigateAway(AppRoutes.postSession);

  void _on90sWorse() {
    // Show transition message for 1.5 s, then route to grounding
    setState(() => _sosPhase = _SosPhase.transition);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _navigateAway(AppRoutes.groundingPicker);
    });
  }

  // ── Overlay switching ────────────────────────────────────────────────────

  Widget _overlayContent() => switch (_sosPhase) {
        _SosPhase.breathing => const SizedBox.shrink(key: ValueKey('none')),
        _SosPhase.prompt60s => _Prompt60s(
            key: const ValueKey('60s'),
            onYes: _on60sYes,
            onKeepBreathing: _on60sKeepBreathing,
          ),
        _SosPhase.prompt90s => _Prompt90s(
            key: const ValueKey('90s'),
            onBetter: _on90sBetter,
            onSame: _on90sSame,
            onWorse: _on90sWorse,
          ),
        _SosPhase.transition =>
          const _TransitionOverlay(key: ValueKey('trans')),
      };

  // ── UI helper ────────────────────────────────────────────────────────────

  String get _phaseLabel => _phaseLabels[_currentPhaseIndex()];

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.sosBackground,
          body: Stack(
            children: [
              // ── Breathing circle + phase text ──────────────────────────
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final r = _radiusAnim.value;
                    final gf = (r - _minR) / (_maxR - _minR);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

              // ── Prompt overlay — cross-fades between phases ────────────
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: _overlayContent(),
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
// Overlay widgets
// ═════════════════════════════════════════════════════════════════════════════

// Shared gradient decoration — transparent at top, solid at bottom so the
// breathing circle is still faintly visible behind the prompt.
BoxDecoration _promptDecoration() => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x001A1F2E), AppColors.sosBackground],
        stops: [0.0, 0.38],
      ),
    );

// ─── 60-second prompt ────────────────────────────────────────────────────────

class _Prompt60s extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onKeepBreathing;

  const _Prompt60s({
    super.key,
    required this.onYes,
    required this.onKeepBreathing,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: _promptDecoration(),
        padding: const EdgeInsets.fromLTRB(28, 56, 28, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringsSos.prompt60s,
              style: AppTypography.headingMedium
                  .copyWith(color: AppColors.sosTextPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _SosButton(
                    label: StringsSos.prompt60sKeepBreathing,
                    color: AppColors.sosTextSecondary,
                    outlined: false,
                    onPressed: onKeepBreathing,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SosButton(
                    label: StringsSos.prompt60sYes,
                    color: AppColors.accentCoral,
                    outlined: true,
                    onPressed: onYes,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 90-second feelings check ────────────────────────────────────────────────

class _Prompt90s extends StatelessWidget {
  final VoidCallback onBetter;
  final VoidCallback onSame;
  final VoidCallback onWorse;

  const _Prompt90s({
    super.key,
    required this.onBetter,
    required this.onSame,
    required this.onWorse,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: _promptDecoration(),
        padding: const EdgeInsets.fromLTRB(28, 56, 28, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              StringsSos.prompt90s,
              style: AppTypography.headingMedium
                  .copyWith(color: AppColors.sosTextPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _SosButton(
              label: StringsSos.prompt90sBetter,
              color: AppColors.accentTeal,
              outlined: true,
              onPressed: onBetter,
            ),
            const SizedBox(height: 10),
            _SosButton(
              label: StringsSos.prompt90sSame,
              color: AppColors.sosTextSecondary,
              outlined: false,
              onPressed: onSame,
            ),
            const SizedBox(height: 10),
            _SosButton(
              label: StringsSos.prompt90sWorse,
              color: AppColors.sosTextSecondary,
              outlined: false,
              onPressed: onWorse,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Transition overlay ("Let's try something different.") ───────────────────

class _TransitionOverlay extends StatelessWidget {
  const _TransitionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sosBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            StringsSos.transitionToGrounding,
            style: AppTypography.sosInstruction
                .copyWith(color: AppColors.sosTextPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ─── Shared button style for overlays ────────────────────────────────────────

class _SosButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback onPressed;

  const _SosButton({
    required this.label,
    required this.color,
    required this.outlined,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          textStyle: AppTypography.button,
        ),
        child: Text(label),
      );
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(double.infinity, 52),
        textStyle: AppTypography.button,
      ),
      child: Text(label),
    );
  }
}
