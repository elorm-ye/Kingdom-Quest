import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Kingdom Quest Design System — Typography
///
/// Uses standard Material 3 text styles.

class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────────
  // FONT FAMILIES
  // ─────────────────────────────────────────────

  static const String displayFamily = 'DM Sans';
  static const String bodyFamily = 'Source Sans 3';

  // ─────────────────────────────────────────────
  // LIGHT MODE TEXT STYLES
  // ─────────────────────────────────────────────

  static const TextStyle h1 = TextStyle(
    fontFamily: displayFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.umber,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: displayFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.25,
    letterSpacing: -0.2,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: displayFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.umber,
    height: 1.55,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.umber,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    height: 1.3,
    letterSpacing: 0.8,
  );

  static const TextStyle button = TextStyle(
    fontFamily: displayFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.1,
  );

  static const TextStyle verseText = TextStyle(
    fontFamily: displayFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.45,
    letterSpacing: -0.2,
  );

  static const TextStyle verseRef = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.terracotta,
    height: 1.4,
  );

  // ─────────────────────────────────────────────
  // TEXT THEME (for ThemeData)
  // ─────────────────────────────────────────────

  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    headlineLarge: h1,
    headlineMedium: h2,
    headlineSmall: h3,
    titleLarge: h3,
    titleMedium: label,
    titleSmall: labelSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: button,
    labelMedium: label,
    labelSmall: caption,
  );

  static final TextTheme darkTextTheme = TextTheme(
    displayLarge: h1.copyWith(color: AppColors.textPrimaryDark),
    displayMedium: h2.copyWith(color: AppColors.textPrimaryDark),
    displaySmall: h3.copyWith(color: AppColors.textPrimaryDark),
    headlineLarge: h1.copyWith(color: AppColors.textPrimaryDark),
    headlineMedium: h2.copyWith(color: AppColors.textPrimaryDark),
    headlineSmall: h3.copyWith(color: AppColors.textPrimaryDark),
    titleLarge: h3.copyWith(color: AppColors.textPrimaryDark),
    titleMedium: label.copyWith(color: AppColors.textSecondaryDark),
    titleSmall: labelSmall.copyWith(color: AppColors.textMutedDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.textSecondaryDark),
    bodySmall: bodySmall.copyWith(color: AppColors.textMutedDark),
    labelLarge: button,
    labelMedium: label.copyWith(color: AppColors.textSecondaryDark),
    labelSmall: caption.copyWith(color: AppColors.textMutedDark),
  );

  // ─────────────────────────────────────────────
  // PINK TEXT THEMES
  // ─────────────────────────────────────────────

  static final TextTheme pinkLightTextTheme = TextTheme(
    displayLarge: h1.copyWith(color: AppColors.pinkInk),
    displayMedium: h2.copyWith(color: AppColors.pinkInk),
    displaySmall: h3.copyWith(color: AppColors.pinkInk),
    headlineLarge: h1.copyWith(color: AppColors.pinkInk),
    headlineMedium: h2.copyWith(color: AppColors.pinkInk),
    headlineSmall: h3.copyWith(color: AppColors.pinkInk),
    titleLarge: h3.copyWith(color: AppColors.pinkInk),
    titleMedium: label.copyWith(color: AppColors.pinkInk),
    titleSmall: labelSmall.copyWith(color: AppColors.pinkMuted),
    bodyLarge: bodyLarge.copyWith(color: AppColors.pinkInk),
    bodyMedium: bodyMedium.copyWith(color: AppColors.pinkInk),
    bodySmall: bodySmall.copyWith(color: AppColors.pinkMuted),
    labelLarge: button,
    labelMedium: label.copyWith(color: AppColors.pinkInk),
    labelSmall: caption.copyWith(color: AppColors.pinkMuted),
  );

  static final TextTheme pinkDarkTextTheme = TextTheme(
    displayLarge: h1.copyWith(color: AppColors.pinkTextPrimaryDark),
    displayMedium: h2.copyWith(color: AppColors.pinkTextPrimaryDark),
    displaySmall: h3.copyWith(color: AppColors.pinkTextPrimaryDark),
    headlineLarge: h1.copyWith(color: AppColors.pinkTextPrimaryDark),
    headlineMedium: h2.copyWith(color: AppColors.pinkTextPrimaryDark),
    headlineSmall: h3.copyWith(color: AppColors.pinkTextPrimaryDark),
    titleLarge: h3.copyWith(color: AppColors.pinkTextPrimaryDark),
    titleMedium: label.copyWith(color: AppColors.pinkTextSecondaryDark),
    titleSmall: labelSmall.copyWith(color: AppColors.pinkTextMutedDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.pinkTextPrimaryDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.pinkTextSecondaryDark),
    bodySmall: bodySmall.copyWith(color: AppColors.pinkTextMutedDark),
    labelLarge: button,
    labelMedium: label.copyWith(color: AppColors.pinkTextSecondaryDark),
    labelSmall: caption.copyWith(color: AppColors.pinkTextMutedDark),
  );
}
