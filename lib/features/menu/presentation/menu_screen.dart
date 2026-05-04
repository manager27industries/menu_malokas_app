import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_malokas/features/menu/presentation/menu_content.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../shared/widgets/language_toggle_button.dart';
import '../../../shared/widgets/loading_placeholder.dart';
import '../../pdf/presentation/pdf_fab.dart';
import 'menu_viewmodel.dart';


class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuViewModelProvider);
    final locale = ref.watch(localeProvider).valueOrNull ?? const Locale('es');
    final lang = locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Raíces Restaurante',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 22,
                    letterSpacing: 3,
                  ),
            ),

          ],
        ),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: const PdfFab(),
      body: menuAsync.when(
        loading: () => const LoadingPlaceholder(),
        error: (e, _) => Center(
          child: Text(
            'Error al cargar el menú',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        data: (state) => MenuContent(state: state, lang: lang),
      ),
    );
  }
}

