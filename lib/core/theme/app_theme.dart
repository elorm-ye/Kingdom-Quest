import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Kingdom Quest Design System — ThemeData Configuration
/// Refactored v2.0 — Removes AI-generated glassmorphism and gradients.
/// Emphasizes solid colors, strict mathematical spacing (4pt grid), and high contrast.

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // LIGHT THEME (Terracotta / Earth)
  // ─────────────────────────────────────────────

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.terracotta,
        onPrimary: Colors.white,
        secondary: AppColors.oliveClay,
        onSecondary: Colors.white,
        tertiary: AppColors.burntAmber,
        onTertiary: Colors.white,
        error: AppColors.alert,
        onError: Colors.white,
        surface: AppColors.sand,
        onSurface: AppColors.umber,
        surfaceContainerHighest: AppColors.linen,
      ),
      scaffoldBackgroundColor: AppColors.sand,
      textTheme: AppTypography.lightTextTheme,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.sand,
        foregroundColor: AppColors.umber,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.umber.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTypography.h3,
        iconTheme: const IconThemeData(color: AppColors.umber, size: AppSpacing.iconLg),
      ),

      // Card Theme (No glassmorphism, solid color, subtle shadow)
      cardTheme: CardThemeData(
        color: AppColors.linen,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.terracotta,
          side: const BorderSide(color: AppColors.terracotta, width: 1.5),
          textStyle: AppTypography.button.copyWith(color: AppColors.terracotta),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.terracotta,
          textStyle: AppTypography.button.copyWith(color: AppColors.terracotta),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      // Input Decoration (No gradients, clear borders)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.linen,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.terracotta, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.linen,
        elevation: 8,
        selectedItemColor: AppColors.terracotta,
        unselectedItemColor: AppColors.muted,
        selectedIconTheme: const IconThemeData(size: AppSpacing.iconLg),
        unselectedIconTheme: const IconThemeData(size: AppSpacing.iconLg),
        selectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTypography.caption,
        type: BottomNavigationBarType.fixed,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.linen,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection)),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.linen,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        titleTextStyle: AppTypography.h3,
        contentTextStyle: AppTypography.bodyMedium,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DARK THEME (WCAG AAA)
  // ─────────────────────────────────────────────

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.burntAmber,
        onPrimary: AppColors.umberNight,
        secondary: AppColors.glow,
        onSecondary: AppColors.umberNight,
        tertiary: AppColors.terracotta,
        onTertiary: Colors.white,
        error: AppColors.alert,
        onError: Colors.white,
        surface: AppColors.umberNight,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.espresso,
      ),
      scaffoldBackgroundColor: AppColors.umberNight,
      textTheme: AppTypography.darkTextTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.umberNight,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimaryDark),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: AppSpacing.iconLg),
      ),

      cardTheme: CardThemeData(
        color: AppColors.espresso,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burntAmber,
          foregroundColor: AppColors.umberNight,
          elevation: 0,
          textStyle: AppTypography.button.copyWith(color: AppColors.umberNight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.burntAmber,
          side: const BorderSide(color: AppColors.borderDark, width: 1.5),
          textStyle: AppTypography.button.copyWith(color: AppColors.burntAmber),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(64, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.burntAmber,
          textStyle: AppTypography.button.copyWith(color: AppColors.burntAmber),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.espresso,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.burntAmber, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.espresso,
        elevation: 8,
        selectedItemColor: AppColors.burntAmber,
        unselectedItemColor: AppColors.textMutedDark,
        selectedIconTheme: const IconThemeData(size: AppSpacing.iconLg),
        unselectedIconTheme: const IconThemeData(size: AppSpacing.iconLg),
        selectedLabelStyle: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTypography.caption,
        type: BottomNavigationBarType.fixed,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.espresso,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSection)),
        ),
      ),
      
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.espresso,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimaryDark),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PINK THEME — LIGHT
  // ─────────────────────────────────────────────

  static ThemeData get pinkLight {
    return light.copyWith(
      colorScheme: const ColorScheme.light(
        primary: AppColors.pinkPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.pinkAccent,
        onSecondary: Colors.white,
        tertiary: AppColors.pinkSecondary,
        onTertiary: Colors.white,
        error: AppColors.alert,
        onError: Colors.white,
        surface: AppColors.pinkBg,
        onSurface: AppColors.pinkInk,
        surfaceContainerHighest: AppColors.pinkSurface,
      ),
      scaffoldBackgroundColor: AppColors.pinkBg,
      textTheme: AppTypography.pinkLightTextTheme,
      appBarTheme: light.appBarTheme.copyWith(
        backgroundColor: AppColors.pinkBg,
        foregroundColor: AppColors.pinkInk,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.pinkInk),
        iconTheme: const IconThemeData(color: AppColors.pinkInk, size: AppSpacing.iconLg),
      ),
      cardTheme: light.cardTheme.copyWith(
        color: AppColors.pinkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: BorderSide(color: AppColors.pinkSecondary.withValues(alpha: 0.1)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: light.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.pinkPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: light.outlinedButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.pinkPrimary),
          side: WidgetStateProperty.all(const BorderSide(color: AppColors.pinkPrimary, width: 1.5)),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: AppColors.pinkPrimary)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: light.textButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.pinkPrimary),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: AppColors.pinkPrimary)),
        ),
      ),
      inputDecorationTheme: light.inputDecorationTheme.copyWith(
        fillColor: AppColors.pinkSurface,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.pinkPrimary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: light.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.pinkSurface,
        selectedItemColor: AppColors.pinkPrimary,
        unselectedItemColor: AppColors.pinkMuted,
      ),
      bottomSheetTheme: light.bottomSheetTheme.copyWith(
        backgroundColor: AppColors.pinkSurface,
      ),
      dialogTheme: light.dialogTheme.copyWith(
        backgroundColor: AppColors.pinkSurface,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.pinkInk),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.pinkInk),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PINK THEME — DARK
  // ─────────────────────────────────────────────

  static ThemeData get pinkDark {
    return dark.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.pinkAccent,
        onPrimary: AppColors.pinkNight,
        secondary: AppColors.pinkGlow,
        onSecondary: AppColors.pinkNight,
        tertiary: AppColors.pinkPrimary,
        onTertiary: Colors.white,
        error: AppColors.alert,
        onError: Colors.white,
        surface: AppColors.pinkNight,
        onSurface: AppColors.pinkTextPrimaryDark,
        surfaceContainerHighest: AppColors.pinkEspresso,
      ),
      scaffoldBackgroundColor: AppColors.pinkNight,
      textTheme: AppTypography.pinkDarkTextTheme,
      appBarTheme: dark.appBarTheme.copyWith(
        backgroundColor: AppColors.pinkNight,
        foregroundColor: AppColors.pinkTextPrimaryDark,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.pinkTextPrimaryDark),
        iconTheme: const IconThemeData(color: AppColors.pinkTextPrimaryDark, size: AppSpacing.iconLg),
      ),
      cardTheme: dark.cardTheme.copyWith(
        color: AppColors.pinkEspresso,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: const BorderSide(color: AppColors.pinkPlumDusk),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: dark.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.pinkAccent),
          foregroundColor: WidgetStateProperty.all(AppColors.pinkNight),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: dark.outlinedButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.pinkAccent),
          side: WidgetStateProperty.all(const BorderSide(color: AppColors.pinkPlumDusk, width: 1.5)),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: AppColors.pinkAccent)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: dark.textButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.pinkAccent),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: AppColors.pinkAccent)),
        ),
      ),
      inputDecorationTheme: dark.inputDecorationTheme.copyWith(
        fillColor: AppColors.pinkEspresso,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.pinkAccent, width: 2),
        ),
      ),
      bottomNavigationBarTheme: dark.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.pinkEspresso,
        selectedItemColor: AppColors.pinkAccent,
        unselectedItemColor: AppColors.pinkTextMutedDark,
      ),
      bottomSheetTheme: dark.bottomSheetTheme.copyWith(
        backgroundColor: AppColors.pinkEspresso,
      ),
      dialogTheme: dark.dialogTheme.copyWith(
        backgroundColor: AppColors.pinkEspresso,
        titleTextStyle: AppTypography.h3.copyWith(color: AppColors.pinkTextPrimaryDark),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.pinkTextPrimaryDark),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // THEME GENERATOR HELPER
  // ─────────────────────────────────────────────

  static ThemeData _buildCustomTheme({
    required bool isDark,
    required Color primary,
    required Color accent,
    required Color secondary,
    required Color bg,
    required Color surface,
    required Color ink,
    required Color muted,
    required Color border,
  }) {
    final base = isDark ? dark : light;
    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: accent,
            onPrimary: bg,
            secondary: primary,
            onSecondary: Colors.white,
            tertiary: accent,
            onTertiary: bg,
            error: AppColors.alert,
            onError: Colors.white,
            surface: bg,
            onSurface: ink,
            surfaceContainerHighest: surface,
          )
        : ColorScheme.light(
            primary: primary,
            onPrimary: Colors.white,
            secondary: secondary,
            onSecondary: Colors.white,
            tertiary: accent,
            onTertiary: Colors.white,
            error: AppColors.alert,
            onError: Colors.white,
            surface: bg,
            onSurface: ink,
            surfaceContainerHighest: surface,
          );

    final textTheme = isDark
        ? AppTypography.darkTextTheme.apply(
            bodyColor: ink,
            displayColor: ink,
          )
        : AppTypography.lightTextTheme.apply(
            bodyColor: ink,
            displayColor: ink,
          );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: bg,
        foregroundColor: ink,
        titleTextStyle: AppTypography.h3.copyWith(color: ink),
        iconTheme: IconThemeData(color: ink, size: AppSpacing.iconLg),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: BorderSide(color: border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: base.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(isDark ? accent : primary),
          foregroundColor: WidgetStateProperty.all(isDark ? bg : Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: base.outlinedButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(isDark ? accent : primary),
          side: WidgetStateProperty.all(BorderSide(color: isDark ? accent : primary, width: 1.5)),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: isDark ? accent : primary)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: base.textButtonTheme.style?.copyWith(
          foregroundColor: WidgetStateProperty.all(isDark ? accent : primary),
          textStyle: WidgetStateProperty.all(AppTypography.button.copyWith(color: isDark ? accent : primary)),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: surface,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: isDark ? accent : primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: surface,
        selectedItemColor: isDark ? accent : primary,
        unselectedItemColor: muted,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: surface,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: surface,
        titleTextStyle: AppTypography.h3.copyWith(color: ink),
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: ink),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // GREEN THEME
  // ─────────────────────────────────────────────

  static ThemeData get greenLight => _buildCustomTheme(
        isDark: false,
        primary: AppColors.greenPrimary,
        accent: AppColors.greenAccent,
        secondary: AppColors.greenSecondary,
        bg: AppColors.greenBg,
        surface: AppColors.greenSurface,
        ink: AppColors.greenInk,
        muted: AppColors.greenMuted,
        border: AppColors.greenSecondary.withValues(alpha: 0.15),
      );

  static ThemeData get greenDark => _buildCustomTheme(
        isDark: true,
        primary: AppColors.greenPrimary,
        accent: AppColors.greenAccent,
        secondary: AppColors.greenGlow,
        bg: AppColors.greenNight,
        surface: AppColors.greenEspresso,
        ink: AppColors.greenTextPrimaryDark,
        muted: AppColors.greenTextMutedDark,
        border: AppColors.greenPlumDusk,
      );

  // ─────────────────────────────────────────────
  // BLUE THEME
  // ─────────────────────────────────────────────

  static ThemeData get blueLight => _buildCustomTheme(
        isDark: false,
        primary: AppColors.bluePrimary,
        accent: AppColors.blueAccent,
        secondary: AppColors.blueSecondary,
        bg: AppColors.blueBg,
        surface: AppColors.blueSurface,
        ink: AppColors.blueInk,
        muted: AppColors.blueMuted,
        border: AppColors.blueSecondary.withValues(alpha: 0.15),
      );

  static ThemeData get blueDark => _buildCustomTheme(
        isDark: true,
        primary: AppColors.bluePrimary,
        accent: AppColors.blueAccent,
        secondary: AppColors.blueGlow,
        bg: AppColors.blueNight,
        surface: AppColors.blueEspresso,
        ink: AppColors.blueTextPrimaryDark,
        muted: AppColors.blueTextMutedDark,
        border: AppColors.bluePlumDusk,
      );

  // ─────────────────────────────────────────────
  // PURPLE THEME
  // ─────────────────────────────────────────────

  static ThemeData get purpleLight => _buildCustomTheme(
        isDark: false,
        primary: AppColors.purplePrimary,
        accent: AppColors.purpleAccent,
        secondary: AppColors.purpleSecondary,
        bg: AppColors.purpleBg,
        surface: AppColors.purpleSurface,
        ink: AppColors.purpleInk,
        muted: AppColors.purpleMuted,
        border: AppColors.purpleSecondary.withValues(alpha: 0.15),
      );

  static ThemeData get purpleDark => _buildCustomTheme(
        isDark: true,
        primary: AppColors.purplePrimary,
        accent: AppColors.purpleAccent,
        secondary: AppColors.purpleGlow,
        bg: AppColors.purpleNight,
        surface: AppColors.purpleEspresso,
        ink: AppColors.purpleTextPrimaryDark,
        muted: AppColors.purpleTextMutedDark,
        border: AppColors.purplePlumDusk,
      );

  // ─────────────────────────────────────────────
  // AMBER THEME
  // ─────────────────────────────────────────────

  static ThemeData get amberLight => _buildCustomTheme(
        isDark: false,
        primary: AppColors.amberPrimary,
        accent: AppColors.amberAccent,
        secondary: AppColors.amberSecondary,
        bg: AppColors.amberBg,
        surface: AppColors.amberSurface,
        ink: AppColors.amberInk,
        muted: AppColors.amberMuted,
        border: AppColors.amberSecondary.withValues(alpha: 0.15),
      );

  static ThemeData get amberDark => _buildCustomTheme(
        isDark: true,
        primary: AppColors.amberPrimary,
        accent: AppColors.amberAccent,
        secondary: AppColors.amberGlow,
        bg: AppColors.amberNight,
        surface: AppColors.amberEspresso,
        ink: AppColors.amberTextPrimaryDark,
        muted: AppColors.amberTextMutedDark,
        border: AppColors.amberPlumDusk,
      );

  // ─────────────────────────────────────────────
  // THEME DISPATCHER
  // ─────────────────────────────────────────────

  static ThemeData getTheme(ColorThemeName themeName, {required bool isDark}) {
    switch (themeName) {
      case ColorThemeName.pink:
        return isDark ? pinkDark : pinkLight;
      case ColorThemeName.green:
        return isDark ? greenDark : greenLight;
      case ColorThemeName.blue:
        return isDark ? blueDark : blueLight;
      case ColorThemeName.purple:
        return isDark ? purpleDark : purpleLight;
      case ColorThemeName.amber:
        return isDark ? amberDark : amberLight;
      case ColorThemeName.defaultTheme:
        return isDark ? dark : light;
    }
  }
}
