import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/pdf_repository_impl.dart';
import '../domain/pdf_repository.dart';

/// Instancia global de SupabaseClient.
final supabaseClientProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

/// Repositorio de PDFs — inyectable y testeable.
final pdfRepositoryProvider = Provider<PdfRepository>(
  (ref) => PdfRepositoryImpl(ref.watch(supabaseClientProvider)),
);

/// URL pública del PDF según idioma.
/// Se re-fetch automáticamente cuando el idioma cambia.
final pdfUrlProvider =
    FutureProvider.family<String, String>((ref, langCode) async {
  final repo = ref.watch(pdfRepositoryProvider);
  return repo.getPdfUrl(langCode);
});
