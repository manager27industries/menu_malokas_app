part of 'dish_detail_screen.dart';

class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton({this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? Colors.transparent : Colors.black45,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: dark ? AppColors.textPrimary : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _ModelStage extends StatelessWidget {
  const _ModelStage({
    required this.glbAssetPath,
    required this.dishName,
  });

  final String? glbAssetPath;
  final String dishName;

  @override
  Widget build(BuildContext context) {
    final path = glbAssetPath;
    if (path == null || path.isEmpty) {
      return Container(
        color: const Color(0xFF0D0D0D),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_in_ar_rounded,
              size: 52,
              color: Colors.white.withValues(alpha: 0.72),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Modelo 3D no disponible',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
            ),
          ],
        ),
      );
    }

    return Dish3DViewer(
      glbAssetPath: path,
      dishName: dishName,
    );
  }
}

class _LoadingDetail extends StatelessWidget {
  const _LoadingDetail();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      body: Center(
        child: CircularProgressIndicator(color: AppColors.earth),
      ),
    );
  }
}

class _ErrorDetail extends StatelessWidget {
  const _ErrorDetail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.earth, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text('Plato no encontrado',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
