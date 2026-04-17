// Runbook Override 2 — full color system for both themes
import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─── Light theme (DEFAULT) ────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8F5F0); // warm cream
  static const Color lightSurface = Color(0xFFFFFFFF);    // white cards
  static const Color lightTextPrimary = Color(0xFF2D2A26); // warm dark
  static const Color lightTextSecondary = Color(0xFF7A7267); // muted brown
  static const Color lightCardBorder = Color(0xFFE8E2D9);  // light warm gray

  // ─── Dark theme ───────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1A1F2E);  // deep navy
  static const Color darkSurface = Color(0xFF252B3D);     // charcoal
  static const Color darkTextPrimary = Color(0xFFE8E8EC); // off-white
  static const Color darkTextSecondary = Color(0xFF9CA3B5); // silver
  static const Color darkCardBorder = Color(0xFF353B4D);  // dim gray

  // ─── Shared accents (same in both themes) ────────────────────────────────
  static const Color accentCoral = Color(0xFFE8907A);   // SOS / breathe circle
  static const Color accentTeal = Color(0xFF7BA8B0);    // calm / grounding
  static const Color accentGold = Color(0xFFD4B480);    // progress / completion
  static const Color accentError = Color(0xFFC26B6B);   // muted brick (never alarming red)

  // ─── SOS active screen — ALWAYS dark regardless of theme ─────────────────
  // Override 2: "SOS mode forces dark background even if the user's theme is Light"
  static const Color sosBackground = darkBackground;
  static const Color sosSurface = darkSurface;
  static const Color sosTextPrimary = darkTextPrimary;
  static const Color sosTextSecondary = darkTextSecondary;

  // ─── Mascot base color ────────────────────────────────────────────────────
  static const Color mascotBase = Color(0xFFC4B5A0);
  static const Color mascotHighlight = Color(0xFFD4C4AE);
  static const Color mascotEye = Color(0xFF3D3229);
}
