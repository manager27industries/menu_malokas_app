import 'package:flutter/material.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/gradient_placeholder.dart';

class DishThumbnail extends StatelessWidget {
   const DishThumbnail({super.key, required this.imagePath});
  final String imagePath;

  bool get _hasImage =>
      imagePath.isNotEmpty &&
      !imagePath.endsWith('.glb') &&
      !imagePath.endsWith('.gltf');

  @override
  Widget build(BuildContext context) {
    if (_hasImage) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const GradientPlaceholder(),
      );
    }
    return const GradientPlaceholder();
  }
}
  