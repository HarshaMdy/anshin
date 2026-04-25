// Post-session screen — Content Bible §8
// Shown after SOS ends (X button, 90-sec "Better" or "About the same").
// Forced dark — visual continuity with SOS, still in the recovery moment.
// Message is selected randomly from rotatingMessages on screen creation and
// never changes on rebuild.
//
// Schedules the 4-hour post-SOS follow-up notification in initState,
// subject to the user's postSosEnabled preference.
import 'dart:async' show unawaited;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_post_session.dart';
import '../../../../core/providers/notification_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class PostSessionScreen extends ConsumerStatefulWidget {
  const PostSessionScreen({super.key});

  @override
  ConsumerState<PostSessionScreen> createState() => _PostSessionScreenState();
}

class _PostSessionScreenState extends ConsumerState<PostSessionScreen> {
  late final String _message;

  @override
  void initState() {
    super.initState();
    // Pick once at creation — stable across rebuilds (theme switches, etc.)
    final idx =
        Random().nextInt(StringsPostSession.rotatingMessages.length);
    _message = StringsPostSession.rotatingMessages[idx];

    // Schedule 4-hour follow-up if user has post-SOS notifications enabled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider).valueOrNull;
      final enabled = auth is AuthAuthenticated
          ? auth.user.notificationPreferences.postSosEnabled
          : true; // default on if prefs not loaded
      if (enabled) {
        unawaited(
          ref
              .read(notificationServiceProvider)
              .schedulePostSosFollowUp()
              .catchError((_) {}),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.dark(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.sosBackground,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // ── Full-screen radial coral glow ─────────────────────────────
              // Centred at upper-third of screen, ~200dp radius.
              // Painted first so everything else layers on top.
              const CustomPaint(painter: _CoralGlowPainter()),

              // ── Bottom sunrise arc — horizon warmth ───────────────────────
              // Arc circle is centred below the screen edge so only the top
              // portion peeks up — a soft warm horizon at 10% opacity.
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 180,
                child: CustomPaint(painter: _SunriseArcPainter()),
              ),

              // ── Content ───────────────────────────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Top spacer — room to breathe ───────────────────
                      const Spacer(flex: 2),

                      // ── Mascot — relieved, gentle breathing ────────────
                      // The warm glow behind it comes from _CoralGlowPainter
                      // (full-screen layer) rather than being constrained
                      // inside a 200×200 box.
                      const Center(
                        child: MascotWidget(
                          emotion: MascotEmotion.postSession,
                          size: 140,
                          breathe: true,
                        ),
                      ),

                      const Spacer(flex: 1),

                      // ── Rotating message — the emotional core ──────────
                      Text(
                        _message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PlusJakartaSans',
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(flex: 3),

                      // ── Three optional action cards ────────────────────
                      _ActionCard(
                        label: StringsPostSession.cardLog,
                        icon: Icons.edit_note_outlined,
                        onTap: () => context.go(AppRoutes.journalHome),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        label: StringsPostSession.cardWrite,
                        icon: Icons.edit_outlined,
                        onTap: () => context.go(AppRoutes.journalEntry),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        label: StringsPostSession.cardRest,
                        icon: Icons.nights_stay_outlined,
                        onTap: () => context.go(AppRoutes.home),
                      ),

                      const SizedBox(height: 40),
                    ],
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

// ─── Action card ─────────────────────────────────────────────────────────────
// Intentionally soft — post-panic, no demands, gentle suggestions only.

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15), // 15% per spec
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.06),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(icon, color: AppColors.sosTextSecondary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyLarge
                        .copyWith(color: AppColors.sosTextPrimary),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.sosTextSecondary.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Full-screen radial coral glow ───────────────────────────────────────────
// Centred at ~30% from top (upper third). Radius ~200dp.
// Replaces the old 200×200-boxed SunriseGlowPainter — the full-screen version
// produces the soft ambient halo the spec calls for.

class _CoralGlowPainter extends CustomPainter {
  const _CoralGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const glowRadius = 200.0;
    final center = Offset(size.width / 2, size.height * 0.30);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentCoral.withValues(alpha: 0.20),
          AppColors.accentCoral.withValues(alpha: 0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 0.50, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: glowRadius),
      );

    canvas.drawCircle(center, glowRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _CoralGlowPainter _) => false;
}

// ─── Bottom sunrise arc ───────────────────────────────────────────────────────
// The arc's centre sits below the visible screen edge so only the cap of the
// circle peeks up — a simple sunrise horizon at 10% opacity in coral/gold.
// Purely decorative; adds warmth without competing with the dark background.

class _SunriseArcPainter extends CustomPainter {
  const _SunriseArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Place arc centre well below the widget's bottom edge
    final arcCenter = Offset(size.width / 2, size.height + size.width * 0.35);
    final arcRadius = size.width * 0.90;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentCoral.withValues(alpha: 0.10),
          AppColors.accentGold.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(
        Rect.fromCircle(center: arcCenter, radius: arcRadius),
      );

    canvas.drawCircle(arcCenter, arcRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _SunriseArcPainter _) => false;
}
