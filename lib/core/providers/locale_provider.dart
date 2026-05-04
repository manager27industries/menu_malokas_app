import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'selected_locale';

/// Notifier que gestiona el Locale activo de la app.
/// Persiste la selección en SharedPreferences.
class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLocaleKey);
    if (saved != null) return Locale(saved);
    return const Locale('es');
  }

  /// Alterna entre español e inglés.
  Future<void> toggle() async {
    final current = state.valueOrNull ?? const Locale('es');
    final next = current.languageCode == 'es'
        ? const Locale('en')
        : const Locale('es');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, next.languageCode);
    state = AsyncData(next);
  }

  /// Establece un idioma específico.
  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, locale.languageCode);
    state = AsyncData(locale);
  }
}

/// Provider global del locale. Úsalo con ref.watch en MaterialApp.
final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
