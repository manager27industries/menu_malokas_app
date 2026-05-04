import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/badge_3d.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/dish_thumbnail.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/dish.dart';

/// Card premium horizontal para la lista del menú.
///
/// Características:
/// - Hero animation en imagen (tag: 'dish-image-{id}')
/// - Press: scale 0.97 + sombra reducida (feedback táctil sutil)
/// - Línea decorativa tierra bajo el nombre del plato
/// - Overlay oscuro 6% sobre la imagen para contraste
/// - Badge 3D sobre imagen cuando aplica
class DishCard extends StatefulWidget {
  const DishCard({
    super.key,
    required this.dish,
    required this.lang,
    required this.onTap,
  });

  final Dish dish;
  final String lang;
  final VoidCallback onTap;

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _pressed = true);
    _ctrl.reverse();
  }

  void _onTapUp(_) {
    setState(() => _pressed = false);
    _ctrl.forward();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
    _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.dish.translate(widget.lang);
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Transform.scale(
          scale: _ctrl.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 166,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFDFC),
                Color(0xFFFFFAF6),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.divider),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: AppColors.coffeeDark.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.coffeeDark.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
              children: [
                // SVG decorativo en esquina inferior derecha
                Positioned(
                  bottom: -28,
                  right: -28,
                  child: IgnorePointer(
                    child: SvgPicture.asset(
                      'assets/images/svg/platas.svg',
                      width: 110,
                      colorFilter: ColorFilter.mode(
                        AppColors.darkGreen.withValues(alpha: 0.08),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                // ── Imagen con Hero ────────────────────────────────────────
                SizedBox(
                  width: 146,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'dish-image-${widget.dish.id}',
                        child: DishThumbnail(imagePath: widget.dish.imagePath),
                      ),
                      // Overlay oscuro sutil para contraste
                      Container(
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                      // Brillo diagonal sutil para evitar look plano
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.16),
                                Colors.white.withValues(alpha: 0.02),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.dish.has3dModel)
                        const Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: Badge3D(),
                        ),
                    ],
                  ),
                ),
                // ── Contenido textual ──────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      14,
                      AppSpacing.sm,
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Categoría — label pequeño tierra
                        Text(
                          widget.dish.category.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.8,
                            color: AppColors.earth,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Nombre del plato — serif semibold
                        Text(
                          t.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Línea decorativa tierra
                        Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 8),
                          child: SizedBox(
                            width: 28,
                            height: 1.5,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.earth.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ),
                        // Descripción corta
                        Text(
                          t.shortDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // Flecha sutil
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.darkGreen.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




