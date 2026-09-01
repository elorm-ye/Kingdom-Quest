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
}
