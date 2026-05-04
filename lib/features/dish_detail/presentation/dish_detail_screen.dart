import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../features/menu/domain/dish.dart';
import '../../../features/menu/presentation/menu_viewmodel.dart';
import '../../../shared/widgets/language_toggle_button.dart';
import 'widgets/dish_3d_viewer.dart';

part 'dish_detail_content.dart';
part 'dish_info_panel.dart';
part 'dish_detail_components.dart';

class DishDetailScreen extends ConsumerStatefulWidget {
  const DishDetailScreen({super.key, required this.dishId});
  final String dishId;

  @override
  ConsumerState<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends ConsumerState<DishDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Arranca la animaciÃ³n tras un breve delay para que el 3D empiece a cargar
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuAsync = ref.watch(menuViewModelProvider);
    final lang = ref.watch(localeProvider).valueOrNull?.languageCode ?? 'es';

    return menuAsync.when(
      loading: () => const _LoadingDetail(),
      error: (e, _) => const _ErrorDetail(),
      data: (state) {
        final dish = state.dishes.where((d) => d.id == widget.dishId).firstOrNull;
        if (dish == null) return const _ErrorDetail();

        return _DetailContent(
          dish: dish,
          lang: lang,
          fade: _fade,
          slide: _slide,
        );
      },
    );
  }
}


