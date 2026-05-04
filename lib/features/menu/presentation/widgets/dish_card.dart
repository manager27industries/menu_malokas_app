import 'package:flutter/material.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/badge_3D.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/dish_thumbnail.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/dish.dart';

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
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleCtrl;
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _scaleCtrl.reverse();
  void _onTapUp(_) {
    _scaleCtrl.forward();
    widget.onTap();
  }
  void _onTapCancel() => _scaleCtrl.forward();

  @override
  Widget build(BuildContext context) {
    final t = widget.dish.translate(widget.lang);
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 156,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: AppColors.coffeeDark.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Row(
              children: [
                SizedBox(
                  width: 148,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DishThumbnail(imagePath: widget.dish.imagePath),
                      if (widget.dish.has3dModel)
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: Badge3D(),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.dish.category.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 10,
                            letterSpacing: 1.4,
                            color: AppColors.earth,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          t.name,
                          style: theme.textTheme.headlineMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs + 2),
                        Text(
                          t.shortDescription,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.md),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: AppColors.earth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




