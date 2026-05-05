

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_malokas/core/constants/app_spacing.dart';
import 'package:menu_malokas/features/menu/presentation/menu_viewmodel.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/dish_card.dart';
import 'package:menu_malokas/shared/widgets/animated_list_item.dart';
import 'package:menu_malokas/shared/widgets/decorative_background.dart';

class MenuContent extends ConsumerWidget {
  const MenuContent({super.key, required this.state, required this.lang});

  final MenuState state;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishes = state.filtered;
    final screenW = MediaQuery.sizeOf(context).width;
    final maxW = screenW > 900
        ? (screenW * 0.86).clamp(0.0, 960.0)
        : 680.0;

    return Stack(
      children: [
        // Formas orgánicas decorativas de fondo (fondo completo)
        const DecorativeBackground(opacity: 0.06),
        // Contenido centrado con ancho máximo para tablet/web
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPaddingMobile,
                      vertical: AppSpacing.lg,
                    ),
                    itemCount: dishes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) {
                      final dish = dishes[i];
                      return AnimatedListItem(
                        index: i,
                        child: DishCard(
                          dish: dish,
                          lang: lang,
                          onTap: () => context.go('/menu/${dish.id}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
