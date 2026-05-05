import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/app_colors.dart';

/// Panel flotante con WebView que muestra el PDF via Google Docs Viewer.
/// Solo se usa en plataformas nativas (Android/iOS).
class PdfViewerMobileDialog extends StatefulWidget {
  const PdfViewerMobileDialog({
    super.key,
    required this.url,
    required this.title,
  });

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
      builder: (_) => PdfViewerMobileDialog(url: url, title: title),
    );
  }

  @override
  State<PdfViewerMobileDialog> createState() => _PdfViewerMobileDialogState();
}

class _PdfViewerMobileDialogState extends State<PdfViewerMobileDialog> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final viewerUrl =
        'https://docs.google.com/viewer?url=${Uri.encodeComponent(widget.url)}&embedded=true';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
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
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.textOnDark, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
              ),

              // ── WebView ──────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller),
                    if (_loading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkGreen,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
