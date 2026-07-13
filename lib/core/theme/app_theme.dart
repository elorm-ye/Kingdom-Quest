import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Kingdom Quest — Complete Theme Configuration
/// Light: warm earth tones. Dark: warm twilight.

class AppTheme {
  AppTheme._();

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.sand,
    colorScheme: const ColorScheme.light(
      primary: AppColors.terracotta,
      onPrimary: Colors.white,
      primaryContainer: AppColors.burntAmber,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.oliveClay,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.linen,
      onSecondaryContainer: AppColors.umber,
      surface: AppColors.sand,
      onSurface: AppColors.umber,
      error: AppColors.alert,
      onError: Colors.white,
      outline: Color(0xFFD9CEBD),
    ),
    textTheme: AppTypography.lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.sand,
      foregroundColor: AppColors.umber,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.h3,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardThemeData(
      color: AppColors.linen,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.terracotta,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.terracotta,
        elevation: 0,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
        side: const BorderSide(color: AppColors.terracotta, width: 1.5),
        textStyle: AppTypography.button.copyWith(color: AppColors.terracotta),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.terracotta,
        textStyle: AppTypography.label.copyWith(color: AppColors.terracotta),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.linen,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.muted),
      labelStyle: AppTypography.label,
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.alert),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.linen,
      selectedColor: AppColors.terracotta,
      labelStyle: AppTypography.labelSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.linen,
      selectedItemColor: AppColors.terracotta,
      unselectedItemColor: AppColors.muted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.terracotta,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5D9C9),
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.terracotta;
        return AppColors.muted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.terracotta.withValues(alpha: 0.3);
        return AppColors.muted.withValues(alpha: 0.2);
      }),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.linen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSection),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.linen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSection),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.umber,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // ─────────────────────────────────────────────
  // DARK THEME ("Warm Twilight")
  // ─────────────────────────────────────────────

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.umberNight,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.burntAmber,
      onPrimary: Colors.white,
      primaryContainer: AppColors.terracotta,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.glow,
      onSecondary: AppColors.umber,
      secondaryContainer: AppColors.plumDusk,
      onSecondaryContainer: AppColors.textPrimaryDark,
      surface: AppColors.umberNight,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.alert,
      onError: Colors.white,
      outline: Color(0xFF4A3A30),
    ),
    textTheme: AppTypography.darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.umberNight,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.h3.copyWith(color: AppColors.textPrimaryDark),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardThemeData(
      color: AppColors.espresso,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.burntAmber,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.burntAmber,
        elevation: 0,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
        side: const BorderSide(color: AppColors.burntAmber, width: 1.5),
        textStyle: AppTypography.button.copyWith(color: AppColors.burntAmber),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.lg,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentLinkDark,
        textStyle: AppTypography.label.copyWith(color: AppColors.accentLinkDark),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.espresso,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: Color(0xFF4A3A30), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.burntAmber, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMutedDark),
      labelStyle: AppTypography.label.copyWith(color: AppColors.textSecondaryDark),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.alert),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.plumDusk,
      selectedColor: AppColors.burntAmber,
      labelStyle: AppTypography.labelSmall.copyWith(color: AppColors.textPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.espresso,
      selectedItemColor: AppColors.burntAmber,
      unselectedItemColor: AppColors.textMutedDark,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.burntAmber,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3D2E25),
      thickness: 1,
      space: 1,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.burntAmber;
        return AppColors.textMutedDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.burntAmber.withValues(alpha: 0.3);
        return AppColors.textMutedDark.withValues(alpha: 0.2);
      }),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.espresso,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusSection),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.espresso,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSection),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.plumDusk,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
