import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/tokenPair.dart';
import 'package:http/http.dart' as http;

class Authentification {
  final storage = FlutterSecureStorage();

  Future<TokenPair> connexion(String identifiant, String motDePasse) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"identifiant": identifiant, "motDePasse": motDePasse}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken == null || refreshToken == null) {
        throw Exception("Tokens manquants dans la réponse serveur.");
      }

      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      return TokenPair(accessToken: accessToken, refreshToken: refreshToken);
    } else {
      // Try to parse a helpful message from the response body (JSON) and throw it
      String message;
      try {
        final bodyJson = jsonDecode(response.body);
        if (bodyJson is Map && bodyJson['message'] != null) {
          message = bodyJson['message'].toString();
        } else if (bodyJson is Map && bodyJson['error'] != null) {
          message = bodyJson['error'].toString();
        } else {
          message = response.body.toString();
        }
      } catch (_) {
        message = response.body.toString();
      }

      throw Exception(message);
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }

  /// Méthode pour faire des requêtes HTTP avec injection du token et rafraîchissement automatique
  Future<http.Response> getWithAuth(String endpoint) async {
    String? token = await getAccessToken();
    final url = Uri.parse('${Constant.remoteUrl}$endpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      // Token expiré : essaye de le rafraîchir
      final refreshed = await refreshToken();
      if (refreshed != null) {
        return await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${refreshed.accessToken}',
          },
        );
      } else {
        throw Exception('Session expirée. Veuillez vous reconnecter.');
      }
    }

    return response;
  }

  /// Rafraîchissement automatique du token
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
