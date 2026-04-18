// Grounding session — Content Bible §7
// Full-screen, one prompt at a time.
// All text from local constants — zero network calls.
// Forced dark (Override 2 — still in crisis/recovery mode).
// Ends with completion message + feeling check on one screen.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_grounding.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../domain/grounding_technique.dart';

class GroundingSessionScreen extends StatefulWidget {
  final String techniqueId;

  const GroundingSessionScreen({super.key, required this.techniqueId});

  @override
  State<GroundingSessionScreen> createState() => _GroundingSessionScreenState();
}

class _GroundingSessionScreenState extends State<GroundingSessionScreen> {
  late final GroundingTechnique _technique;

  // Step index within technique.steps (0 = intro, 1..N = prompts).
  int _stepIndex = 0;

  // True once all steps are done — shows completion + feeling check.
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _technique = GroundingTechnique.byId(widget.techniqueId);
  }

  // ── Navigation ─────────────────────────────────────────────────────────

  void _onNext() {
    if (_stepIndex < _technique.steps.length - 1) {
      setState(() => _stepIndex++);
    } else {
      // All steps complete — show completion + feeling check
      setState(() => _done = true);
    }
  }

  void _onBack() {
    if (_done) {
      setState(() { _done = false; }); // back to last step
    } else if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    } else {
      if (context.canPop()) context.pop();
    }
  }

  // ── Feeling-check navigation ────────────────────────────────────────────

  void _onBetter() => context.go(AppRoutes.postSession);
  void _onSame()   => context.go(AppRoutes.home);
  void _onWorse()  => context.go(AppRoutes.home);

  // ── Build ───────────────────────────────────────────────────────────────

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
                      technique: _technique,
                      onBack: _onBack,
                      onBetter: _onBetter,
                      onSame: _onSame,
                      onWorse: _onWorse,
                    )
                  : _StepView(
                      key: ValueKey('step_$_stepIndex'),
                      technique: _technique,
                      stepIndex: _stepIndex,
                      onNext: _onNext,
                      onBack: _onBack,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Step view — one prompt per screen
// ═════════════════════════════════════════════════════════════════════════════

class _StepView extends StatelessWidget {
  final GroundingTechnique technique;
  final int stepIndex;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _StepView({
    super.key,
    required this.technique,
    required this.stepIndex,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final total = technique.steps.length;
    // Human-readable: "1 of 6"
    final stepLabel = '${stepIndex + 1} of $total';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.sosTextSecondary,
                  size: 22,
                ),
                onPressed: onBack,
              ),
              Expanded(
                child: Text(
                  technique.title,
                  style: AppTypography.headingSmall
                      .copyWith(color: AppColors.sosTextPrimary),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 56, // balances back button so title is truly centred
                child: Text(
                  stepLabel,
                  style: AppTypography.caption
                      .copyWith(color: AppColors.sosTextSecondary),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Progress dots ────────────────────────────────────────────────
        _ProgressDots(current: stepIndex, total: total),

        const SizedBox(height: 40),

        // ── Prompt text ─────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: _BoldText(
                text: technique.steps[stepIndex],
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.sosTextPrimary,
                  fontSize: 19,
                  height: 1.65,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // ── Advance button ───────────────────────────────────────────────
        Center(
          child: _CircleButton(onPressed: onNext),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Completion + feeling check — shown after the last step
// ═════════════════════════════════════════════════════════════════════════════

class _CompletionView extends StatelessWidget {
  final GroundingTechnique technique;
  final VoidCallback onBack;
  final VoidCallback onBetter;
  final VoidCallback onSame;
  final VoidCallback onWorse;

  const _CompletionView({
    super.key,
    required this.technique,
    required this.onBack,
    required this.onBetter,
    required this.onSame,
    required this.onWorse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Minimal back affordance
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 8),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.sosTextSecondary,
                size: 22,
              ),
              onPressed: onBack,
            ),
          ),
        ),

        const Spacer(flex: 2),

        // Completion message
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            technique.completion,
            style: AppTypography.sosInstruction.copyWith(
              color: AppColors.sosTextPrimary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const Spacer(flex: 3),

        // Feeling check heading
        Text(
          StringsGrounding.feelingCheckHeading,
          style: AppTypography.headingMedium
              .copyWith(color: AppColors.sosTextPrimary),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Three feeling buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FeelingButton(
                label: StringsGrounding.feelingBetter,
                color: AppColors.accentTeal,
                outlined: true,
                onPressed: onBetter,
              ),
              const SizedBox(height: 10),
              _FeelingButton(
                label: StringsGrounding.feelingSame,
                color: AppColors.sosTextSecondary,
                outlined: false,
                onPressed: onSame,
              ),
              const SizedBox(height: 10),
              _FeelingButton(
                label: StringsGrounding.feelingWorse,
                color: AppColors.sosTextSecondary,
                outlined: false,
                onPressed: onWorse,
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Shared helper widgets
// ═════════════════════════════════════════════════════════════════════════════

// ─── Bold-markdown renderer ──────────────────────────────────────────────────
// Parses **bold** markers from Content Bible strings.
// Every odd-indexed segment after splitting on '**' is rendered bold.

class _BoldText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _BoldText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    final parts = text.split('**');
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(TextSpan(
        text: parts[i],
        style: i.isOdd ? style.copyWith(fontWeight: FontWeight.w700) : style,
      ));
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}

// ─── Progress dots ────────────────────────────────────────────────────────────

class _ProgressDots extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: i == current ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: switch (true) {
                _ when i < current =>
                  AppColors.accentTeal.withValues(alpha: 0.7),
                _ when i == current => AppColors.accentCoral,
                _ => AppColors.sosTextSecondary.withValues(alpha: 0.25),
              },
            ),
          ),
          if (i < total - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

// ─── Circular advance button ─────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CircleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentCoral.withValues(alpha: 0.12),
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.accentCoral, width: 1.5),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            Icons.arrow_forward,
            color: AppColors.accentCoral,
            size: 26,
          ),
        ),
      ),
    );
  }
}

// ─── Feeling check button ─────────────────────────────────────────────────────

class _FeelingButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback onPressed;

  const _FeelingButton({
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
