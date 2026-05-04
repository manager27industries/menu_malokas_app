import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// ThemeData central de Raíces.
/// Todos los widgets Material heredan estos estilos automáticamente.
final class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      floatingActionButtonTheme: _fabTheme,
      appBarTheme: _appBarTheme,
      chipTheme: _chipTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ── Color Scheme ──────────────────────────────────────────────────────────

  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.darkGreen,
    onPrimary: AppColors.textOnDark,
    secondary: AppColors.earth,
    onSecondary: AppColors.textOnDark,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: Color(0xFFB00020),
    onError: Colors.white,
  );

  // ── Text Theme ────────────────────────────────────────────────────────────

  static TextTheme get _textTheme {
    final serif = GoogleFonts.playfairDisplayTextTheme();
    final sans = GoogleFonts.interTextTheme();

    return sans.copyWith(
      // displayLarge → título de pantalla (serif)
      displayLarge: serif.displayLarge?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      // headlineLarge → nombre del plato en detalle (serif)
      headlineLarge: serif.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      // headlineMedium → nombre del plato en card (serif)
      headlineMedium: serif.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      // titleMedium → subtítulos de sección (serif)
      titleMedium: serif.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      // bodyLarge → descripción en detalle (sans)
      bodyLarge: sans.bodyLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.65,
      ),
      // bodyMedium → descripción en card (sans)
      bodyMedium: sans.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.55,
      ),
      // labelMedium → labels, botones, chips (sans)
      labelMedium: sans.labelMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.0,
      ),
    );
  }

  // ── Card Theme ────────────────────────────────────────────────────────────

  static CardThemeData get _cardTheme => CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      side: const BorderSide(color: AppColors.divider, width: 1),
    ),
    margin: EdgeInsets.zero,
  );

  // ── Elevated Button ───────────────────────────────────────────────────────

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: AppColors.textOnDark,
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  // ── FAB Theme ─────────────────────────────────────────────────────────────

  static FloatingActionButtonThemeData get _fabTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: AppColors.textOnDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.fab),
        ),
      );

  // ── AppBar Theme ──────────────────────────────────────────────────────────

  static AppBarTheme get _appBarTheme => AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
  );

  // ── Chip Theme ────────────────────────────────────────────────────────────

  static ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.chipUnselected,
    selectedColor: AppColors.chipSelected,
    labelStyle: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
  );
}
