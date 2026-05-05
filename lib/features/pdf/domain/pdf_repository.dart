import 'dart:typed_data';

/// Contrato del repositorio de PDFs del menú.
/// La implementación concreta usa Firebase Storage.
abstract class PdfRepository {
  /// Devuelve la URL de descarga vigente del PDF para el idioma dado.
  /// Lanza [PdfNotFoundException] si no existe en Storage.
  Future<String> getPdfUrl(String langCode);

  /// Sube [bytes] como PDF para [langCode] sobreescribiendo el anterior.
  Future<void> uploadPdf(String langCode, Uint8List bytes);
}

class PdfNotFoundException implements Exception {
  const PdfNotFoundException(this.langCode);
  final String langCode;

  @override
  String toString() => 'PDF no encontrado para idioma: $langCode';
}
