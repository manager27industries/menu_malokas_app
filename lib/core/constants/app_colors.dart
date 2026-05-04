import 'package:flutter/material.dart';

/// Tokens de color del sistema de diseño Raíces.
/// Ningún widget debe usar un color en crudo — siempre importar desde aquí.
abstract final class AppColors {
  // ── Primarios ────────────────────────────────────────────────────────────
  static const Color darkGreen = Color(0xFF1F3A32);
  static const Color oliveGreen = Color(0xFF314D43);

  // ── Fondos ───────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFBF7F1);
  static const Color surface = Color(0xFFFFFDFC);
  static const Color sandLight = Color(0xFFE7D7C2);

  // ── Tierra ───────────────────────────────────────────────────────────────
  static const Color earth = Color(0xFFB7906C);
  static const Color coffeeDark = Color(0xFF5A3E2B);

  // ── Texto ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1F3A32);
  static const Color textSecondary = Color(0xFF7A6656);
  static const Color textOnDark = Color(0xFFFBF7F1);

  // ── Divisores / bordes ───────────────────────────────────────────────────
  static const Color divider = Color(0xFFDCCEBE);

  // ── Estado ───────────────────────────────────────────────────────────────
  static const Color chipSelected = Color(0xFF1F3A32);
  static const Color chipUnselected = Color(0xFFE7D7C2);
}
