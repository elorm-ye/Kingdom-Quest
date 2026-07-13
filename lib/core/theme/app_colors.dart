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
    colors: [
      Color(0xFFC7784E),
      Color(0xFFB8614A),
      Color(0xFF8B4332),
    ],
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
}
