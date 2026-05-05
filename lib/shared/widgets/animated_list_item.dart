import 'package:flutter/material.dart';

/// Envuelve cualquier widget con una entrada animada: fade + slide desde abajo.
///
/// Uso:
/// ```dart
/// AnimatedListItem(
///   index: i,          // delay escalonado automático
///   child: DishCard(...),
/// )
/// ```
class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.delayBase = const Duration(milliseconds: 20),
  });

  final int index;
  final Widget child;

  /// Intervalo base de delay entre ítems. El delay total = index * delayBase.
  final Duration delayBase;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _scale = Tween<double>(begin: 0.94, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    // Slide vertical mínimo para scroll rápido
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Stagger máx 2 ítems (40 ms) — el resto aparece casi al instante
    final clampedIndex = widget.index.clamp(0, 2);
    Future.delayed(widget.delayBase * clampedIndex, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(
          scale: _scale,
          alignment: Alignment.topCenter,
          child: widget.child,
        ),
      ),
    );
  }
}
