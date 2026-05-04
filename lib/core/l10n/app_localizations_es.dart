// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Raíces';

  @override
  String get menuTitle => 'Nuestro Menú';

  @override
  String get allCategories => 'Todos';

  @override
  String get dishDetailTitle => 'Detalle del plato';

  @override
  String get downloadMenu => 'Descargar Menú';

  @override
  String get downloadError => 'No se pudo abrir el menú PDF';

  @override
  String get languageButton => 'EN';

  @override
  String get loading => 'Cargando…';

  @override
  String get errorLoadingMenu => 'Error al cargar el menú';
}
