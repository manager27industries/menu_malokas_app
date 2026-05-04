import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Widget decorativo reutilizable que pinta formas orgánicas (hojas/curvas)
/// en las esquinas del fondo — opacidad muy baja para no interferir con
/// el contenido.
///
/// Uso:
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

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _OrganicShapesPainter(color: baseColor),
        ),
      ),
    );
  }
}

class _OrganicShapesPainter extends CustomPainter {
  const _OrganicShapesPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // ── Hoja top-right ────────────────────────────────────────────────────
    _drawLeaf(
      canvas,
      paint,
      center: Offset(size.width + 10, -20),
      width: 130,
      height: 200,
      rotation: -0.6,
    );

    // ── Hoja bottom-left ──────────────────────────────────────────────────
    _drawLeaf(
      canvas,
      paint,
      center: Offset(-20, size.height + 10),
      width: 110,
      height: 180,
      rotation: 2.4,
    );

    // ── Círculo difuminado top-left (elemento sutil de fondo) ─────────────
    _drawBlob(
      canvas,
      paint,
      center: Offset(size.width * 0.08, size.height * 0.12),
      radius: 70,
    );
  }

  /// Dibuja una forma de hoja (bezier cúbico simétrico).
  void _drawLeaf(
    Canvas canvas,
    Paint paint, {
    required Offset center,
    required double width,
    required double height,
    required double rotation,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final path = Path();
    final hw = width / 2;
    final hh = height / 2;

    path.moveTo(0, -hh);
    path.cubicTo(hw, -hh * 0.5, hw, hh * 0.5, 0, hh);
    path.cubicTo(-hw, hh * 0.5, -hw, -hh * 0.5, 0, -hh);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  /// Dibuja un círculo difuso (blob) con Paint de bajo alpha para refuerzo.
  void _drawBlob(Canvas canvas, Paint paint,
      {required Offset center, required double radius}) {
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_OrganicShapesPainter oldDelegate) =>
      oldDelegate.color != color;
}
