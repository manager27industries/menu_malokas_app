/// Configuración central de la app Raíces.
/// Cambia [menuPdfUrl] cuando actualices el PDF en Google Drive.
abstract final class AppConfig {
  /// Link de Google Drive del menú en PDF.
  /// Formato: https://drive.google.com/file/d/TU_ID_DE_ARCHIVO/view?usp=sharing
  ///
  /// Para obtenerlo:
  ///   1. Sube el PDF a Google Drive
  ///   2. Click derecho → Compartir → "Cualquier persona con el enlace"
  ///   3. Copia el link y pégalo aquí
  static const String menuPdfUrl =
      'https://drive.google.com/file/d/TU_ID_DE_ARCHIVO/view?usp=sharing';
}
