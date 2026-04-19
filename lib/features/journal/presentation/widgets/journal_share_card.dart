// Shareable journal card — Content Bible §19
//
// Renders at exactly 300×300 logical pixels.
// Wrap in a RepaintBoundary and call toImage(pixelRatio: capturePixelRatio)
// to produce a 1080×1080 px PNG ready for the system share sheet.
//
// Design: always warm-cream regardless of app theme (social content should
// look consistent on every recipient's device).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/strings_share.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/mascot_widget.dart';

class JournalShareCard extends StatelessWidget {
  final MascotEmotion emotion;

  const JournalShareCard({super.key, required this.emotion});

  // ── Sizing constants ───────────────────────────────────────────────────────

  /// Logical pixel dimensions of the card.
  static const double cardSize = 300.0;

  /// pixelRatio for RepaintBoundary.toImage() → 300 × 3.6 = 1080 px output.
  static const double capturePixelRatio = 3.6;

  // ── Always-light palette (hardcoded — card is social content) ─────────────
  static const Color _bg = Color(0xFFFAF5EE);          // warm cream
  static const Color _textPrimary = Color(0xFF2D2A26); // warm dark
  static const Color _teal = AppColors.accentTeal;     // branding divider

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardSize,
      height: cardSize,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Mascot — user's selected emotion ──────────────────────────
            SvgPicture.asset(
              emotion.assetPath,
              width: 108,
              height: 108,
            ),

            const SizedBox(height: 18),

            // ── Primary text ───────────────────────────────────────────────
            const Text(
              StringsShare.journalCardText,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
                letterSpacing: -0.2,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),

            // ── Teal divider ───────────────────────────────────────────────
            Container(
              width: 36,
              height: 1.5,
              decoration: BoxDecoration(
                color: _teal,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

            const SizedBox(height: 12),

            // ── Branding ───────────────────────────────────────────────────
            Text(
              StringsShare.journalCardBranding,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _teal.withValues(alpha: 0.85),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
