/// Configuración central de la app Raíces.
abstract final class AppConfig {
  /// Rutas en Firebase Storage donde viven los PDFs del menú.
  /// El cliente actualiza el PDF subiendo uno nuevo con el mismo path.
  static const String pdfPathEs = 'pdfs/menu_es.pdf';
  static const String pdfPathEn = 'pdfs/menu_en.pdf';

  static String pdfStoragePath(String langCode) =>
      langCode == 'en' ? pdfPathEn : pdfPathEs;
}
