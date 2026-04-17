// PRD §5.3 + Voice Guide — humanist sans-serif, larger body text for anxious eyes
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const String _fontFamily = 'PlusJakartaSans';

  // ─── Text styles (color-agnostic — themed via copyWith in AppTheme) ───────

  // SOS instructions: 32–40pt, medium weight (shaky hands need large readable text)
  static const TextStyle sosInstruction = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // Headers: 24–28pt
  static const TextStyle headingLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Body: 17pt (larger than typical 15pt — anxious eyes struggle with small text)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Captions: 13pt minimum
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  // Button labels
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Card sublabels
  static const TextStyle cardSub = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // ─── TextTheme builders (light / dark) ────────────────────────────────────

  static TextTheme textThemeLight() => _buildTextTheme(
        primary: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
      );

  static TextTheme textThemeDark() => _buildTextTheme(
        primary: AppColors.darkTextPrimary,
        secondary: AppColors.darkTextSecondary,
      );

  static TextTheme _buildTextTheme({
    required Color primary,
    required Color secondary,
  }) {
    return TextTheme(
      displayLarge: headingLarge.copyWith(color: primary),
      displayMedium: headingMedium.copyWith(color: primary),
      displaySmall: headingSmall.copyWith(color: primary),
      headlineMedium: headingLarge.copyWith(color: primary),
      headlineSmall: headingMedium.copyWith(color: primary),
      titleLarge: headingSmall.copyWith(color: primary),
      titleMedium: bodyLarge.copyWith(
        color: primary,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: bodyMedium.copyWith(
        color: secondary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: primary),
      bodySmall: caption.copyWith(color: secondary),
      labelLarge: button.copyWith(color: primary),
      labelSmall: caption.copyWith(color: secondary, letterSpacing: 0.4),
    );
  }
}
