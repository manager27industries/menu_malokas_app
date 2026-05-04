import 'package:flutter/material.dart';

class Dish3DErrorFallback extends StatelessWidget {
  const Dish3DErrorFallback({
    super.key,
    required this.dishName,
  });

  final String dishName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.view_in_ar_rounded,
            size: 56,
            color: Colors.white.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 12),
          Text(
            dishName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Modelo 3D no disponible en este momento',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
