import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/tokenPair.dart';
import 'package:http/http.dart' as http;

class Authentification {
  final storage = FlutterSecureStorage();

  Future<TokenPair> connexion(String identifiant, String motDePasse) async {
    final response = await http
        .post(
          Uri.parse("${Constant.remoteUrl}/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "identifiant": identifiant,
            "motDePasse": motDePasse,
          }),
        )
        .timeout(const Duration(seconds: 10));
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

  Future<void> logout() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
  }
}
