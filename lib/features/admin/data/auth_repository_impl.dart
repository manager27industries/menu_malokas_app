import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_config.dart';
import '../domain/auth_repository.dart';

/// Login contra `/api/login` (cookie HttpOnly en el mismo dominio).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client) {
    unawaited(_refresh());
  }

  final http.Client _client;
  final _controller = StreamController<bool>.broadcast();
  bool _authed = false;
  bool _ready = false;

  Future<void> _refresh() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/api/session'),
      );
      if (response.statusCode != 200) {
        _authed = false;
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        _authed = body['ok'] == true;
      }
    } catch (_) {
      _authed = false;
    }
    _ready = true;
    _controller.add(_authed);
  }

  @override
  Future<void> signIn(String email, String password) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      String message = 'Email o contraseña incorrectos.';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        message = (body['error'] as String?) ?? message;
      } catch (_) {}
      throw AuthExceptionApp(message);
    }
    _authed = true;
    _controller.add(true);
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.post(Uri.parse('${ApiConfig.baseUrl}/api/logout'));
    } catch (_) {}
    _authed = false;
    _controller.add(false);
  }

  @override
  Stream<bool> get authStateChanges async* {
    if (!_ready) {
      await _refresh();
    }
    yield _authed;
    yield* _controller.stream;
  }
}
