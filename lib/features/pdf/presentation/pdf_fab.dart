import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_spacing.dart';

class PdfFab extends ConsumerWidget {
  const PdfFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _openPdf(context),
      backgroundColor: AppColors.darkGreen,
      foregroundColor: AppColors.textOnDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.fab),
      ),
      icon: const Icon(Icons.picture_as_pdf_outlined),
      label: const Text('Menú PDF'),
    );
  }

  Future<void> _openPdf(BuildContext context) async {
    final uri = Uri.parse(AppConfig.menuPdfUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el menú PDF')),
        );
      }
    }
  }
}
