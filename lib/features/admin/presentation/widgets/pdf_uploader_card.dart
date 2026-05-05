import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../pdf/presentation/pdf_providers.dart';
import '../admin_providers.dart';
import '../../domain/upload_state.dart';

/// Tarjeta de subida de PDF para un idioma específico.
///
/// Muestra el estado actual del PDF en Storage y permite
/// seleccionar y subir un nuevo archivo.
class PdfUploaderCard extends ConsumerWidget {
  const PdfUploaderCard({
    super.key,
    required this.langCode,
    required this.flag,
    required this.label,
  });

  final String langCode;
  final String flag;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadProvider =
        langCode == 'es' ? uploadEsProvider : uploadEnProvider;
    final uploadState = ref.watch(uploadProvider);
    final pdfUrl = ref.watch(pdfUrlProvider(langCode));

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: AppColors.darkGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreen,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Estado actual del PDF en Storage
            pdfUrl.when(
              loading: () => const Text('Verificando PDF en Storage…',
                  style: TextStyle(color: Colors.grey)),
              error: (_, _) => Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text('Sin PDF subido aún',
                      style: TextStyle(color: Colors.orange.shade700)),
                ],
              ),
              data: (_) => Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  const Text('PDF disponible cargado',
                      style: TextStyle(color: Colors.green)),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Botón y feedback de subida
            _UploadButton(
              langCode: langCode,
              state: uploadState,
              onTap: () {
                ref.read(uploadProvider.notifier).pick(langCode);
              },
              onReset: () {
                ref.read(uploadProvider.notifier).reset();
                // Refresca el estado del PDF en Storage
                ref.invalidate(pdfUrlProvider(langCode));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.langCode,
    required this.state,
    required this.onTap,
    required this.onReset,
  });

  final String langCode;
  final UploadState state;
  final VoidCallback onTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      UploadIdle() => FilledButton.icon(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkGreen,
            minimumSize: const Size(double.infinity, 48),
          ),
          icon: const Icon(Icons.upload_file, color: Colors.white),
          label: const Text('Seleccionar PDF',
              style: TextStyle(color: Colors.white)),
        ),
      UploadLoading() => const Center(
          child: CircularProgressIndicator(color: AppColors.darkGreen),
        ),
      UploadSuccess() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('¡PDF subido correctamente!',
                    style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: onReset,
              child: const Text('Subir otro'),
            ),
          ],
        ),
      UploadError(:final message) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(message,
                      style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: onReset,
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
    };
  }
}
