import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:globshopp/_base/constant.dart';
import 'package:globshopp/model/commercant.dart';
import 'package:globshopp/model/fournisseur.dart';
import 'package:http/http.dart' as http;

class Authentification {
  final storage = FlutterSecureStorage();

  Future<bool> connexion(String username, String motDePasse) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"identifiant": username, "motDePasse": motDePasse}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await storage.write(key: 'jwt', value: token);
      return true;
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

  Future<String?> registerCommercant(Commercant commercant) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/commercant/register"),
      headers: {"Content-Type": "application/json"},
      // body: jsonEncode(commercant.toJson()),
    );

    if (response.statusCode == 200) {
      return "Inscription réussie";
    } else {
      return "Erreur: ${response.body}";
    }
  }

  Future<String?> registerFournisseur(Fournisseurs fournisseur) async {
    final response = await http.post(
      Uri.parse("${Constant.remoteUrl}/auth/fournisseur/register"),
      headers: {"Content-Type": "application/json"},
      // body: jsonEncode(fournisseur.toJson()),
    );

    if (response.statusCode == 200) {
      return "Inscription réussie";
    } else {
      return "Erreur: ${response.body}";
    }
  }
}
