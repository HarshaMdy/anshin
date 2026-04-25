// Sleep — coming-soon empty state per Content Bible §16
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/strings_empty_states.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mascot_widget.dart';

class SleepHomeScreen extends StatelessWidget {
  const SleepHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero illustration — full width, sleep night scene ────────────
          SafeArea(
            bottom: false,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: SvgPicture.asset(
                MascotEmotion.sleepHero.assetPath,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                semanticsLabel: MascotEmotion.sleepHero.semanticsLabel,
              ),
            ),
          ),

          // ── Text + CTA ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Heading
                  Text(
                    StringsEmptyStates.sleepHeading,
                    style: AppTypography.headingMedium
                        .copyWith(color: textPrimary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  // Body
                  Text(
                    StringsEmptyStates.sleepBody,
                    style: AppTypography.bodyMedium
                        .copyWith(color: textSecondary, height: 1.6),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // Notify CTA
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "You'll be notified when Sleep is ready."),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      minimumSize: const Size.fromHeight(52),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      StringsEmptyStates.sleepNotifyButton,
                      style: AppTypography.button
                          .copyWith(color: textPrimary),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
