// Breathing session screen — Content Bible §6
//
// Full-screen animated session. Dark mode forced (Override 2).
// Default duration: 5 minutes.  Phases cycle continuously.
// Each phase drives an AnimatedContainer (expand = inhale/holdIn,
// contract = exhale/holdOut) with a duration equal to that phase.
// Completion: "Nice work." + one-word feeling prompt.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_breathing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../domain/breathing_pattern.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class BreathingSessionScreen extends ConsumerStatefulWidget {
  final String patternId;

  const BreathingSessionScreen({super.key, required this.patternId});

  @override
  ConsumerState<BreathingSessionScreen> createState() =>
      _BreathingSessionScreenState();
}

class _BreathingSessionScreenState
    extends ConsumerState<BreathingSessionScreen> {
  static const int _sessionMinutes = 5;
  static const int _totalSeconds = _sessionMinutes * 60;

  late final BreathingPattern _pattern;

  int _phaseIndex = 0;
  int _phaseRemaining = 0; // seconds remaining in current phase
  int _elapsed = 0;        // total seconds elapsed
  bool _done = false;

  // AnimatedContainer controls
  bool _expanded = true;
  Duration _phaseDuration = const Duration(seconds: 4);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pattern = BreathingPattern.byId(widget.patternId);
    _startPhase(0);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Phase management ──────────────────────────────────────────────────────

  void _startPhase(int index) {
    _phaseIndex = index;
    final phase = _pattern.phases[index];
    _phaseRemaining = phase.durationSeconds;
    _phaseDuration = Duration(seconds: phase.durationSeconds);
    _expanded = phase.type == BreathingPhaseType.inhale ||
        phase.type == BreathingPhaseType.holdIn;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsed++;
        _phaseRemaining--;

        if (_elapsed >= _totalSeconds) {
          _timer?.cancel();
          _done = true;
          return;
        }

        if (_phaseRemaining <= 0) {
          final next = (_phaseIndex + 1) % _pattern.phases.length;
          _startPhase(next);
        }
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.sosBackground,
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: _done
                  ? _CompletionView(
                      key: const ValueKey('done'),
                      patternName: _pattern.name,
                      onDone: () => context.go(AppRoutes.home),
                    )
                  : _SessionView(
                      key: const ValueKey('session'),
                      pattern: _pattern,
                      phaseIndex: _phaseIndex,
                      phaseRemaining: _phaseRemaining,
                      elapsed: _elapsed,
                      totalSeconds: _totalSeconds,
                      expanded: _expanded,
                      phaseDuration: _phaseDuration,
                      onStop: _stop,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Session view
// ═════════════════════════════════════════════════════════════════════════════

class _SessionView extends StatelessWidget {
  final BreathingPattern pattern;
  final int phaseIndex;
  final int phaseRemaining;
  final int elapsed;
  final int totalSeconds;
  final bool expanded;
  final Duration phaseDuration;
  final VoidCallback onStop;

  const _SessionView({
    super.key,
    required this.pattern,
    required this.phaseIndex,
    required this.phaseRemaining,
    required this.elapsed,
    required this.totalSeconds,
    required this.expanded,
    required this.phaseDuration,
    required this.onStop,
  });

  static const double _minCircle = 120.0;
  static const double _maxCircle = 240.0;

  String get _phaseLabel => switch (pattern.phases[phaseIndex].type) {
        BreathingPhaseType.inhale => 'Inhale',
        BreathingPhaseType.holdIn => 'Hold',
        BreathingPhaseType.exhale => 'Exhale',
        BreathingPhaseType.holdOut => 'Hold',
      };

  @override
  Widget build(BuildContext context) {
    final progress = elapsed / totalSeconds;
    final remaining = totalSeconds - elapsed;
    final mm = (remaining ~/ 60).toString().padLeft(2, '0');
    final ss = (remaining % 60).toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.sosTextSecondary,
                  size: 22,
                ),
                tooltip: 'Stop session',
                onPressed: onStop,
              ),
              Expanded(
                child: Text(
                  pattern.name,
                  style: AppTypography.headingSmall
                      .copyWith(color: AppColors.sosTextPrimary),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  '$mm:$ss',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.sosTextSecondary),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        // ── Progress bar ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  AppColors.sosTextSecondary.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentTeal,
              ),
              minHeight: 3,
            ),
          ),
        ),

        const Spacer(flex: 2),

        // ── Breathing circle ─────────────────────────────────────────────────
        Center(
          child: AnimatedContainer(
            duration: phaseDuration,
            curve: Curves.easeInOut,
            width: expanded ? _maxCircle : _minCircle,
            height: expanded ? _maxCircle : _minCircle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentTeal.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.accentTeal.withValues(alpha: 0.55),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentTeal
                      .withValues(alpha: expanded ? 0.18 : 0.06),
                  blurRadius: expanded ? 40 : 12,
                  spreadRadius: expanded ? 8 : 2,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 36),

        // ── Phase label ──────────────────────────────────────────────────────
        Text(
          _phaseLabel,
          style: AppTypography.headingLarge
              .copyWith(color: AppColors.sosTextPrimary),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 6),

        // ── Phase countdown ──────────────────────────────────────────────────
        Text(
          '$phaseRemaining',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.sosTextSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),

        const Spacer(flex: 3),

        // ── Phase summary ─────────────────────────────────────────────────────
        Text(
          pattern.phaseSummary,
          style: AppTypography.caption.copyWith(
            color: AppColors.sosTextSecondary.withValues(alpha: 0.45),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Completion view
// ═════════════════════════════════════════════════════════════════════════════

class _CompletionView extends StatefulWidget {
  final String patternName;
  final VoidCallback onDone;

  const _CompletionView({
    super.key,
    required this.patternName,
    required this.onDone,
  });

  @override
  State<_CompletionView> createState() => _CompletionViewState();
}

class _CompletionViewState extends State<_CompletionView> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),

          // ── "Nice work." ───────────────────────────────────────────────────
          Text(
            StringsBreathing.sessionComplete,
            style: AppTypography.headingLarge.copyWith(
              color: AppColors.sosTextPrimary,
              fontSize: 32,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 1),

          // ── Micro-prompt ──────────────────────────────────────────────────
          Text(
            StringsBreathing.sessionMicroPrompt,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.sosTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // ── One-word input ─────────────────────────────────────────────────
          TextField(
            controller: _ctrl,
            maxLength: 30,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.none,
            style: AppTypography.headingMedium.copyWith(
              color: AppColors.sosTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'calm',
              hintStyle: AppTypography.headingMedium.copyWith(
                color: AppColors.sosTextSecondary.withValues(alpha: 0.35),
              ),
              counterText: '',
              filled: true,
              fillColor:
                  AppColors.sosTextSecondary.withValues(alpha: 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.sosTextSecondary.withValues(alpha: 0.20),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.sosTextSecondary.withValues(alpha: 0.20),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.accentTeal,
                  width: 1.5,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),

          const Spacer(flex: 2),

          // ── Done button ───────────────────────────────────────────────────
          ElevatedButton(
            onPressed: widget.onDone,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentTeal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              textStyle: AppTypography.button,
            ),
            child: const Text('Done'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
