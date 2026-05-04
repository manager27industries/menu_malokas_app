part of 'dish_detail_screen.dart';

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.dish,
    required this.lang,
    required this.fade,
    required this.slide,
  });

  final Dish dish;
  final String lang;
  final Animation<double> fade;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width > 720;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: isWide
          ? _WideLayout(dish: dish, lang: lang, fade: fade, slide: slide)
          : _NarrowLayout(dish: dish, lang: lang, fade: fade, slide: slide),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.dish,
    required this.lang,
    required this.fade,
    required this.slide,
  });

  final Dish dish;
  final String lang;
  final Animation<double> fade;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 55,
          child: Stack(
            children: [
              _ModelStage(
                glbAssetPath: dish.glbAssetPath,
                dishName: dish.translate(lang).name,
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSpacing.md,
                left: AppSpacing.md,
                child: _FloatingBackButton(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 45,
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: _InfoPanel(
                dish: dish,
                lang: lang,
                showBackButton: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.dish,
    required this.lang,
    required this.fade,
    required this.slide,
  });

  final Dish dish;
  final String lang;
  final Animation<double> fade;
  final Animation<Offset> slide;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: screenH * 0.40,
          child: _ModelStage(
            glbAssetPath: dish.glbAssetPath,
            dishName: dish.translate(lang).name,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: screenH * 0.50,
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: _InfoPanel(
                dish: dish,
                lang: lang,
                showBackButton: false,
                roundedTop: true,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
          left: AppSpacing.md,
          child: _FloatingBackButton(),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
          right: AppSpacing.md,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const LanguageToggleButton(),
          ),
        ),
      ],
    );
  }
}
