part of 'dish_detail_screen.dart';

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.dish,
    required this.lang,
    required this.showBackButton,
    this.roundedTop = false,
  });

  final Dish dish;
  final String lang;
  final bool showBackButton;
  final bool roundedTop;

  @override
  Widget build(BuildContext context) {
    final t = dish.translate(lang);
    final theme = Theme.of(context);
    final topRadius = roundedTop ? const Radius.circular(28) : Radius.zero;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: topRadius,
          topRight: topRadius,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: roundedTop ? AppSpacing.xl : AppSpacing.xxl,
                left: AppSpacing.xl,
                right: AppSpacing.xl,
                bottom: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (roundedTop)
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  if (!roundedTop)
                    Row(
                      children: [
                        _FloatingBackButton(dark: true),
                        const Spacer(),
                        const LanguageToggleButton(),
                      ],
                    ),
                  if (!roundedTop) const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 4,
                      vertical: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sandLight,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      dish.category.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        color: AppColors.coffeeDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(t.name, style: theme.textTheme.headlineLarge),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 56,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.earth, AppColors.coffeeDark],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(t.fullDescription, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: AppSpacing.lg),
                  if (dish.has3dModel) _Badge3DHint(),
                ],
              ),
            ),
          ),
          // Decoración: planta saliendo de la esquina inferior derecha
          Positioned(
            bottom: -40,
            right: -40,
            child: IgnorePointer(
              child: SvgPicture.asset(
                'assets/images/svg/platas.svg',
                width: 200,
                colorFilter: ColorFilter.mode(
                  AppColors.darkGreen.withValues(alpha: 0.10),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge3DHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.darkGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.view_in_ar_rounded,
              size: 16, color: AppColors.darkGreen),
          const SizedBox(width: AppSpacing.xs + 2),
          Flexible(
            child: Text(
              'Modelo 3D interactivo · arrastra para rotar',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.darkGreen,
                    fontSize: 12,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
