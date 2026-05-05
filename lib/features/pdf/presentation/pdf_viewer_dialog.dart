import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'pdf_viewer_impl_stub.dart'
    // ignore: uri_does_not_exist
    if (dart.library.html) 'pdf_viewer_impl_web.dart';

/// Panel flotante que renderiza un PDF con un <iframe> (solo web).
/// Se muestra centrado con esquinas redondeadas, dejando visible el fondo.
class PdfViewerDialog extends StatefulWidget {
  const PdfViewerDialog({super.key, required this.url, required this.title});

  final String url;
  final String title;

  static Future<void> show(
    BuildContext context, {
    required String url,
    required String title,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => PdfViewerDialog(url: url, title: title),
    );
  }

  @override
  State<PdfViewerDialog> createState() => _PdfViewerDialogState();
}

class _PdfViewerDialogState extends State<PdfViewerDialog> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'pdf-viewer-${widget.url.hashCode.abs()}';
    registerPdfView(_viewId, widget.url);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final isMobile = size.width < 600;
    final hPad = isMobile ? 8.0 : size.width * 0.04;
    final vPad = isMobile ? 12.0 : size.height * 0.04;
    final dialogW = size.width - hPad * 2;
    final dialogH = size.height - vPad * 2;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: vPad,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        child: SizedBox(
          width: dialogW,
          height: dialogH,
          child: Column(
            children: [
              // ── Barra de título ──────────────────────────────────────
              Container(
                height: 52,
                color: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.textOnDark,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.textOnDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textOnDark, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Cerrar',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // ── iframe PDF ───────────────────────────────────────────
              Expanded(child: buildPdfView(_viewId)),
            ],
          ),
        ),
      ),
    );
  }
}
