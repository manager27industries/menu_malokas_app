/// Tokens de espaciado del sistema de diseño Raíces.
/// Unidad base: 8. Usar siempre múltiplos de esta unidad.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Padding interno de cards
  static const double cardPadding = 16;

  // Margen exterior en mobile
  static const double screenPaddingMobile = 16;

  // Margen exterior en tablet / web
  static const double screenPaddingTablet = 32;

  // Ancho máximo del contenido en web
  static const double maxContentWidth = 1100;
}

/// Tokens de bordes redondeados.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double fab = 20;
}
