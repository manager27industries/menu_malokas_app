/// Contrato del repositorio de autenticación del admin.
abstract class AuthRepository {
  /// Inicia sesión con email y contraseña.
  /// Lanza [AuthException] en caso de error.
  Future<void> signIn(String email, String password);

  /// Cierra la sesión actual.
  Future<void> signOut();

  /// Emite [true] si hay un usuario autenticado, [false] en caso contrario.
  Stream<bool> get authStateChanges;
}

class AuthExceptionApp implements Exception {
  const AuthExceptionApp(this.message);
  final String message;

  @override
  String toString() => message;
}
