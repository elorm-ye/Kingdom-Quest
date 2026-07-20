import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Kingdom Quest Design System — Typography
///
/// Display: Bricolage Grotesque (characterful grotesque for display)
/// Body: Schibsted Grotesk (sturdy, even-toned grotesque for reading)

class AppTypography {
  AppTypography._();

  // ─────────────────────────────────────────────
  // FONT FAMILIES
  // ─────────────────────────────────────────────

  static String get displayFamily =>
      GoogleFonts.bricolageGrotesque().fontFamily!;
  static String get bodyFamily => GoogleFonts.schibstedGrotesk().fontFamily!;

  // ─────────────────────────────────────────────
  // LIGHT MODE TEXT STYLES
  // ─────────────────────────────────────────────

  static TextStyle get h1 => GoogleFonts.bricolageGrotesque(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.umber,
    height: 1.15,
    letterSpacing: -0.3,
  );

  static TextStyle get h2 => GoogleFonts.bricolageGrotesque(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static TextStyle get h3 => GoogleFonts.bricolageGrotesque(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.3,
  );

  static TextStyle get bodyLarge => GoogleFonts.schibstedGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.umber,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.umber,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.schibstedGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
    height: 1.4,
  );

  static TextStyle get label => GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.umber,
    height: 1.4,
  );

  static TextStyle get labelSmall => GoogleFonts.schibstedGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    height: 1.3,
    letterSpacing: 0.5,
  );

  static TextStyle get caption => GoogleFonts.schibstedGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
    height: 1.3,
    letterSpacing: 1.0,
  );

  static TextStyle get button => GoogleFonts.schibstedGrotesk(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static TextStyle get verseText => GoogleFonts.bricolageGrotesque(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.umber,
    height: 1.4,
    letterSpacing: -0.2,
  );

  static TextStyle get verseRef => GoogleFonts.schibstedGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.terracotta,
    height: 1.4,
  );

  // ─────────────────────────────────────────────
  // TEXT THEME (for ThemeData)
  // ─────────────────────────────────────────────

  static TextTheme get lightTextTheme => TextTheme(
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

  static TextTheme get darkTextTheme => TextTheme(
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
}
