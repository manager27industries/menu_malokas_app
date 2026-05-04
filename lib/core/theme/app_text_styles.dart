import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Jerarquía tipográfica del sistema de diseño Raíces.
///
/// Serif  → Playfair Display (títulos, nombres de platos)
/// Sans   → Inter (descripciones, labels, UI)
abstract final class AppTextStyles {
  // ── Serif ─────────────────────────────────────────────────────────────────

  /// Título de pantalla — 36 serif semibold
  static TextStyle displayLarge(BuildContext context) =>
      GoogleFonts.playfairDisplay(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Nombre del plato en detalle — 32 serif semibold
  static TextStyle headlineLarge(BuildContext context) =>
      GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  /// Nombre del plato en card — 22 serif semibold
  static TextStyle headlineMedium(BuildContext context) =>
      GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// Subtítulo de sección — 18 serif regular
  static TextStyle titleMedium(BuildContext context) =>
      GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ── Sans ──────────────────────────────────────────────────────────────────

  /// Descripción en detalle — 17 inter regular
  static TextStyle bodyLarge(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.65,
      );

  /// Descripción en card — 14 inter regular
  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.55,
      );

  /// Label de botón / chip — 14 inter medium
  static TextStyle labelMedium(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.0,
      );

  /// Label de botón sobre fondo oscuro — 14 inter medium
  static TextStyle labelOnDark(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnDark,
        height: 1.0,
      );
}
