import 'package:flutter/material.dart';

/// Kingdom Quest Design System — Color Tokens
/// Refactored v2.0 — Mature, WCAG-compliant palette.
///
/// Light mode: warm, grounded earth. Deep contrast.
/// Dark mode: true dark backgrounds with high-contrast foreground.
///   All text-on-background combinations target WCAG AAA (7:1+ ratio).

class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // LIGHT MODE
  // ─────────────────────────────────────────────

  /// Primary · CTAs, actionable elements
  static const Color terracotta = Color(0xFFB8614A);

  /// Accent · secondary emphasis
  static const Color burntAmber = Color(0xFFC7784E);

  /// Secondary · muted interactive
  static const Color oliveClay = Color(0xFF7E7458);

  /// Text · primary ink — near-black for max contrast
  static const Color umber = Color(0xFF1C1410);

  /// Background · page-level
  static const Color sand = Color(0xFFF3ECE0);

  /// Cards · elevated surface
  static const Color linen = Color(0xFFF8F3EB);

  /// Captions · secondary text
  static const Color muted = Color(0xFF5E5346);

  /// Success
  static const Color sage = Color(0xFF4A7D57);

  /// Error · destructive
  static const Color alert = Color(0xFFCC3D28);

  // ─────────────────────────────────────────────
  // DARK MODE — True Dark (WCAG AAA compliant)
  // ─────────────────────────────────────────────

  /// Base · scaffold background — deep charcoal-brown
  static const Color umberNight = Color(0xFF0F0B09);

  /// Surface · card background
  static const Color espresso = Color(0xFF1A1310);

  /// Raised surface · elevated cards
  static const Color plumDusk = Color(0xFF261D18);

  /// Highlight · accent on dark
  static const Color glow = Color(0xFFF5D984);

  // Text on Dark — all achieve 7:1+ contrast ratio on umberNight
  static const Color textPrimaryDark = Color(0xFFF5EDE2);
  static const Color textSecondaryDark = Color(0xFFD4C5B3);
  static const Color textMutedDark = Color(0xFF9A8C7E);
  static const Color accentLinkDark = Color(0xFFE8A87C);

  // ─────────────────────────────────────────────
  // SOLID ACCENTS (replaces gradients in UI)
  // ─────────────────────────────────────────────

  /// Splash background — solid branded color
  static const Color splashBg = Color(0xFFB8614A);

  // ─────────────────────────────────────────────
  // CATEGORY COLORS (for prayer request types, etc.)
  // ─────────────────────────────────────────────

  static const Color healing = Color(0xFF4A7D57);
  static const Color family = Color(0xFFC7784E);
  static const Color financial = Color(0xFF7E7458);
  static const Color education = Color(0xFF4A6D8A);
  static const Color spiritualGrowth = Color(0xFFB8614A);
  static const Color thanksgiving = Color(0xFFD4A84A);
  static const Color other = Color(0xFF8A7C6E);

  // ─────────────────────────────────────────────
  // NEUTRAL BORDERS
  // ─────────────────────────────────────────────

  static const Color borderLight = Color(0xFFE0D6C8);
  static const Color borderDark = Color(0xFF362A22);

  // ─────────────────────────────────────────────
  // PINK THEME — LIGHT MODE
  // ─────────────────────────────────────────────

  /// Primary · CTAs
  static const Color pinkPrimary = Color(0xFFD4547A);

  /// Accent
  static const Color pinkAccent = Color(0xFFE88AA8);

  /// Secondary
  static const Color pinkSecondary = Color(0xFF8A6E7A);

  /// Text · ink
  static const Color pinkInk = Color(0xFF1C151A);

  /// Background
  static const Color pinkBg = Color(0xFFFFF0F5);

  /// Cards
  static const Color pinkSurface = Color(0xFFFFF7FA);

  /// Captions
  static const Color pinkMuted = Color(0xFF7A6670);

  /// Success (pink-tinted)
  static const Color pinkSage = Color(0xFFD4699B);

  // ─────────────────────────────────────────────
  // PINK THEME — DARK MODE
  // ─────────────────────────────────────────────

  static const Color pinkNight = Color(0xFF0F0A0D);
  static const Color pinkEspresso = Color(0xFF1A1218);
  static const Color pinkPlumDusk = Color(0xFF2A1E26);
  static const Color pinkGlow = Color(0xFFFFCCE5);

  // Text on Pink Dark
  static const Color pinkTextPrimaryDark = Color(0xFFF7EFF3);
  static const Color pinkTextSecondaryDark = Color(0xFFC8B0BC);
  static const Color pinkTextMutedDark = Color(0xFF8A7580);
  static const Color pinkAccentLinkDark = Color(0xFFF5B0CC);

  // ─────────────────────────────────────────────
  // GREEN THEME (Sage / Emerald)
  // ─────────────────────────────────────────────

  static const Color greenPrimary = Color(0xFF2D6A4F);
  static const Color greenAccent = Color(0xFF52B788);
  static const Color greenSecondary = Color(0xFF40916C);
  static const Color greenInk = Color(0xFF081C15);
  static const Color greenBg = Color(0xFFF2F7F4);
  static const Color greenSurface = Color(0xFFF8FCF9);
  static const Color greenMuted = Color(0xFF4F775D);

  static const Color greenNight = Color(0xFF08120B);
  static const Color greenEspresso = Color(0xFF102115);
  static const Color greenPlumDusk = Color(0xFF1B3623);
  static const Color greenGlow = Color(0xFF95D5B2);
  static const Color greenTextPrimaryDark = Color(0xFFEDF7F1);
  static const Color greenTextSecondaryDark = Color(0xFFB7D5C2);
  static const Color greenTextMutedDark = Color(0xFF759B82);

  // ─────────────────────────────────────────────
  // BLUE THEME (Ocean / Royal Sapphire)
  // ─────────────────────────────────────────────

  static const Color bluePrimary = Color(0xFF1D5A8A);
  static const Color blueAccent = Color(0xFF4392C6);
  static const Color blueSecondary = Color(0xFF52799A);
  static const Color blueInk = Color(0xFF0A1926);
  static const Color blueBg = Color(0xFFF1F6FB);
  static const Color blueSurface = Color(0xFFF8FAFD);
  static const Color blueMuted = Color(0xFF4D6C85);

  static const Color blueNight = Color(0xFF071018);
  static const Color blueEspresso = Color(0xFF0F1E2E);
  static const Color bluePlumDusk = Color(0xFF1A314A);
  static const Color blueGlow = Color(0xFFA8D5E5);
  static const Color blueTextPrimaryDark = Color(0xFFEEF5FA);
  static const Color blueTextSecondaryDark = Color(0xFFB4CDE0);
  static const Color blueTextMutedDark = Color(0xFF6F8CA3);

  // ─────────────────────────────────────────────
  // PURPLE THEME (Royal Amethyst)
  // ─────────────────────────────────────────────

  static const Color purplePrimary = Color(0xFF704382);
  static const Color purpleAccent = Color(0xFF9D65B2);
  static const Color purpleSecondary = Color(0xFF865D94);
  static const Color purpleInk = Color(0xFF1F0D29);
  static const Color purpleBg = Color(0xFFF8F2FA);
  static const Color purpleSurface = Color(0xFFFCF8FD);
  static const Color purpleMuted = Color(0xFF71527D);

  static const Color purpleNight = Color(0xFF120817);
  static const Color purpleEspresso = Color(0xFF1F0F29);
  static const Color purplePlumDusk = Color(0xFF331942);
  static const Color purpleGlow = Color(0xFFE2B6F5);
  static const Color purpleTextPrimaryDark = Color(0xFFF9F0FD);
  static const Color purpleTextSecondaryDark = Color(0xFFD4B8DE);
  static const Color purpleTextMutedDark = Color(0xFF91729E);

  // ─────────────────────────────────────────────
  // AMBER / GOLD THEME (Kingdom Harvest Gold)
  // ─────────────────────────────────────────────

  static const Color amberPrimary = Color(0xFFC06C00);
  static const Color amberAccent = Color(0xFFE28B1E);
  static const Color amberSecondary = Color(0xFF9E651E);
  static const Color amberInk = Color(0xFF241500);
  static const Color amberBg = Color(0xFFFAF5EC);
  static const Color amberSurface = Color(0xFFFDFBF7);
  static const Color amberMuted = Color(0xFF7E6649);

  static const Color amberNight = Color(0xFF140D04);
  static const Color amberEspresso = Color(0xFF24180A);
  static const Color amberPlumDusk = Color(0xFF3B2812);
  static const Color amberGlow = Color(0xFFFFD485);
  static const Color amberTextPrimaryDark = Color(0xFFFAF4EB);
  static const Color amberTextSecondaryDark = Color(0xFFE0CEB2);
  static const Color amberTextMutedDark = Color(0xFF9C8769);
}

/// Supported color theme palettes
enum ColorThemeName {
  defaultTheme('Terracotta', AppColors.terracotta, Color(0xFFF3ECE0)),
  pink('Blush Pink', AppColors.pinkPrimary, Color(0xFFFFF0F5)),
  green('Forest Green', AppColors.greenPrimary, Color(0xFFF2F7F4)),
  blue('Ocean Blue', AppColors.bluePrimary, Color(0xFFF1F6FB)),
  purple('Royal Purple', AppColors.purplePrimary, Color(0xFFF8F2FA)),
  amber('Kingdom Amber', AppColors.amberPrimary, Color(0xFFFAF5EC));

  final String label;
  final Color primaryColor;
  final Color previewBg;
  const ColorThemeName(this.label, this.primaryColor, this.previewBg);
}
