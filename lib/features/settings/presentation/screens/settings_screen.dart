// Settings screen — Task 8 implementation
// Fully wired: Audio & haptics (voice + vibration), Appearance (theme)
// Other sections rendered as stubs pending their respective tasks
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/strings_settings.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final auth = ref.watch(authProvider).valueOrNull;
    final user =
        auth is AuthAuthenticated ? auth.user : null;

    final voiceCues = user?.settings.voiceCues ?? true;
    final hapticOn = user?.settings.hapticOn ?? true;
    final currentTheme = ref.watch(themeProvider);

    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.profile),
        ),
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          // ── Audio & haptics ─────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAudio,
            textSecondary: textSecondary,
          ),

          // Voice guidance toggle — FUNCTIONAL
          SwitchListTile(
            value: voiceCues,
            onChanged: user == null
                ? null
                : (v) => ref
                    .read(settingsNotifierProvider.notifier)
                    .setVoiceCues(v),
            title: Text(
              StringsSettings.voiceGuidanceToggle,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            activeThumbColor: AppColors.accentCoral,
            tileColor: surface,
          ),

          Divider(height: 1, color: dividerColor),

          // Vibration toggle — FUNCTIONAL
          SwitchListTile(
            value: hapticOn,
            onChanged: user == null
                ? null
                : (v) => ref
                    .read(settingsNotifierProvider.notifier)
                    .setHapticOn(v),
            title: Text(
              StringsSettings.vibrationToggle,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            activeThumbColor: AppColors.accentCoral,
            tileColor: surface,
          ),

          Divider(height: 1, color: dividerColor),

          // Default breathing pattern — navigates to picker
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.defaultPatternLabel,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.settings.breathingPreference.toUpperCase() ?? 'BOX',
                  style:
                      AppTypography.caption.copyWith(color: textSecondary),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
              ],
            ),
            onTap: () => context.push(AppRoutes.breathingPicker),
          ),

          const SizedBox(height: 24),

          // ── Appearance ──────────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAppearance,
            textSecondary: textSecondary,
          ),

          // Theme — 3 RadioListTiles inside RadioGroup — FUNCTIONAL
          RadioGroup<ThemeMode>(
            groupValue: currentTheme,
            onChanged: (v) =>
                ref.read(themeProvider.notifier).setTheme(v!),
            child: Column(
              children: [
                _ThemeRadio(
                  label: StringsSettings.themeLight,
                  value: ThemeMode.light,
                  surface: surface,
                  textPrimary: textPrimary,
                ),
                Divider(height: 1, color: dividerColor),
                _ThemeRadio(
                  label: StringsSettings.themeDark,
                  value: ThemeMode.dark,
                  surface: surface,
                  textPrimary: textPrimary,
                ),
                Divider(height: 1, color: dividerColor),
                _ThemeRadio(
                  label: StringsSettings.themeSystem,
                  value: ThemeMode.system,
                  surface: surface,
                  textPrimary: textPrimary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Notifications (stub — Task 9+) ──────────────────────────────
          _SectionHeader(
            StringsSettings.sectionNotifications,
            textSecondary: textSecondary,
          ),
          _StubTile(
            StringsSettings.dailyReminderToggle,
            surface: surface,
            textPrimary: textPrimary,
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.postSosToggle,
            surface: surface,
            textPrimary: textPrimary,
          ),

          const SizedBox(height: 24),

          // ── Account (stub — Task 9+) ─────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAccount,
            textSecondary: textSecondary,
          ),
          _StubTile(
            StringsSettings.exportData,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.deleteAccount,
            surface: surface,
            textPrimary: AppColors.accentError,
          ),

          const SizedBox(height: 24),

          // ── Subscription (stub — Task 11+) ───────────────────────────────
          _SectionHeader(
            StringsSettings.sectionSubscription,
            textSecondary: textSecondary,
          ),
          _StubTile(
            StringsSettings.manageSubscription,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.restorePurchase,
            surface: surface,
            textPrimary: textPrimary,
          ),

          const SizedBox(height: 24),

          // ── About (stub — Task 9+) ───────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAbout,
            textSecondary: textSecondary,
          ),
          _StubTile(
            StringsSettings.privacyPolicy,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.termsOfService,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.contactSupport,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),
          Divider(height: 1, color: dividerColor),
          _StubTile(
            StringsSettings.rateAnshin,
            surface: surface,
            textPrimary: textPrimary,
            trailing: Icon(Icons.chevron_right, color: textSecondary, size: 20),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color textSecondary;

  const _SectionHeader(this.label, {required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.caption.copyWith(
          color: textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── Theme radio tile ─────────────────────────────────────────────────────────

class _ThemeRadio extends StatelessWidget {
  final String label;
  final ThemeMode value;
  final Color surface;
  final Color textPrimary;

  const _ThemeRadio({
    required this.label,
    required this.value,
    required this.surface,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    // groupValue / onChanged are inherited from the RadioGroup ancestor
    return RadioListTile<ThemeMode>(
      value: value,
      tileColor: surface,
      title: Text(
        label,
        style: AppTypography.bodyLarge.copyWith(color: textPrimary),
      ),
    );
  }
}

// ─── Non-functional stub tile (for sections not yet implemented) ──────────────

class _StubTile extends StatelessWidget {
  final String label;
  final Color surface;
  final Color textPrimary;
  final Widget? trailing;

  const _StubTile(
    this.label, {
    required this.surface,
    required this.textPrimary,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: surface,
      title: Text(
        label,
        style: AppTypography.bodyLarge.copyWith(color: textPrimary),
      ),
      trailing: trailing,
    );
  }
}
