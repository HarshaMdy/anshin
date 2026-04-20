// Paywall screen — Content Bible §13
//
// Full-screen modal pushed from anywhere a premium feature is tapped.
// Shows mascot, benefits, annual/monthly plan selector, and CTA.
// Live pricing is fetched from RevenueCat offerings; hardcoded fallback
// values from StringsPaywall are used when offerings are unavailable.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/strings_paywall.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  // Annual is the recommended / default plan
  String _selectedPlan = 'annual';
  bool _purchasing = false;
  bool _restoring  = false;

  // ── URL launcher ──────────────────────────────────────────────────────────

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link.')),
      );
    }
  }

  // ── Purchase ───────────────────────────────────────────────────────────────

  Future<void> _purchase(Offerings? offerings) async {
    final Package? package = _selectedPackage(offerings);

    if (package == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Store products not yet available. Please try again shortly.'),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _purchasing = true);
    final success = await ref
        .read(purchaseNotifierProvider.notifier)
        .purchase(package);

    if (!mounted) return;
    setState(() => _purchasing = false);

    if (success) {
      Navigator.of(context).pop(); // dismiss paywall
      return;
    }

    // Show error only for real store errors (cancelled = silent)
    final err = ref.read(purchaseNotifierProvider).error;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase failed. Please try again.')),
      );
    }
  }

  Future<void> _restore() async {
    setState(() => _restoring = true);
    final found = await ref
        .read(purchaseNotifierProvider.notifier)
        .restore();

    if (!mounted) return;
    setState(() => _restoring = false);

    if (found) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active purchases found.')),
      );
    }
  }

  /// Formats the annual price divided by 12 as a currency string.
  /// E.g. price=34.99, currencyCode='USD' → '$2.92'
  String _perMonth(double annualPrice, String currencyCode) {
    final perMonth = annualPrice / 12;
    // Simple formatting: prepend currency symbol for common codes
    final symbol = switch (currencyCode.toUpperCase()) {
      'USD' => '\$',
      'EUR' => '€',
      'GBP' => '£',
      'INR' => '₹',
      'AUD' => 'A\$',
      'CAD' => 'CA\$',
      _ => '$currencyCode ',
    };
    return '$symbol${perMonth.toStringAsFixed(2)}';
  }

  Package? _selectedPackage(Offerings? offerings) {
    final packages = offerings?.current?.availablePackages;
    if (packages == null || packages.isEmpty) return null;
    if (_selectedPlan == 'annual') {
      return packages
          .where((p) => p.packageType == PackageType.annual)
          .firstOrNull;
    }
    return packages
        .where((p) => p.packageType == PackageType.monthly)
        .firstOrNull;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;

    final offeringsAsync = ref.watch(offeringsProvider);
    final offerings = offeringsAsync.valueOrNull;
    final busy = _purchasing || _restoring;

    // Live pricing from RC — falls back to StringsPaywall constants
    final packages = offerings?.current?.availablePackages ?? [];
    final annualPkg = packages
        .where((p) => p.packageType == PackageType.annual)
        .firstOrNull;
    final monthlyPkg = packages
        .where((p) => p.packageType == PackageType.monthly)
        .firstOrNull;

    final annualPrice  = annualPkg?.storeProduct.priceString
        ?? StringsPaywall.annualPrice;
    final monthlyPrice = monthlyPkg?.storeProduct.priceString
        ?? StringsPaywall.monthlyPrice;

    // Per-month breakdown for annual (live: price / 12, fallback hardcoded)
    final annualSubtext = annualPkg != null
        ? "That's ${_perMonth(annualPkg.storeProduct.price, annualPkg.storeProduct.currencyCode)}/month"
        : StringsPaywall.annualSubtext;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Close button row ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: textSecondary,
                      size: 22,
                    ),
                    tooltip: 'Close',
                    onPressed: busy ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ───────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mascot
                    const Center(
                      child: MascotWidget(
                        emotion: MascotEmotion.proud,
                        size: 90,
                        breathe: true,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Header
                    Text(
                      StringsPaywall.header,
                      style: AppTypography.headingLarge
                          .copyWith(color: textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      StringsPaywall.subheader,
                      style: AppTypography.bodyMedium
                          .copyWith(color: textSecondary),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // Benefits
                    _BenefitRow(
                      icon: Icons.air_outlined,
                      text: StringsPaywall.benefit1,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 12),
                    _BenefitRow(
                      icon: Icons.menu_book_outlined,
                      text: StringsPaywall.benefit2,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 12),
                    _BenefitRow(
                      icon: Icons.bar_chart_outlined,
                      text: StringsPaywall.benefit3,
                      textSecondary: textSecondary,
                    ),

                    const SizedBox(height: 20),

                    // Future preview chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accentTeal.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accentTeal.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: AppColors.accentTeal,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              StringsPaywall.futurePreview,
                              style: AppTypography.caption
                                  .copyWith(color: textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Plan selector ─────────────────────────────────────────
                    _PlanCard(
                      plan: 'annual',
                      label: StringsPaywall.planAnnual,
                      price: annualPrice,
                      subtext: annualSubtext,
                      badge: StringsPaywall.annualBadge,
                      selected: _selectedPlan == 'annual',
                      onTap: busy
                          ? null
                          : () => setState(() => _selectedPlan = 'annual'),
                      surface: surface,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      plan: 'monthly',
                      label: StringsPaywall.planMonthly,
                      price: monthlyPrice,
                      subtext: StringsPaywall.monthlySubtext,
                      selected: _selectedPlan == 'monthly',
                      onTap: busy
                          ? null
                          : () => setState(() => _selectedPlan = 'monthly'),
                      surface: surface,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Sticky bottom CTA ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Primary CTA
                  ElevatedButton(
                    onPressed: busy ? null : () => _purchase(offerings),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCoral,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.accentCoral.withValues(alpha: 0.35),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      textStyle: AppTypography.button,
                      elevation: 0,
                    ),
                    child: _purchasing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Text(StringsPaywall.ctaButton),
                  ),

                  const SizedBox(height: 8),

                  // CTA subtext
                  Text(
                    _selectedPlan == 'annual'
                        ? StringsPaywall.ctaSubtextAnnual
                        : StringsPaywall.ctaSubtextMonthly,
                    style: AppTypography.caption
                        .copyWith(color: textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  // Restore
                  TextButton(
                    onPressed: busy ? null : _restore,
                    style: TextButton.styleFrom(
                      foregroundColor: textSecondary,
                      minimumSize: const Size(double.infinity, 40),
                      textStyle: AppTypography.bodyMedium,
                    ),
                    child: _restoring
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                color: textSecondary, strokeWidth: 2),
                          )
                        : Text(StringsPaywall.restorePurchase),
                  ),

                  // Terms + Privacy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => _launchUrl(
                            'https://harshamdy.github.io/anshin/terms.html'),
                        style: TextButton.styleFrom(
                          foregroundColor: textSecondary,
                          textStyle: AppTypography.caption,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                        child: Text(StringsPaywall.termsLink),
                      ),
                      Text('·',
                          style: AppTypography.caption
                              .copyWith(color: textSecondary)),
                      TextButton(
                        onPressed: () => _launchUrl(
                            'https://harshamdy.github.io/anshin/privacy.html'),
                        style: TextButton.styleFrom(
                          foregroundColor: textSecondary,
                          textStyle: AppTypography.caption,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                        child: Text(StringsPaywall.privacyLink),
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// Benefit row
// ─────────────────────────────────────────────────────────────────────────────

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textSecondary;

  const _BenefitRow({
    required this.icon,
    required this.text,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentTeal.withValues(alpha: 0.12),
          ),
          child: Icon(icon, size: 15, color: AppColors.accentTeal),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(color: textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Plan card
// ─────────────────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String plan;
  final String label;
  final String price;
  final String subtext;
  final String? badge;
  final bool selected;
  final VoidCallback? onTap;
  final Color surface;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _PlanCard({
    required this.plan,
    required this.label,
    required this.price,
    required this.subtext,
    this.badge,
    required this.selected,
    required this.onTap,
    required this.surface,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '$label plan, selected' : '$label plan',
      child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accentCoral.withValues(alpha: 0.06)
              : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accentCoral : borderColor,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.accentCoral : Colors.transparent,
                border: Border.all(
                  color:
                      selected ? AppColors.accentCoral : borderColor,
                  width: 1.8,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),

            // Plan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: AppTypography.bodyLarge.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.accentGold
                                  .withValues(alpha: 0.40),
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtext,
                    style: AppTypography.caption
                        .copyWith(color: textSecondary),
                  ),
                ],
              ),
            ),

            // Price
            Text(
              price,
              style: AppTypography.headingSmall.copyWith(
                color: selected ? AppColors.accentCoral : textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
