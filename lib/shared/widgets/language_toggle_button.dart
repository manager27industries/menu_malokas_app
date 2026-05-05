import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';

/// Botón en el AppBar que alterna el idioma entre ES ↔ EN.
class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider).valueOrNull ?? const Locale('es');
    final isSpanish = locale.languageCode == 'es';

    return InkWell(
      onTap: () => ref.read(localeProvider.notifier).toggle(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: isSpanish ? 1.0 : 0.35,
              child: const Text('🇨🇴', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 6),
            Opacity(
              opacity: isSpanish ? 0.35 : 1.0,
              child: const Text('🇺🇸', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}
