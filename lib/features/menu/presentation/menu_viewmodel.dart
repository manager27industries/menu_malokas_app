import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/menu_repository.dart';
import '../domain/dish.dart';

/// Estado del menú: lista filtrada por categoría.
class MenuState {
  const MenuState({
    required this.dishes,
    required this.selectedCategory,
  });

  final List<Dish> dishes;
  final String? selectedCategory; // null = todas las categorías

  List<Dish> get filtered => selectedCategory == null
      ? dishes
      : dishes.where((d) => d.category == selectedCategory).toList();

  List<String> get categories =>
      dishes.map((d) => d.category).toSet().toList();

  MenuState copyWith({
    List<Dish>? dishes,
    Object? selectedCategory = _sentinel,
  }) =>
      MenuState(
        dishes: dishes ?? this.dishes,
        selectedCategory: selectedCategory == _sentinel
            ? this.selectedCategory
            : selectedCategory as String?,
      );
}

const _sentinel = Object();

/// ViewModel del menú. Carga el JSON y gestiona el filtro de categorías.
class MenuViewModel extends AsyncNotifier<MenuState> {
  @override
  Future<MenuState> build() async {
    final repo = ref.read(menuRepositoryProvider);
    final dishes = await repo.fetchDishes();
    return MenuState(dishes: dishes, selectedCategory: null);
  }

  void selectCategory(String? category) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedCategory: category));
  }
}

final menuViewModelProvider =
    AsyncNotifierProvider<MenuViewModel, MenuState>(MenuViewModel.new);
