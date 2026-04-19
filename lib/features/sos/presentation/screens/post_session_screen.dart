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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Top spacer — room to breathe ──────────────────────
                  const Spacer(flex: 2),

                  // ── Mascot — peaceful, eyes closed after SOS ──────────
                  const Center(
                    child: MascotWidget(
                      emotion: MascotEmotion.eyesClosed,
                      size: 90,
                      breathe: true,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // ── Rotating message — the emotional core ─────────────
                  Text(
                    _message,
                    style: AppTypography.sosInstruction.copyWith(
                      color: AppColors.sosTextPrimary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // ── Middle spacer ─────────────────────────────────────
                  const Spacer(flex: 4),

                  // ── Three optional action cards ───────────────────────
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
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
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
    );
  }
}
