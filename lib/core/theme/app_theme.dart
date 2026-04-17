// Runbook Override 2 — light ThemeData (default) + dark ThemeData
// SOS active screen always forces dark regardless of user preference (handled at screen level).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  // ─── Light theme (DEFAULT) ────────────────────────────────────────────────
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.accentCoral,
      onPrimary: Colors.white,
      secondary: AppColors.accentTeal,
      onSecondary: Colors.white,
      tertiary: AppColors.accentGold,
      onTertiary: AppColors.lightTextPrimary,
      error: AppColors.accentError,
      onError: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTypography.textThemeLight(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentCoral,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.lightCardBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightTextSecondary,
          textStyle: AppTypography.bodyMedium,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accentCoral,
        inactiveTrackColor: AppColors.lightCardBorder,
        thumbColor: AppColors.accentCoral,
        overlayColor: AppColors.accentCoral.withValues(alpha: 0.12),
        trackHeight: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedColor: AppColors.accentCoral.withValues(alpha: 0.15),
        side: const BorderSide(color: AppColors.lightCardBorder),
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightCardBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary),
      pageTransitionsTheme: _pageTransitions(),
    );
  }

  // ─── Dark theme ───────────────────────────────────────────────────────────
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.accentCoral,
      onPrimary: Colors.white,
      secondary: AppColors.accentTeal,
      onSecondary: Colors.white,
      tertiary: AppColors.accentGold,
      onTertiary: AppColors.darkTextPrimary,
      error: AppColors.accentError,
      onError: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTypography.textThemeDark(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentCoral,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: AppColors.darkCardBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkTextSecondary,
          textStyle: AppTypography.bodyMedium,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.accentCoral,
        inactiveTrackColor: AppColors.darkCardBorder,
        thumbColor: AppColors.accentCoral,
        overlayColor: AppColors.accentCoral.withValues(alpha: 0.12),
        trackHeight: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.accentCoral.withValues(alpha: 0.20),
        side: const BorderSide(color: AppColors.darkCardBorder),
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkCardBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextSecondary),
      pageTransitionsTheme: _pageTransitions(),
    );
  }

  // ─── Page transitions (Override 7 — smooth cross-fade, 250ms, ease-in-out) ─
  static PageTransitionsTheme _pageTransitions() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _FadePageTransitionBuilder(),
        TargetPlatform.iOS: _FadePageTransitionBuilder(),
      },
    );
  }
}

// 250ms cross-fade — Override 7: "No slide-from-bottom. No bouncy springs."
class _FadePageTransitionBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: child,
    );
  }
}
