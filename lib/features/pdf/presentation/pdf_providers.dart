import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/app_http_client.dart';
import '../data/pdf_repository_impl.dart';
import '../domain/pdf_repository.dart';

final pdfRepositoryProvider = Provider<PdfRepository>(
  (ref) => PdfRepositoryImpl(createHttpClient()),
);

/// URL pública del PDF según idioma.
final pdfUrlProvider =
    FutureProvider.family<String, String>((ref, langCode) async {
  final repo = ref.watch(pdfRepositoryProvider);
  return repo.getPdfUrl(langCode);
});
