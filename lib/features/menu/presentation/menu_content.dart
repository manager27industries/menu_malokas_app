

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menu_malokas/core/constants/app_spacing.dart';
import 'package:menu_malokas/features/menu/presentation/menu_viewmodel.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/category_filter.dart';
import 'package:menu_malokas/features/menu/presentation/widgets/dish_card.dart';

class MenuContent extends ConsumerWidget {
   const MenuContent({super.key, required this.state, required this.lang});

  final MenuState state;
  final String lang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishes = state.filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        if (state.categories.isNotEmpty)
          CategoryFilter(
            categories: state.categories,
            selected: state.selectedCategory,
            onSelected: (cat) =>
                ref.read(menuViewModelProvider.notifier).selectCategory(cat),
          ),
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
              return DishCard(
                dish: dish,
                lang: lang,
                onTap: () => context.go('/menu/${dish.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
