/// Credenciales de Supabase para el proyecto menu-malokas.
abstract final class SupabaseConfig {
  static const String url = 'https://ungvemalhhocwwxfphoe.supabase.co';
  static const String anonKey =
      'sb_publishable_UTo5urfGIrX_GUi5N-0GyQ_YL0RKdVz';

  /// Nombre del bucket en Supabase Storage.
  static const String bucket = 'pdfs';

  /// Rutas dentro del bucket.
  static const String pathEs = 'menu_es.pdf';
  static const String pathEn = 'menu_en.pdf';

  static String storagePath(String langCode) =>
      langCode == 'en' ? pathEn : pathEs;
}
