import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import '../../../core/constants/app_colors.dart';
import 'pdf_web_embed_stub.dart' if (dart.library.html) 'pdf_web_embed.dart';

/// Panel flotante que renderiza un PDF de forma nativa con pdfx.
/// Funciona en Android, iOS y Web sin WebView ni iframe.
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

  static Future<void> warmupWebPdf(String url) {
    return _PdfViewerDialogState.warmupWebPdf(url);
  }

  @override
  State<PdfViewerDialog> createState() => _PdfViewerDialogState();
}

class _PdfViewerDialogState extends State<PdfViewerDialog> {
  PdfControllerPinch? _controller;

  static Future<void> warmupWebPdf(String url) async {
    // No-op: en web usamos el visor nativo del navegador con carga progresiva.
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = PdfControllerPinch(
        document: _openNativeDocument(widget.url),
      );
    }
  }

  static Future<PdfDocument> _openNativeDocument(String source) async {
    final uri = Uri.tryParse(source);
    final isRemote = uri != null &&
        (uri.scheme.toLowerCase() == 'http' ||
            uri.scheme.toLowerCase() == 'https');

    if (isRemote) {
      final response = await http.get(uri);
      if (response.statusCode >= 400) {
        throw Exception('No se pudo descargar el PDF (${response.statusCode}).');
      }
      return PdfDocument.openData(response.bodyBytes);
    }

    return PdfDocument.openFile(source);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 600;
    final hPad = isMobile ? 8.0 : size.width * 0.04;
    final vPad = isMobile ? 12.0 : size.height * 0.04;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: hPad,
        vertical: vPad,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        child: SizedBox(
          width: size.width - hPad * 2,
          height: size.height - vPad * 2,
          child: Column(
            children: [
              // ── Barra de título ──────────────────────────────────────
              Container(
                height: 52,
                color: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded,
                        color: AppColors.textOnDark, size: 18),
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
                    // ── Indicador de página ──────────────────────────
                    if (!kIsWeb && _controller != null)
                      PdfPageNumber(
                        controller: _controller!,
                        builder: (_, loadingState, page, pagesCount) {
                          if (loadingState != PdfLoadingState.success) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            '$page / $pagesCount',
                            style: const TextStyle(
                              color: AppColors.textOnDark,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    const SizedBox(width: 8),
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

              // ── Visor PDF nativo ─────────────────────────────────────
              Expanded(
                child: kIsWeb
                    ? PdfWebEmbedView(url: widget.url)
                    : PdfViewPinch(
                        controller: _controller!,
                        scrollDirection: Axis.vertical,
                        maxScale: 20.0,
                        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                          options: const DefaultBuilderOptions(),
                          documentLoaderBuilder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.darkGreen,
                            ),
                          ),
                          pageLoaderBuilder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.darkGreen,
                            ),
                          ),
                          errorBuilder: (_, error) => Center(
                            child: Text('Error: $error',
                                style: const TextStyle(color: Colors.red)),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
