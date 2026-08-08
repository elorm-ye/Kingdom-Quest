import 'package:flutter/material.dart';

/// Kingdom Quest Design System — Color Tokens
/// Extracted from Brand Guidelines v1.0 (July 2026)
///
/// Light mode: warm, grounded earth. Terracotta carries the brand.
/// Dark mode: warm twilight — the same earth palette pushed into shadow.

class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // LIGHT MODE
  // ─────────────────────────────────────────────

  /// Primary · CTAs
  static const Color terracotta = Color(0xFFB8614A);

  /// Accent · gradients
  static const Color burntAmber = Color(0xFFC7784E);

  /// Secondary
  static const Color oliveClay = Color(0xFF7E7458);

  /// Text · ink
  static const Color umber = Color(0xFF2C211A);

  /// Background
  static const Color sand = Color(0xFFF1E9DC);

  /// Cards
  static const Color linen = Color(0xFFF8F1E8);

  /// Captions
  static const Color muted = Color(0xFF706750);

  /// Success
  static const Color sage = Color(0xFF5B8A68);

  /// Care · flag
  static const Color alert = Color(0xFFE24E36);

  // ─────────────────────────────────────────────
  // DARK MODE ("Warm Twilight")
  // ─────────────────────────────────────────────

  /// Base · from Umber
  static const Color umberNight = Color(0xFF1A110E);

  /// Surface
  static const Color espresso = Color(0xFF241A15);

  /// Raised · twilight
  static const Color plumDusk = Color(0xFF332420);

  /// Accent · reused from light
  // burntAmber reused

  /// Highlight · reused
  static const Color glow = Color(0xFFF5D984);

  // Text on Dark
  static const Color textPrimaryDark = Color(0xFFF7F0E6);
  static const Color textSecondaryDark = Color(0xFFC3B4A5);
  static const Color textMutedDark = Color(0xFF8A7C6E);
  static const Color accentLinkDark = Color(0xFFE0946A);

  // ─────────────────────────────────────────────
  // GRADIENTS
  // ─────────────────────────────────────────────

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [terracotta, burntAmber],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [terracotta, Color(0xFFD4956A)],
  );

  static const LinearGradient darkSurfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [espresso, plumDusk],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC7784E), Color(0xFFB8614A), Color(0xFF8B4332)],
  );

  // ─────────────────────────────────────────────
  // CATEGORY COLORS (for prayer request types, etc.)
  // ─────────────────────────────────────────────

  static const Color healing = Color(0xFF5B8A68);
  static const Color family = Color(0xFFC7784E);
  static const Color financial = Color(0xFF7E7458);
  static const Color education = Color(0xFF5A7A9B);
  static const Color spiritualGrowth = Color(0xFFB8614A);
  static const Color thanksgiving = Color(0xFFF5D984);
  static const Color other = Color(0xFF8A7C6E);

  // ─────────────────────────────────────────────
  // PINK THEME — LIGHT MODE
  // ─────────────────────────────────────────────

  /// Primary · CTAs
  static const Color pinkPrimary = Color(0xFFE8638A);

  /// Accent · gradients
  static const Color pinkAccent = Color(0xFFF29BBB);

  /// Secondary
  static const Color pinkSecondary = Color(0xFF9B7E8A);

  /// Text · ink
  static const Color pinkInk = Color(0xFF2D1F28);

  /// Background
  static const Color pinkBg = Color(0xFFFFF0F5);

  /// Cards
  static const Color pinkSurface = Color(0xFFFFF7FA);

  /// Captions
  static const Color pinkMuted = Color(0xFF9E8A94);

  /// Success / sage (pink-tinted)
  static const Color pinkSage = Color(0xFFD4699B);

  // ─────────────────────────────────────────────
  // PINK THEME — DARK MODE
  // ─────────────────────────────────────────────

  static const Color pinkNight = Color(0xFF1F121A);
  static const Color pinkEspresso = Color(0xFF2A1A24);
  static const Color pinkPlumDusk = Color(0xFF3A2530);
  static const Color pinkGlow = Color(0xFFFFCCE5);

  // Text on Pink Dark
  static const Color pinkTextPrimaryDark = Color(0xFFF7EFF3);
  static const Color pinkTextSecondaryDark = Color(0xFFC8B0BC);
  static const Color pinkTextMutedDark = Color(0xFF8A7580);
  static const Color pinkAccentLinkDark = Color(0xFFF5B0CC);

  // ─────────────────────────────────────────────
  // PINK GRADIENTS
  // ─────────────────────────────────────────────

  static const LinearGradient pinkBrandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkPrimary, pinkAccent],
  );

  static const LinearGradient pinkWarmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [pinkPrimary, Color(0xFFF5B0CC)],
  );

  static const LinearGradient pinkDarkSurfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pinkEspresso, pinkPlumDusk],
  );

  static const LinearGradient pinkSplashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF29BBB), Color(0xFFE8638A), Color(0xFFC94D72)],
  );
}
