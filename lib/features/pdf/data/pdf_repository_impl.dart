import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_config.dart';
import '../domain/pdf_repository.dart';

/// Implementación de [PdfRepository] usando Supabase Storage.
///
/// Los PDFs se almacenan en el bucket [SupabaseConfig.bucket]:
///   menu_es.pdf
///   menu_en.pdf
class PdfRepositoryImpl implements PdfRepository {
  PdfRepositoryImpl(this._client);

  final SupabaseClient _client;

  SupabaseStorageClient get _storage => _client.storage;

  @override
  Future<String> getPdfUrl(String langCode) async {
    final path = SupabaseConfig.storagePath(langCode);
    final url = _storage.from(SupabaseConfig.bucket).getPublicUrl(path);
    // Verifica existencia con list() — mucho más ligero que download().
    final files = await _storage.from(SupabaseConfig.bucket).list();
    if (!files.any((f) => f.name == path)) {
      throw PdfNotFoundException(langCode);
    }
    return url;
  }

  @override
  Future<void> uploadPdf(String langCode, Uint8List bytes) async {
    final path = SupabaseConfig.storagePath(langCode);
    await _storage.from(SupabaseConfig.bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            contentType: 'application/pdf',
            upsert: true, // sobreescribe si ya existe
          ),
        );
  }
}

