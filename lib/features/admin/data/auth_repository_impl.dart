import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_repository.dart';

/// Implementación de [AuthRepository] usando Supabase Auth.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AuthExceptionApp(_mapError(e.message));
    }
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Stream<bool> get authStateChanges =>
      _client.auth.onAuthStateChange.map((e) => e.session != null);

  String _mapError(String message) {
    final m = message.toLowerCase();
    if (m.contains('invalid login')) return 'Email o contraseña incorrectos.';
    if (m.contains('email not confirmed')) return 'Confirma tu email primero.';
    if (m.contains('too many requests')) return 'Demasiados intentos. Espera un momento.';
    return 'Error de autenticación. Intenta de nuevo.';
  }
}
