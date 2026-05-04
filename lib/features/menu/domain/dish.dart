/// Modelo de dominio de un plato del menú.
///
/// - [translations] permite múltiples idiomas (es, en, …).
/// - [has3dModel] y [glbAssetPath] reservan el slot para la iteración 3D.
class Dish {
  const Dish({
    required this.id,
    required this.category,
    required this.imagePath,
    required this.translations,
    this.has3dModel = false,
    this.glbAssetPath,
  });

  final String id;
  final String category;
  final String imagePath;
  final Map<String, DishTranslation> translations;
  final bool has3dModel;
  final String? glbAssetPath;

  /// Devuelve la traducción para [languageCode].
  /// Si no existe, cae al español como idioma base.
  DishTranslation translate(String languageCode) =>
      translations[languageCode] ?? translations['es']!;

  factory Dish.fromJson(Map<String, dynamic> json) {
    final rawTranslations = json['translations'] as Map<String, dynamic>;
    return Dish(
      id: json['id'] as String,
      category: json['category'] as String,
      imagePath: json['imagePath'] as String,
      has3dModel: (json['has3dModel'] as bool?) ?? false,
      glbAssetPath: json['glbAssetPath'] as String?,
      translations: rawTranslations.map(
        (lang, data) => MapEntry(
          lang,
          DishTranslation.fromJson(data as Map<String, dynamic>),
        ),
      ),
    );
  }
}

/// Contenido textual de un plato en un idioma específico.
class DishTranslation {
  const DishTranslation({
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
  });

  final String name;
  final String shortDescription;
  final String fullDescription;

  factory DishTranslation.fromJson(Map<String, dynamic> json) =>
      DishTranslation(
        name: json['name'] as String,
        shortDescription: json['shortDescription'] as String,
        fullDescription: json['fullDescription'] as String,
      );
}
