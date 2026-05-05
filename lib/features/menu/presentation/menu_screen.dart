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
        toolbarHeight: 84,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Builder(builder: (context) {
          final screenW = MediaQuery.sizeOf(context).width;
          final maxW = screenW > 900
              ? (screenW * 0.86).clamp(0.0, 960.0)
              : 680.0;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPaddingMobile),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Raíces Restaurante',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 24,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Menú digital',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 11,
                                  letterSpacing: 2.0,
                                  color: const Color(0xFFB7906C),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const LanguageToggleButton(),
                  ],
                ),
              ),
            ),
          );
        }),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x00DCCEBE),
                  Color(0xFFDCCEBE),
                  Color(0x00DCCEBE),
                ],
              ),
            ),
          ),
        ),
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

