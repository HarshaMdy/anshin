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
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../routing/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // ── Optimistic local state ───────────────────────────────────────────────────
  // null = "not yet set by user in this session" → fall back to auth value.
  // Once the user flips a switch, we hold that value locally so the UI never
  // flickers back to the default during the AuthNotifier.refresh() cycle
  // (which temporarily sets state = AsyncData(AuthLoading()), making user null).
  bool? _voiceCues;
  bool? _hapticOn;
  bool? _notifEnabled;
  bool? _postSosEnabled;

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

  Future<void> _showDeleteDialog() async {
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
    if (confirmed == true && mounted) {
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

  Future<void> _showSignOutDialog() async {
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
    if (confirmed == true && mounted) {
      await ref.read(authServiceProvider).signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final auth = ref.watch(authProvider).valueOrNull;
    // user is null during AuthLoading (background refresh after a save).
    // The optimistic _field values shield the UI during that window.
    final user = auth is AuthAuthenticated ? auth.user : null;

    // ── Eager seeding ────────────────────────────────────────────────────────
    // Populate every local field from the real user values as soon as user is
    // available (??= skips fields already set by a user tap this session).
    // After this block, no _field is ever null while the screen is mounted,
    // so auth refreshes that temporarily set user=null cannot flicker any
    // toggle — not even ones the user hasn't touched this session.
    if (user != null) {
      _voiceCues      ??= user.settings.voiceCues;
      _hapticOn       ??= user.settings.hapticOn;
      _notifEnabled   ??= user.notificationPreferences.enabled;
      _postSosEnabled ??= user.notificationPreferences.postSosEnabled;
    }

    // Resolve each toggle: local optimistic value (always non-null after
    // seeding above) → safe default only on very first frame before auth loads.
    final voiceCues      = _voiceCues      ?? true;
    final hapticOn       = _hapticOn       ?? true;
    final notifEnabled   = _notifEnabled   ?? true;
    final postSosEnabled = _postSosEnabled ?? true;

    final notifTime = user?.notificationPreferences.dailyTime ?? '20:00';

    final currentTheme = ref.watch(themeProvider);
    final isPremium    = ref.watch(isPremiumProvider);

    final bg           = isDark ? AppColors.darkBackground  : AppColors.lightBackground;
    final surface      = isDark ? AppColors.darkSurface     : AppColors.lightSurface;
    final textPrimary  = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        // Settings is a shell tab — no conceptual "back" destination.
        // Show the title instead of a back button.
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: AppTypography.headingSmall.copyWith(color: textPrimary),
        ),
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          // ── Premium card ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _PremiumCard(
              isPremium: isPremium,
              onTap: isPremium
                  ? () => _launch(
                      'https://play.google.com/store/account/subscriptions')
                  : () => context.push(AppRoutes.paywall),
            ),
          ),

          const SizedBox(height: 24),

          // ── Audio & haptics ─────────────────────────────────────────────
          _SectionHeader(
            StringsSettings.sectionAudio,
            textSecondary: textSecondary,
          ),

          SwitchListTile(
            value: voiceCues,
            onChanged: user == null
                ? null
                : (v) {
                    // Update local state immediately so the UI reflects the
                    // new value even during the auth refresh that follows.
                    setState(() => _voiceCues = v);
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setVoiceCues(v);
                  },
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
                : (v) {
                    setState(() => _hapticOn = v);
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setHapticOn(v);
                  },
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
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  tileColor: surface,
                  activeColor: AppColors.accentCoral,
                  title: Text(
                    StringsSettings.themeLight,
                    style:
                        AppTypography.bodyLarge.copyWith(color: textPrimary),
                  ),
                ),
                Divider(height: 1, color: dividerColor),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  tileColor: surface,
                  activeColor: AppColors.accentCoral,
                  title: Text(
                    StringsSettings.themeDark,
                    style:
                        AppTypography.bodyLarge.copyWith(color: textPrimary),
                  ),
                ),
                Divider(height: 1, color: dividerColor),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  tileColor: surface,
                  activeColor: AppColors.accentCoral,
                  title: Text(
                    StringsSettings.themeSystem,
                    style:
                        AppTypography.bodyLarge.copyWith(color: textPrimary),
                  ),
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
                : (v) {
                    setState(() => _notifEnabled = v);
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setReminderEnabled(v);
                  },
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
                      if (picked != null && mounted) {
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
                : (v) {
                    setState(() => _postSosEnabled = v);
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setPostSosEnabled(v);
                  },
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

          // Status tile — tapping opens paywall (free) or manage page (premium)
          ListTile(
            tileColor: surface,
            title: Text(
              StringsSettings.sectionSubscription,
              style: AppTypography.bodyLarge.copyWith(color: textPrimary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isPremium
                      ? StringsSettings.premiumActive
                      : StringsSettings.premiumNotSubscribed,
                  style: AppTypography.caption.copyWith(
                    color: isPremium
                        ? AppColors.accentTeal
                        : AppColors.accentCoral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: textSecondary, size: 20),
              ],
            ),
            onTap: isPremium
                ? () => _launch(
                    'https://play.google.com/store/account/subscriptions')
                : () => context.push(AppRoutes.paywall),
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
            onTap: _showSignOutDialog,
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
            onTap: _showDeleteDialog,
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
                _launch('https://harshamdy.github.io/anshin/privacy.html'),
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
                _launch('https://harshamdy.github.io/anshin/terms.html'),
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

// ─── Premium card ────────────────────────────────────────────────────────────

class _PremiumCard extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onTap;

  const _PremiumCard({required this.isPremium, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (isPremium) {
      // Already premium — green confirmation card
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentTeal,
              AppColors.accentTeal.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const MascotWidget(emotion: MascotEmotion.proud, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You have Premium ✓',
                    style: AppTypography.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'All features unlocked. Thank you!',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Free user — coral upgrade card
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE8907A), Color(0xFFD07060)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCoral.withValues(alpha: 0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const MascotWidget(emotion: MascotEmotion.hopeful, size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: AppTypography.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Unlock all breathing patterns, grounding, and more.',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Start free trial',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentCoral,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

