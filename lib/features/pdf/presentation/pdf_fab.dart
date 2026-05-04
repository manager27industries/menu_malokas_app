import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_spacing.dart';

/// FAB premium para abrir el menú PDF.
///
/// Incluye un pulse suave (escala 1.0 → 1.04) que se repite cada 3 s para
/// llamar la atención sin resultar molesto.
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

    // Pulso cada 3 s: forward → reverse → espera
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

  Future<void> _openPdf() async {
    final uri = Uri.parse(AppConfig.menuPdfUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el menú PDF')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: GestureDetector(
        onTap: _openPdf,
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
              const Text(
                'Menú PDF',
                style: TextStyle(
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
