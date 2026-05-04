import 'package:flutter/material.dart';

class GradientPlaceholder extends StatelessWidget {
  const GradientPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C1A0E), Color(0xFF7A5030)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          size: 38,
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}
