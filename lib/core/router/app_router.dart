import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import '../../features/menu/presentation/menu_screen.dart';
import '../../features/dish_detail/presentation/dish_detail_screen.dart';
import '../../features/admin/presentation/admin_screen.dart';

/// Rutas de la app Raíces.
///
/// /          → redirect a /menu
/// /menu      → MenuScreen
/// /menu/:id  → DishDetailScreen
/// /admin     → AdminScreen (panel de subida de PDFs)
final appRouter = GoRouter(
  initialLocation: '/menu',
  routes: [
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
      routes: [
        GoRoute(
          path: ':dishId',
          builder: (_, state) {
            final dishId = state.pathParameters['dishId']!;
            return DishDetailScreen(dishId: dishId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      // Solo accesible en web — en móvil/tablet redirige al menú
      redirect: (_, _) => kIsWeb ? null : '/menu',
      builder: (_, _) => const AdminScreen(),
    ),
  ],
);
