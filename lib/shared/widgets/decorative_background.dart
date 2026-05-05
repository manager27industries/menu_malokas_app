import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

/// Widget decorativo reutilizable que posiciona motivos tropicales SVG
/// en las esquinas del fondo — opacidad muy baja para no interferir con
/// el contenido.
///
/// Uso (dentro de un Stack):
/// ```dart
/// Stack(children: [
///   const DecorativeBackground(),
///   // ... tu contenido
/// ])
/// ```
class DecorativeBackground extends StatelessWidget {
  const DecorativeBackground({
    super.key,
    this.enabled = true,
    this.color,
    this.opacity = 0.07,
  });

  /// Permite desactivar el decorado fácilmente.
  final bool enabled;

  /// Color base de las formas. Por defecto usa [AppColors.darkGreen].
  final Color? color;

  /// Opacidad global (0.0 – 1.0). Recomendado: 0.05 – 0.10.
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();

    final baseColor = (color ?? AppColors.darkGreen).withValues(alpha: opacity);
    final filterSimple = ColorFilter.mode(baseColor, BlendMode.srcIn);

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // ── Top-left: planta 1 (platas — fill negro, srcIn funciona) ──
            Positioned(
              top: -40,
              left: -30,
              child: Transform.rotate(
                angle: 0.3,
                child: SvgPicture.asset(
                  'assets/images/svg/platas.svg',
                  width: 220,
                  colorFilter: filterSimple,
                ),
              ),
            ),

            // ── Bottom-right: planta 2 (ramita — SVG con colores, usar Opacity) ──
            Positioned(
              bottom: -30,
              right: -30,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: -0.4,
                  child: SvgPicture.asset(
                    'assets/images/svg/planta2.svg',
                    width: 200,
                  ),
                ),
              ),
            ),

            // ── Bottom-left: planta 3 (hoja — SVG con colores, usar Opacity) ──
            Positioned(
              bottom: -20,
              left: -20,
              child: Opacity(
                opacity: opacity,
                child: Transform.rotate(
                  angle: 0.5,
                  child: SvgPicture.asset(
                    'assets/images/svg/planta3.svg',
                    width: 180,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

