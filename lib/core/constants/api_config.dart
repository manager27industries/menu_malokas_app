/// Backend de PDFs y admin (Vercel Blob + serverless).
abstract final class ApiConfig {
  /// Vacío = mismo origen (producción). En local:
  /// `--dart-define=API_BASE=http://localhost:3000`
  static const String _fromEnv = String.fromEnvironment('API_BASE');

  static String get baseUrl {
    if (_fromEnv.isNotEmpty) return _fromEnv.replaceAll(RegExp(r'/$'), '');
    return Uri.base.origin;
  }
}
