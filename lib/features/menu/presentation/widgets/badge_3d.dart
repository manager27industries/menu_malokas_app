import 'package:flutter/material.dart';
import 'package:menu_malokas/core/constants/app_colors.dart';

class Badge3D extends StatelessWidget {
  const Badge3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.darkGreen.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.view_in_ar_rounded, size: 10, color: Colors.white),
          SizedBox(width: 3),
          Text(
            '3D',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
