import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/dish.dart';

/// Único punto de acceso a los datos del menú.
/// Lee el JSON local y devuelve la lista de [Dish].
class MenuRepository {
  const MenuRepository();

  Future<List<Dish>> fetchDishes() async {
    final raw = await rootBundle.loadString('assets/data/dishes.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = json['dishes'] as List<dynamic>;
    return list
        .map((e) => Dish.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }
}

/// Provider del repositorio. Singleton sin estado propio.
final menuRepositoryProvider = Provider<MenuRepository>(
  (_) => const MenuRepository(),
);
