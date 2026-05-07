import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/locale_provider.dart';
import 'pdf_providers.dart';
import 'pdf_viewer_dialog.dart';

/// FAB premium para abrir el menú PDF desde Firebase Storage.
///
/// Obtiene la URL de descarga vigente vía [pdfUrlProvider] y la abre:
///   • Android → Google Docs Viewer (dentro de la app)
///   • Web     → nueva pestaña del navegador
class PdfFab extends ConsumerStatefulWidget {
  const PdfFab({super.key});

  @override
  ConsumerState<PdfFab> createState() => _PdfFabState();
}

class _PdfFabState extends ConsumerState<PdfFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _schedulePulse();
  }

  void _schedulePulse() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      _pulseCtrl.forward().then((_) {
        if (!mounted) return;
        _pulseCtrl.reverse().then((_) => _schedulePulse());
      });
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _openPdf(String lang) async {
    late final String url;
    try {
      url = await ref.refresh(pdfUrlProvider(lang).future);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('El menú PDF aún no está disponible.')),
        );
      }
      return;
    }

    if (!mounted) return;

    final title = lang == 'en' ? 'PDF Menu' : 'Menú PDF';
    await PdfViewerDialog.show(context, url: url, title: title);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).valueOrNull?.languageCode ?? 'es';
    final label = lang == 'en' ? 'PDF Menu' : 'Menú PDF';
    // Pre-carga la URL para que esté lista al tocar y calienta caché en web.
    final pdfUrlAsync = ref.watch(pdfUrlProvider(lang));
    pdfUrlAsync.whenData(PdfViewerDialog.warmupWebPdf);

    return ScaleTransition(
      scale: _pulseAnim,
      child: GestureDetector(
        onTap: () => _openPdf(lang),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.darkGreen,
            borderRadius: BorderRadius.circular(AppRadius.fab),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkGreen.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -math.pi / 180 * 5,
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.textOnDark,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textOnDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
