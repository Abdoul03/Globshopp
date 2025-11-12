import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/tokenPair.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  final storage = FlutterSecureStorage();

  Future<http.Response> requestWithAuthentification(
    String method,
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    Duration? timeout,
  }) async {
    String? token = await getAccessToken();

    Uri buildUri() {
      final base = endpoint.startsWith('http')
          ? endpoint
          : '${Constant.remoteUrl}$endpoint';
      if (queryParameters == null || queryParameters.isEmpty) {
        return Uri.parse(base);
      } else {
        return Uri.parse(base).replace(queryParameters: queryParameters);
      }
    }

    Uri url = buildUri();

    // Préparer headers par défaut + fusion des headers utilisateur
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    // Encodage du body si nécessaire
    Object? encodedBody;
    if (body != null) {
      if (body is String) {
        encodedBody = body;
      } else if (body is Map || body is List) {
        encodedBody = jsonEncode(body);
      } else {
        // Laisser tel quel pour d'autres types (ex: déjà encodé)
        encodedBody = body;
      }
    }

    Future<http.Response> sendRequest(Map<String, String> hdrs) {
      final methodUpper = method.toUpperCase();
      switch (methodUpper) {
        case 'GET':
          return http
              .get(url, headers: hdrs)
              .timeout(timeout ?? const Duration(seconds: 30));
        case 'POST':
          return http
              .post(url, headers: hdrs, body: encodedBody)
              .timeout(timeout ?? const Duration(seconds: 30));
        case 'PUT':
          return http
              .put(url, headers: hdrs, body: encodedBody)
              .timeout(timeout ?? const Duration(seconds: 30));
        case 'DELETE':
          return http
              .delete(url, headers: hdrs, body: encodedBody)
              .timeout(timeout ?? const Duration(seconds: 30));
        case 'PATCH':
          return http
              .patch(url, headers: hdrs, body: encodedBody)
              .timeout(timeout ?? const Duration(seconds: 30));
        default:
          throw ArgumentError('Méthode HTTP non supportée: $method');
      }
    }

    try {
      // Premier essai
      final response = await sendRequest(requestHeaders);

      if (response.statusCode != 401) {
        return response;
      }

      // Si 401 : on tente de rafraîchir le token
      final refreshed =
          await refreshToken(); // retourne un objet ou null selon ton implémentation
      if (refreshed == null) {
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      }

      // Utiliser le nouveau token pour retenter la requête
      final newToken = refreshed.accessToken ?? await getAccessToken();
      final retryHeaders = {
        ...requestHeaders,
        'Authorization': 'Bearer $newToken',
      };

      final retryResponse = await sendRequest(retryHeaders);

      // Si encore 401, on jette une exception pour forcer la reconnexion
      if (retryResponse.statusCode == 401) {
        throw Exception(
          'Session expirée après tentative de rafraîchissement. Veuillez vous reconnecter.',
        );
      }

      return retryResponse;
    } on http.ClientException catch (e) {
      // Erreurs réseau (client)
      rethrow;
    } on Exception {
      rethrow;
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future<TokenPair?> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return null;

    final response = await http.post(
      Uri.parse('${Constant.remoteUrl}/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: refresh,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);
        return TokenPair(accessToken: accessToken, refreshToken: refreshToken);
      }
    }

    return null;
  }
}
