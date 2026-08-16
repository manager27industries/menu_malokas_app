import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_config.dart';
import '../domain/pdf_repository.dart';

/// PDFs en Vercel Blob (`/api/pdf`).
class PdfRepositoryImpl implements PdfRepository {
  PdfRepositoryImpl(this._client);

  final http.Client _client;

  Uri _uri(String langCode) => Uri.parse(
        '${ApiConfig.baseUrl}/api/pdf?lang=${langCode == 'en' ? 'en' : 'es'}',
      );

  @override
  Future<String> getPdfUrl(String langCode) async {
    final response = await _client.get(_uri(langCode));
    if (response.statusCode == 404) {
      throw PdfNotFoundException(langCode);
    }
    if (response.statusCode != 200) {
      throw Exception(_apiError(response, 'No se pudo consultar el PDF'));
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final url = body['url'] as String?;
    if (url == null || url.isEmpty) {
      throw PdfNotFoundException(langCode);
    }
    return url;
  }

  @override
  Future<void> uploadPdf(String langCode, Uint8List bytes) async {
    final response = await _client.put(
      _uri(langCode),
      headers: {'Content-Type': 'application/pdf'},
      body: bytes,
    );
    if (response.statusCode == 401) {
      throw Exception('Sesión expirada. Vuelve a iniciar sesión.');
    }
    if (response.statusCode != 200) {
      throw Exception(_apiError(response, 'No se pudo subir el PDF'));
    }
  }

  String _apiError(http.Response response, String fallback) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['error'] is String) {
        return body['error'] as String;
      }
    } catch (_) {}
    return '$fallback (${response.statusCode}).';
  }
}
