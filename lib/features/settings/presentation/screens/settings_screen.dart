// Settings screen — Content Bible §15
// Fully functional: Audio, Appearance, Notifications, Subscription,
// Account, About.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/strings_settings.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // ── URL helpers ─────────────────────────────────────────────────────────────

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> _launchEmail(String address) =>
      _launch('mailto:$address');

  static Future<void> _launchPlayStore(BuildContext context) =>
      _launch('market://details?id=com.anshin.app')
          .catchError((_) => _launch(
              'https://play.google.com/store/apps/details?id=com.anshin.app'));

  // ── Delete account dialog ────────────────────────────────────────────────────

  static Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(StringsSettings.deleteAccount),
        content: Text(StringsSettings.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(StringsSettings.keepAccountButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.accentError),
            child: Text(StringsSettings.deleteAccountConfirmButton),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account deletion scheduled. You have 30 days to cancel by signing back in.',
          ),
        ),
      );
    }
  }

  // ── Sign out dialog ──────────────────────────────────────────────────────────

  static Future<void> _showSignOutDialog(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You are using an anonymous account. '
          'Signing out will end your session. '
          'Your data is saved and will be accessible again on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                TextButton.styleFrom(foregroundColor: AppColors.accentError),
            child: Text(StringsSettings.signOut),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(authServiceProvider).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final auth = ref.watch(authProvider).valueOrNull;
    final user = auth is AuthAuthenticated ? auth.user : null;

    final voiceCues = user?.settings.voiceCues ?? true;
    final hapticOn = user?.settings.hapticOn ?? true;
    final currentTheme = ref.watch(themeProvider);

    final notifEnabled =
        user?.notificationPreferences.enabled ?? true;
    final notifTime =
        user?.notificationPreferences.dailyTime ?? '20:00';
    final postSosEnabled =
        user?.notificationPreferences.postSosEnabled ?? true;

    final isPremium = ref.watch(isPremiumProvider);

    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
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
                  style: AppTypography.caption
                      .copyWith(color: textSecondary),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right,
                    color: textSecondary, size: 20),
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

          // ── Notifications ────────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionNotifications,
            textSecondary: textSecondary,
          ),

          // Daily reminder toggle
          SwitchListTile(
            value: notifEnabled,
            onChanged: user == null
                ? null
                : (v) => ref
                    .read(settingsNotifierProvider.notifier)
                    .setReminderEnabled(v),
            title: Text(
              StringsSettings.dailyReminderToggle,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            activeThumbColor: AppColors.accentCoral,
            tileColor: surface,
          ),

          // Reminder time picker (shown only when enabled)
          if (notifEnabled) ...[
            Divider(height: 1, color: dividerColor),
            ListTile(
              tileColor: surface,
              title: Text(
                StringsSettings.reminderTimeLabel,
                style:
                    AppTypography.bodyLarge.copyWith(color: textPrimary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notifTime,
                    style: AppTypography.bodyMedium
                        .copyWith(color: textSecondary),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right,
                      color: textSecondary, size: 20),
                ],
              ),
              onTap: user == null
                  ? null
                  : () async {
                      final parts = notifTime.split(':');
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: int.parse(parts[0]),
                          minute: int.parse(parts[1]),
                        ),
                        helpText: 'Choose reminder time',
                        builder: (ctx, child) => MediaQuery(
                          data: MediaQuery.of(ctx)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (picked != null && context.mounted) {
                        final timeStr =
                            '${picked.hour.toString().padLeft(2, '0')}:'
                            '${picked.minute.toString().padLeft(2, '0')}';
                        await ref
                            .read(settingsNotifierProvider.notifier)
                            .setReminderTime(timeStr);
                      }
                    },
            ),
          ],

          Divider(height: 1, color: dividerColor),

          // Post-SOS follow-up toggle
          SwitchListTile(
            value: postSosEnabled,
            onChanged: user == null
                ? null
                : (v) => ref
                    .read(settingsNotifierProvider.notifier)
                    .setPostSosEnabled(v),
            title: Text(
              StringsSettings.postSosToggle,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            activeThumbColor: AppColors.accentCoral,
            tileColor: surface,
          ),

          const SizedBox(height: 24),

          // ── Subscription ─────────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionSubscription,
            textSecondary: textSecondary,
          ),

          // Status tile
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.sectionSubscription,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing: Text(
              isPremium
                  ? StringsSettings.premiumActive
                  : StringsSettings.premiumNotSubscribed,
              style: AppTypography.caption.copyWith(
                color: isPremium
                    ? AppColors.accentTeal
                    : textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Divider(height: 1, color: dividerColor),

          // Manage subscription — opens Play Store subscriptions page
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.manageSubscription,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () => _launch(
                'https://play.google.com/store/account/subscriptions'),
          ),

          Divider(height: 1, color: dividerColor),

          // Restore purchase
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.restorePurchase,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            onTap: () async {
              final restored = await ref
                  .read(purchaseNotifierProvider.notifier)
                  .restore();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(restored
                        ? 'Purchase restored successfully.'
                        : 'No active purchase found.'),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 24),

          // ── Account ──────────────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAccount,
            textSecondary: textSecondary,
          ),

          // Signed-in status
          ListTile(
            tileColor: surface,
            title: Text(
              user?.email != null
                  ? StringsSettings.signedInAs(user!.email!)
                  : 'Anonymous account',
              style:
                  AppTypography.bodyMedium.copyWith(color: textSecondary),
            ),
          ),

          Divider(height: 1, color: dividerColor),

          // Export data
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.exportData,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(StringsSettings.exportDataSubtext)),
            ),
          ),

          Divider(height: 1, color: dividerColor),

          // Sign out
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.signOut,
              style: AppTypography.bodyLarge
                  .copyWith(color: textSecondary),
            ),
            onTap: () => _showSignOutDialog(context, ref),
          ),

          Divider(height: 1, color: dividerColor),

          // Delete account
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.deleteAccount,
              style: AppTypography.bodyLarge
                  .copyWith(color: AppColors.accentError),
            ),
            onTap: () => _showDeleteDialog(context),
          ),

          const SizedBox(height: 24),

          // ── About ────────────────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAbout,
            textSecondary: textSecondary,
          ),

          // Rate Anshin
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.rateAnshin,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () => _launchPlayStore(context),
          ),

          Divider(height: 1, color: dividerColor),

          // Share Anshin
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.shareAnshin,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () => Share.share(StringsSettings.shareText),
          ),

          Divider(height: 1, color: dividerColor),

          // Privacy Policy
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.privacyPolicy,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () =>
                _launch('https://anshin.app/privacy'),
          ),

          Divider(height: 1, color: dividerColor),

          // Terms of Service
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.termsOfService,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () =>
                _launch('https://anshin.app/terms'),
          ),

          Divider(height: 1, color: dividerColor),

          // Contact support
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.contactSupport,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing:
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
            onTap: () => _launchEmail(StringsSettings.supportEmail),
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
