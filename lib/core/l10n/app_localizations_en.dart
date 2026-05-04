// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Raíces';

  @override
  String get menuTitle => 'Our Menu';

  @override
  String get allCategories => 'All';

  @override
  String get dishDetailTitle => 'Dish Detail';

  @override
  String get downloadMenu => 'Download Menu';

  @override
  String get downloadError => 'Could not open the menu PDF';

  @override
  String get languageButton => 'ES';

  @override
  String get loading => 'Loading…';

  @override
  String get errorLoadingMenu => 'Error loading the menu';
}
