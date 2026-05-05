import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';
import '../domain/upload_state.dart';
import '../../pdf/presentation/pdf_providers.dart';
import '../../pdf/domain/pdf_repository.dart';
import 'pdf_file_picker_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'pdf_file_picker_web.dart';

// ── Auth ─────────────────────────────────────────────────────────────────────

final supabaseAuthClientProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(supabaseAuthClientProvider)),
);

final authStateProvider = StreamProvider<bool>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// ── Upload notifier ───────────────────────────────────────────────────────────

class UploadNotifier extends StateNotifier<UploadState> {
  UploadNotifier(this._pdfRepo, this._ref) : super(const UploadIdle());

  final PdfRepository _pdfRepo;
  final Ref _ref;

  Future<void> pick(String langCode) async {
    state = const UploadLoading();
    try {
      final Uint8List? bytes = await pickPdfBytes();
      if (bytes == null) {
        state = const UploadIdle();
        return;
      }
      await _pdfRepo.uploadPdf(langCode, bytes);
      // Invalida el caché para que el FAB obtenga la URL actualizada.
      _ref.invalidate(pdfUrlProvider(langCode));
      state = const UploadSuccess();
    } catch (e) {
      state = UploadError(e.toString());
    }
  }

  void reset() => state = const UploadIdle();
}

final uploadEsProvider =
    StateNotifierProvider.autoDispose<UploadNotifier, UploadState>(
  (ref) => UploadNotifier(ref.watch(pdfRepositoryProvider), ref),
);

final uploadEnProvider =
    StateNotifierProvider.autoDispose<UploadNotifier, UploadState>(
  (ref) => UploadNotifier(ref.watch(pdfRepositoryProvider), ref),
);
